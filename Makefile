# Set your default values
REGION={MY-AWS-REGION}
PROFILE={MY-AWS-CLI-PROFILE}
BUCKET={MY-S3-BUCKET}

copy-config-files:
	aws s3 sync config s3://$(BUCKET)/blog/config

create-inception-stack:
	aws cloudformation create-stack \
		--region $(REGION) \
		--profile $(PROFILE) \
		--stack-name $(STACK_NAME) \
		--template-body file://cloudformation/templates/inception.cfn.yaml

create-blog-host-stack: copy-config-files
	aws cloudformation create-stack \
		--region $(REGION) \
		--profile $(PROFILE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-body file://cloudformation/templates/ghost-blog-setup.cfn.yaml

update-inception-stack:
	aws cloudformation update-stack \
		--region $(REGION) \
		--profile $(PROFILE) \
		--stack-name $(STACK_NAME) \
		--template-body file://cloudformation/templates/inception.cfn.yaml

update-blog-host-stack: copy-config-files
	aws cloudformation update-stack \
		--region $(REGION) \
		--profile $(PROFILE) \
		--stack-name $(STACK_NAME) \
		--capabilities CAPABILITY_NAMED_IAM \
		--template-body file://cloudformation/templates/ghost-blog-setup.cfn.yaml

delete-stack:
	aws cloudformation delete-stack \
		--profile $(PROFILE) \
		--stack-name $(STACK_NAME)