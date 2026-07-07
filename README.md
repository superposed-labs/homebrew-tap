# superposed-labs/homebrew-tap

Homebrew tap for [Fluxion](https://github.com/superposed-labs/fluxion-bus).

## Install

```bash
brew tap superposed-labs/tap
brew install --cask fluxion
```

Or in one line:

```bash
brew install --cask superposed-labs/tap/fluxion
```

## Note on signing

`Fluxion.app` is currently **not signed or notarized by Apple**. The cask
strips the macOS quarantine flag on install so the app launches without a
Gatekeeper prompt. Every release ships a `SHA256SUMS` file you can use to
verify the download.

## Update / uninstall

Fluxion updates itself in place via Sparkle — the app prompts you when a new
version is available, so there is normally nothing to run. To uninstall:

```bash
brew uninstall --cask fluxion          # keeps ~/.local/share/fluxion (.env, data/)
brew uninstall --zap --cask fluxion    # also removes backend, config, and app state
```
