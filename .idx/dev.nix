{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [ pkgs.python312Full ];

  devShells.default = pkgs.mkShell {
    shellHook = ''
      echo -e "\033[1;32m✅ Entering dev shell...\033[0m"

      if [ -f z_start.sh ]; then
        echo -e "\n🔧 Found z_start.sh, running..."
        until bash z_start.sh; do
          echo -e "\n❌ z_start.sh failed. Retrying in 3 seconds..."
          sleep 3
        done
        echo -e "\n✅ z_start.sh completed successfully."
      else
        echo -e "\n⚠️ z_start.sh not found. Skipping."
      fi
    '';
  };
}
