
# Build stage 
FROM maven:3-openjdk-11-slim AS build
COPY src /home/app/src
COPY pom.xml /home/app
RUN mvn clean compile assembly:single -f /home/app/pom.xml 

# Package stage
FROM openjdk:11.0.11-jre-slim
RUN echo "deb http://ftp.debian.org/debian/ bullseye main" > /etc/apt/sources.list \
    && apt-get -o Acquire::Check-Valid-Until=false update \
    && apt-get install -y libfreetype-dev \
    && rm -rf /var/lib/apt/lists/*
COPY --from=build /home/app/target/server.jar /usr/local/lib/server.jar
COPY config /config
COPY resources /resources

VOLUME /config

EXPOSE 8080
CMD ["java","-jar","/usr/local/lib/server.jar"]

