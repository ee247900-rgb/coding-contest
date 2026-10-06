# Step 1: Build Java application with Maven
FROM maven:3.8.6-openjdk-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn clean package -DskipTests

# Step 2: Run with Jetty / Tomcat container
FROM jetty:9.4-jre8
COPY --from=build /app/target/coding-platform.war /var/lib/jetty/webapps/ROOT.war
EXPOSE 8080
CMD ["java", "-jar", "/usr/local/jetty/start.jar"]
