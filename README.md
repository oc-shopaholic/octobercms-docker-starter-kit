Features:

  * Based on [laradock](https://laradock.io/).
  * Make commands based on ansible playbooks.
  * Allows you to store configuration files for local/staging/production environments in the repository.
  * Allows you to store credentials and settings in encrypted .yml with using [ansible vault](https://docs.ansible.com/ansible/2.4/vault.html).
  * Commands allow you to quickly up/stop/restart/rebuild docker containers on different environments (local, staging, production).
  * Commands allow you to quickly create staging server with using [DO droplets](https://www.digitalocean.com/products/droplets/).
  * Commands allow you to quickly configure production server.
  * Commands allow you to quickly update your staging/production servers.
  * Commands allow you to quickly install OctoberCMS and start new project with [empty theme](https://github.com/lovata/octobercms-starter-kit-laravel-mix).
  * Commands allow you to quickly import/export database, images, content with saving zip archive on bitbacket

# Prepare local environment

1. Install **docker, ansible, make**.
  * For Ubuntu: ```sudo bash bash/install-ubuntu.sh```.
  * For Linux Mint: ```sudo bash bash/install-mint.sh```.
2. Run ```sudo usermod -a -G docker $USER```.
You need **reboot** system, after running the command.

# Usage guide

  * You can run the project using ```make local-up``` command.
  * You can check docker container status using ```make docker-status``` command.
  * You can connect to workspace using ```make local-bash``` command.
  * You can run migrations using ```make local-october-up``` command.
> **app/vendor** folder can be in .gitignore file, so after cloning project you need to run ```local-composer-install``` command.

### First start

  * Clone repo with project.
  * Run ```make local-first-start``` command.
  * Connect to workspace. Run ```make local-bash``` command.
  * Run ```nmp i``` and ```npm run watch``` commands.

### Usual developer day guide

  * Run ```make local-up``` command.
  * Connect to workspace. Run ```make local-bash``` command.
  * Run ```npm run watch``` commands.
  * You start to do the task.
  
 >  If you get **database error**, after updating the project, then you can update your database (```make import-mysql-db```) or apply migrations (```make local-october-up```).
 
 >  If you get **non-database error**, after updating the project, then you can try run ```make local-composer-install``` command.

### Useful links

  * Maildev - http://localhost:1080/
  * PHPMyAdmin - http://localhost:8080/
  * Beanstalkd console - http://localhost:2080/
  * Netdata - http://localhost:19999/
  * Grafana - http://localhost:3000/
  * Metabase - http://localhost:3030/
  * Portainer - http://localhost:9010/
  * Docker web UI - http://localhost:8754/
  * PHPRedisAdmin - http://localhost:9987/
  * Kibana - http://localhost:5601/

# Available commands (local environment)

### local-first-start

Starts docker machines. Run import-full command.
```bash
make local-first-start [src=bitbucket|staging|production]
```

### local-up

Starts docker machines.
```bash
make local-up
```

### local-restart

Restarts docker machines.
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

### local-bash

Connect to workspace with laradock user
```bash
make local-bash
```

### local-composer-install

Connect to workspace with laradock user and run composer install
```bash
make local-composer-install
```

### local-october-up

Connect to workspace with laradock user and apply migrations
```bash
make local-october-up
```

### local-npm-prod

Connect to workspace with laradock user and run ```npm run prod```
```bash
make local-npm-prod
```

### local-sphinx-rotate-all

Connect to Sphinx search container and run ```indexer --rotate --all```
```bash
make local-sphinx-rotate-all
```

# Database

### import-mysql-db

  * Download db.zip file from bitbucket.
  * Get dump db.sql file from temp/db.zip archive.
  * Import mysql dump file.
```bash
make import-mysql-db [src=bitbucket|staging|production]
```

### export-mysql-db

  * Export mysql database in db.sql file.
  * Create temp/db.zip archive with db.sql file.
  * Upload db.zip archive to bitbucket.
```bash
make export-mysql-db [src=bitbucket]
```

# Content files

### import-content

  * Download content.zip file from bitbucket.
  * Get content files from temp/content.zip archive.
  * Copy content folders: meta, content.
```bash
make import-content [src=bitbucket|staging|production]
```

### export-content

  * Copy content folders: meta, content.
  * Create temp/content.zip archive with content files.
  * Upload content.zip archive to bitbucket.
```bash
make export-content [src=bitbucket]
```

# Image files

### import-images

  * Download images.zip file from bitbucket.
  * Get images files from temp/images.zip archive.
  * Copy images folders: upload, media.
```bash
make import-images [src=bitbucket|staging|production]
```

### export-images

  * Copy images folders: upload, media.
  * Create temp/images.zip archive with images files.
  * Upload images.zip archive to bitbucket.
```bash
make export-images [src=bitbucket]
```

# Full import/export

### import-full

Starts import mysql database, content files, images.
```bash
make import-full [src=bitbucket|staging|production]
```

### export-full

Starts export mysql database, content files, images.
```bash
make export-full [src=bitbucket]
```

# Available commands (staging environment)

Features:
  * Allow you to create/update [DO droplets](https://www.digitalocean.com/products/droplets/).
  * Creates app_user on server. Docker container starts from 'app_user' user. Project folder is '/home/app_user/project'.
  * Allow you to quickly update project on [DO droplets](https://www.digitalocean.com/products/droplets/).

### staging-create

Creates droplet machine.
```bash
make staging-create [prefix=staging]
```

### staging-provisioning

Configure server default setup.
```bash
make staging-provisioning [prefix=staging]
```

### staging-first-start

Connect to staging server. Starts docker machines. Run import-full command.
```bash
make staging-first-start [prefix=staging] [version=master] [src=bitbucket|production]
```

### staging-up

Connect to staging server. Starts docker machines.
```bash
make staging-up [prefix=master]
```

### staging-pull

Connect to staging server and update project
```bash
make staging-pull [prefix=master] [version=master]
```

### staging-restart

Connect to staging server. Restarts docker machines.
```bash
make staging-restart [prefix=master]
```

### staging-stop

Stops docker machines on staging server.
```bash
make staging-stop [prefix=master]
```

### staging-rebuild

Rebuild and restart docker machines on staging server.
```bash
make staging-rebuild [prefix=master]
```

### staging-import-mysql-db

  * Connect to staging droplet.
  * Download db.zip file from bitbucket.
  * Get dump db.sql file from temp/db.zip archive.
  * Import mysql dump file.
```bash
make staging-import-mysql-db [prefix=master] [src=bitbucket|staging|production]
```

### staging-export-mysql-db

  * Connect to staging droplet.
  * Export mysql database in db.sql file.
  * Create temp/db.zip archive with db.sql file.
  * Upload db.zip archive to bitbucket.
```bash
make staging-export-mysql-db [prefix=master] [src=bitbucket]
```

### staging-import-content

  * Connect to staging droplet.
  * Download content.zip file from bitbucket.
  * Get content files from temp/content.zip archive.
  * Copy content folders: meta, content.
```bash
make staging-import-content [prefix=master] [src=bitbucket|staging|production]
```

### staging-export-content

  * Connect to staging droplet.
  * Copy content folders: meta, content.
  * Create temp/content.zip archive with content files.
  * Upload content.zip archive to bitbucket.
```bash
make staging-export-content [prefix=master] [src=bitbucket]
```

### staging-import-images

  * Connect to staging droplet.
  * Download images.zip file from bitbucket.
  * Get images files from temp/images.zip archive.
  * Copy images folders: upload, media.
```bash
make staging-import-images [prefix=master] [src=bitbucket|staging|production]
```

### staging-export-images

  * Connect to staging droplet.
  * Copy images folders: upload, media.
  * Create temp/images.zip archive with images files.
  * Upload images.zip archive to bitbucket.
```bash
make staging-export-images [prefix=master] [src=bitbucket]
```

### staging-import-full

Starts import mysql database, content files, images.
```bash
make staging-import-full [src=bitbucket|staging|production]
```

### staging-export-full

Starts export mysql database, content files, images.
```bash
make staging-export-full [src=bitbucket]
```

### staging-sphinx-rotate-all

Connect to Sphinx search container and run ```indexer --rotate --all```
```bash
make staging-sphinx-rotate-all
```

# Available commands (production environment)

Features:
  * Allow you to configure production server.
  * Creates app_user on server. Docker container starts from 'app_user' user. Project folder is '/home/app_user/project'.
  * Allow you to quickly update project on production server.

### production-up

Connect to production server. Starts docker machines.
```bash
make production-up
```

### production-pull

Connect to production server and update project.
```bash
make production-pull
```

### production-simple-pull

Connect to production server and update project.
```bash
make production-simple-pull
```

### production-restart

Connect to production server. Restarts docker machines.
```bash
make production-restart
```

### production-stop

Stops docker machines on production server.
```bash
make production-stop
```

### production-rebuild

Rebuild and restart docker machines on production server.
```bash
make production-rebuild
```

### production-import-mysql-db

  * Connect to production server.
  * Download db.zip file from bitbucket.
  * Get dump db.sql file from temp/db.zip archive.
  * Import mysql dump file.
```bash
make production-import-mysql-db [src=bitbucket]
```

### production-export-mysql-db

  * Connect to production server.
  * Export mysql database in db.sql file.
  * Create temp/db.zip archive with db.sql file.
  * Upload db.zip archive to bitbucket.
```bash
make production-export-mysql-db [src=bitbucket]
```

### production-import-content

  * Connect to production server.
  * Download content.zip file from bitbucket.
  * Get content files from temp/content.zip archive.
  * Copy content folders: meta, content.
```bash
make production-import-content [src=bitbucket]
```

### production-export-content

  * Connect to production server.
  * Copy content folders: meta, content.
  * Create temp/content.zip archive with content files.
  * Upload content.zip archive to bitbucket.
```bash
make production-export-content [src=bitbucket]
```

### production-import-images

  * Connect to production server.
  * Download images.zip file from bitbucket.
  * Get images files from temp/images.zip archive.
  * Copy images folders: upload, media.
```bash
make production-import-images [src=bitbucket]
```

### production-export-images

  * Connect to production server.
  * Copy images folders: upload, media.
  * Create temp/images.zip archive with images files.
  * Upload images.zip archive to bitbucket.
```bash
make production-export-images [src=bitbucket]
```

### production-import-full

Starts import mysql database, content files, images.
```bash
make production-import-full [src=bitbucket]
```

### production-export-full

Starts export mysql database, content files, images.
```bash
make production-export-full [src=bitbucket]
```

### production-sphinx-rotate-all

Connect to Sphinx search container and run ```indexer --rotate --all```
```bash
make production-sphinx-rotate-all
```

# Project initialisation

Steps of quick start of new project:

  * You need to change *.yml files with vars in folder **ansible/vars**.
  * You need to check and change template files in folder **ansible/templates**.
  * You need to change workspace host name in **ansible/*-hosts.yml** and playbooks (For example: from **laradockoctober_workspace_1** to **laradockmyproject_workspace_1**).
  * You need to set app_user password in provision playbooks with using [dock](https://docs.ansible.com/ansible/latest/reference_appendices/faq.html#how-do-i-generate-encrypted-passwords-for-the-user-module).
  * Run ```make project-install``` command.