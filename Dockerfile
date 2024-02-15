# Use an official OpenJDK runtime as a base image
FROM openjdk:8-jre-slim

# Set the working directory in the container
WORKDIR /app

# Copy the application JAR file into the container at /app
COPY target/project_tracker-0.0.1-SNAPSHOT.jar /app/app.jar

# Expose the port the app runs on
EXPOSE 8080

# Specify the command to run on container startup
CMD ["java", "-jar", "app.jar"]

