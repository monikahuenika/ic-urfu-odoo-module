"""
Demo Credentials Configuration
===============================

🔐 ЕДИНСТВЕННОЕ МЕСТО ГДЕ НУЖНО МЕНЯТЬ ЛОГИНЫ И ПАРОЛИ!

Все скрипты и demo данные берут учетные данные отсюда.
Измени значения здесь и запусти: make clean && make init

"""

# ============================================
# УЧЕТНЫЕ ДАННЫЕ СТУДЕНТА
# ============================================
STUDENT_LOGIN = "student"
STUDENT_PASSWORD = "student"  # noqa: S105
STUDENT_EMAIL = "student@example.com"
STUDENT_NAME = "Иванов Петр Сергеевич"

# ============================================
# УЧЕТНЫЕ ДАННЫЕ ПРЕПОДАВАТЕЛЯ
# ============================================
TEACHER_LOGIN = "teacher"
TEACHER_PASSWORD = "teacher"  # noqa: S105
TEACHER_EMAIL = "teacher@example.com"
TEACHER_NAME = "Смирнова Анна Викторовна"

# ============================================
# ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ
# ============================================
# Компания по умолчанию (обычно не нужно менять)
DEFAULT_COMPANY_REF = "base.main_company"

# Группы безопасности (обычно не нужно менять)
STUDENT_GROUP_REF = "ic_urfu_module.group_ic_urfu_student"
TEACHER_GROUP_REF = "ic_urfu_module.group_ic_urfu_teacher"
