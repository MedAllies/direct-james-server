FROM azul/zulu-openjdk-alpine:8u282-jre

# Run system update
RUN apk update
RUN apk upgrade --ignore zulu8-*
RUN apk add --no-cache --upgrade bash
RUN apk add --no-cache curl && \
    rm -rf /var/cache/apk/*

# When build images, name with this tag
LABEL tag=james-server

# Build arguments
ARG BUILD_VERSION=8.1.0-SNAPSHOT

# Create and use local user and group
RUN addgroup -S direct && adduser -S -D direct -G direct

# Set application location
RUN mkdir -p /opt/app
RUN chown direct:direct /opt/app
ENV PROJECT_HOME /opt/app

# Set microservice
ENV CLOUD_CONFIG=true
ENV SERVICE_PORT=8084
ENV WEBADMIN_PORT=8084
ENV WEBADMIN_USERNAME=admin
ENV WEBADMIN_PASSWORD=d1r3ct

# Set config-service access
ENV CONFIG_SERVICE_HOST=config-service
ENV CONFIG_SERVICE_PORT=8082
ENV CONFIG_SERVICE_USERNAME=admin
ENV CONFIG_SERVICE_PASSWORD=direct

# Set RabbitMQ env variables
ENV RABBIT_MQ_HOST=rabbitmq
ENV RABBIT_MQ_PORT=5672
ENV RABBIT_MQ_USERNAME=guest
ENV RABBIT_MQ_PASSWORD=guest

# Use local user and group
USER direct:direct

# Copy application artifact
COPY bootstrap.properties $PROJECT_HOME/bootstrap.properties
COPY application.properties $PROJECT_HOME/application.properties
COPY target/direct-james-server-$BUILD_VERSION.jar $PROJECT_HOME/james-server.jar

# Switching to the application location
WORKDIR $PROJECT_HOME

# Run application
CMD ["java","-jar","./james-server.jar"]
