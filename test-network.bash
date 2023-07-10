#!/bin/bash

GREEN='\033[0;32m'
RED='\033[0;31m'
BLUE='\033[1;34m'
NC='\033[0m'

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
  if curl --head --fail "$domain" > /dev/null 2>&1; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
done
echo

# Test domains on OpenShift
echo -e "${BLUE}Testing domains on OpenShift:${NC}"
oc apply -f - <<EOF > /dev/null 2>&1
apiVersion: v1
kind: Pod
metadata:
  name: test-pod
spec:
  containers:
    - name: curl
      image: curlimages/curl
      command: ["sleep", "10"]
EOF

for domain in "${domains_oc[@]}"; do
  if oc exec -i test-pod -- curl --head --fail "$domain" > /dev/null 2>&1; then
    echo -e "[${GREEN}OK${NC}] $domain is accessible"
  else
    echo -e "[${RED}KO${NC}] $domain is not accessible"
  fi
done
echo

# Clean up test pod
oc delete pod test-pod > /dev/null 2>&1

