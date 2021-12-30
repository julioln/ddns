FROM docker.io/node

# Copy files and setup
RUN mkdir -p /app
COPY serverless.yml /app/serverless.yml
COPY update_route53.py /app/update_route53.py
COPY entrypoint.sh /app/entrypoint.sh
COPY aws /app/aws
ENV AWS_CONFIG_FILE=/app/aws/config
ENV AWS_SHARED_CREDENTIALS_FILE=/app/aws/credentials
WORKDIR /app

# Install dependencies
RUN apt update
RUN apt install awscli curl -y
RUN npm install -g serverless

# Deploy app and save endpoint
RUN serverless deploy | tee /var/log/serverless.log
RUN grep -A1 'endpoints:' /var/log/serverless.log > /app/endpoints

ENTRYPOINT ["/app/entrypoint.sh"]
