# Cloud Pak Deployer Helper

This is a simple bash script designed to help automate the setup and configuration of IBM Cloud Pak environments. The script helps users configure key environment variables, manage them in a YAML configuration file, and perform modifications as needed. It also provides information about the OpenShift cluster and Cloud Pak environment setup.

## Features

- **Interactive Configuration**: The script prompts the user for environment variables like the Entitlement Key, directory paths, and OC login credentials.
- **YAML Configuration File**: Saves and loads configurations from a YAML file.
- **Modify Configuration**: Allows users to modify specific configuration variables.
- **Cluster Information**: Automatically retrieves and displays cluster-related information, such as the OpenShift cluster ID and version.
- **Color-coded prompts** for better readability.

## Prerequisites

- OpenShift CLI (`oc`) must be installed and configured on your system.
- Ensure that you have admin access to the OpenShift cluster.
- The script requires bash shell.

## Directory Structure

It is recommended to adopt the following directory structure for easier maintenance:

```
.
├── cpd-config/
│   └── ...           # Configuration files
├── cpd-status/
│   └── ...           # Directory for status-related information
└── setenv.bash       # Script for setting environment variables
```

This structure allows for better organization and simplifies tasks such as adding cartridges or performing upgrades.

## Usage

1. **Clone the Repository:**

    ```bash
    git clone https://github.com/<your-github-username>/cloud-pak-deployer-helper.git
    cd cloud-pak-deployer-helper
    ```

2. **Run the Script:**

    Make the script executable:

    ```bash
    chmod +x setenv.bash
    ```

    Execute the script:

    ```bash
    ./setenv.bash
    ```

3. **First-time Setup:**

    - If the configuration file (`config.yaml`) does not exist, the script will prompt you to enter key variables such as:
      - Entitlement Key
      - Status Directory Path
      - Config Directory Path
      - OC Login

    - The configuration is saved in a YAML file called `config.yaml`.

4. **Modify Configuration:**

    - If `config.yaml` exists, the script will ask if you'd like to modify the configuration.
    - You can select specific variables to modify (e.g., Entitlement Key, Status Directory, etc.).

5. **Display Cluster Information:**

    - After loading or modifying the configuration, the script will fetch and display:
      - Cluster ID
      - OpenShift version
      - Status and Config directory paths

## Configuration

The configuration is saved in `config.yaml`, which contains the following variables:

```yaml
entitlement_key: "<your-entitlement-key>"
status_dir_path: "<path-to-status-directory>"
config_dir_path: "<path-to-config-directory>"
oc_login: "<oc-login>"
```

You can modify these values by running the script and selecting the **Modify Configuration** option.

## Example Output

```bash
  ___ ____  __  __ 
 |_ _| __ )|  \/  |
  | ||  _ \| |\/| |
  | || |_) | |  | |
 |___|____/|_|  |_|

       Cloud Pak Deployer Helper

The configuration file exists.
Do you want to modify the existing configuration? (y/n) y
Which variable would you like to modify?
1) Entitlement Key
2) Status directory
3) Config directory
4) OC Login
5) Exit
Select the option (1-5): 1
Enter the new Entitlement Key: <new-entitlement-key>
Would you like to modify another variable? (y/n) n
Configuration updated in config.yaml

Variables set:
--------------
STATUS DIR : /root/IBM/cpd-status
CONFIG DIR : /root/IBM/cpd-config
ENTITLEMENT KEY : <new-entitlement-key>
CLUSTER ID : <your-cluster-id>
VERSION OF OC :
Client Version: 4.7.0-202103101024.p0
```

## Contributing

If you'd like to contribute to this project, feel free to fork the repository, make your changes, and submit a pull request.
