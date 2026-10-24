FROM maven:3.9.9-eclipse-temurin-21 AS build

WORKDIR /build

COPY pom.xml .
COPY src ./src

RUN mvn --batch-mode --no-transfer-progress -DskipTests package

FROM tomcat:9.0.123-jdk21-temurin

ENV CATALINA_HOME=/usr/local/tomcat

COPY --from=build /build/target/simple-attendance.war /usr/local/tomcat/webapps/ROOT.war
COPY entrypoint.sh /usr/local/bin/entrypoint.sh

RUN sed -i 's/\r$//' /usr/local/bin/entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.sh

EXPOSE 8080

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["catalina.sh", "run"]
