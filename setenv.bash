#!/bin/bash
#Author : Luigi Molinaro - luigi.molinaro@ibm.com

#colors :)
BLU='\033[0;34m'
RED='\033[0;31m'  # Corrected the escape sequence
NC='\033[0m'

CONFIG_FILE="./config.yaml"  # YAML Configuration File

logo_ibm() {
    echo -e ${BLU}
    echo -e "  ___ ____  __  __ "
    echo -e " |_ _| __ )|  \/  |"
    echo -e "  | ||  _ \| |\/| |"
    echo -e "  | || |_) | |  | |"
    echo -e " |___|____/|_|  |_|"
    echo -e "       Cloud Pak Deployer Helper"
    echo -e ${NC}
}

# Function to prompt the user for input and save variables in YAML
save_config() {
    read -p "Enter the Entitlement Key: " ENTITLEMENT_KEY
    read -p "Enter the path for the status directory: (ex: /opt/IBM/project/cpd-status" STATUS_DIR_PATH
    read -p "Enter the path for the config directory: (ex: /opt/IBM/project/cpd-config" CONFIG_DIR_PATH
    read -p "Enter the OC login: " OC_LOGIN

    # Save the variables in the YAML configuration file
    cat > $CONFIG_FILE <<EOL
entitlement_key: "$ENTITLEMENT_KEY"
status_dir_path: "$STATUS_DIR_PATH"
config_dir_path: "$CONFIG_DIR_PATH"
oc_login: "$OC_LOGIN"
EOL
    echo "Configuration saved in $CONFIG_FILE"
}

# Function to load variables from the YAML file without using yq
load_config() {
    if [ -f "$CONFIG_FILE" ]; then
        ENTITLEMENT_KEY=$(grep 'entitlement_key' $CONFIG_FILE | cut -d '"' -f2)
        STATUS_DIR_PATH=$(grep 'status_dir_path' $CONFIG_FILE | cut -d '"' -f2)
        CONFIG_DIR_PATH=$(grep 'config_dir_path' $CONFIG_FILE | cut -d '"' -f2)
        OC_LOGIN=$(grep 'oc_login' $CONFIG_FILE | cut -d '"' -f2)

        export STATUS_DIR="$STATUS_DIR_PATH"
        export CONFIG_DIR="$CONFIG_DIR_PATH"
        export CP_ENTITLEMENT_KEY="$ENTITLEMENT_KEY"
        export CPD_OC_LOGIN="$OC_LOGIN"

        echo "Configuration loaded from $CONFIG_FILE"
    else
        echo -e "${RED}The configuration file does not exist.${NC}"
        exit 1
    fi
}

# Function to modify a specific variable in the YAML file without using yq
modify_config() {
    local choice
    load_config  # First, load the existing variables

    while true; do
        echo -e "${BLU}Which variable would you like to modify?${NC}"
        echo "1) Entitlement Key"
        echo "2) Status directory"
        echo "3) Config directory"
        echo "4) OC Login"
        echo "5) Exit"
        read -p "Select the option (1-5): " choice

        case $choice in
            1) read -p "Enter the new Entitlement Key: " ENTITLEMENT_KEY
               sed -i "s|^entitlement_key:.*|entitlement_key: \"$ENTITLEMENT_KEY\"|" $CONFIG_FILE ;;
            2) read -p "Enter the new path for the status directory: " STATUS_DIR_PATH
               sed -i "s|^status_dir_path:.*|status_dir_path: \"$STATUS_DIR_PATH\"|" $CONFIG_FILE ;;
            3) read -p "Enter the new path for the config directory: " CONFIG_DIR_PATH
               sed -i "s|^config_dir_path:.*|config_dir_path: \"$CONFIG_DIR_PATH\"|" $CONFIG_FILE ;;
            4) read -p "Enter the new OC login: " OC_LOGIN
               sed -i "s|^oc_login:.*|oc_login: \"$OC_LOGIN\"|" $CONFIG_FILE ;;
            5) echo "Exiting modification."; break ;;
            *) echo -e "${RED}Invalid option, please select a number between 1 and 5.${NC}" ;;
        esac

        echo -e "${BLU}Would you like to modify another variable? (y/n)${NC}"
        read -p "Answer: " modify_more
        if [[ "$modify_more" != "y" && "$modify_more" != "Y" ]]; then
            break
        fi
    done

    echo "Configuration updated in $CONFIG_FILE"
}

# Main function
main() {
    logo_ibm

    if [ -f "$CONFIG_FILE" ]; then
        echo -e "${BLU}The configuration file exists.${NC}"
        echo -e "${BLU}Do you want to modify the existing configuration? (y/n)${NC}"
        read -p "Answer: " answer

        if [[ "$answer" == "y" || "$answer" == "Y" ]]; then
            modify_config
        else
            load_config
        fi
    else
        echo -e "${RED}The configuration file does not exist. Let's create one...${NC}"
        save_config
    fi

    CLUSTER_ID="$(oc get clusterversion -o jsonpath='{.items[].spec.clusterID}{"\n"}')"
    echo "Variables set:"
    echo -e "--------------"
    echo -e "${RED}STATUS DIR : ${NC} $STATUS_DIR_PATH"
    echo -e "${RED}CONFIG DIR : ${NC} $CONFIG_DIR_PATH"
    echo -e "${RED}ENTITLEMENT KEY : ${NC} $CP_ENTITLEMENT_KEY"
    echo -e "${RED}CLUSTER ID : (env id) ${NC} $CLUSTER_ID"
    echo -e "${RED}VERSION OF OC :\n${NC} $(oc version)"
}

# Run the main function
main
