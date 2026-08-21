cask "litelens" do
  version "1.7.2"
  sha256 "7adccd6a5416a8174c8478f03a6fed3a6afc50c6edb085b5c9a007dc9cf506ba"

  url "https://github.com/litelensapp/litelens/releases/download/v#{version}/litelens-darwin-arm64.zip"
  name "Litelens"
  desc "Lightweight Kubernetes desktop dashboard"
  homepage "https://github.com/litelensapp/litelens"

  app "litelens.app"

  depends_on arch: :arm64

  postflight do
    # The app is ad-hoc signed, not notarized. Homebrew preserves the
    # com.apple.quarantine xattr on extraction, which makes Gatekeeper
    # refuse to open it at all (no "Open Anyway" override). Strip
    # quarantine and re-sign ad-hoc, mirroring scripts/install.sh.
    system_command "/usr/bin/xattr",
                    args: ["-cr", "#{appdir}/litelens.app"],
                    sudo: false
    system_command "/usr/bin/codesign",
                    args: ["--force", "--deep", "--sign", "-", "#{appdir}/litelens.app"],
                    sudo: false
  end

  caveats do
    <<~EOS
      Litelens is ad-hoc signed, not notarized. This cask strips the
      quarantine attribute and re-signs the app after install so
      Gatekeeper won't block it. If macOS still shows a warning on
      first launch, open System Settings > Privacy & Security and
      click "Open Anyway" next to Litelens.

      Litelens's built-in self-updater is disabled for Homebrew installs.
      To upgrade, run:
        brew update && brew upgrade litelens

      `brew update` refreshes Homebrew's local tap cache; `brew upgrade` alone
      may report "already installed" if that cache is stale.
    EOS
  end

  livecheck do
    url :url
    strategy :github_latest_release
    regex(/^v?(\d+(?:\.\d+)*)$/i)
  end
end
