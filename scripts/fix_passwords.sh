#!/bin/bash
# Script to fix user passwords if login fails

set -e

echo "=========================================="
echo "  Fixing User Passwords"
echo "=========================================="
echo ""

# Check if containers are running
if ! docker ps | grep -q odoo_app; then
    echo "❌ Error: Odoo container is not running!"
    echo "   Start it with: make start"
    exit 1
fi

echo "🔧 Updating passwords in database..."
echo ""

# Execute password update directly via stdin
docker exec -i odoo_app odoo shell -c /etc/odoo/odoo.conf -d odoo --no-http 2>&1 <<'PYEOF' | grep -E '(✓|✗|✅|Password)'
# Update student password
student = env['res.users'].search([('login', '=', 'student')], limit=1)
if student:
    student.write({'password': 'student'})
    print('✓ Student password updated (ID: {})'.format(student.id))
else:
    print('✗ Student user not found!')

# Update teacher password
teacher = env['res.users'].search([('login', '=', 'teacher')], limit=1)
if teacher:
    teacher.write({'password': 'teacher'})
    print('✓ Teacher password updated (ID: {})'.format(teacher.id))
else:
    print('✗ Teacher user not found!')

env.cr.commit()
print('')
print('✅ Passwords updated successfully!')
PYEOF

echo ""
echo "=========================================="
echo "  ✅ Done!"
echo "=========================================="
echo ""
echo "🔐 You can now login with:"
echo ""
echo "   Student:  student / student"
echo "   Teacher:  teacher / teacher"
echo ""
echo "🌐 URL: http://localhost:8069"
echo ""
