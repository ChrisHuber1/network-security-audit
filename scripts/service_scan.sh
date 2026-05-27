#!/bin/bash
# Service Enumeration Scanner
# Wraps nmap for consistent scanning across an audit

set -euo pipefail

TARGET="${1:?Usage: $0 <target_ip_or_range> [output_dir]}"
OUTPUT_DIR="${2:-./evidence}"

mkdir -p "$OUTPUT_DIR"
TIMESTAMP=$(date -u +%Y%m%d_%H%M%S)

echo "=== Service Scan: $TARGET ==="
echo "Date: $(date -u +%Y-%m-%dT%H:%M:%SZ)"
echo "Output: $OUTPUT_DIR"
echo ""

# Phase 1: Quick discovery scan
echo "[1/3] Host discovery..."
nmap -sn "$TARGET" -oN "$OUTPUT_DIR/discovery_${TIMESTAMP}.txt"

# Phase 2: Full TCP port scan with version detection
echo "[2/3] Full TCP scan with version detection..."
nmap -sS -sV -p- --open -T4 "$TARGET" -oN "$OUTPUT_DIR/tcp_full_${TIMESTAMP}.txt" -oX "$OUTPUT_DIR/tcp_full_${TIMESTAMP}.xml"

# Phase 3: Top UDP ports
echo "[3/3] UDP top 100 ports..."
nmap -sU --top-ports 100 -T4 "$TARGET" -oN "$OUTPUT_DIR/udp_top100_${TIMESTAMP}.txt"

echo ""
echo "=== Scan Complete ==="
echo "Evidence files:"
ls -la "$OUTPUT_DIR"/*_${TIMESTAMP}*
