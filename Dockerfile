FROM maven:3.9.6-eclipse-temurin-17 AS builder
WORKDIR /app

COPY pom.xml .
RUN  mvn dependency:go-offline

COPY src ./src
RUN mvn clean package -DskipTests

FROM maven:3.9.6-eclipse-temurin-17 AS build
#RUN mvn clean compile package
WORKDIR /app
COPY --from=builder /app/target/*.jar service-a.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "/app/service-a.jar"]