#!/bin/bash
# Test script to verify disk-backed TMPDIR works inside the ANTs container
# Adjust USER and image path as needed before running on compute node.

HOST_TMP=/tscc/lustre/ddn/scratch/sehatton/temp
mkdir -p "$HOST_TMP"
chmod 700 "$HOST_TMP"

IMAGE_PATH=containers/.datalad/environments/ants-nidm-bidsapp-0-1-0/image

# Check that singularity is available
if ! command -v singularity >/dev/null 2>&1; then
  cat <<'MSG'
Error: 'singularity' command not found in PATH.
Run this script on a compute node with Singularity available, e.g.:
  source ~/.bashrc
  module load singularitypro/3.11
Then re-run this script in a bash session (not PowerShell).
MSG
  exit 1
fi

# Quick write test inside the container (200 MB)
echo "Running write test inside container (200 MB) to $HOST_TMP"
singularity exec -B "$HOST_TMP":"$HOST_TMP" "$IMAGE_PATH" \
  bash -c 'export TMPDIR="/tscc/lustre/ddn/scratch/sehatton/temp"; dd if=/dev/zero of="$TMPDIR/testfile" bs=1M count=200 && echo wrote OK || echo write FAILED; ls -l "$TMPDIR/testfile"'

# Verify container can list atlas files
echo "Checking atlas files under /opt/data inside container"
singularity exec "$IMAGE_PATH" ls -l /opt/data/OASIS-TRT-20_brains || true
