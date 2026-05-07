#!/bin/bash
# Test script to verify disk-backed TMPDIR works inside the ANTs container
# Adjust USER and image path as needed before running on compute node.

HOST_TMP=/tscc/lustre/ddn/scratch/sehatton/temp
mkdir -p "$HOST_TMP"
chmod 700 "$HOST_TMP"

IMAGE_PATH=containers/.datalad/environments/ants-nidm-bidsapp-0-1-0/image

# Quick write test inside the container (200 MB)
singularity exec -B "$HOST_TMP":"$HOST_TMP" "$IMAGE_PATH" \
  bash -c 'export TMPDIR="/tscc/lustre/ddn/scratch/sehatton/temp"; dd if=/dev/zero of="$TMPDIR/testfile" bs=1M count=200 && echo wrote OK || echo write FAILED; ls -l "$TMPDIR/testfile"'

# Verify container can list atlas files
singularity exec "$IMAGE_PATH" ls -l /opt/data/OASIS-TRT-20_brains || true
