REGION=ap-southeast-2

create-inception-stack:
	aws cloudformation create-stack \
		--region $(REGION) \
		--profile blog-admin \
		--stack-name $(STACK_NAME) \
		--template-body file://cloudformation/templates/inception.cfn.yaml

create-blog-host-stack:
	aws cloudformation create-stack \
		--region $(REGION) \
		--profile blog-admin \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-body file://cloudformation/templates/ghost-blog-setup.cfn.yaml

update-inception-stack:
	aws cloudformation update-stack \
		--region $(REGION) \
		--profile blog-admin \
		--stack-name $(STACK_NAME) \
		--template-body file://cloudformation/templates/inception.cfn.yaml

update-blog-host-stack:
	aws cloudformation update-stack \
		--region $(REGION) \
		--profile blog-admin \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-body file://cloudformation/templates/ghost-blog-setup.cfn.yaml

delete-stack:
	aws cloudformation delete-stack \
		--profile blog-admin \
		--stack-name $(STACK_NAME)