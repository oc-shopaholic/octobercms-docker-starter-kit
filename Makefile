prefix = 'staging'
inventory = 'local'
version = 'master'

# Local commands
local-init-env:
	ansible-playbook ansible/playbooks/init-env.yml -i ansible/$(inventory)-hosts.yml
local-up:
	make local-init-env
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/build.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-stop:
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/$(inventory)-hosts.yml
	docker-compose stop
local-restart:
	make local-init-env
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
	docker-compose stop
	docker-compose up -d
	make docker-status
local-rebuild:
	make local-stop
	make local-init-env
	ansible-playbook ansible/playbooks/mysql/rebuild.yml -i ansible/$(inventory)-hosts.yml
	docker-compose build
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-bash:
	docker-compose exec --user=laradock workspace bash
local-composer-install:
	ansible-playbook ansible/playbooks/project/composer-install.yml -i ansible/$(inventory)-hosts.yml
local-october-up:
	ansible-playbook ansible/playbooks/project/october-up.yml -i ansible/$(inventory)-hosts.yml
local-npm-prod:
	ansible-playbook ansible/playbooks/project/npm-prod.yml -i ansible/$(inventory)-hosts.yml

# Import/export database commands
import-mysql-db:
	ansible-playbook ansible/playbooks/mysql/import-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-mysql-db:
	ansible-playbook ansible/playbooks/mysql/export-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Import/export content commands
import-content:
	ansible-playbook ansible/playbooks/content/import-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-content:
	ansible-playbook ansible/playbooks/content/export-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Import/export images commands
import-images:
	ansible-playbook ansible/playbooks/images/import-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-images:
	ansible-playbook ansible/playbooks/images/export-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Staging commands
staging-create :
	ansible-playbook ansible/playbooks/terraform/apply.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-provisioning :
	ansible-playbook ansible/playbooks/terraform/provisioning.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) GIT_VERSION=$(version)"
staging-destroy :
	ansible-playbook ansible/playbooks/terraform/destroy.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-up :
	ansible-playbook ansible/playbooks/staging/up.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-stop :
	ansible-playbook ansible/playbooks/staging/stop.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-restart :
	ansible-playbook ansible/playbooks/staging/restart.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-rebuild :
	ansible-playbook ansible/playbooks/staging/rebuild.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-pull :
	ansible-playbook ansible/playbooks/staging/pull.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) GIT_VERSION=$(version)"
staging-import-mysql-db :
	ansible-playbook ansible/playbooks/staging/import-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-mysql-db :
	ansible-playbook ansible/playbooks/staging/export-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-import-content :
	ansible-playbook ansible/playbooks/staging/import-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-content :
	ansible-playbook ansible/playbooks/staging/export-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-import-images :
	ansible-playbook ansible/playbooks/staging/import-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-images :
	ansible-playbook ansible/playbooks/staging/export-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"

# Production server commands
production-create :
	ansible-playbook ansible/playbooks/terraform/apply.yml -i ansible/production-hosts.yml
production-provisioning :
	ansible-playbook ansible/playbooks/terraform/provisioning.yml -i ansible/production-hosts.yml --extra-vars "GIT_VERSION=$(version)"
production-destroy :
	ansible-playbook ansible/playbooks/terraform/destroy.yml -i ansible/production-hosts.yml
production-up :
	ansible-playbook ansible/playbooks/production/up.yml -i ansible/production-hosts.yml
production-stop :
	ansible-playbook ansible/playbooks/production/stop.yml -i ansible/production-hosts.yml
production-restart :
	ansible-playbook ansible/playbooks/production/restart.yml -i ansible/production-hosts.yml
production-rebuild :
	ansible-playbook ansible/playbooks/production/rebuild.yml -i ansible/production-hosts.yml
production-pull :
	ansible-playbook ansible/playbooks/production/pull.yml -i ansible/production-hosts.yml --extra-vars "GIT_VERSION=$(version)"
production-import-mysql-db :
	ansible-playbook ansible/playbooks/production/import-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-mysql-db :
	ansible-playbook ansible/playbooks/production/export-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-import-content :
	ansible-playbook ansible/playbooks/production/import-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-content :
	ansible-playbook ansible/playbooks/production/export-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-import-images :
	ansible-playbook ansible/playbooks/production/import-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-images :
	ansible-playbook ansible/playbooks/production/export-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Docker commands
docker-status:
	docker ps

# Project install commands
project-install:
	ansible-playbook ansible/playbooks/project/install.yml -i ansible/local-hosts.yml
	make project-laravel-mix-install
project-laravel-mix-install:
	ansible-playbook ansible/playbooks/project/install-laravel-mix.yml -i ansible/local-hosts.yml