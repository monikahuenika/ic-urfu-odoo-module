"""Configuration settings for IC UrFU Module."""

from odoo import fields, models


class IcUrfuConfigSettings(models.TransientModel):
    """Configuration settings for IC UrFU Module.

    This model provides a UI for configuring module defaults and preferences.
    Settings are stored as ir.config_parameter records.
    """

    _name = "ic.urfu.config.settings"
    _inherit = "res.config.settings"
    _description = "IC UrFU Configuration Settings"

    # Document Generation Settings
    default_document_font = fields.Char(
        string="Шрифт документа",
        default="Times New Roman",
        config_parameter="ic_urfu.document_font",
        help="Шрифт для генерируемых DOCX документов",
    )
    default_document_font_size = fields.Integer(
        string="Размер шрифта",
        default=12,
        config_parameter="ic_urfu.document_font_size",
        help="Размер шрифта в пунктах для документов",
    )

    # Default Values for Subjects
    default_hours = fields.Integer(
        string="Часы по умолчанию",
        default=34,
        config_parameter="ic_urfu.default_hours",
        help="Объем аудиторной работы по умолчанию для новых дисциплин",
    )
    default_credits = fields.Integer(
        string="ЗЕТ по умолчанию",
        default=3,
        config_parameter="ic_urfu.default_credits",
        help="Количество зачетных единиц по умолчанию для новых дисциплин",
    )
    default_control_form = fields.Selection(
        [
            ("exam", "Экзамен"),
            ("credit", "Зачет"),
            ("credit_grade", "Зачет с оценкой"),
        ],
        string="Форма аттестации по умолчанию",
        default="credit",
        config_parameter="ic_urfu.default_control_form",
        help="Форма контроля по умолчанию для новых дисциплин",
    )

    # Institution Defaults
    default_institute = fields.Char(
        string="Институт по умолчанию",
        config_parameter="ic_urfu.default_institute",
        help="Название института, автоматически подставляется в новые планы",
    )
    default_department = fields.Char(
        string="Кафедра/Департамент по умолчанию",
        config_parameter="ic_urfu.default_department",
        help="Название кафедры/департамента, автоматически подставляется в новые планы",
    )

    # Workflow Settings
    notification_enabled = fields.Boolean(
        string="Включить уведомления",
        default=True,
        config_parameter="ic_urfu.notification_enabled",
        help="Отправлять уведомления студентам при изменении статуса плана",
    )
