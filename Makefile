local-init-env:
	ansible-playbook ansible/playbooks/init-env.yml -i ansible/local/hosts.yml
local-up:
	make local-init-env
	docker-compose up -d
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
	ansible-playbook ansible/playbooks/mysql/build.yml -i ansible/local/hosts.yml
	docker-compose build
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	make docker-status
local-import-mysql-db:
	ansible-playbook ansible/playbooks/mysql/import-db.yml -i ansible/local/hosts.yml
docker-status:
	docker ps
project-install:
	ansible-playbook ansible/playbooks/project/install.yml -i ansible/local/hosts.yml