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

### local-bash

Connect to workspace with laradock user
```bash
make local-bash
```

# Database

### import-mysql-db

  * Get dump db.sql file from temp/db.zip archive.
  * Import mysql dump file.
```bash
make import-mysql-db
```

  * Download db.zip file from bitbacket.
  * Get dump db.sql file from temp/db.zip archive.
  * Import mysql dump file.
```bash
make import-mysql-db --src=bitbacket
```

### export-mysql-db

  * Export mysql database in db.sql file.
  * Create temp/db.zip archive with db.sql file.
```bash
make export-mysql-db
```

  * Export mysql database in db.sql file.
  * Create temp/db.zip archive with db.sql file.
  * Upload db.zip archive to bitbacket.
```bash
make export-mysql-db --src=bitbacket
```

# Content files

### import-content

  * Get content files from temp/content.zip archive.
  * Copy content folders: meta, content.
```bash
make import-content
```

  * Download content.zip file from bitbacket.
  * Get content files from temp/content.zip archive.
  * Copy content folders: meta, content.
```bash
make import-content --src=bitbacket
```

### export-content

  * Copy content folders: meta, content.
  * Create temp/content.zip archive with content files.
```bash
make export-content
```

  * Copy content folders: meta, content.
  * Create temp/content.zip archive with content files.
  * Upload content.zip archive to bitbacket.
```bash
make export-content --src=bitbacket
```

# Image files

### import-images

  * Get images files from temp/images.zip archive.
  * Copy images folders: upload, media.
```bash
make import-images
```

  * Download images.zip file from bitbacket.
  * Get images files from temp/images.zip archive.
  * Copy images folders: upload, media.
```bash
make import-images --src=bitbacket
```

### export-images

  * Copy images folders: upload, media.
  * Create temp/images.zip archive with images files.
```bash
make export-images
```

  * Copy images folders: upload, media.
  * Create temp/images.zip archive with images files.
  * Upload images.zip archive to bitbacket.
```bash
make export-images --src=bitbacket
```

# Project initialisation

Steps of quick start of new project:
1. You need change *.yml file with vars in folder **ansible/vars**.
2. You need check and change template files in folder **ansible/templates**.
3. You need change workspace host name in **ansible/local/hosts.yml** and **ansible/playbooks/mysql/import-db.yml** (For example: **laradockoctober_workspace_1**).
4. Run ```make project-install``` command.