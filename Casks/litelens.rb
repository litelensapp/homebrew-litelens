cask "litelens" do
  version "1.10.9"
  sha256 "746d6ef2fd15a27058d558aced446311db8543148669e1bb6b6b7e772d3e0955"

  url "https://github.com/litelensapp/litelens/releases/download/v#{version}/litelens-darwin-arm64.zip"
  name "Litelens"
  desc "Lightweight Kubernetes desktop dashboard"
  homepage "https://github.com/litelensapp/litelens"

  app "litelens.app"

  depends_on arch: :arm64

  postflight_steps do
    # The app is ad-hoc signed, not notarized. Homebrew preserves the
    # com.apple.quarantine xattr on extraction, which makes Gatekeeper
    # refuse to open it at all (no "Open Anyway" override). Strip
    # quarantine and re-sign ad-hoc, mirroring scripts/install.sh.
    run "/usr/bin/xattr", args: ["-cr", "{{appdir}}/litelens.app"]
    run "/usr/bin/codesign",
        args: ["--force", "--deep", "--sign", "-", "{{appdir}}/litelens.app"]

    # Record that this install came from Homebrew, so the app's own
    # runtime detection (which can be fooled by app translocation or
    # a  binary missing from a GUI process's PATH) doesn't have
    # to guess. Read by internal/storage.ReadInstallSource, which
    # internal/updater.DetectInstallSource consults before falling
    # back to its own heuristics. Reruns (upgrade/reinstall) simply
    # overwrite this with the same value.
    mkdir_p ".litelens", base: :home
    write_file ".litelens/install-source", "homebrew", base: :home
  end

  uninstall trash: [
    "~/.litelens/install-source",
  ]

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
