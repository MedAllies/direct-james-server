# direct-james-server

Apache James Direct Mail Server 

The direct james server is an reassembly of the Apache James mail server as a SpringBoot application.  Although it can be modified, the default configuration is tailored to use the server as an edge protocol server (not as an SMTP server for receiving messages from other HISPs or as a relay) and to store messages until they are picked up by and edge client.  

It also exposes a RESTFul web interface (protected by basic auth by default) to configure aspects of the server.  The web administration API is documented by the James project web admin [page](https://james.apache.org/server/manage-webadmin.html).  Domains and users can be added via this interface.

## Build Component
This project is using maven pom.xml file for the build lifecyle.

`mvn clean install`

## Running Component
To run thins project locally with default configuration:

`java -jar direct-james-server-<version>.jar`

For a custom configuration please use externalized `application.properties` along with the JAR file.

## Microservice health check

`curl --location --request GET 'http://<host>:<port>/healthcheck' \
 --header 'Authorization: Basic YWRtaW46ZDFyM2N0'`

should to return response 200 OK. 

## Microservice containerization
Microservice application should be built and ready to deploy using `mvn clean isntall` command or full package built form `direct-ri-build-microsrvcs` project.

To create docker image or `james-server` run command below:

`docker build -t james-server:latest .`

When running created image containerized microservice will start on default port `8084` with default `admin` user and `d1r3ct` password.

## Dependencies
Running:
- `config-service` microservice with specified connection to it in the `Dockerfile`
- `rabbitmq` message broker with specified connection to it in the `Dockerfile`