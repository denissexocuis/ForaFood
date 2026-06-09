# tomcat con Java 17
FROM tomcat:9.0-jdk17-corretto

# limpiar la basura por defecto de Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# copiar archivo war y renombrarlo a ROOT.war
# esto para que la app corra directo en la raiz de la url
COPY target/ForaFood.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]