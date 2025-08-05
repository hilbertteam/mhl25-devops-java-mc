# 🚀 Быстрый старт с Java чартом

## 📋 Что у вас есть

Универсальный Helm чарт для Java приложений с:
- ✅ Удобной настройкой JAVA_OPTS в виде массива
- ✅ JMX Exporter для мониторинга JVM
- ✅ PodMonitor для Prometheus
- ✅ Готовыми шаблонами Deployment и Service
- ✅ Безопасностью по умолчанию

## 🎯 Рекомендуемые тестовые приложения

### 1. **Spring Boot PetClinic** (Лучший выбор)
```bash
# Деплой с полным мониторингом
./test-deploy.sh petclinic
```

**Особенности:**
- Полнофункциональное приложение с UI
- Встроенные health checks
- JMX метрики
- Подходит для демонстрации

### 2. **Простое Spring Boot приложение**
```bash
# Быстрый деплой без мониторинга
./test-deploy.sh simple
```

## 🛠️ Ручной деплой

### PetClinic с мониторингом:
```bash
# Создаем namespace
kubectl create namespace test-java-apps

# Устанавливаем приложение
helm install petclinic . -f petclinic-values.yaml -n test-java-apps

# Проверяем статус
kubectl get pods,svc -n test-java-apps
```

### Простое приложение:
```bash
helm install simple-app . -f simple-app-values.yaml -n test-java-apps
```

## 🔍 Проверка работы

### Доступ к приложению:
```bash
# Port-forward для PetClinic
kubectl port-forward svc/petclinic 8080:80 -n test-java-apps

# Проверяем health check
curl http://localhost:8080/actuator/health

# Открываем в браузере
open http://localhost:8080
```

### Проверка мониторинга:
```bash
# JMX метрики
kubectl port-forward svc/petclinic 9404:9404 -n test-java-apps
curl http://localhost:9404/metrics

# Проверяем PodMonitor
kubectl get podmonitor -n test-java-apps

# Проверяем InitContainer
kubectl describe pod -l app.kubernetes.io/name=petclinic -n test-java-apps
```

## 🧹 Очистка

```bash
# Очистка всех ресурсов
./test-deploy.sh cleanup

# Или вручную
helm uninstall petclinic -n test-java-apps
kubectl delete namespace test-java-apps
```

## 📊 Что мониторится

### JVM метрики:
- **GC метрики**: время и количество сборок мусора
- **Memory метрики**: использование heap и non-heap памяти
- **Thread метрики**: количество потоков
- **Application метрики**: настраиваемые через rules

### Health checks:
- **Liveness probe**: `/actuator/health`
- **Readiness probe**: `/actuator/health`
- **Prometheus метрики**: `/actuator/prometheus`

## 🔧 Настройка JAVA_OPTS

```yaml
java:
  opts:
    # JVM настройки
    - "-Xms512m"
    - "-Xmx1g"
    - "-XX:+UseG1GC"
    
    # Настройки приложения
    - "-Dspring.profiles.active=production"
    - "-Dserver.port=8080"
    - "-Dlogging.level.root=INFO"
```

## 📝 Полезные команды

```bash
# Проверка статуса
./test-deploy.sh status

# Просмотр логов
kubectl logs -f deployment/petclinic -n test-java-apps

# Описание пода
kubectl describe pod -l app.kubernetes.io/name=petclinic -n test-java-apps

# Проверка сервисов
kubectl get svc -n test-java-apps
```

## 🎉 Готово!

Теперь у вас есть полностью функциональный Java чарт с мониторингом. Можете использовать его как основу для своих приложений! 