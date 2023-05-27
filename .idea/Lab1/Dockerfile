# Використовуємо базовий образ з підтримкою Bash
FROM bash:latest

# Скопіювати bash скрипт до контейнера
COPY script.sh /script.sh

# Додати cron-розклад для запуску скрипту
COPY cron_schedule /etc/cron.d/my-cron

# Змінити права доступу до cron-розкладу
RUN chmod 0644 /etc/cron.d/my-cron

# Запустити cron сервіс
CMD cron && tail -f /var/log/cron.log