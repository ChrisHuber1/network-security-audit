# Network Security Audit

A complete security audit of a multi-host network environment ;  the same methodology I'd use for a client engagement, applied to my own infrastructure.

I ran this audit because I realized I was building security tools on top of infrastructure I hadn't actually validated. The audit covered host discovery, service enumeration, vulnerability scanning, SSH configuration review, firewall rule analysis, and segmentation testing. Every finding was documented with evidence, risk rating, and remediation steps.

## Methodology

1. **Scope definition** ;  identified all hosts, IP ranges, and network segments
2. **Host discovery** ;  nmap sweeps across all subnets to find active hosts and unexpected services
3. **Service enumeration** ;  detailed port scans with version detection on every discovered host
4. **Vulnerability assessment** ;  cross-referenced running services and kernel versions against known CVEs
5. **SSH hardening review** ;  audited sshd_config on every host against CIS benchmarks
6. **Firewall analysis** ;  reviewed OPNsense rules for overly permissive access, missing deny rules, and segmentation gaps
7. **Segmentation testing** ;  verified that network segments couldn't reach each other except through intended paths
8. **Evidence collection** ;  17 evidence files with raw scan output, screenshots, and configuration snapshots

## Deliverables

| Document | What It Contains |
|---|---|
| Findings report | Every finding with severity, evidence, affected hosts, and remediation |
| Posture summary | Executive-level overview of security posture with risk scores |
| Handoff document | Prioritized remediation plan feeding directly into firewall hardening project |

## What I Found

I'm not publishing specific vulnerabilities from a live environment, but the categories of findings included:

- Services listening on interfaces they shouldn't be
- SSH configurations that didn't meet CIS baseline (password auth enabled, weak key exchange algorithms)
- Firewall rules that were too broad ;  allowing entire subnets instead of specific host-to-host paths
- Network segments that could reach each other when they shouldn't
- Default credentials on infrastructure management interfaces
- Missing host-based firewalls on several Linux hosts

The findings fed directly into the [OPNsense Lockdown](https://github.com/ChrisHuber1/opnsense-lockdown) project, where each finding became a hardening rule.

## Decisions and Tradeoffs

**Full audit before building security tools:** I could have started building detection and monitoring first. But detecting attacks on misconfigured infrastructure is putting the cart before the horse. The audit established a known-good baseline, and the hardening project closed the gaps.

**OPNsense API automation over manual rule changes:** The firewall changes from this audit affected dozens of rules across multiple interfaces. Scripting them through the OPNsense API meant I could version-control the rules, roll back if something broke, and reproduce the configuration on a fresh firewall.

**CIS benchmarks as the standard:** I needed an objective baseline, not "what seems right." CIS provides that for SSH, Linux hosts, and firewall configs. Where CIS was too strict for a home lab (like requiring FIPS mode), I documented the deviation and the reason.

## Tools Used

- nmap (host discovery, service enumeration, version detection)
- Wazuh (vulnerability detection, SCA checks)
- OPNsense API (firewall rule export and analysis)
- SSH (manual configuration review)
- Custom Python scripts (evidence collection, report generation)

## Lessons Learned

- The hosts I was most confident about had the most findings. Confidence without verification is just optimism.
- Network segmentation is only as good as your firewall rules. Having VLANs means nothing if the firewall allows inter-VLAN traffic by default.
- Document everything as you go. Retroactive evidence collection is tedious and you'll miss things.
