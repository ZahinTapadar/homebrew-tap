class AdbAppManager < Formula
  desc "A beautifully designed TUI for managing Android apps via ADB"
  homepage "https://github.com/ZahinTapadar/adb-app-manager"
  url "https://github.com/ZahinTapadar/adb-app-manager/archive/refs/tags/v1.0.0.tar.gz"
  version "1.0.0"
  sha256 "bb961085b75c517d32d1c3213fd0dbca3cec93d45a9982c2df783ebdee1b9151"
  license "MIT"

  depends_on "python@3.12"
  depends_on cask: "android-platform-tools"

  def install
    # Install the main Python script and any required files to libexec
    libexec.install "adb_manager.py"
    libexec.install "requirements.txt" if File.exist?("requirements.txt")

    # Set up an isolated Python Virtual Environment
    system Formula["python@3.12"].opt_bin/"python3", "-m", "venv", libexec/"venv"

    # Upgrade pip and install the dependencies silently
    system libexec/"venv/bin/pip", "install", "--upgrade", "pip"
    if File.exist?("requirements.txt")
      system libexec/"venv/bin/pip", "install", "-r", "requirements.txt"
    else
      system libexec/"venv/bin/pip", "install", "textual", "rich"
    end

    # Create the executable wrapper script ensuring the original PATH inherits Homebrew binaries
    (bin/"adb-app-manager").write <<~EOS
      #!/bin/bash
      
      # Execute the Python script inside the isolated virtual environment
      exec "#{libexec}/venv/bin/python" "#{libexec}/adb_manager.py" "$@"
    EOS
  end

  test do
    # Simple test to verify the app can be called and handles the help argument
    assert_match "Usage:", shell_output("#{bin}/adb-app-manager --help", 1)
  end
end
