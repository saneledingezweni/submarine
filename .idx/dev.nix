{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [
    pkgs.python312Full
    pkgs.screen
  ];

  idx.workspace.onStart.default = ''
    echo -e "\033[1;32m✅ Entering dev shell...\033[0m"

    if [ -f install.sh ]; then
      echo -e "\n🔧 Found install.sh, running..."
      until bash install.sh; do
        echo -e "\n❌ install.sh failed. Retrying in 3 seconds..."
        sleep 3
      done
      echo -e "\n✅ install.sh completed successfully."
    else
      echo -e "\n⚠️ install.sh not found. Skipping."
    fi
  '';
}
