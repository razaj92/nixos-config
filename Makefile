.PHONEY: switch
switch: ## nix build and switch.
	nix build ".#darwinConfigurations.fastlybook.system"
	./result/sw/bin/darwin-rebuild switch --flake "$$(pwd)#fastlybook"

.PHONY: help
help:
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}'

.DEFAULT_GOAL := help
