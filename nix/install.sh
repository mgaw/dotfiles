#!/bin/bash

# https://nix.dev/install-nix
curl -L https://nixos.org/nix/install | sh -s -- --daemon

nix --extra-experimental-features "nix-command flakes" run home-manager/master -- switch --flake ~/src/dotfiles
