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
	@echo "You will now need to validate domain ownership for your certificate to be issued before your infrastructure provisioning can be completed"
	@echo "Visit the ACM console and follow the instructions for using CNAME records to validate domain ownership"
	@echo "ACM console: https://console.aws.amazon.com/acm/home?region=us-east-1#/certificates/list" 
	@echo "DNS Validation Docs: https://docs.aws.amazon.com/acm/latest/userguide/dns-validation.html"

cfn-update:
	aws --profile $(AWS_PROFILE) --region $(AWS_REGION) cloudformation update-stack \
		--stack-name $(STACK_NAME) \
		--template-body file://configuration/template.yaml \
		--parameter \
			ParameterKey="DomainName",ParameterValue=$(DOMAIN_NAME)

invalidate:
	aws --profile $(AWS_PROFILE) cloudfront create-invalidation \
		--distribution-id $(shell aws --region $(AWS_REGION) --profile $(AWS_PROFILE) cloudformation describe-stacks --stack-name $(STACK_NAME) --query "Stacks[0].Outputs[?OutputKey=='CloudfrontDistributionId'].OutputValue" --output text) \
		--paths "/*"

release: invalidate
	aws --profile $(AWS_PROFILE) s3 cp site s3://$(DOMAIN_NAME) --recursive --cache-control max-age=86400
