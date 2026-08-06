{ pkgs, ... }:

{
  programs.waybar = {
    enable = true;

    systemd = {
      enable = true;
      targets = [
	"graphical-session.target"
      ];
    };

    settings = {
      mainBar = {
	layer = "top";
	position = "top";
	height = 34;
	spacing = 8;

	modules-left = [
	  "hyprland/workspaces"
	    "hyprland/window"
	];

	modules-center = [
	  "clock"
	];

	modules-right = [
	  "tray"
	    "network"
	    "bluetooth"
	    "power-profiles-daemon"
	    "wireplumber"
	    "battery"
	];

	"hyprland/workspaces" = {
	  disable-scroll = true;
	  all-outputs = true;
	  format = "{icon}";

	  format-icons = {
	    active = "";
	    default = "";
	    urgent = "";
	  };
	};

	"hyprland/window" = {
	  format = "{}";
	  max-length = 45;
	  separate-outputs = true;
	};

	clock = {
	  format = "  {:%H:%M}";
	  format-alt = "  {:%A, %d %B %Y}";
	  tooltip-format = "<tt><small>{calendar}</small></tt>";
	};

	network = {
	  format-wifi = "  {essid}";
	  format-ethernet = "󰈀  Connected";
	  format-disconnected = "󰖪  Offline";
	  tooltip-format = "{ifname}\n{ipaddr}/{cidr}\nSignal: {signalStrength}%";
	};

	bluetooth = {
	  format = "  {status}";
	  format-connected = "  {num_connections}";
	  format-disabled = "󰂲";
	  tooltip-format = "{controller_alias}\n{num_connections} connected";
	};

	power-profiles-daemon = {
	  format = "{icon}";
	  tooltip-format = "Power profile: {profile}";

	  format-icons = {
	    performance = "";
	    balanced = "";
	    power-saver = "";
	  };
	};

	wireplumber = {
	  format = "{icon}  {volume}%";
	  format-muted = "󰝟  Muted";

	  format-icons = [
	    ""
	      ""
	      ""
	  ];

	  on-click = "pwvucontrol";
	};

	battery = {
	  states = {
	    warning = 30;
	    critical = 15;
	  };

	  format = "{icon}  {capacity}%";
	  format-charging = "󰂄  {capacity}%";
	  format-plugged = "  {capacity}%";

	  format-icons = [
	    ""
	      ""
	      ""
	      ""
	      ""
	  ];
	};

	tray = {
	  spacing = 10;
	};
      };
    };

    style = ''
      @define-color foreground #d8e3e0;
    @define-color background #0b1113;
    @define-color surface #182326;
    @define-color surface-alt #223034;
    @define-color muted #4a5f62;
    @define-color selection #365156;
    @define-color accent #33b8a8;
    @define-color accent-soft #59d6c5;
    @define-color green #4dba7a;
    @define-color yellow #d9c76b;
    @define-color red #e16f73;
    @define-color blue #5e9bff;

    * {
border: none;
	border-radius: 0;
	font-family: "JetBrainsMono Nerd Font";
	font-size: 13px;
	min-height: 0;
    }

    window#waybar {
background: alpha(@background, 0.96);
color: @foreground;
    }

    tooltip {
background: @background;
color: @foreground;
border: 1px solid @selection;
    }

    tooltip label {
color: @foreground;
    }

#workspaces {
margin: 4px 0 4px 8px;
padding: 0 4px;
background: @surface;
}

#workspaces button {
padding: 0 7px;
color: @muted;
background: transparent;
transition: all 150ms ease;
}

#workspaces button:hover {
color: @foreground;
background: @surface-alt;
}

#workspaces button.active {
color: @accent;
}

#workspaces button.urgent {
color: @red;
}

#window {
  margin-left: 10px;
color: @foreground;
}

#clock,
#network,
#bluetooth,
#power-profiles-daemon,
#wireplumber,
#battery,
#tray {
margin: 4px 3px;
padding: 0 9px;
background: @surface;
color: @foreground;
transition: all 150ms ease;
}

#clock:hover,
#network:hover,
#bluetooth:hover,
#power-profiles-daemon:hover,
#wireplumber:hover,
#battery:hover,
#tray:hover {
background: @surface-alt;
}

#clock {
color: @accent-soft;
}

#network {
color: @yellow;
}

#network.disconnected {
color: @red;
}

#bluetooth {
color: @blue;
}

#power-profiles-daemon {
color: @accent;
}

#wireplumber {
color: @accent-soft;
}

#wireplumber.muted {
color: @muted;
}

#battery {
color: @green;
}

#battery.warning {
color: @yellow;
}

#battery.critical {
color: @red;
}
'';
};

home.packages = with pkgs; [
  pwvucontrol
];
}
