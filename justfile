rebuild := if os() == "macos" { "darwin-rebuild" } else { "nixos-rebuild" }

default:
    @just --list

# Build HOST without activating it
build host:
    {{ rebuild }} build --flake .#{{ host }}

# Build and activate HOST
switch host:
    sudo SSH_AUTH_SOCK="$SSH_AUTH_SOCK" {{ rebuild }} switch --flake .#{{ host }}

# Activate the previous generation
rollback:
    sudo {{ rebuild }} {{ if os() == "macos" { "--rollback" } else { "switch --rollback" } }}

# List system generations
generations:
    {{ if os() == "macos" { "sudo darwin-rebuild --list-generations" } else { "nixos-rebuild list-generations" } }}

# Update all flake inputs, or only INPUT
update input="":
    nix flake update {{ input }}
