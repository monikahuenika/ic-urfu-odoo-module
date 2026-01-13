#!/bin/bash
set -e

# Создаем конфигурационный файл с подстановкой переменных окружения
cat > /etc/odoo/odoo.conf << EOF
[options]
addons_path = /mnt/extra-addons,/usr/lib/python3/dist-packages/odoo/addons
data_dir = /var/lib/odoo

# Database settings
db_host = ${DB_HOST}
db_port = ${DB_PORT:-5432}
db_user = ${DB_USER}
db_password = ${DB_PASSWORD}
db_name = ${DB_NAME:-odoo}

# Database manager settings
admin_passwd = ${ADMIN_PASSWORD:-admin}
list_db = True
dbfilter = .*

# Server settings
xmlrpc_port = 8069
workers = 2
max_cron_threads = 1

# Proxy mode для Render
proxy_mode = True

# Logging
log_level = info
log_handler = :INFO

# Безопасность
limit_time_cpu = 600
limit_time_real = 1200
limit_memory_hard = 2684354560
limit_memory_soft = 2147483648
EOF

# Запускаем Odoo
exec odoo -c /etc/odoo/odoo.conf "$@"
