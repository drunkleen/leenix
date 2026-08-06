let
  tuf-f15 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIETVTroq1vgwo2F21cEUcFZrzc7ql2D/opi7S+QC2SWx root@tuf-f15";
in
{
  "user-password.age".publicKeys = [ tuf-f15 ];
}
