#!/usr/bin/env bash
# Linux administration tasks for company-devops-platform
# Run as a user with sudo privileges (WSL Ubuntu).
# Usage: sudo bash scripts/01_linux_admin.sh
set -euo pipefail

PROJECT_DIR="${PROJECT_DIR:-$(pwd)}"
LOG="${PROJECT_DIR}/reports/linux-admin.log"
mkdir -p "$(dirname "$LOG")"
exec > >(tee -a "$LOG") 2>&1

echo "===== Linux Admin Bootstrap @ $(date -u) ====="
echo "Project dir: $PROJECT_DIR"

# 1-2. Project structure (idempotent — already created by repo)
mkdir -p "$PROJECT_DIR"/{configs,deployments,policies,reports}

# 4. Create groups FIRST (so we can assign as primary group when creating users)
for g in developers operations; do
  getent group "$g" >/dev/null 2>&1 || sudo groupadd "$g"
  echo "group ok: $g"
done

# 3. Create users (using -N to skip per-user group; -g sets primary group)
declare -A PRIMARY=( [developer]=developers [tester]=developers [devopsadmin]=operations )
for u in developer tester devopsadmin; do
  if id -u "$u" >/dev/null 2>&1; then
    sudo usermod -g "${PRIMARY[$u]}" "$u" || true
  else
    sudo useradd -m -s /bin/bash -N -g "${PRIMARY[$u]}" "$u"
  fi
  echo "user ok: $u (primary=${PRIMARY[$u]})"
done

# 5. Group membership
sudo usermod -aG developers developer
sudo usermod -aG developers tester
sudo usermod -aG operations devopsadmin

# 6. Permissions
sudo chgrp -R developers "$PROJECT_DIR/configs" "$PROJECT_DIR/deployments"
sudo chmod -R 770 "$PROJECT_DIR/configs" "$PROJECT_DIR/deployments"
sudo chown -R devopsadmin:operations "$PROJECT_DIR/policies" "$PROJECT_DIR/reports"
sudo chmod -R 750 "$PROJECT_DIR/policies" "$PROJECT_DIR/reports"

# Grant devopsadmin sudo (full admin)
if ! sudo grep -q "^devopsadmin " /etc/sudoers.d/devopsadmin 2>/dev/null; then
  echo "devopsadmin ALL=(ALL) NOPASSWD:ALL" | sudo tee /etc/sudoers.d/devopsadmin >/dev/null
  sudo chmod 440 /etc/sudoers.d/devopsadmin
fi

# 7. Configuration files (created in repo; verify)
for f in deployment.yaml pipeline.yaml security.conf; do
  test -f "$PROJECT_DIR/configs/$f" && echo "config ok: $f"
done

# 8-9. Backup with timestamp rename
TS="$(date +%Y%m%d-%H%M%S)"
BACKUP_DIR="$PROJECT_DIR/backup-configs"
mkdir -p "$BACKUP_DIR"
for f in "$PROJECT_DIR"/configs/*; do
  base="$(basename "$f")"
  cp "$f" "$BACKUP_DIR/${base%.*}.${TS}.${base##*.}"
done
echo "Backups written to $BACKUP_DIR:"
ls -l "$BACKUP_DIR"

# 10. Project tree
echo "----- Project structure -----"
if command -v tree >/dev/null; then
  tree -L 3 "$PROJECT_DIR"
else
  find "$PROJECT_DIR" -maxdepth 3 -not -path '*/\.git*' | sort
fi

# 11. Background process + terminate
echo "----- Background process demo -----"
sleep 120 &
BG_PID=$!
echo "Started background sleep PID=$BG_PID"
ps -f -p $BG_PID || true
kill "$BG_PID"
sleep 1
echo "Killed PID=$BG_PID; status:"
ps -p "$BG_PID" || echo "Process $BG_PID is gone (as expected)."

# 12. Process tree (parent-child)
echo "----- Process parent/child relationships -----"
ps -ef --forest | head -30

# 13. Compressed archive of project
ARCHIVE="$PROJECT_DIR/../company-devops-platform-${TS}.tar.gz"
tar --exclude='.git' --exclude='backup-configs' \
    -czf "$ARCHIVE" -C "$(dirname "$PROJECT_DIR")" "$(basename "$PROJECT_DIR")"
echo "Archive created: $ARCHIVE ($(du -h "$ARCHIVE" | cut -f1))"

echo "===== DONE ====="
