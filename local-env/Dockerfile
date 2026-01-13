FROM odoo:17.0

# Устанавливаем python-docx для генерации документов
USER root
RUN pip3 install --trusted-host pypi.org --trusted-host pypi.python.org --trusted-host files.pythonhosted.org python-docx

# Возвращаемся к пользователю odoo
USER odoo
