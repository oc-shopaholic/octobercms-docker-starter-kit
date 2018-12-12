# Prepare local environment

1. Install **docker, ansible, make**.
  * For Ubuntu: ```sudo bash bash/install-ubuntu.sh```.
  * For Linux Mint: ```sudo bash bash/install-mint.sh```.
2. Run ```sudo usermod -a -G docker $USER```.
You need **reboot** system, after running the command.

# Available commands (local environment)

### init-local-env

Creates local environment files from templates.
```bash
make local-init-env
```

### local-up

Creates local environment files from templates. Starts docker machines. (local-init-env + docker-compose up)
```bash
make local-up
```

### local-restart

Creates local environment files from templates. Restarts docker machines. (local-init-env + docker-compose up)
```bash
make local-restart
```

### local-stop

Stops docker machines.
```bash
make local-stop
```

### local-rebuild

Rebuild and restart docker machines.
```bash
make local-rebuild
```

### local-import-mysql-db

Get dump file from server or bitbacket files. Import mysql db from dump file.
```bash
make local-import-mysql-db
```

# Project initialisation

Steps of quick start of new project:
1. You need change *.yml file with vars in folder **ansible/vars**.
2. You need check and change template files in folder **ansible/templates**.
3. You need change workspace host name in **ansible/local/hosts.yml** and **ansible/playbooks/mysql/import-db.yml** (For example: **laradockoctober_workspace_1**).