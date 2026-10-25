cask "atlas" do
  version "1.4.0"
  sha256 "5625ec9ddbdef8615eaf992dbb6f3d3d2202af4c010bb02b90ee02905c8c9b09"

  url "https://github.com/ZahinTapadar/atlas/releases/download/v#{version}/ATLAS-#{version}.dmg"
  name "ATLAS"
  desc "Local-first activity tracker with scheduled Claude check-ins"
  homepage "https://atlasmac.web.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

  auto_updates true
  depends_on macos: ">= :sonoma"

  app "ATLAS.app"
  binary "#{appdir}/ATLAS.app/Contents/MacOS/atlasctl"

  zap trash: [
    "~/Library/Application Support/ATLAS",
    "~/Library/Preferences/com.atlas.tracker.plist",
  ]

  caveats <<~EOS
    ATLAS is not notarized by Apple yet, so macOS blocks the first launch.
    Open System Settings → Privacy & Security and click "Open Anyway" next to
    "ATLAS was blocked". You only need to do this once.

    On first launch a setup checklist walks you through permissions, connecting
    Claude, your check-in schedule and email. ATLAS updates itself after that.
  EOS
end
