local-init-env:
	ansible-playbook ansible/playbooks/init-env.yml -i ansible/local/hosts.yml
local-up:
	make local-init-env
	docker-compose up -d
	docker-compose ps
local-stop:
	docker-compose stop
local-restart:
	make local-init-env
	docker-compose restart
	docker-compose ps
local-import-db:
	ansible-playbook ansible/playbooks/import-db.yml -i ansible/local/hosts.yml
	bash dump.sh && rm dump.sh