local-init-env:
	ansible-playbook ansible/playbooks/init-env.yml -i ansible/local/hosts.yml
local-up:
	make local-init-env
	docker-compose up -d
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	docker ps
local-stop:
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/local/hosts.yml
	docker-compose stop
local-restart:
	make local-init-env
	ansible-playbook ansible/playbooks/mysql/stop.yml -i ansible/local/hosts.yml
	ansible-playbook ansible/playbooks/mysql/start.yml -i ansible/local/hosts.yml
	docker-compose stop
	docker-compose up -d
	docker ps
local-import-mysql-db:
	ansible-playbook ansible/playbooks/mysql/import-db.yml -i ansible/local/hosts.yml