# homebrew-litelens

Homebrew tap for [LiteLens](https://github.com/litelensapp/litelens), a lightweight Kubernetes desktop dashboard.

> **Note:** `brew search litelens` will not find this tap — Homebrew doesn't index third-party taps. You must tap it explicitly first (see below).

## Install

```bash
brew tap litelensapp/homebrew-litelens
brew install litelens
```

## Upgrade

LiteLens has a built-in self-updater that Homebrew is not aware of. If you installed via Homebrew, prefer:

```bash
brew upgrade litelens
```

over the in-app updater, to keep versions in sync.

## Supported platforms

macOS (Apple Silicon / arm64) only.

## About this tap

This tap is automatically updated by LiteLens's CD pipeline on every release — the cask in `Casks/litelens.rb` is regenerated and published as part of `litelensapp/litelens`'s `job-build.yml` workflow. Manual edits will be overwritten on the next release.
