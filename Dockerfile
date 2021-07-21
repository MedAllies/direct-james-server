FROM openjdk:8u282-jre

# When build images, name with this tag
LABEL tag=james-server

# Build arguments
ARG BUILD_VERSION=6.0.1

# Create and use local user and group
RUN addgroup direct && adduser direct --ingroup direct

# Set application location
RUN mkdir -p /opt/app
RUN chown direct:direct /opt/app
ENV PROJECT_HOME /opt/app

# Set microservice
ENV SERVICE_PORT=8084
ENV WEBADMIN_PORT=8084
ENV WEBADMIN_USERNAME=admin
ENV WEBADMIN_PASSWORD=d1r3ct

# Set config-service access
ENV CONFIG_SERVICE_HOST=config-service
ENV CONFIG_SERVICE_PORT=8082

# Set RabbitMQ env variables
ENV RABBIT_MQ_HOST=rabbitmq
ENV RABBIT_MQ_PORT=5672
ENV RABBIT_MQ_USERNAME=guest
ENV RABBIT_MQ_PASSWORD=guest

# Use local user and group
USER direct:direct

# Copy application artifact
COPY application.properties $PROJECT_HOME/application.properties
COPY target/direct-james-server-$BUILD_VERSION.jar $PROJECT_HOME/james-server.jar

# Switching to the application location
WORKDIR $PROJECT_HOME

# Run application
CMD ["java","-jar","./james-server.jar"]
