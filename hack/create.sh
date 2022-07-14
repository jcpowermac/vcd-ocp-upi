#!/bin/bash


#wget -O yq https://github.com/mikefarah/yq/releases/download/v4.25.3/yq_linux_amd64
#chmod +x yq

rm -Rf auth tls terraform.* install-config.yaml metadata.json .openshift_install* *.ign bootstrap.iso

cp install-config{-backup-dev,}.yaml

export OPENSHIFT_INSTALL_RELEASE_IMAGE_OVERRIDE="registry.ci.openshift.org/ocp/release:4.11"

../openshift-install create ignition-configs

RHCOS_ISO_URL=$(../openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.metal.formats.iso.disk.location')
RHCOS_OVA_URL=$(../openshift-install coreos print-stream-json | jq -r '.architectures.x86_64.artifacts.vmware.formats.ova.disk.location')

wget -O rhcos.iso ${RHCOS_ISO_URL}
wget -O rhcos.ova ${RHCOS_OVA_URL}


# TODO: replace this with some sort of injection...
# since there are versions in the ovf.

# replace coreos.ovf with modified
tar --delete -vf rhcos.ova coreos.ovf
tar -vuf rhcos.ova coreos.ovf



podman run --security-opt label=disable --pull=always --rm -v .:/data -w /data quay.io/coreos/coreos-installer:release iso ignition embed -i /data/bootstrap.ign /data/rhcos.iso -o /data/bootstrap.iso

