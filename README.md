# PropaneCloud
The terraform/docker wombo combo to stand up the Propane KoTH challenge environment and scoreboard in AWS


## Usage

IMPORTANT: CONFIGURE YOUR SSH KEY AND REPLACE IT IN EACH `.tf` file where applicable

### Propane Setup:
1. `cd PropaneLab/propane`
2. `terraform apply`

### Vuln Lab Setup:
1. `cd PropaneLab/vuln`
2. `terraform apply`

Once your vuln lab is up, copy the IP/Hostname list, remove the quotes, and add it to the propane config.

On the propane host find the `tmp` folder in the home directory and paste your new `propane_config.ini` in there