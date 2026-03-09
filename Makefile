.PHONY: help init bootstrap start stop restart logs clean status shell db-shell test-generator update-credentials fix-passwords

# Default target
help:
	@echo ""
	@echo "IC UrFU Odoo Module - Available Commands"
	@echo "=========================================="
	@echo ""
	@echo "  make bootstrap          - 🚀 Full setup from scratch (clean + init)"
	@echo "  make init               - Initialize project from scratch (first-time setup)"
	@echo "  make start              - Start Docker containers"
	@echo "  make stop               - Stop Docker containers"
	@echo "  make restart            - Restart Docker containers"
	@echo "  make logs               - View Odoo logs (Ctrl+C to exit)"
	@echo "  make status             - Check containers status"
	@echo "  make shell              - Open shell in Odoo container"
	@echo "  make db-shell           - Open PostgreSQL shell"
	@echo "  make test-generator     - Test document generator standalone"
	@echo "  make update-credentials - Regenerate demo_users.xml from credentials config"
	@echo "  make fix-passwords      - Fix user passwords if login fails"
	@echo "  make clean              - Remove all data (containers, volumes, DB)"
	@echo ""
	@echo "🔐 To change passwords: edit ic_urfu_module/config/demo_credentials.py"
	@echo ""
	@echo "💡 First time? Run: make bootstrap"
	@echo ""

# Bootstrap: complete setup from scratch
bootstrap:
	@echo ""
	@echo "🚀 Starting full bootstrap process..."
	@echo ""
	@echo "This will:"
	@echo "  1. Stop and remove all containers"
	@echo "  2. Delete all volumes (database will be lost!)"
	@echo "  3. Initialize fresh installation"
	@echo "  4. Create users from credentials config"
	@echo ""
	@read -p "Are you sure? Type 'yes' to continue: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		cd local-env && docker compose down -v && cd ..; \
		make init; \
	else \
		echo "Cancelled."; \
	fi

# Initialize project from scratch
init: update-credentials
	@./scripts/init.sh

# Update credentials (regenerate demo_users.xml from config)
update-credentials:
	@echo "Regenerating demo_users.xml from credentials config..."
	@python3 scripts/generate_demo_users.py
	@echo ""

# Fix passwords if login fails
fix-passwords:
	@./scripts/fix_passwords.sh

# Start containers
start:
	@echo "Starting Docker containers..."
	@cd local-env && docker compose up -d
	@echo "✓ Containers started!"
	@echo ""
	@echo "Odoo:       http://localhost:8069"
	@echo "PostgreSQL: localhost:5432"
	@echo ""
	@echo "Login: student / student"
	@echo "       teacher / teacher"
	@echo ""

# Stop containers
stop:
	@echo "Stopping Docker containers..."
	@cd local-env && docker compose down
	@echo "✓ Containers stopped!"

# Restart containers
restart:
	@echo "Restarting Docker containers..."
	@cd local-env && docker compose restart
	@echo "✓ Containers restarted!"

# View logs
logs:
	@cd local-env && docker compose logs -f odoo

# Check status
status:
	@echo "Container Status:"
	@echo "=================="
	@cd local-env && docker compose ps
	@echo ""
	@echo "Database Status:"
	@echo "=================="
	@docker exec odoo_db pg_isready -U odoo 2>/dev/null && echo "✓ PostgreSQL is ready" || echo "✗ PostgreSQL is not ready"
	@echo ""
	@echo "Odoo URL: http://localhost:8069"

# Open shell in Odoo container
shell:
	@echo "Opening shell in Odoo container..."
	@docker exec -it odoo_app /bin/bash

# Open PostgreSQL shell
db-shell:
	@echo "Opening PostgreSQL shell..."
	@docker exec -it odoo_db psql -U odoo -d odoo

# Test document generator standalone
test-generator:
	@echo "Testing document generator..."
	@cd ic_urfu_module/doc_generator && python3 doc_generator.py
	@echo "✓ Document generated! Check ic_urfu_module/doc_generator/ for output."

# Clean everything (WARNING: deletes all data!)
clean:
	@echo "⚠️  WARNING: This will delete ALL data including:"
	@echo "   - Docker containers"
	@echo "   - Docker volumes (database will be lost!)"
	@echo "   - All uploaded files"
	@echo ""
	@read -p "Are you sure? Type 'yes' to confirm: " confirm; \
	if [ "$$confirm" = "yes" ]; then \
		echo "Stopping and removing containers..."; \
		cd local-env && docker compose down -v; \
		echo "✓ All data removed!"; \
		echo ""; \
		echo "Run 'make init' to start fresh."; \
	else \
		echo "Cancelled."; \
	fi
