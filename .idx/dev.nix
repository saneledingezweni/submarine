{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = with pkgs; [
    python312Full
    screen
    htop
  ];

  idx = {
    extensions = [
      "ms-python.python"
    ];

    workspace = { };

    previews = {
      enable = false;
    };
  };
}
