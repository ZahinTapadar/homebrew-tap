cask "atlas" do
  version "1.1.0"
  sha256 "1f48baf9efb809cbab5db5cae3eebe309fd7efd5229ff98eb5b1c56ffaa95f6f"

  url "https://github.com/ZahinTapadar/atlas/releases/download/v#{version}/ATLAS-#{version}.dmg"
  name "ATLAS"
  desc "Local-first activity tracker with scheduled Claude check-ins"
  homepage "https://atlasmac.web.app/"

  livecheck do
    url :url
    strategy :github_latest
  end

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

    For scheduled check-ins, open ATLAS → Settings → Claude and click Connect.
  EOS
end
