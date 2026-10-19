
FROM eclipse-temurin:17-jdk AS build

WORKDIR /app
COPY . .

RUN chmod +x scripts/compile.sh && \
    bash scripts/compile.sh && \
    mkdir -p /app/build/career-recommendation-system/WEB-INF && \
    cp -r src/main/webapp/. /app/build/career-recommendation-system/ && \
    cp -r src/main/webapp/WEB-INF/classes \
       /app/build/career-recommendation-system/WEB-INF/

FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/build/career-recommendation-system/ \
    /usr/local/tomcat/webapps/ROOT/

EXPOSE 10000
EXPOSE 10000
RUN sed -i 's/port="8080"/port="10000"/' /usr/local/tomcat/conf/server.xml
CMD ["catalina.sh", "run"]
