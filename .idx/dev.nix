{ pkgs, ... }: {
  channel = "stable-23.11";

  packages = [ pkgs.python312Full ];

  idx.workspace.onStart.default = ''
    echo -e "\033[1;32m✅ Entering dev shell...\033[0m"

    if [ -f start.sh ]; then
      echo -e "\n🔧 Found start.sh, running..."
      until bash start.sh; do
        echo -e "\n❌ start.sh failed. Retrying in 3 seconds..."
        sleep 3
      done
      echo -e "\n✅ start.sh completed successfully."
    else
      echo -e "\n⚠️ start.sh not found. Skipping."
    fi
  '';
}
