#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[1;34m'
NC='\033[0m'
port=443
pod_name=test-pod

domains_bastion=(
  "registry.access.redhat.com"
  "quay.io"
  "icr.io"
  "cdn.redhat.com"
  "cdn-ubi.redhat.com"
  "rpm.releases.hashicorp.com"
  "dl.fedoraproject.org"
  "mirrors.fedoraproject.org"
  "fedora.mirrorservice.org"
  "pypi.org"
  "galaxy.ansible.com"
)

domains_oc=(
  "github.com"
  "gcr.io"
  "quay.io"
  "objects.githubusercontent.com"
  "mirror.openshift.com"
  "ocsp.digicert.com"
  "subscription.rhsm.redhat.com"
)

# Test domains on Bastion Host
echo -e "${BLUE}Testing domains on Bastion Host:${NC}"
for domain in "${domains_bastion[@]}"; do
  if nc -z -v -w5 "$domain" $port > /dev/null 2>&1; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
done
echo

# Test domains on OpenShift
echo -e "${BLUE}Testing domains on OpenShift:${NC}"

# Create the test-pod
oc apply -f - <<EOF > /dev/null 2>&1
apiVersion: v1
kind: Pod
metadata:
  name: $pod_name
spec:
  containers:
    - name: nc
      image: alpine
      command: ["sleep", "100"]
EOF

# Wait for the test-pod to be ready
while true; do
  pod_status=$(oc get pod $pod_name -o jsonpath='{.status.phase}')
  if [[ "$pod_status" == "Running" ]]; then
    echo "The $pod_name is running and ready"
    break
  elif [[ "$pod_status" == "Pending" ]]; then
    echo "Waiting for the $pod_name to be ready..."
    sleep 5
  else
    echo "The test-pod failed to start or is in an error state, please check"
    exit 1
  fi
done

# Perform port check for each domain
for domain in "${domains_oc[@]}"; do
  if oc exec -i $pod_name -- nc -z -v -w5 "$domain" "$port" 2>&1 | grep -q "open"; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    oc exec -i $pod_name -- nc -z -v -w5 "$domain" "$port"
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
done

# Clean up test pod
oc delete pod $pod_name > /dev/null 2>&1

