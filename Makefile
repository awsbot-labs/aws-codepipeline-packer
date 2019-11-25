REGION := $(shell bash -c 'read -p "ENVIRONMENT[dev, test, prod]: " var; echo $$var')
REPOSITORY := $(shell basename $(PWD))
PROFILE=$(REPOSITORY)-$(REGION)

pipeline:
	@unset AWS_DEFAULT_REGION; \
	aws configure --profile $(PROFILE); \
	aws cloudformation create-stack \
		--profile $(PROFILE) \
		--stack-name $(PROFILE) \
		--capabilities CAPABILITY_IAM \
		--template-body file://pipeline.yml \
		--parameters \
		  ParameterKey=Environment,ParameterValue=$(REGION) \
		  ParameterKey=RepositoryName,ParameterValue=$(REPOSITORY)


.PHONY: update_pipeline
update_pipeline:
	-@unset AWS_DEFAULT_REGION; \
	aws configure --profile $(PROFILE); \
	aws cloudformation update-stack \
		--profile $(PROFILE) \
		--stack-name $(PROFILE) \
		--capabilities CAPABILITY_IAM \
		--template-body file://pipeline.yml \
		--parameters \
		  ParameterKey=Environment,ParameterValue=$(REGION) \
		  ParameterKey=RepositoryName,ParameterValue=$(REPOSITORY)

.PHONY: git
git:
	@git status
	@echo "Enter commit message:"
	@read REPLY; \
	git add --all; \
	git commit -m "$$REPLY"; \
	git push


.PHONY: release
release: update_pipeline git