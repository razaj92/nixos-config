.PHONY: switch-fastlybook
switch-fastlybook: ## nix build and switch for fastlybook.
	NIXPKGS_ALLOW_UNFREE=1 nix build ".#darwinConfigurations.fastlybook.system" --impure
	sudo ./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#fastlybook"

.PHONY: switch-jhaveribox
switch-jhaveribox: ## home-manager build and switch for jhaveribox.
	NIXPKGS_ALLOW_UNFREE=1 nix run ".#homeConfigurations.jhaveribox.activationPackage" --impure

.PHONY: switch-rjhaveri-agent
switch-rjhaveri-agent: ## home-manager build and switch for rjhaveri-agent.
	NIXPKGS_ALLOW_UNFREE=1 nix run ".#homeConfigurations.rjhaveri-agent.activationPackage" --impure

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-24s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
