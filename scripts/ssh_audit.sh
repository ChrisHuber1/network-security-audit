#!/bin/bash
# SSH Configuration Auditor
# Checks sshd_config against CIS benchmarks on a remote host

set -euo pipefail

HOST="${1:?Usage: $0 <host> [ssh_user]}"
USER="${2:-root}"
SSH_OPTS="-o ConnectTimeout=5 -o StrictHostKeyChecking=accept-new"

echo "=== SSH Configuration Audit: $HOST ==="
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo ""

SSHD_CONFIG=$(ssh $SSH_OPTS "$USER@$HOST" "cat /etc/ssh/sshd_config 2>/dev/null" || echo "FAILED TO READ")

if [ "$SSHD_CONFIG" = "FAILED TO READ" ]; then
    echo "ERROR: Could not read sshd_config on $HOST"
    exit 1
fi

check_setting() {
    local setting="$1"
    local expected="$2"
    local label="$3"
    local actual=$(echo "$SSHD_CONFIG" | grep -i "^${setting}" | awk '{print $2}' | head -1)
    
    if [ -z "$actual" ]; then
        echo "[WARN] $label: not explicitly set (using default)"
    elif [ "$actual" = "$expected" ]; then
        echo "[PASS] $label: $actual"
    else
        echo "[FAIL] $label: $actual (expected: $expected)"
    fi
}

echo "--- CIS Benchmark Checks ---"
check_setting "PermitRootLogin" "no" "Root login"
check_setting "PasswordAuthentication" "no" "Password auth"
check_setting "PermitEmptyPasswords" "no" "Empty passwords"
check_setting "X11Forwarding" "no" "X11 forwarding"
check_setting "MaxAuthTries" "4" "Max auth tries"
check_setting "Protocol" "2" "SSH protocol"
check_setting "IgnoreRhosts" "yes" "Ignore rhosts"
check_setting "HostbasedAuthentication" "no" "Hostbased auth"
check_setting "LoginGraceTime" "60" "Login grace time"
check_setting "ClientAliveInterval" "300" "Client alive interval"
check_setting "ClientAliveCountMax" "3" "Client alive count max"
check_setting "GSSAPIAuthentication" "no" "GSSAPI auth"

echo ""
echo "--- Key Exchange Algorithms ---"
echo "$SSHD_CONFIG" | grep -i "^KexAlgorithms" || echo "[INFO] Using system defaults"

echo ""
echo "--- Authorized Keys ---"
ssh $SSH_OPTS "$USER@$HOST" "cat ~/.ssh/authorized_keys 2>/dev/null | wc -l" | xargs -I{} echo "Authorized keys for $USER: {} entries"

echo ""
echo "=== Audit Complete ==="
