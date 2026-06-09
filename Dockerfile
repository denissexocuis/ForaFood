# compilar con maven
FROM maven:3.8.5-openjdk-17 AS builder

# configurar el directorio de trabajo dentro del contenedor
WORKDIR /app

# copiar el archivo de configuración de Maven y el código fuente
COPY pom.xml .
COPY src ./src

# generar el .war
RUN mvn clean package -DskipTests

# levantar servidor tomcat
FROM tomcat:9.0-jdk17-corretto

# limpiar las aplicaciones por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# copiar .war generado
COPY --from=builder /app/target/ForaFood.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]