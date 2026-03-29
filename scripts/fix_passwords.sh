#!/bin/bash
# Reset student/teacher passwords (users must exist — run make upgrade-module once after pulling data/demo_users.xml).

set -e

echo "=========================================="
echo "  Demo user passwords"
echo "=========================================="
echo ""

if ! docker ps | grep -q odoo_app; then
    echo "❌ Error: Odoo container is not running!"
    echo "   Start it with: make start"
    exit 1
fi

docker exec -i odoo_app odoo shell -c /etc/odoo/odoo.conf -d odoo --no-http 2>&1 <<'PYEOF'
missing = []
student = env["res.users"].search([("login", "=", "student")], limit=1)
if student:
    student.write({"password": "student"})
    print("✓ Student password set (id=%s)" % student.id)
else:
    missing.append("student")
    print("✗ No login=student — run: make upgrade-module")

teacher = env["res.users"].search([("login", "=", "teacher")], limit=1)
if teacher:
    teacher.write({"password": "teacher"})
    print("✓ Teacher password set (id=%s)" % teacher.id)
else:
    missing.append("teacher")
    print("✗ No login=teacher — run: make upgrade-module")

env.cr.commit()
if missing:
    print("")
    print("Create users from XML: make upgrade-module")
PYEOF

echo ""
echo "=========================================="
echo ""
