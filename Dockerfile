FROM openjdk:11
COPY target/hello-world.jar hello-world.jar
CMD ["java", "-jar", "/hello-world.jar"]
