{ pkgs ?  import <nixpkgs> {}
, firmware ? import ../src {}
}:

let
  config = ./.;

  go60_left  = firmware.zmk.override { board = "go60_lh"; keymap = "${config}/go60.keymap"; kconfig = "${config}/go60.conf"; };
  go60_right = firmware.zmk.override { board = "go60_rh"; keymap = "${config}/go60.keymap"; kconfig = "${config}/go60.conf"; };

  # dockyard:begin — written by dockyard at every build preparation; edit go60.conf instead
  dockyard_left  = go60_left.override (args: { kconfig = "${args.kconfig};${config}/go60_dockyard.conf;${config}/go60_studio.conf"; snippets = (args.snippets or [ ]) ++ [ "studio-rpc-usb-uart" ]; });
  dockyard_right = go60_right.override (args: { kconfig = "${args.kconfig};${config}/go60_dockyard.conf"; });
  # dockyard:end

in firmware.combine_uf2 dockyard_left dockyard_right "go60"
