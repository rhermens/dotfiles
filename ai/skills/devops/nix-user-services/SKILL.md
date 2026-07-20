---
name: nix-user-services
description: "Define and verify Home Manager user services."
version: 1.0.0
author: Hermes Agent
license: MIT
platforms: [linux, macos]
metadata:
  hermes:
    tags: [nix, home-manager, systemd, services]
    category: devops
---

# Nix User Services Skill

Define persistent per-user services through Home Manager, with systemd on Linux and no invalid configuration on Darwin. This covers service declaration and evaluation; it does not replace application-specific security, authentication, or deployment design.

## When to Use

- A user asks to run a CLI, local server, or dashboard persistently through their Nix configuration.
- A Home Manager module is shared by Linux and macOS and needs a Linux-only systemd service.
- A service must survive login-session changes and restart after failure.

## Prerequisites

- The target repository is a Nix flake with a Home Manager configuration.
- Inspect the module that imports the service and the application package or wrapper before choosing `ExecStart`.
- Use `read_file`, `search_files`, and `terminal` to establish the existing Nix style and the actual executable path.

## How to Run

1. Read the target `.nix` module and search the repository for existing `systemd.user.services` conventions.
2. Inspect the executable that will run in the service. Do not assume a package attribute exports a matching CLI binary.
3. Add a `systemd.user.services.<name>` declaration with a stable `ExecStart`, explicit working directory where appropriate, restart policy, and `Install.WantedBy = [ "default.target" ]`.
4. For a module shared with Darwin, make the service value Linux-only:
   ```nix
   systemd.user.services.example = lib.mkIf pkgs.stdenv.isLinux {
     # unit definition
   };
   ```
   Keep the conditional inside the module attribute rather than conditionally composing the entire returned module from `pkgs`.
5. Evaluate the exact generated service configuration with `nix eval --json` before activation.
6. Run `git diff --check`. Do not activate a full NixOS/Home Manager generation unless the user asked and the scope of unrelated pending changes is understood.

## Quick Reference

```nix
systemd.user.services.example-server = lib.mkIf pkgs.stdenv.isLinux {
  Unit = {
    Description = "Example local server";
    After = [ "network-online.target" ];
    Wants = [ "network-online.target" ];
  };

  Service = {
    ExecStart = "${config.home.homeDirectory}/.local/bin/example serve --host 127.0.0.1 --port 9119";
    WorkingDirectory = config.home.homeDirectory;
    Restart = "always";
    RestartSec = 5;
  };

  Install.WantedBy = [ "default.target" ];
};
```

Inspect a generated unit declaration without activating it:

```bash
nix eval --json .#nixosConfigurations.<host>.config.home-manager.users.<user>.systemd.user.services.<service>
```

## Procedure

### 1. Choose the executable deliberately

Check the package output or existing wrapper. Desktop packages and server CLIs often have different executable names. If a user-maintained wrapper is the supported entry point, use its absolute path and set any required service environment explicitly.

### 2. Bind local admin surfaces safely

For dashboards intended for local use, bind to `127.0.0.1` unless the user explicitly needs remote access and the application authentication design has been reviewed. Do not add insecure bypass flags merely to make a service start.

### 3. Keep macOS evaluation valid

A shared Home Manager module may be imported by both Linux and Darwin configurations. Gate Linux-specific systemd declarations with `lib.mkIf pkgs.stdenv.isLinux`, then evaluate both configurations when the flake supports them.

### 4. Verify declaratively before activation

Use targeted `nix eval` for the exact service attribute. Confirm the generated `ExecStart`, environment, restart policy, and `WantedBy` values. `git diff --check` catches whitespace and patch errors, but is not a substitute for Nix evaluation.

## Pitfalls

- Do not assume `pkgs.<name>` exposes a same-named executable; inspect it first.
- Do not place a Linux-only `systemd` service in a shared module without a Linux guard.
- Do not use an outer `lib.optionalAttrs pkgs...` module composition when it introduces module-argument evaluation recursion; guard the service value with `lib.mkIf` instead.
- Do not activate a system generation as incidental verification when the checkout contains unrelated changes.
- `--skip-build` is suitable only when the server's static assets are already available; otherwise use the application's documented build/deployment path.

## Verification

- `nix eval --json` returns the generated service object for the Linux configuration.
- If applicable, a Darwin configuration evaluates without exposing an invalid systemd declaration.
- `git diff --check` passes.
- After an explicitly requested activation, use `systemctl --user status <service>` and inspect journal output for startup failures.
