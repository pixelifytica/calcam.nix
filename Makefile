.PHONY: default
default:
	nix build --override-input nixpkgs flake:nixpkgs .#default

.PHONY: develop
develop:
	nix develop --override-input nixpkgs flake:nixpkgs .#default
