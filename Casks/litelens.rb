cask "litelens" do
  version "1.4.6"
  sha256 "44c4de43bf504010273a266b283647ba1fd3200242f009f2c78796d52ebd5978"

  url "https://github.com/litelensapp/litelens/releases/download/v#{version}/litelens-darwin-arm64.zip"
  name "LiteLens"
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
      LiteLens is ad-hoc signed, not notarized. This cask strips the
      quarantine attribute and re-signs the app after install so
      Gatekeeper won't block it. If macOS still shows a warning on
      first launch, open System Settings > Privacy & Security and
      click "Open Anyway" next to LiteLens.

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
