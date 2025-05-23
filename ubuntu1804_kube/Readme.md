# Ubuntu 18.04 Kubernetes Old version

## Описание проекта

Этот проект содержит файлы конфигурации и скрипты для создания готового к использованию образа виртуальной машины Ubuntu 18.04 с предустановленными инструментами для работы с Kubernetes. Образ создается с помощью инструмента HashiCorp Packer и предназначен для использования в VirtualBox.

## Возможности

- Автоматическое создание виртуальной машины с Ubuntu 18.04
- Предустановленные инструменты для работы с Kubernetes:
  - kubectl (v1.10.0) (используется старая версия по запросу преподавателя)
  - Docker
  - Helm (v3.9.0)
  - kubectx и kubens
  - k9s (v0.25.18)
  - kube-ps1 (для отображения текущего контекста Kubernetes в командной строке)
- Настроенная аутентификация по SSH-ключу
- Отключенная аутентификация по паролю для повышения безопасности

## Требования

- HashiCorp Packer (последняя версия)
- Oracle VirtualBox
- Доступ в интернет для загрузки образа Ubuntu и необходимых пакетов

## Использование

### Подготовка

1. Убедитесь, что у вас установлен и настроен SSH-ключ
2. При необходимости измените путь к публичному SSH-ключу в файле `ubuntu.pkr.hcl`

### Создание образа

```bash
packer build ubuntu.pkr.hcl
```

После успешного выполнения в директории `output` будет создан файл образа в формате OVA, который можно импортировать в VirtualBox.

### Импорт образа в VirtualBox

1. Откройте VirtualBox
2. Выберите "Файл" -> "Импорт конфигураций"
3. Укажите путь к созданному OVA-файлу
4. Следуйте инструкциям мастера импорта

## Структура проекта

- `ubuntu.pkr.hcl` - основной файл конфигурации Packer
- `http/preseed.cfg` - файл предварительной настройки установщика Ubuntu
- `script/` - директория со скриптами для настройки системы:
  - `update.sh` - обновление системы и установка базовых пакетов
  - `install_kubectl.sh` - установка инструментов Kubernetes
  - `ssh.sh` - настройка SSH
  - `cleanup.sh` - очистка системы перед созданием образа

## Дополнительная информация

- Пользователь по умолчанию: `ubuntu`
- Аутентификация происходит только по SSH-ключу
- Образ оптимизирован и очищен от временных файлов для минимизации размера

## Настройка

Для изменения параметров виртуальной машины (память, процессоры, размер диска) отредактируйте соответствующие переменные в файле `ubuntu.pkr.hcl`.
