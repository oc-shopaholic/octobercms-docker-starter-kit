prefix = 'staging'
inventory = 'local'
version = 'master'
src = 'bitbucket'

# Local commands
local-first-start:
	ansible-playbook --vault-id password ansible/playbooks/init-env.yml -i ansible/$(inventory)-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
	docker-compose up -d
#	ansible-playbook --vault-id password ansible/playbooks/project/generate-public-mirror.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/build.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
	make local-composer-install
	make import-full src=$(src)
	make local-october-up
	make local-npm-prod
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/build.yml -i ansible/$(inventory)-hosts.yml
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/start.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-up:
	ansible-playbook --vault-id password ansible/playbooks/init-env.yml -i ansible/$(inventory)-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
	docker-compose up -d
#	ansible-playbook --vault-id password ansible/playbooks/project/generate-public-mirror.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/build.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/build.yml -i ansible/$(inventory)-hosts.yml
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/start.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-stop:
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/stop.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/stop.yml -i ansible/$(inventory)-hosts.yml
	docker-compose stop
local-restart:
	ansible-playbook --vault-id password ansible/playbooks/init-env.yml -i ansible/$(inventory)-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/stop.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/stop.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/start.yml -i ansible/$(inventory)-hosts.yml
	docker-compose stop
	docker-compose up -d
#	ansible-playbook --vault-id password ansible/playbooks/project/generate-public-mirror.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-rebuild:
	make local-stop
	ansible-playbook --vault-id password ansible/playbooks/init-env.yml -i ansible/$(inventory)-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/rebuild.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/rebuild.yml -i ansible/$(inventory)-hosts.yml
	docker-compose up -d --force-recreate --build
#	ansible-playbook --vault-id password ansible/playbooks/project/generate-public-mirror.yml -i ansible/$(inventory)-hosts.yml
	ansible-playbook --vault-id password ansible/playbooks/mysql/start.yml -i ansible/$(inventory)-hosts.yml
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/start.yml -i ansible/$(inventory)-hosts.yml
	make docker-status
local-bash:
	docker-compose exec --user=laradock workspace bash
local-composer-install:
	ansible-playbook --vault-id password ansible/playbooks/project/composer-install.yml -i ansible/$(inventory)-hosts.yml
local-october-up:
	ansible-playbook --vault-id password ansible/playbooks/project/october-up.yml -i ansible/$(inventory)-hosts.yml
local-npm-prod:
	ansible-playbook --vault-id password ansible/playbooks/project/npm-prod.yml -i ansible/$(inventory)-hosts.yml
#local-sphinx-rotate-all:
#	ansible-playbook --vault-id password ansible/playbooks/sphinxsearch/indexer-rotate-all.yml -i ansible/$(inventory)-hosts.yml

# Import/export database commands
import-mysql-db:
	ansible-playbook --vault-id password ansible/playbooks/mysql/import-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-mysql-db:
	ansible-playbook --vault-id password ansible/playbooks/mysql/export-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Import/export content commands
import-content:
	ansible-playbook --vault-id password ansible/playbooks/content/import-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-content:
	ansible-playbook --vault-id password ansible/playbooks/content/export-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Import/export images commands
import-images:
	ansible-playbook --vault-id password ansible/playbooks/images/import-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-images:
	ansible-playbook --vault-id password ansible/playbooks/images/export-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Import/export full
import-full :
	ansible-playbook --vault-id password ansible/playbooks/mysql/import-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/content/import-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/images/import-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
export-full :
	ansible-playbook --vault-id password ansible/playbooks/mysql/export-db.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/content/export-content.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/images/export-images.yml -i ansible/$(inventory)-hosts.yml --extra-vars "DUMP_SRC=$(src)"

# Staging commands
staging-first-start:
	make staging-create prefix=$(prefix)
	sleep 30
	make staging-provisioning prefix=$(prefix) version=$(version)
	ansible-playbook --vault-id password ansible/playbooks/staging/first-start.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-create :
	ansible-playbook --vault-id password ansible/playbooks/terraform/apply.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-provisioning :
	ansible-playbook --vault-id password ansible/playbooks/terraform/provisioning.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) GIT_VERSION=$(version)"
