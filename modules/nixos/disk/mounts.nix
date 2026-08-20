{ config, lib, pkgs, ... }:

# LEENIX simple storage mounts — declarative extra/existing filesystem mounts.
#
# Ownership boundary:
#   Disko            partitions/formats/LUKS/install layout (untouched here)
#   storage.mounts   only declares how EXISTING extra filesystems are mounted
#
# Generated entries use the reserved `fileSystems."storage-<name>"` attribute
# namespace so collisions with Disko/hardware-owned entries are detected by
# attribute-name partition (never by re-reading our own output).
#
# VERSION/DEVICE POLICY: no package pins, no UUID guessing. Devices use stable
# by-uuid/by-label/by-partuuid identifiers; raw paths are allowed but documented
# as less stable. This module never partitions, formats, resizes, enrolls LUKS,
# or mutates filesystem contents.
let
  inherit (lib) types mkOption mkEnableOption mkIf mkMerge mkForce;

  # Reserved mount points that storage.mounts must never claim (Disko/root).
  reservedPaths = [
    "/"
    "/boot"
    "/home"
    "/nix"
    "/var/log"
    "/.snapshots"
  ];

  cfg = config.leenix.storage.mounts;
  primaryUser = config.leenix.user.username;

  # Resolve a group name to a numeric gid declaratively.
  resolveGid = name:
    if config.users.groups ? ${name} && config.users.groups.${name}.gid != null then
      config.users.groups.${name}.gid
    else if config.ids.gids ? ${name} then
      config.ids.gids.${name}
    else
      throw "LEENIX storage.mounts: cannot resolve group '${name}' to a gid.";

  # Resolve a user name to a numeric uid ONLY when statically assigned. The
  # primary LEENIX user's UID is activation-assigned (null at eval time), so we
  # never guess a UID; non-POSIX ownership then falls back to the group
  # mechanism (group gid + group-write mask).
  resolveUid = name:
    if config.users.users ? ${name} && config.users.users.${name}.uid != null then
      config.users.users.${name}.uid
    else if config.ids.uids ? ${name} then
      config.ids.uids.${name}
    else
      null;

  # Non-POSIX filesystems carry ownership/mode via mount options.
  nonPosix = m: builtins.elem m.type [ "ntfs" "exfat" "vfat" ];

  mountOptions = m:
    let
      automountOpts = if m.automount then
        [ "x-systemd.automount" "x-systemd.idle-timeout=${toString m.idleTimeoutSec}" ]
      else
        [ ];
      # Every extra data drive is nofail with a bounded device timeout so an
      # absent drive never makes the machine unbootable.
      safeOpts = [ "nofail" "x-systemd.device-timeout=10" ];

      # readOnly => unconditional ro; otherwise rw (never both).
      rwOpts = if m.readOnly then [ "ro" ] else [ "rw" ];

      # Non-POSIX ownership: group gid + group-write mask. uid= is emitted only
      # when the requested user has a statically-known UID; otherwise the group
      # mechanism carries ownership (primary user is a member of `users`).
      nonPosixOpts = if nonPosix m then
        let
          gid = resolveGid (if m.group != null then m.group else "users");
          uid = if m.user != null then resolveUid m.user else null;
          umask = if m.umask != null then [ "umask=${m.umask}" ] else [ ];
          fmasks = (if m.fileMask != null then [ "fmask=${m.fileMask}" ] else [ ])
            ++ (if m.dirMask != null then [ "dmask=${m.dirMask}" ] else [ ]);
        in
        lib.optional (uid != null) "uid=${toString uid}"
        ++ [ "gid=${toString gid}" ]
        ++ umask
        ++ fmasks
      else
        [ ];
    in
    rwOpts ++ automountOpts ++ safeOpts ++ nonPosixOpts ++ m.options;

  enabledMounts = builtins.filter (m: m.value.enable)
    (lib.mapAttrsToList (n: v: { name = n; value = v; }) cfg);

  val = m: m.value;

  # Collision detection via attribute-name namespace partition.
  storageEntries = lib.filterAttrs (n: _: lib.hasPrefix "storage-" n) config.fileSystems;
  externalEntries = lib.filterAttrs (n: _: !lib.hasPrefix "storage-" n) config.fileSystems;
  externalPaths = map (fs: fs.mountPoint) (lib.attrValues externalEntries);

  duplicatePathCheck =
    let
      paths = map (m: (val m).path) enabledMounts;
      seen = lib.unique paths;
    in
    builtins.length seen == builtins.length paths;

  collisionCheck = lib.all (m:
    !lib.elem (val m).path externalPaths && !lib.elem (val m).path reservedPaths) enabledMounts;

  typeCheck = lib.all (m:
    builtins.elem (val m).type [ "ntfs" "exfat" "vfat" "ext4" "btrfs" "xfs" "auto" ]) enabledMounts;

  pathCheck = lib.all (m:
    builtins.isString (val m).path
    && builtins.substring 0 1 (val m).path == "/"
    && (val m).path != "/") enabledMounts;

  deviceCheck = lib.all (m: builtins.isString (val m).device && (val m).device != "") enabledMounts;

  # Dangerous NTFS-family options that windowsSafe must never allow.
  dangerousOptions = [ "force" "remove_hiberfile" "recover" "norecover" ];
  windowsSafeCheck = lib.all (m:
    if (val m).windowsSafe then
      builtins.all (o: !lib.elem o dangerousOptions) (val m).options
    else
      true) enabledMounts;

  mkFsEntry = m:
    lib.nameValuePair "storage-${m.name}" {
      device = (val m).device;
      fsType = if (val m).type == "ntfs" then "ntfs3" else (val m).type;
      mountPoint = (val m).path;
      options = mountOptions (val m);
    };
