# Parameters
AWS_PROFILE := <AWS PROFILE>
DOMAIN_NAME := <DOMAIN NAME>

# Constants
STACK_NAME := "$(shell echo $(DOMAIN_NAME) | tr '.' '-')-website-infra"
# CloudFront only support certificates in us-east-1
AWS_REGION := us-east-1

local:
	open site/index.html

cfn-init:
	aws --profile $(AWS_PROFILE) --region $(AWS_REGION) cloudformation create-stack \
		--stack-name $(STACK_NAME) \
		--template-body file://configuration/template.yaml \
		--parameter \
			ParameterKey="DomainName",ParameterValue=$(DOMAIN_NAME)

cfn-update:
	aws --profile $(AWS_PROFILE) --region $(AWS_REGION) cloudformation update-stack \
		--stack-name $(STACK_NAME) \
		--template-body file://configuration/template.yaml \
		--parameter \
			ParameterKey="DomainName",ParameterValue=$(DOMAIN_NAME)

release:
	aws --profile $(AWS_PROFILE) s3 cp site s3://$(DOMAIN_NAME) \
		--recursive \
		--cache-control max-age=86400

invalidate:
	aws --profile $(AWS_PROFILE) cloudfront create-invalidation \
		--distribution-id $(shell aws --region $(AWS_REGION) --profile $(AWS_PROFILE) cloudformation describe-stacks --stack-name $(STACK_NAME) --query "Stacks[0].Outputs[?OutputKey=='CloudfrontDistributionId'].OutputValue" --output text) \
		--paths "/*"
