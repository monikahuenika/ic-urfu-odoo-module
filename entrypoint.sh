#!/bin/bash
set -e

# Используем порт из переменной окружения (Render передаёт PORT)
export ODOO_PORT="${PORT:-8069}"

echo "Starting Odoo on port $ODOO_PORT"

# Парсим DATABASE_URL если он задан
if [ -n "$DATABASE_URL" ]; then
    echo "Parsing DATABASE_URL..."

    # Показываем маскированный URL для отладки
    MASKED_URL=$(echo "$DATABASE_URL" | sed -E 's/(postgres[ql]*:\/\/[^:]+:)[^@]+(@.*)/\1****\2/')
    echo "DATABASE_URL format: $MASKED_URL"

    # Извлекаем компоненты из postgres[ql]://user:password@host:port/database
    # Поддерживаем как postgres:// так и postgresql://
    if [[ $DATABASE_URL =~ postgres(ql)?://([^:]+):([^@]+)@([^:/]+):?([0-9]*)/([^?]+)(\?.*)?$ ]]; then
        export DB_USER="${BASH_REMATCH[2]}"
        export DB_PASSWORD="${BASH_REMATCH[3]}"
        export DB_HOST="${BASH_REMATCH[4]}"
        export DB_PORT="${BASH_REMATCH[5]:-5432}"
        export DB_NAME="${BASH_REMATCH[6]}"

        # URL-decode пароля (если содержит %XX последовательности)
        DB_PASSWORD=$(printf '%b' "${DB_PASSWORD//%/\\x}")

        echo "✓ Database connection parsed successfully"
        echo "  Host: $DB_HOST"
        echo "  Port: $DB_PORT"
        echo "  Database: $DB_NAME"
        echo "  User: $DB_USER"
    else
        echo "✗ ERROR: Failed to parse DATABASE_URL"
        echo "Expected format: postgres://user:password@host:port/database"
        echo "Or: postgresql://user:password@host:port/database"
        exit 1
    fi
fi

# Проверяем наличие обязательных переменных
if [ -z "$DB_HOST" ] || [ -z "$DB_USER" ] || [ -z "$DB_PASSWORD" ]; then
    echo "ERROR: Database connection parameters not set"
    echo "Please set DATABASE_URL or DB_HOST, DB_USER, DB_PASSWORD"
    exit 1
fi

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
xmlrpc_port = ${ODOO_PORT}
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

echo "Odoo configuration created successfully"

# Проверяем, инициализирована ли база данных
echo "Checking if database is initialized..."

# Пытаемся подключиться и проверить наличие таблицы ir_module_module
DB_INITIALIZED=$(PGPASSWORD="$DB_PASSWORD" psql -h "$DB_HOST" -p "$DB_PORT" -U "$DB_USER" -d "$DB_NAME" -t -c "SELECT EXISTS (SELECT FROM information_schema.tables WHERE table_name = 'ir_module_module');" 2>/dev/null || echo "f")

if [[ "$DB_INITIALIZED" =~ "t" ]]; then
    echo "✓ Database already initialized"
    INIT_FLAGS=""
else
    echo "✗ Database not initialized, will initialize with -i base"
    INIT_FLAGS="-i base --without-demo=all"
fi

# Запускаем Odoo (с инициализацией если нужно)
echo "Starting Odoo..."
exec odoo -c /etc/odoo/odoo.conf $INIT_FLAGS "$@"
