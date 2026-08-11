# Dotfiles

Nix configuration

## Hosts

- `omen` — NixOS (`x86_64-linux`)
- `MBP-Roy` — macOS with nix-darwin (`aarch64-darwin`)

## Apply

```sh
# NixOS
sudo nixos-rebuild switch --flake .#omen

# macOS
sudo darwin-rebuild switch --flake .#MBP-Roy
```

> These files are tailored to my machines. Review the configuration before using it elsewhere.
