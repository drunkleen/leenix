{ pkgs, variables, ... }:

# LEENIX web framework scaffolding helper.
#
# Only ENABLED development.web.* project-support leaves are exposed. Scaffold
# invocation is taken from the canonical catalog's structured
# support.scaffold metadata (command + argsBeforeName + argsAfterName) — never
# a constructed-and-eval'd shell string. Application/framework dependencies
# stay project-local (pnpm dlx / pnpm create run the generator at scaffold
# time); only the generic Nix-owned runtime (nodejs + pnpm) is installed.
let
  catalog = import ../../nixos/development/catalog.nix;
  webDev = variables.development.web or { };
  enabledFrameworks = builtins.sort builtins.lessThan (
    builtins.filter (f: (catalog.web.${f} or { }).classification or null == "E" && (webDev.${f} or false))
      (builtins.attrNames webDev)
  );
  scaffoldOf = f: (catalog.web.${f}).support.scaffold;
  joinArgs = args: builtins.concatStringsSep " " args;
  cmdLine = f: "  FRAMEWORK_CMD[${f}]=${(scaffoldOf f).command}";
  beforeLine = f: "  FRAMEWORK_BEFORE[${f}]=\"${joinArgs (scaffoldOf f).argsBeforeName}\"";
  afterLine = f: "  FRAMEWORK_AFTER[${f}]=\"${joinArgs (scaffoldOf f).argsAfterName}\"";
  specLines =
    builtins.concatStringsSep "\n" (map cmdLine enabledFrameworks)
    + "\n"
    + builtins.concatStringsSep "\n" (map beforeLine enabledFrameworks)
    + "\n"
    + builtins.concatStringsSep "\n" (map afterLine enabledFrameworks);
  enabledList = builtins.concatStringsSep " " enabledFrameworks;
in
{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-dev-scaffold";
      runtimeInputs = with pkgs; [
        nodejs
        pnpm
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Scaffold a project for an enabled web framework (application deps stay project-local).

        # leenix:args=<framework> <directory>

        set -uo pipefail

        declare -A FRAMEWORK_CMD FRAMEWORK_BEFORE FRAMEWORK_AFTER
${specLines}

        ENABLED="${enabledList}"

        usage() {
          echo "Usage: leenix-dev-scaffold <framework> <directory>"
          echo "Enabled frameworks: ''${ENABLED:-<none>}"
        }

        name=''${1:-}
        dir=''${2:-}

        [[ -n $name && -n $dir ]] || { usage; exit 1; }
        if [[ -z ''${FRAMEWORK_BEFORE[$name]+x} ]]; then
          echo "unknown or disabled framework: $name" >&2
          usage
          exit 1
        fi
        case "$dir" in
          /* | *..* | *" "*) echo "invalid project directory: $dir" >&2; exit 1 ;;
        esac

        read -ra before_args <<< "''${FRAMEWORK_BEFORE[$name]}"
        read -ra after_args <<< "''${FRAMEWORK_AFTER[$name]}"
        exec "''${FRAMEWORK_CMD[$name]}" "''${before_args[@]}" "$dir" "''${after_args[@]}"
      '';
    })
  ];
}
