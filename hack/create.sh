#!/bin/bash

rm -Rf auth tls terraform.* install-config.yaml metadata.json .openshift_install* *.ign

cp install-config{-backup-dev,}.yaml

export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE="registry.ci.openshift.org/ocp/release:4.11"

../openshift-install create ignition-configs

RHCOS_ISO_URL=$(../openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.metal.formats.iso.disk.location')
RHCOS_OVA_URL=$(../openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.vmware.formats.ova.disk.location')

wget -O rhcos.iso ${RHCOS_ISO_URL}
wget -O rhcos.ova ${RHCOS_OVA_URL}

podman run --security-opt label=disable --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release iso ignition embed -i /data/bootstrap.ign /data/rhcos.iso -o /data/bootstrap.iso
