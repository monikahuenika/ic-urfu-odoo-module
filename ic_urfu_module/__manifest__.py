# Copyright <2026> Michael <->
# License MIT
{
    "name": "IC UrFU Module",
    "summary": "Individual education plan generator for UrFU",
    "version": "17.0.1.0.0",
    "development_status": "Beta",
    "category": "Education",
    "website": "-",
    "author": "<->",
    "maintainers": ["TheMLord"],
    "license": "LGPL-3",
    "application": True,
    "installable": True,
    "depends": ["base", "web", "mail"],
    "external_dependencies": {
        "python": ["docx"],
    },
    "data": [
        "security/ic_urfu_security.xml",
        "security/ir.model.access.csv",
        "views/ic_urfu_views.xml",
        "views/ic_urfu_config_views.xml",
    ],
}
