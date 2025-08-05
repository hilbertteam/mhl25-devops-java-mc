# Тестовые Java приложения для деплоя чартом

## 🚀 Готовые к использованию приложения

### 1. **Spring Boot PetClinic** (Рекомендуется)
```yaml
app:
  name: petclinic
  image:
    repository: springcommunity/spring-petclinic
    tag: "latest"
    pullPolicy: Always

java:
  opts:
    - "-Xms512m"
    - "-Xmx1g"
    - "-XX:+UseG1GC"
    - "-Dspring.profiles.active=kubernetes"

deployment:
  replicas: 1
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi

# Включаем мониторинг
jmxExporter:
  enabled: true
  port: 9404

podMonitor:
  enabled: true
  labels:
    release: prometheus
```

**Особенности:**
- ✅ Полнофункциональное Spring Boot приложение
- ✅ Встроенные health checks (`/actuator/health`)
- ✅ JMX метрики
- ✅ Стабильный и популярный образ
- ✅ Подходит для демонстрации

### 2. **Spring Boot Sample App**
```yaml
app:
  name: spring-sample
  image:
    repository: springguides/gs-spring-boot-docker
    tag: "latest"

java:
  opts:
    - "-Xms256m"
    - "-Xmx512m"
    - "-XX:+UseG1GC"

deployment:
  replicas: 1
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 250m
      memory: 256Mi
```

### 3. **JHipster Sample App**
```yaml
app:
  name: jhipster-sample
  image:
    repository: jhipster/jhipster-sample-app
    tag: "latest"

java:
  opts:
    - "-Xms1g"
    - "-Xmx2g"
    - "-XX:+UseG1GC"
    - "-Dspring.profiles.active=prod"

deployment:
  replicas: 1
  resources:
    limits:
      cpu: 2000m
      memory: 2Gi
    requests:
      cpu: 1000m
      memory: 1Gi

# Включаем мониторинг
jmxExporter:
  enabled: true
  port: 9404

podMonitor:
  enabled: true
```

### 4. **Spring Boot Actuator Demo**
```yaml
app:
  name: actuator-demo
  image:
    repository: springguides/gs-actuator-service
    tag: "latest"

java:
  opts:
    - "-Xms256m"
    - "-Xmx512m"
    - "-XX:+UseG1GC"

app:
  healthCheck:
    path: /actuator/health
    enabled: true

deployment:
  replicas: 1
  resources:
    limits:
      cpu: 500m
      memory: 512Mi
    requests:
      cpu: 250m
      memory: 256Mi
```

## 🎯 Рекомендуемое приложение для тестирования

**Spring Boot PetClinic** - лучший выбор для тестирования чарта:

### Преимущества:
- ✅ **Полнофункциональное приложение** с UI
- ✅ **Встроенные health checks** на `/actuator/health`
- ✅ **JMX метрики** для мониторинга
- ✅ **Стабильный образ** с регулярными обновлениями
- ✅ **Популярное** в сообществе Spring Boot
- ✅ **Подходит для демонстрации** всех возможностей чарта

### Быстрый старт:
```bash
# Создаем values файл для PetClinic
cat > petclinic-values.yaml << EOF
app:
  name: petclinic
  image:
    repository: springcommunity/spring-petclinic
    tag: "latest"
    pullPolicy: Always

java:
  opts:
    - "-Xms512m"
    - "-Xmx1g"
    - "-XX:+UseG1GC"
    - "-Dspring.profiles.active=kubernetes"

deployment:
  replicas: 1
  resources:
    limits:
      cpu: 1000m
      memory: 1Gi
    requests:
      cpu: 500m
      memory: 512Mi

jmxExporter:
  enabled: true
  port: 9404

podMonitor:
  enabled: true
  labels:
    release: prometheus
EOF

# Устанавливаем приложение
helm install petclinic ./java-chart -f petclinic-values.yaml

# Проверяем статус
kubectl get pods -l app.kubernetes.io/name=petclinic
kubectl get svc -l app.kubernetes.io/name=petclinic
```

### Проверка работы:
```bash
# Port-forward для доступа к приложению
kubectl port-forward svc/petclinic 8080:80

# Проверяем health check
curl http://localhost:8080/actuator/health

# Проверяем JMX метрики
curl http://localhost:8080/metrics
```

## 🔍 Альтернативные приложения

Если PetClinic недоступен, можно использовать:

1. **Spring Boot Sample** - минимальное приложение
2. **JHipster Sample** - полнофункциональное приложение
3. **Actuator Demo** - демонстрация мониторинга

## 📝 Примечания

- Все образы должны иметь **health check endpoint** на `/actuator/health`
- Для **JMX мониторинга** приложение должно поддерживать JMX
- **Ресурсы** подобраны для тестирования, для продакшна нужно увеличить
- **Порт** по умолчанию 8080, но может отличаться в зависимости от приложения 