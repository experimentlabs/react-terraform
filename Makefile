.EXPORT_ALL_VARIABLES:

.PHONY: terraform, node

help:
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(MAKEFILE_LIST) | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

t: ## Run terraform
	@bin/terraform.sh apply

hooks: ## Commit hooks setup
	@pre-commit install
	@pre-commit gc
	@pre-commit autoupdate

validate: ## Validate with pre-commit hooks
	@pre-commit run --all-files

changelog: ## Update Changelog
	git-chglog -o CHANGELOG.md --next-tag `semtag final -s minor -o`

release: ## Create release tag
	semtag final -s minor

run: ## Run website locally
	@cd website && yarn start