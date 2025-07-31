## Практика на примере elasticsearch
- запуск Elasticsearch через оператор в кубере 

```bash
helm install elastic-operator elastic/eck-operator -n elastic-system --create-namespace
git clone https://github.com/hilbertteam/mhl25-devops-java-mc.git
cd deploy/eck-operator/templates
kubectl apply -f elasticsearch.yaml
```

  - обзор стенда, используем k0s (каждый может воспроизвести у себя)
  - запуск с недостаточными ресурсами, падаем по OOM
  - добавляем ресурсы, успешный запуск
  - запуск без ресурсов
  - 
  
      ```
      kubectl -n mhl exec -it mhl-elastic-es-masters-0 -- bash
      su -l elasticsearch -g root

      curl localhost:9200/_cat/health
      curl localhost:9200/_nodes/jvm?pretty
      curl localhost:9200/_nodes/os?pretty

      /usr/share/elasticsearch/jdk/bin/jstack  7 | more
      /usr/share/elasticsearch/jdk/bin/jcmd 7  VM.system_properties
      /usr/share/elasticsearch/jdk/bin/jcmd 7  VM.flags

      /usr/share/elasticsearch/jdk/bin/jshell -q <<< "Runtime.getRuntime().availableProcessors()"
      /usr/share/elasticsearch/jdk/bin/jmap -dump:live,file=logs/live.dmp 7

      /usr/share/elasticsearch/jdk/bin/jstat -gcutil <pid> 1000 5
      
      ```
  - анализируем параметры Java
  - разбираем дамп от OOM
  - разбираем как Elasticsearch выставляет Xmx, Xms
  - запуск без выставленных ресурсов
  - разбираем влияние лимитов/реквестов на CPU
  - разбираем лог GC

### Как устроена сборка мусора в Java (5 минут)

### Java и Kubernetes (5 минут)

### Практика - делаем свой чарт для запуска java приложения (20 минут)
  - организуем темплейт для сборки переменной APP_JAVA_OPTS
  - организуем передачу переменной с параметрами
  - директория для сохранения дампов памяти
  - использование jdk инструментов
  - различные варианты OOM
  - нехватка cpu

### Мониторинг - смотрим метрики на стенде (10 минут)
  - обзор параметров jmx экспортера
  - micrometer
  - демонстрация дашбордов
  
### Рекомендации (1 минута)
