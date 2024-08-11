FROM maven:3.6.1-jdk-8-alpine as build
WORKDIR /app
COPY ./.mvn/. ./.mvn
COPY ./mvnw .
COPY ./pom.xml .
RUN mvn -N io.takari:maven:wrapper && mvn -B dependency:go-offline
COPY ./src/. ./src
RUN mvn -B package -DskipTests

FROM openjdk:8-jdk-alpine
RUN apk add --no-cache bash
WORKDIR /app
COPY ./wait-for-it.sh .
RUN chmod +x ./wait-for-it.sh
COPY --from=build app/target/*.jar ./service.jar
EXPOSE 8087
ENTRYPOINT ["/bin/bash", "-c", "/app/wait-for-it.sh db:5432 -t 60 && java -jar /app/*.jar"]