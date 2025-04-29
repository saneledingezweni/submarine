{ pkgs, ... }: {
  channel = "stable-23.11";
  packages = [ pkgs.python312Full ];

  idx = {
    workspace = {
      onStart = {
        default = ''
          pkill -f flutter || true
          pkill -f gradle || true
          echo -e "\033[1;32mRunning Python script..\033[0m"
          bash z_start.sh
        '';
      };
    };
  };
}
