# compilar usando maven con java 8
FROM maven:3.6.3-openjdk-8 AS builder

WORKDIR /app

# copiar el pom.xml y el codigo
COPY pom.xml .
COPY src ./src

# compilar el proyecto para el .war
RUN mvn clean package -DskipTests

FROM tomcat:9.0-jdk8-corretto

# limpiar las aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# copiar el archivo .war
COPY --from=builder /app/target/ForaFood.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]