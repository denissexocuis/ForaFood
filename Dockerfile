# ── Etapa 1: Build con Maven ────────────────────────────────
FROM maven:3.9.6-eclipse-temurin-8 AS build

WORKDIR /app

# Copiar pom.xml primero (aprovecha caché de Docker)
COPY pom.xml .
RUN mvn dependency:go-offline -q

# Estructura estándar Maven: todo está en src/main/
COPY src ./src
RUN mvn clean package -DskipTests -q

# ── Etapa 2: Correr en Tomcat 9 ─────────────────────────────
FROM tomcat:9.0-jdk8-temurin

# Limpiar apps por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copiar el WAR como ROOT.war → app queda en / en lugar de /ForaFood
COPY --from=build /app/target/ForaFood.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