in
{
  options.leenix.storage.mounts = mkOption {
    type = types.attrsOf (types.submodule ({ name, ... }: {
      options = {
        enable = mkEnableOption "storage mount '${name}'" // {
          default = true;
        };
        device = mkOption {
          type = types.str;
          description = "Stable device identifier (by-uuid/by-label/by-partuuid preferred; raw paths allowed but less stable).";
        };
        path = mkOption {
          type = types.str;
          description = "Absolute mount point.";
        };
        type = mkOption {
          type = types.str;
          description = "Filesystem type (ntfs, exfat, vfat, ext4, btrfs, xfs, auto). 'ntfs' maps to the kernel ntfs3 driver.";
        };
        automount = mkOption {
          type = types.bool;
          default = true;
          description = "true: systemd first-access automount; false: normal boot-time mount attempt (nofail).";
        };
        readOnly = mkOption {
          type = types.bool;
          default = false;
          description = "Mount unconditionally read-only.";
        };
        windowsSafe = mkOption {
          type = types.bool;
          default = false;
          description = "NTFS safety mode: allow RW only when ntfs3 considers the volume safe; never force/repair/clear Windows state.";
        };
        user = mkOption {
          type = types.nullOr types.str;
          default = primaryUser;
          description = "Requested owner user (uid= emitted only when statically known).";
        };
        group = mkOption {
          type = types.nullOr types.str;
          default = "users";
          description = "Requested owner group (gid= emitted; resolved declaratively).";
        };
        umask = mkOption {
          type = types.nullOr types.str;
          default = "002";
          description = "umask for non-POSIX filesystems (group-write by default).";
        };
        fileMask = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional fmask for non-POSIX filesystems.";
        };
        dirMask = mkOption {
          type = types.nullOr types.str;
          default = null;
          description = "Optional dmask for non-POSIX filesystems.";
        };
        idleTimeoutSec = mkOption {
          type = types.int;
          default = 300;
          description = "systemd automount idle timeout in seconds.";
        };
        options = mkOption {
          type = types.listOf types.str;
          default = [ ];
          description = "Advanced mount options escape hatch.";
        };
      };
    }));
    default = { };
    description = "Declarative extra/existing filesystem mounts (data drives, Windows partitions, backups).";
  };

  config = mkIf (enabledMounts != [ ]) {
    fileSystems = lib.listToAttrs (map mkFsEntry enabledMounts);

    assertions = [
      {
        assertion = typeCheck;
        message = "LEENIX storage.mounts: unsupported filesystem type. Supported: ntfs, exfat, vfat, ext4, btrfs, xfs, auto.";
      }
      {
        assertion = pathCheck;
        message = "LEENIX storage.mounts: every mount path must be an absolute path (starting with '/') and not '/'.";
      }
      {
        assertion = deviceCheck;
        message = "LEENIX storage.mounts: every enabled mount must declare a non-empty device.";
      }
      {
        assertion = duplicatePathCheck;
        message = "LEENIX storage.mounts: duplicate mount path detected; each mount path must be unique.";
      }
      {
        assertion = collisionCheck;
        message = "LEENIX storage.mounts: mount path collides with a Disko/hardware-owned mount point or a reserved root path. storage.mounts must never override existing or reserved mount points.";
      }
      {
        assertion = windowsSafeCheck;
        message = "LEENIX storage.mounts: windowsSafe=true with a dangerous NTFS option (force, remove_hiberfile, recover, norecover). These are never allowed in windowsSafe mode.";
      }
    ];
  };
}
