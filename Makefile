deploy-template: build-template
	sam deploy --no-fail-on-empty-changeset \
		--no-confirm-changeset \
		--parameter-overrides WebACLForCloudFrontArn=`aws cloudformation list-exports --region us-east-1 | jq -r '.Exports[] | select (.Name=="WebACLForCloudFrontArn") | .Value'`

build-template: deploy-template-waf
	sam build

deploy-template-waf: build-template-waf
	sam deploy --config-file samconfig-waf.toml \
		--no-fail-on-empty-changeset \
		--no-confirm-changeset

build-template-waf:
	sam build -t template-waf.yaml