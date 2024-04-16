# KMS Private

This example creates the infrastructure for a KMS bring your own key material (BYOK(m)) being accessible via a VPC Endpoint.

## Security

A KMS role is included which will be locked down to
- the VPCE Endpoint created.

## Deploying

```bash
terraform init

# plan
make tfplan aws_profile=<profile-name>
# apply
make tfapply aws_profile=<profile-name> root_user=<root_user> public_cidr=<public_cidr>
```

Where
- root_user is the iam administrator or root user
- public_cidr is the cidr notation for the organization's external ip.

## Clean up

Once you're done, remove the resources you have created. Back up any data prior to running the following command(s).

```bash
# remove resources
make tfdestroy aws_profile=<profile-name>
```
