{ ... }: {
  # Window manager
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # Platform-independent key remapper
  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings = {
        main = {
          capslock = "overload(control, esc)";
        };
      };
    };
  };

  # Allow gtklock to work
  security.pam.services.gtklock = {};
}
