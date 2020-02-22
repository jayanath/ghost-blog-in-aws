REGION=ap-southeast-2

deploy:
	aws cloudformation $(ACTION)-stack \
		--region $(REGION) \
		--profile blog-admin \
		--stack-name test-stack-1 \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-body file://cloudformation/templates/ghost-blog.cfn.yaml

cleanup:
	aws cloudformation delete-stack \
		--profile blog-admin \
		--stack-name test-stack-1