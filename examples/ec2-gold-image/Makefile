.PHONEY = guard-% help tfplan tfapply tffmt

help: ## this help text
	@echo 'Available commands'
	@grep -E '^[a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[36m%-30s\033[0m %s\n", $$1, $$2}'

tfapply: guard-aws_profile ## terraform apply <aws_profile=>
	AWS_PROFILE=${aws_profile} terraform apply

tfdestroy: guard-aws_profile ## terraform destroy <aws_profile=>
	AWS_PROFILE=${aws_profile} terraform destroy 

tffmt: ## terraform format
	terraform fmt

tfplan: guard-aws_profile ## terraform plan <aws_profile=>
	AWS_PROFILE=${aws_profile} terraform plan

# ensure required vars are set
guard-%:
	@ if [ "${${*}}" = "" ]; then \
		echo "Variable $* not set. Specify via $*=<value>"; \
		exit 1; \
	fi