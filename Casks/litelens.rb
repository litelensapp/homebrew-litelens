cask "litelens" do
  version "1.3.1"
  sha256 "77c8171b467048f1d5264353af10658bf648e3d434f584f0ece4b6171f30a8bc"

  url "https://github.com/litelensapp/litelens/releases/download/v#{version}/litelens-darwin-arm64.zip"
  name "LiteLens"
  desc "Lightweight Kubernetes desktop dashboard"
  homepage "https://github.com/litelensapp/litelens"

  app "litelens.app"

  depends_on arch: :arm64

  caveats do
    <<~EOS
      macOS may show a "LiteLens is from an unidentified developer" warning on
      first launch (the app is ad-hoc signed, not notarized). To run it, open
      System Settings > Privacy & Security and click "Open Anyway" next to LiteLens.

      LiteLens has a built-in self-updater that Homebrew is not aware of. If you
      installed via Homebrew, prefer  to keep versions in sync.
    EOS
  end

  livecheck do
    url :url
    strategy :github_latest_release
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end
end
