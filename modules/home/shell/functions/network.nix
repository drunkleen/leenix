{ ... }:

{
  programs.zsh.initContent = ''
    iporigin() {
      local input target host ip info

      (( $# )) || {
        printf 'Usage: iporigin <ip|domain|url>\n' >&2
        return 1
      }

      command -v curl >/dev/null 2>&1 || {
        printf 'Missing command: curl\n' >&2
        return 1
      }

      command -v jq >/dev/null 2>&1 || {
        printf 'Missing command: jq\n' >&2
        return 1
      }

      command -v getent >/dev/null 2>&1 || {
        printf 'Missing command: getent\n' >&2
        return 1
      }

      input="$1"
      target="$input"

      if [[ "$input" =~ ^[a-zA-Z][a-zA-Z0-9+.-]*:// ]]; then
        target="''${input#*://}"
        target="''${target%%/*}"
      fi

      target="''${target#*@}"

      if [[ "$target" =~ ^\[.*\](:[0-9]+)?$ ]]; then
        host="''${target#[}"
        host="''${host%%]*}"
      else
        host="''${target%%:*}"
      fi

      if [[ "$host" =~ ^([0-9]{1,3}\.){3}[0-9]{1,3}$ ]] || [[ "$host" == *:* ]]; then
        ip="$host"
      else
        ip="$(getent ahosts "$host" | awk '{print $1}' | head -n 1)"

        [[ -n "$ip" ]] || {
          printf 'Could not resolve host: %s\n' "$host" >&2
          return 1
        }
      fi

      info="$(curl -fsS "http://ip-api.com/json/$ip")" || {
        printf 'IP lookup failed: %s\n' "$ip" >&2
        return 1
      }

      printf 'IP origin lookup\n'
      printf '  Input    %s\n' "$input"
      printf '  Host     %s\n' "$host"
      printf '  IP       %s\n' "$ip"
      printf '  Country  %s\n' "$(echo "$info" | jq -r '.country')"
      printf '  Region   %s\n' "$(echo "$info" | jq -r '.regionName')"
      printf '  City     %s\n' "$(echo "$info" | jq -r '.city')"
      printf '  ISP      %s\n' "$(echo "$info" | jq -r '.isp')"
      printf '  ASN      %s\n' "$(echo "$info" | jq -r '.as')"
    }

    ips() {
      local hide_re='^(br-|veth|virbr|podman|tun|tap)'
      local pub4 pub6

      command -v ip >/dev/null 2>&1 || {
        printf 'Missing command: ip\n' >&2
        return 1
      }

      command -v curl >/dev/null 2>&1 || {
        printf 'Missing command: curl\n' >&2
        return 1
      }

      printf 'Local IPv4\n'
      ip -o -4 addr show up |
        awk -v re="$hide_re" '$2 !~ re { print $2, $4 }' |
        sort -k1,1

      echo

      printf 'Local IPv6\n'
      ip -o -6 addr show up scope global 2>/dev/null |
        awk -v re="$hide_re" '$2 !~ re { print $2, $4 }' |
        sort -k1,1

      pub4="$(curl -4fsS --max-time 3 https://ifconfig.co 2>/dev/null || true)"
      pub6="$(curl -6fsS --max-time 3 https://ifconfig.co 2>/dev/null || true)"

      echo
      printf '  Public IPv4  %s\n' "''${pub4:-not available}"
      printf '  Public IPv6  %s\n' "''${pub6:-not available}"
    }
  '';
}
