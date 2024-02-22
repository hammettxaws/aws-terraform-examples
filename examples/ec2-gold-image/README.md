# EC2 Gold Image

This example creates the infrastructure for a single AMI image that can then be used by downstream services. This is for demonstration purposes and does not represent a complete workflow.

## Deploying

```bash
terraform init

# plan
make tfplan aws_profile=<profile-name>
# apply
make tfapply aws_profile=<profile-name>
```

## Clean up

Once you're done, remove the resources you have created. Back up any data prior to running the following command(s).

```bash
# remove resources
make tfdestroy aws_profile=<profile-name>
```
