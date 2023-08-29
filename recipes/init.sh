# Fill vault password for local environment
echo "Please enter vault password for local environment:"
read vault_password

echo $vault_password > .vault-password-local

# Remove .git folder from source repository
#rm -R .git

# Run "init-docker.yml" playbook
ansible-playbook --vault-id .vault-password-local ansible/playbooks/project/init-docker.yml -i ansible/local-hosts.yml

docker-compose up -d backend
