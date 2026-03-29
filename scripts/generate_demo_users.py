#!/usr/bin/env python3
"""
Script to generate demo_users.xml from credentials configuration.
Run this after changing credentials in ic_urfu_module/config/demo_credentials.py
"""

import importlib.util
from pathlib import Path

_REPO_ROOT = Path(__file__).resolve().parent.parent

# Load credentials module directly without importing the whole package
creds_path = _REPO_ROOT / "ic_urfu_module" / "config" / "demo_credentials.py"

spec = importlib.util.spec_from_file_location("demo_credentials", creds_path)
creds = importlib.util.module_from_spec(spec)
spec.loader.exec_module(creds)

# Generate XML content
xml_content = f"""<?xml version="1.0" encoding="utf-8"?>
<odoo>
    <data noupdate="0">
        <!-- Демо пользователь: Студент -->
        <record id="user_demo_student" model="res.users">
            <field name="name">{creds.STUDENT_NAME}</field>
            <field name="login">{creds.STUDENT_LOGIN}</field>
            <field name="password">{creds.STUDENT_PASSWORD}</field>
            <field name="email">{creds.STUDENT_EMAIL}</field>
            <field name="groups_id" eval="[(4, ref('{creds.STUDENT_GROUP_REF}'))]"/>
            <field name="company_id" ref="{creds.DEFAULT_COMPANY_REF}"/>
        </record>

        <!-- Демо пользователь: Преподаватель -->
        <record id="user_demo_teacher" model="res.users">
            <field name="name">{creds.TEACHER_NAME}</field>
            <field name="login">{creds.TEACHER_LOGIN}</field>
            <field name="password">{creds.TEACHER_PASSWORD}</field>
            <field name="email">{creds.TEACHER_EMAIL}</field>
            <field name="groups_id" eval="[(4, ref('{creds.TEACHER_GROUP_REF}'))]"/>
            <field name="company_id" ref="{creds.DEFAULT_COMPANY_REF}"/>
        </record>
    </data>
</odoo>
"""

# Write to file
output_file = _REPO_ROOT / "ic_urfu_module" / "demo" / "demo_users.xml"
output_file.write_text(xml_content, encoding="utf-8")

print(f"✓ Generated {output_file}")
print("\nCredentials used:")
print(f"  Student: {creds.STUDENT_LOGIN} / {creds.STUDENT_PASSWORD}")
print(f"  Teacher: {creds.TEACHER_LOGIN} / {creds.TEACHER_PASSWORD}")
