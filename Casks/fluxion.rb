cask "fluxion" do
  version "1.0.4"
  sha256 "a12f96b222906f98e93c517e49daaf2bc94afa5cd7c506b99590d14c577b46e9"

  url "https://github.com/superposed-labs/fluxion-bus/releases/download/v#{version}/Fluxion.dmg"
  name "Fluxion"
  desc "Local-first AI gateway and agent hub with a web observation deck"
  homepage "https://github.com/superposed-labs/fluxion-bus"

  livecheck do
    url :url
    strategy :github_latest
  end

  # The app updates itself via Sparkle, so Homebrew should defer to it rather
  # than trying to manage versions. `brew` still handles the initial install
  # and `brew uninstall`; in-app updates keep it current after that.
  auto_updates true
  # Fluxion.app targets Apple Silicon and macOS 12+.
  depends_on macos: :monterey

  app "Fluxion.app"

  # Fluxion.app is NOT signed or notarized by Apple. Homebrew removed the
  # `--no-quarantine` install flag in late 2025, so an unsigned app would
  # otherwise hit a "damaged or unidentified developer" Gatekeeper block on
  # first launch. We strip the quarantine flag here instead.
  #
  # `-dr` is recursive because Fluxion bundles the Sparkle updater, whose
  # nested helpers (Autoupdate, Updater.app, and its XPC services) macOS
  # refuses to spawn while quarantined under a non-quarantined parent.
  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/Fluxion.app"],
                   sudo: false
  end

  # Quit the running menu bar app (and the backend services it supervises)
  # before Homebrew replaces or removes it.
  uninstall quit: "app.superposed.fluxion"

  zap trash: [
    # Managed Python backend: contains your .env and data/. Only removed on
    # `brew uninstall --zap`.
    "~/.local/share/fluxion",
    "~/Library/Application Support/Fluxion",
    "~/Library/Preferences/app.superposed.fluxion.plist",
    "~/Library/Saved Application State/app.superposed.fluxion.savedState",
  ]

  caveats <<~EOS
    Fluxion.app is not signed or notarized by Apple. This cask removes the
    macOS quarantine flag on install so the app opens without a Gatekeeper
    prompt. Each release publishes a SHA256SUMS file if you want to verify
    the download yourself:
      https://github.com/superposed-labs/fluxion-bus/releases

    This cask installs only the menu bar app. On first launch Fluxion sets up
    its Python backend in ~/.local/share/fluxion (Install / Repair), which
    needs Python 3.12+ (it can install python@3.13 via Homebrew if missing).
    Executor CLIs (codex, claude, or agy) must be installed and authenticated
    separately.
  EOS
end
