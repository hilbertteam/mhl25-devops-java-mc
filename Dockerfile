# ----------- STAGE 1: Build application ----------- #
FROM maven:3.9-eclipse-temurin-17 AS builder

# Установка рабочей директории
WORKDIR /app

# Клонируем репозиторий
RUN git clone https://github.com/spring-petclinic/spring-petclinic-rest.git .

# Добавим зависимость micrometer-registry-prometheus (через pom.xml)
RUN sed -i '/<\/dependencies>/i\
<dependency>\n\
  <groupId>io.micrometer</groupId>\n\
  <artifactId>micrometer-registry-prometheus</artifactId>\n\
  <version>1.15.0</version>\n\
</dependency>' pom.xml

# Вставим настройки в application.properties
RUN echo '\
management.endpoints.web.exposure.include=*\n\
management.endpoint.prometheus.enabled=true\n\
management.metrics.export.prometheus.enabled=true\n\
management.server.port=9966\n\
' >> src/main/resources/application.properties

# Собираем JAR
RUN mvn clean package -DskipTests

# ----------- STAGE 2: Run application ----------- #
FROM eclipse-temurin:17-jre

WORKDIR /app

# Копируем JAR
COPY --from=builder /app/target/*.jar app.jar

# Открываем порты
EXPOSE 9966

# Запускаем приложение
ENTRYPOINT ["java", "-jar", "app.jar"]
