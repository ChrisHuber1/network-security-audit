# Network Security Audit Checklist

## Pre-Engagement
- [ ] Define scope (hosts, networks, exclusions)
- [ ] Get written authorization
- [ ] Document timeline and contacts
- [ ] Set up evidence collection directory

## Host Discovery
- [ ] Ping sweep all in-scope subnets
- [ ] ARP scan for local network hosts
- [ ] DNS enumeration for known domains
- [ ] Compare discovered hosts against asset inventory

## Service Enumeration
- [ ] Full TCP port scan (nmap -sS -p- -sV)
- [ ] UDP scan of common ports (nmap -sU --top-ports 100)
- [ ] Document all listening services with versions
- [ ] Flag unexpected services or ports

## Vulnerability Assessment
- [ ] Cross-reference services against CVE databases
- [ ] Check kernel versions against known vulnerabilities
- [ ] Run Wazuh SCA (Security Configuration Assessment) checks
- [ ] Validate findings against NVD (eliminate false positives)

## SSH Configuration
- [ ] Audit sshd_config against CIS benchmarks
- [ ] Check for password authentication (should be disabled)
- [ ] Verify key exchange algorithms
- [ ] Check for root login permissions
- [ ] Review authorized_keys files

## Firewall Review
- [ ] Export all firewall rules
- [ ] Identify overly permissive rules (any/any)
- [ ] Verify network segmentation
- [ ] Test cross-segment access (should be denied)
- [ ] Check for default-allow policies

## Post-Assessment
- [ ] Generate finding reports
- [ ] Create executive posture summary
- [ ] Prioritize remediation
- [ ] Create handoff document for remediation team
- [ ] Schedule follow-up assessment
