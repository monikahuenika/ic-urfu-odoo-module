#!/usr/bin/env bash
# Read-only checks: is the Odoo DB initialized, is ic_urfu_module installed, do demo users exist?
set -euo pipefail

if ! docker ps --format '{{.Names}}' | grep -qx odoo_db; then
  echo "ERROR: odoo_db container not running. Run: make start"
  exit 1
fi

PSQL=(docker exec odoo_db psql -U odoo -d odoo -q)

echo "--- 1) Database reachable ---"
"${PSQL[@]}" -c "SELECT current_database() AS db, version() AS pg;"

echo ""
echo "--- 2) Initialized? (ir_module_module = Odoo metadata) ---"
HAS_META=$("${PSQL[@]}" -tAc "SELECT EXISTS (
  SELECT 1 FROM information_schema.tables
  WHERE table_schema = 'public' AND table_name = 'ir_module_module'
);")
echo "ir_module_module exists: ${HAS_META}"

if [ "$HAS_META" != "t" ]; then
  echo ""
  echo "DB is NOT initialized (no Odoo tables). Run: make init  (or make clean && make init)"
  exit 0
fi

echo ""
echo "--- 3) Module state (want ic_urfu_module = installed) ---"
"${PSQL[@]}" -c "SELECT name, state, latest_version FROM ir_module_module WHERE name IN ('base','web','mail','ic_urfu_module') ORDER BY name;"

echo ""
echo "--- 4) Logins (Odoo uses res_users.login, NOT email) ---"
"${PSQL[@]}" -c "SELECT u.id, u.login, u.active, u.share, p.email
FROM res_users u
LEFT JOIN res_partner p ON p.id = u.partner_id
WHERE u.login IN ('admin','student','teacher')
ORDER BY u.login;"

echo ""
echo "--- 5) Users with @ in login (usually wrong — use student / teacher) ---"
"${PSQL[@]}" -c "SELECT id, login, active FROM res_users WHERE login LIKE '%@%' LIMIT 10;"

echo ""
echo "Tips:  · Login = student or teacher (column login), password from make fix-passwords"
echo "       · If ic_urfu_module is uninstalled: Apps → Update Apps List → Install, or make clean && make init"
