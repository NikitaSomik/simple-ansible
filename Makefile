.DEFAULT_GOAL := help

help:
	@echo ""
	@echo "Available tasks:"
	@echo "	   create-vault-pass 				    	Create text file for your vault password"
	@echo "    copy-vars 				    		        Copy secret vars from example file"
	@echo "    encrypt-vars 				    		Encrypt your secret vars file"
	@echo "    decrypt-vars 				    		Decrypt your secret vars file"
	@echo "	   show-secrets  					Show decrypted secret variables"
	@echo "    apply 				    			Deploy your changes into your hosts"
	@echo "    safe-apply 				    			Deploy your changes into your hosts usingvault pass"
	@echo "    deploy 				    			Pull latest changes "
	@echo "    safe-deploy 				    		Pull latest changes with vault pass"
	@echo "    update-config 				    		Update your env file"
	@echo "    safe-update-config 				    		Update your env file with vault pass"

	@echo ""

create-vault-pass:
	touch .vault_pass.txt

copy-secret-vars:
	copy ./group_vars/secrets.example.yaml ./group_vars/secrets.yaml

encrypt-vars:
	ansible-vault encrypt ./group_vars/secrets.yml --vault-password-file .vault_pass.txt

decrypt-vars:
	ansible-vault decrypt ./group_vars/secrets.yml --vault-password-file .vault_pass.txt

show-secrets:
	@ansible-vault view group_vars/secrets.yml --vault-password-file vault_pass.txt

generate-inventory:
	python generate.py

apply:
	ansible-playbook -i hosts.ini playbook.yml

safe-apply:
	ansible-playbook -i hosts.ini playbook.yml --vault-password-file  .vault_pass.txt

deploy:
	ansible-playbook -i hosts.ini playbook.yml --tags="deploy"

safe-deploy:
	ansible-playbook -i hosts.ini playbook.yml --tags="deploy" --vault-password-file  .vault_pass.txt

update-config-force:
	ansible-playbook -i hosts.ini playbook.yml --tags="env-file" -e "force=true"

safe-update-config-force:
	ansible-playbook deploy.yml --tags="env-file" -e "force=true" --vault-password-file  .vault_pass.txt


.PHONY: help encrypt-vars decrypt-vars apply safe-apply show-secrets