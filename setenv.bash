#!/bin/bash

BLU='\033[0;34m'
RED='\e[0;31m'
NC='\033[0m'

logo_ibm() {
echo -e ${BLU}
echo -e "  ___ ____  __  __ "
echo -e " |_ _| __ )|  \/  |"
echo -e "  | ||  _ \| |\/| |"
echo -e "  | || |_) | |  | |"
echo -e " |___|____/|_|  |_|"
echo -e ${NC}
}

#ELEMENTI DA MODIFIARE
###
ENTITLEMENT_KEY="INSERT ENT KEY"
STATUS_DIR_PATH="/root/IBM/cpd-status" #YOUR PATH    
CONFIG_DIR_PATH="/root/IBM/cpd-config" #YOUR PATH
OC_LOGIN=" INSERT OC LOGIN"
###

#https://ibm.github.io/cloud-pak-deployer/cpd-design/objects/objects/
export STATUS_DIR="$STATUS_DIR_PATH"
export CONFIG_DIR="$CONFIG_DIR_PATH"
export CP_ENTITLEMENT_KEY="$ENTITLEMENT_KEY"
export CPD_OC_LOGIN="$OC_LOGIN"
CLUSTER_ID="$(oc get clusterversion -o jsonpath='{.items[].spec.clusterID}{"\n"}')"

logo_ibm
echo "Variabili settate :"
echo -e "--------------"
echo -e "${RED}STATUS DIR : ${NC} $STATUS_DIR"
echo -e "${RED}CONFIG DIR : ${NC} $CONFIG_DIR"
echo -e "${RED}ENTITLEMENT KEY : ${NC} $CP_ENTITLEMENT_KEY"
echo -e "${RED}CLUSTER ID : (env id) ${NC} $CLUSTER_ID"
echo -e "${RED}VERSION OF OC :\n${NC} `oc version`"
