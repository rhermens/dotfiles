---
name: nix-dependency-management
description: Resolve, compare, and add Nix/NixOS/Home Manager package dependencies, including optional tool dependencies and third-party flakes.
---

# Nix dependency management

Use this skill when the user asks whether a dependency is available on NixOS/Nix, how to install optional dependencies declaratively, whether to use an alternative package, or whether to add an external flake.

## Workflow

1. Identify the dependency shape.
   - Is it a CLI binary, Python module, library, language-server, plugin dependency, or system service?
   - Determine whether the caller needs the command on `PATH`, a Python import, a shared library, or a build input.

2. Check the user's config before recommending edits.
   - Locate `flake.nix`, Home Manager modules, and relevant `home.packages` / `environment.systemPackages` declarations.
   - In this user's dotfiles, Nix config is typically under `~/dotfiles`, with Home Manager modules under `nix/`.

3. Verify package availability with Nix, not memory.
   - Prefer direct eval when the attribute is plausible:
     - `nix eval --raw nixpkgs#<attr>.name`
     - `nix eval --raw nixpkgs#python3Packages.<module>.name`
     - `nix eval --raw nixpkgs#python313Packages.<module>.name`
   - Use `nix search nixpkgs <query> --json` for broader discovery.
   - For current upstream facts or popularity, use web/GitHub search as supporting evidence only.

4. Prefer nixpkgs packages before external flakes.
   - If a suitable package exists in nixpkgs, recommend that first.
   - If only an external flake exists, explain the trade-off: extra input/lock churn and trust surface versus exact tool support.
   - For optional dependencies, recommend the packaged alternative first unless the feature demonstrably requires the un-packaged tool.

5. Give concrete Home Manager/NixOS snippets.
   - For user-level tools: `home.packages = [ pkgs.<pkg> ];`
   - For host/system tools: `environment.systemPackages = with pkgs; [ <pkg> ];`
   - For flake inputs already passed via `extraSpecialArgs = { inherit inputs; };`, use `inputs.<name>.packages.${pkgs.stdenv.hostPlatform.system}.default` from Home Manager modules.
- When a third-party flake drops its overlay output, remove `nixpkgs.overlays = [ inputs.<name>.overlays.default ];` and replace `pkgs.<namespace>.<pkg>` references with a local package-set binding such as:
  ```nix
  let
    upstreamPkgs = inputs.<name>.packages.${pkgs.stdenv.hostPlatform.system};
  in
  upstreamPkgs.<pkg>
  ```
  Verify package attrs exist with `nix flake show <flake> --json` or `nix eval` before editing call sites.
- When one package breaks on current nixpkgs but the rest of the system should stay current, pin only that package through a dedicated old-nixpkgs input and a tiny overlay. Preserve `config = prev.config;` when importing the pinned nixpkgs so unfree/package config carries over. See `references/pin-single-package-from-old-nixpkgs.md`.

6. Verify when making edits.
   - After editing, run the relevant `nix flake check`, `home-manager switch --flake ...`, or `nixos-rebuild dry-build/switch --flake ...` command only when scope is clear and side effects are acceptable.
   - If canonical verification is not obvious or external tooling requests it, create a temporary `/tmp/hermes-verify-*` script that exercises the changed Nix behavior, run it, remove it when possible, and report it explicitly as ad-hoc verification rather than full suite green.
   - For local flake eval/build probes, prefer `--no-write-lock-file` unless the requested task is to update the lockfile; this prevents verification from adding incidental `flake.lock` churn.
   - For Home Manager symlink-collision fixes, verify both declaration and behavior: the file entry has the intended `source`/`force` settings, the live target is a symlink to the canonical dotfiles path, the referenced file parses, and any relevant app writer preserves the symlink.

## Pitfalls

- For Home Manager-managed dotfile symlinks that an app may replace with a real file (for example config writers that use atomic replace), use the attrset form with `force = true;` so activation restores the symlink instead of failing with a clobbering/collision error:
  ```nix
  home.file.".app/config.yaml" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/app/config.yaml";
    force = true;
  };
  ```
  Only apply this when the source file is the desired canonical copy; preserve or compare any existing real file before replacing it.
- Do not conclude a package is unavailable from web search alone; check `nix search` and plausible attr paths.
- Do not add third-party flakes for optional niceties before checking packaged alternatives.
- Do not hard-code architecture-specific flake package paths when `${pkgs.stdenv.hostPlatform.system}` is available.
- Distinguish Python package availability from CLI availability; a Python module in `home.packages` may not provide the command the user expects.
- For macOS `.app` bundles created with Nix/Home Manager, a PNG in `Contents/Resources` is not enough for Finder/Dock icons. Generate an `.icns`, place it in `Contents/Resources`, and add `CFBundleIconFile` to `Info.plist`.
- For GApps-wrapped packages, do not manually call `wrapGAppsHook` as if it accepted a target binary or output name; it is a fixup hook that expects the stdenv `output` variable. To wrap one explicit binary in an override, replace the call with `wrapGApp <program>`. See `references/mongodb-compass-wrapgapp.md`.
- If a tool invocation is blocked by user confirmation or policy, stop and report the partial verification rather than retrying through another route.

## References

- `references/pin-single-package-from-old-nixpkgs.md`: overlay pattern for pinning one broken package to an older nixpkgs revision while keeping the rest of the system current.
