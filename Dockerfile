FROM odoo:17.0

# Устанавливаем python-docx для генерации документов
USER root

# Установка зависимостей
RUN pip3 install --no-cache-dir --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org python-docx

# Копируем кастомный модуль
COPY --chown=odoo:odoo ./ic_urfu_module /mnt/extra-addons/ic_urfu_module

# Копируем entrypoint скрипт
COPY --chown=odoo:odoo ./entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

# Возвращаемся к пользователю odoo
USER odoo

# Expose порт
EXPOSE 8069

# Используем кастомный entrypoint
ENTRYPOINT ["/entrypoint.sh"]
