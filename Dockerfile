# Stage 1: Build the application
FROM maven:3.8.5-openjdk-17 AS build

# Set the working directory to /app
WORKDIR /app

# Copy the current directory contents into the container at /app
COPY . /app

# Build the application
RUN mvn -B clean package -DskipTests && rm -rf /root/.m2

# Stage 2: Create the runtime image
FROM openjdk:17-jdk-slim

# Set the working directory to /app
WORKDIR /app

# Copy the JAR file from the build stage
COPY --from=build /app/target/kafka-0.0.1-SNAPSHOT.jar /app/kafka-0.0.1-SNAPSHOT.jar

# Expose port 8080
EXPOSE 8080

# Start the application
CMD ["java", "-jar", "-Dspring.profiles.active=docker", "kafka-0.0.1-SNAPSHOT.jar"]
