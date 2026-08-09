{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellApplication {
      name = "leenix-dev-bin-metadata";

      runtimeInputs = with pkgs; [
        jq
        coreutils
      ];

      text = ''
        #!/bin/bash

        # leenix:summary=Show Leenix bin metadata fields and defaults

        # leenix:args=[--json]

        set -euo pipefail

        show_json() {
          jq -n '{
          ok: true,
          defaults: {
          group: "first filename segment after leenix-",
          name: "remaining filename segments with dashes converted to spaces",
          route: "leenix  ",
          binary: "filename",
          requires_sudo: false
          },
          fields: [
          {name: "summary", required: true, type: "string", note: "One-line human and agent-facing description."},
          {name: "group", required: false, type: "string", note: "Only set when the route group should differ from the filename-derived group."},
          {name: "name", required: false, type: "string", note: "Only set when the route name should differ from the filename-derived name. May be empty for root commands."},
          {name: "args", required: false, type: "string", note: "Only set when the command accepts arguments."},
          {name: "examples", required: false, type: "string", note: "Pipe-separated examples."},
          {name: "aliases", required: false, type: "string", note: "Pipe-separated alternate routes, e.g. leenix screenshot."},
          {name: "requires-sudo", required: false, type: "true", default: false, note: "Only include when true."},
          {name: "hidden", required: false, type: "true", default: false, note: "Hide from default command listings; visible with --all."}
          ]
          }'
        }

        show_help() {
          cat <<'EOF'
        Leenix bin metadata

        Metadata lives in the top comment block of each executable bin/leenix-* file.
        Keep it slim: define only fields that are required or override defaults.

        Required:

        # leenix:summary=

        Inferred defaults:
        group         first filename segment after leenix-
        name          remaining filename segments, with dashes converted to spaces
        route         leenix  
        binary        filename
        requires-sudo false
        hidden        false

        Optional fields:

        # leenix:group=                  route override only

        # leenix:name=                    route override only; may be empty

        # leenix:args=                    only if the command accepts args

        # leenix:examples= |          pipe-separated examples

        # leenix:aliases= |       pipe-separated alternate routes

        # leenix:requires-sudo=true             only when true

        # leenix:hidden=true                    hide from default command listings

        Do not define:
        binary      inferred from filename
        usage       derived from route + args
        false flags or empty args

        Examples:

        # leenix:summary=Restart Walker and related user services

        # leenix:summary=Take a screenshot

        # leenix:group=capture

        # leenix:args=[smart|region|windows|fullscreen] [slurp|copy] [--editor=]

        # leenix:examples=leenix screenshot | leenix capture screenshot region

        # leenix:aliases=leenix screenshot

        EOF
        }

        case "''${1:-}" in
          --json)
            show_json
            ;;
          --help | -h)
            show_help
            ;;
          "")
            show_help
            ;;
          *)
            echo "Unknown option: $1" >&2
            show_help >&2
            exit 2
            ;;
        esac
      '';
    })
  ];
}