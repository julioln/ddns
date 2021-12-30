# Route53 DDNS

You will need an IAM user with Serverless Framework permissions to deploy the stack.

You should also change your docker image builder in the `build.sh` file if you don't use `docker`.

The stack will be deployed during the docker build, and the entrypoint is a loop that updates the DNS every 5 minutes.

## Configuration

Update the `update_route53.py` file with your DNS and secret.

Add the same secret to the `entrypoint.sh`

