# Local commands
local-init-env:
	ansible-playbook ansible/playbooks/init-env.yml -i ansible/local/hosts.yml
local-up:
	make local-init-env
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/build.yml -i ansible/local/hosts.yml
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	make docker-status
local-stop:
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/local/hosts.yml
	docker-compose stop
local-restart:
	make local-init-env
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/local/hosts.yml
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	docker-compose stop
	docker-compose up -d
	make docker-status
local-rebuild:
	make local-stop
	make local-init-env
	ansible-playbook ansible/playbooks/mysql/rebuild.yml -i ansible/local/hosts.yml
	docker-compose build
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	make docker-status
local-bash:
	docker-compose exec --user=laradock workspace bash

# Import/export database commands
import-mysql-db:
	ansible-playbook ansible/playbooks/mysql/import-db.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"
export-mysql-db:
	ansible-playbook ansible/playbooks/mysql/export-db.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"

# Import/export content commands
import-content:
	ansible-playbook ansible/playbooks/content/import-content.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"
export-content:
	ansible-playbook ansible/playbooks/content/export-content.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"

# Import/export images commands
import-images:
	ansible-playbook ansible/playbooks/images/import-images.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"
export-images:
	ansible-playbook ansible/playbooks/images/export-images.yml -i ansible/local/hosts.yml --extra-vars "dump_src=$(src)"

# Docker commands
docker-status:
	docker ps

# Project install commands
project-install:
	ansible-playbook ansible/playbooks/project/install.yml -i ansible/local/hosts.yml
	make project-laravel-mix-install
project-laravel-mix-install:
	ansible-playbook ansible/playbooks/project/install-laravel-mix.yml -i ansible/local/hosts.yml