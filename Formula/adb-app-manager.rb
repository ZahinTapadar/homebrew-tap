class AdbAppManager < Formula
  desc "A beautifully designed TUI for managing Android apps via ADB"
  homepage "https://github.com/ZahinTapadar/adb-app-manager"
  url "https://github.com/ZahinTapadar/adb-app-manager/archive/refs/tags/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "bb961085b75c517d32d1c3213fd0dbca3cec93d45a9982c2df783ebdee1b9151"
  license "MIT"

  depends_on "python@3.12"

  def install
    # Install the main Python script and any required files to libexec
    libexec.install "adb_manager.py"
    libexec.install "requirements.txt" if File.exist?("requirements.txt")

    # Write a dynamic wrapper that automatically sets up the venv safely in the user's local directory!
    (bin/"adb-app-manager").write <<~EOS
      #!/bin/bash
      
      VENV_DIR="$HOME/.local/share/adb-app-manager-venv"
      
      if [ ! -d "$VENV_DIR" ]; then
          echo "[*] Setting up ADB App Manager Python Environment for the first time..."
          mkdir -p "$(dirname "$VENV_DIR")"
          "#{Formula["python@3.12"].opt_bin}/python3" -m venv "$VENV_DIR"
          
          # Install dependencies quietly
          if [ -f "#{libexec}/requirements.txt" ]; then
              "$VENV_DIR/bin/pip" install --upgrade pip -q
              "$VENV_DIR/bin/pip" install -r "#{libexec}/requirements.txt" -q
          else
              "$VENV_DIR/bin/pip" install textual rich -q
          fi
          echo "[*] Setup Complete! Launching Interactive Manager..."
      fi
      
      # Execute the Python script inside the isolated virtual environment
      exec "$VENV_DIR/bin/python" "#{libexec}/adb_manager.py" "$@"
    EOS
  end

  def caveats
    <<~EOS
      ADB App Manager requires ADB (Android Debug Bridge) to connect to your device.
      Homebrew has migrated ADB to a Cask, which cannot be automatically installed as a dependency.

      If you don't already have ADB installed, please run:
        brew install --cask android-platform-tools
    EOS
  end

  test do
    # Simple test to verify the app can be called and handles the help argument
    assert_match "Usage:", shell_output("#{bin}/adb-app-manager --help", 1)
  end
end
