# Java Application Helm Chart

Универсальный Helm чарт для развертывания Java приложений в Kubernetes.

## Особенности

- ✅ Удобная настройка JAVA_OPTS в виде массива
- ✅ Готовые шаблоны для Deployment и Service
- ✅ Поддержка ConfigMap и Secret
- ✅ Настраиваемые health checks
- ✅ Поддержка Ingress
- ✅ Persistent Volume Claims
- ✅ Service Account
- ✅ JMX Exporter для мониторинга JVM
- ✅ PodMonitor для Prometheus Operator
- ✅ Безопасность по умолчанию (non-root, read-only filesystem с writable /tmp)
- ✅ Гибкая настройка ресурсов

## Быстрый старт

1. Склонируйте репозиторий или скопируйте чарт
2. Создайте файл `my-values.yaml` на основе `values-example.yaml`
3. Настройте параметры под ваше приложение
4. Установите чарт:

```bash
helm install my-app ./java-chart -f my-values.yaml
```

## Конфигурация JAVA_OPTS

Одна из ключевых особенностей чарта - удобная настройка JAVA_OPTS в виде массива:

```yaml
java:
  opts:
    # JVM настройки
    - "-Xms1g"
    - "-Xmx2g"
    - "-XX:+UseG1GC"
    - "-XX:MaxGCPauseMillis=200"
    
    # Настройки приложения
    - "-Dspring.profiles.active=production"
    - "-Dserver.port=8080"
    - "-Dlogging.level.root=INFO"
```

Эти опции автоматически объединяются в одну строку и передаются в переменную окружения `JAVA_OPTS`.

## Основные параметры

### Приложение

```yaml
app:
  name: my-app                    # Имя приложения
  image:
    repository: my-registry/app   # Репозиторий образа
    tag: "1.0.0"                 # Тег образа
  port:
    container: 8080              # Порт контейнера
    service: 80                  # Порт сервиса
```

### Health Checks

```yaml
app:
  healthCheck:
    enabled: true
    path: /actuator/health       # Путь для проверки здоровья
    initialDelaySeconds: 30      # Задержка перед первой проверкой
    periodSeconds: 10            # Интервал проверок
```

### Ресурсы

```yaml
deployment:
  replicas: 3
  resources:
    limits:
      cpu: 2000m
      memory: 3Gi
    requests:
      cpu: 1000m
      memory: 1Gi
```

### Дополнительные переменные окружения

```yaml
java:
  env:
    - name: SPRING_PROFILES_ACTIVE
      value: "production"
    - name: LOG_LEVEL
      value: "INFO"
```

### JMX Exporter для мониторинга JVM

```yaml
jmxExporter:
  enabled: true
  port: 9404
  config:
    lowercaseOutputName: true
    lowercaseOutputLabelNames: true
    rules:
      - pattern: "java.lang<type=GarbageCollector, name=(.+)><>CollectionCount"
        name: "jvm_gc_collection_count"
        type: COUNTER
        labels:
          gc: "$1"
      - pattern: "java.lang<type=Memory><HeapMemoryUsage><Used>"
        name: "jvm_memory_heap_used_bytes"
        type: GAUGE
```

**Примечание:** JMX Exporter автоматически загружается как javaagent через InitContainer и добавляется в `JAVA_TOOL_OPTIONS`.

### PodMonitor для Prometheus

```yaml
podMonitor:
  enabled: true
  labels:
    release: prometheus
  endpoints:
    - port: jmx-metrics
      path: /metrics
      interval: 30s
```

## Примеры использования

### Простое Spring Boot приложение

```yaml
app:
  name: simple-app
  image:
    repository: my-registry/simple-app
    tag: "latest"

java:
  opts:
    - "-Xms512m"
    - "-Xmx1g"
    - "-Dspring.profiles.active=kubernetes"
```

### Продакшн приложение с мониторингом

```yaml
app:
  name: production-app
  image:
    repository: my-registry/production-app
    tag: "1.0.0"
  
  healthCheck:
    path: /actuator/health
    initialDelaySeconds: 60

java:
  opts:
    - "-Xms2g"
    - "-Xmx4g"
    - "-XX:+UseG1GC"
    - "-XX:MaxGCPauseMillis=200"
    - "-Dspring.profiles.active=production"
    - "-Xlog:gc*:stdout:time,level,tags"

deployment:
  replicas: 3
  resources:
    limits:
      cpu: 4000m
      memory: 6Gi
    requests:
      cpu: 2000m
      memory: 3Gi

service:
  additionalPorts:
    - name: metrics
      port: 9090
      targetPort: 9090
```

### Приложение с внешним доступом

```yaml
ingress:
  enabled: true
  className: "nginx"
  hosts:
    - host: myapp.example.com
      paths:
        - path: /
          pathType: Prefix
  tls:
    - secretName: myapp-tls
      hosts:
        - myapp.example.com
```

## Установка

```bash
# Установка с кастомными значениями
helm install my-app ./java-chart -f my-values.yaml

# Установка с переопределением параметров
helm install my-app ./java-chart \
  --set app.image.repository=my-registry/app \
  --set app.image.tag=1.0.0 \
  --set deployment.replicas=3

# Обновление
helm upgrade my-app ./java-chart -f my-values.yaml

# Удаление
helm uninstall my-app
```

## Проверка установки

```bash
# Проверка статуса
helm status my-app

# Просмотр сгенерированных манифестов
helm template my-app ./java-chart -f my-values.yaml

# Проверка логов
kubectl logs -l app.kubernetes.io/name=my-app

# Проверка health check
kubectl get pods -l app.kubernetes.io/name=my-app
```

## Безопасность

Чарт по умолчанию включает настройки безопасности:

- Запуск от непривилегированного пользователя (UID 1000)
- Read-only файловая система
- Запрет escalation привилегий
- Настраиваемые security contexts

## Мониторинг

Для интеграции с Prometheus добавьте аннотации:

```yaml
deployment:
  annotations:
    prometheus.io/scrape: "true"
    prometheus.io/port: "8080"
    prometheus.io/path: "/actuator/prometheus"
```

## Поддержка

При возникновении проблем:

1. Проверьте логи приложения: `kubectl logs <pod-name>`
2. Проверьте события: `kubectl describe pod <pod-name>`
3. Убедитесь, что health check endpoint доступен
4. Проверьте настройки JAVA_OPTS в переменных окружения

## Лицензия

MIT 