FROM odoo:17.0

COPY --from=ghcr.io/astral-sh/uv:latest /uv /usr/local/bin/uv

# Устанавливаем python-docx для генерации документов
USER root
RUN uv pip install --system python-docx

# Возвращаемся к пользователю odoo
USER odoo
