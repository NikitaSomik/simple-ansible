import os
import jinja2
import yaml

# Load the template file
template_loader = jinja2.FileSystemLoader(searchpath="./")
template_env = jinja2.Environment(loader=template_loader)
template_file = "hosts.ini.j2"
template = template_env.get_template(template_file)

# Load variables from environment or hardcode them here
# env_variables = {
#     "server_ip": os.getenv("SERVER_IP", "your_default_ip"),
#     "ansible_user": os.getenv("ANSIBLE_USER", "ubuntu"),
#     "ansible_ssh_private_key_file": os.getenv("ANSIBLE_SSH_PRIVATE_KEY_FILE", "~/.ssh/id_rsa"),
# }

# Load variables from group_vars/secrets.yml
with open("group_vars/secrets.yml", "r") as stream:
    try:
        yaml_variables = yaml.safe_load(stream)
    except yaml.YAMLError as exc:
        print(exc)
        yaml_variables = {}

# Combine environment variables with YAML variables, giving precedence to environment variables
variables = {**yaml_variables, 
            #  **env_variables
             }

# Render the template with variables
output_text = template.render(variables)

# Write the output to hosts.ini
with open("hosts.ini", "w") as output_file:
    output_file.write(output_text)