staging-destroy :
	ansible-playbook --vault-id password ansible/playbooks/terraform/destroy.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-up :
	ansible-playbook --vault-id password ansible/playbooks/staging/up.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-stop :
	ansible-playbook --vault-id password ansible/playbooks/staging/stop.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-restart :
	ansible-playbook --vault-id password ansible/playbooks/staging/restart.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-rebuild :
	ansible-playbook --vault-id password ansible/playbooks/staging/rebuild.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"
staging-pull :
	ansible-playbook --vault-id password ansible/playbooks/staging/pull.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) GIT_VERSION=$(version)"
staging-import-mysql-db :
	ansible-playbook --vault-id password ansible/playbooks/staging/import-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-mysql-db :
	ansible-playbook --vault-id password ansible/playbooks/staging/export-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-import-content :
	ansible-playbook --vault-id password ansible/playbooks/staging/import-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-content :
	ansible-playbook --vault-id password ansible/playbooks/staging/export-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-import-images :
	ansible-playbook --vault-id password ansible/playbooks/staging/import-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-images :
	ansible-playbook --vault-id password ansible/playbooks/staging/export-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-import-full :
	ansible-playbook --vault-id password ansible/playbooks/staging/import-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/staging/import-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/staging/import-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
staging-export-full :
	ansible-playbook --vault-id password ansible/playbooks/staging/export-mysql-db.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/staging/export-content.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/staging/export-images.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix) DUMP_SRC=$(src)"
#staging-sphinx-rotate-all :
#	ansible-playbook --vault-id password ansible/playbooks/staging/sphinx-rotate-all.yml -i ansible/staging-hosts.yml --extra-vars "STAGING_PREFIX=$(prefix)"

# Production server commands
production-provisioning :
	ansible-playbook --vault-id password ansible/playbooks/production/provisioning.yml -i ansible/production-hosts.yml --extra-vars "GIT_VERSION=$(version)"
production-up :
	ansible-playbook --vault-id password ansible/playbooks/production/up.yml -i ansible/production-hosts.yml
production-stop :
	ansible-playbook --vault-id password ansible/playbooks/production/stop.yml -i ansible/production-hosts.yml
production-restart :
	ansible-playbook --vault-id password ansible/playbooks/production/restart.yml -i ansible/production-hosts.yml
production-rebuild :
	ansible-playbook --vault-id password ansible/playbooks/production/rebuild.yml -i ansible/production-hosts.yml
production-pull :
	docker-compose up -d workspace
	ansible-playbook --vault-id password ansible/playbooks/production/pull.yml -i ansible/production-hosts.yml --extra-vars "GIT_VERSION=$(version)"
production-import-mysql-db :
	ansible-playbook --vault-id password ansible/playbooks/production/import-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-mysql-db :
	ansible-playbook --vault-id password ansible/playbooks/production/export-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-import-content :
	ansible-playbook --vault-id password ansible/playbooks/production/import-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-content :
	ansible-playbook --vault-id password ansible/playbooks/production/export-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-import-images :
	ansible-playbook --vault-id password ansible/playbooks/production/import-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-images :
	ansible-playbook --vault-id password ansible/playbooks/production/export-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-import-full :
	ansible-playbook --vault-id password ansible/playbooks/production/import-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/production/import-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/production/import-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
production-export-full :
	ansible-playbook --vault-id password ansible/playbooks/production/export-mysql-db.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/production/export-content.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
	ansible-playbook --vault-id password ansible/playbooks/production/export-images.yml -i ansible/production-hosts.yml --extra-vars "DUMP_SRC=$(src)"
#production-sphinx-rotate-all :
#	ansible-playbook --vault-id password ansible/playbooks/production/sphinx-rotate-all.yml -i ansible/production-hosts.yml

# Docker commands
docker-status:
	docker ps

# Project install commands
project-install:
	ansible-playbook --vault-id password ansible/playbooks/project/install.yml -i ansible/local-hosts.yml
	make project-laravel-mix-install
project-laravel-mix-install:
	ansible-playbook --vault-id password ansible/playbooks/project/install-laravel-mix.yml -i ansible/local-hosts.yml

# Git flow commands
git-push-release:
	git checkout develop
	git push origin develop
	git checkout master
	git push origin master
	git push --tags
	git checkout develop