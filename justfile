[macos]
rebuild := "darwin-rebuild"

[linux]
rebuild := "nixos-rebuild"

default:
    @just --list

# Build HOST without activating it
build host:
    {{ rebuild }} build --flake .#{{ host }}

# Build and activate HOST
switch host:
    sudo {{ rebuild }} switch --flake .#{{ host }}

# Activate the previous generation
[macos]
rollback:
    sudo darwin-rebuild --rollback

# Activate the previous generation
[linux]
rollback:
    sudo nixos-rebuild switch --rollback

# List system generations
[macos]
generations:
    sudo darwin-rebuild --list-generations

# List system generations
[linux]
generations:
    nixos-rebuild list-generations

# Update all flake inputs, or only INPUT
update input="":
    nix flake update {{ input }}

# Build HOST on TARGET and activate it there
deploy host="server" target="ehbr.cloud":
    nix run nixpkgs#nixos-rebuild-ng -- switch --flake .#{{ host }} --target-host {{ target }} --build-host {{ target }} --sudo

# Format all Nix files
fmt:
    nix fmt

# Run deadnix, statix and the formatting check
lint:
    nix build --no-link .#checks.$(nix eval --impure --raw --expr builtins.currentSystem).lint

# Run all flake checks, including building every host for this system
check:
    nix flake check
