# Blog Tagging Strategy

**Updated:** 2026-01-10

## Why I'm doing this

My blog's pivoting from pure technical content toward IT leadership and business owner audience (while keeping the technical stuff). Need a consistent tagging strategy that:
- Helps business owners find strategic content
- Doesn't break SEO for technical posts
- Actually makes sense when I'm writing new posts

Based on [this article](https://delante.co/categories-and-tags-on-the-blog/) about avoiding keyword cannibalisation and keeping things organised.

---

## My 6 Categories

Think of these like a table of contents. Stick to 1 category per post (2 max if really needed).

### Strategy & Leadership
For my vCISO/vCTO content. IT governance, risk management, leadership topics.
- **Who I'm writing for:** Business owners, IT leaders, C-suite, MSP principals
- **Examples:** The cybersecurity leadership post, incident management frameworks
- **SEO angle:** IT leadership, cyber risk management, business continuity

### Security & Compliance
Cybersecurity strategy, vulnerability management, compliance, access control.
- **Who I'm writing for:** IT leaders, security professionals, compliance officers
- **Examples:** CVE response posts, authentication deep-dives, security automation
- **SEO angle:** Cybersecurity for SMBs, compliance automation, security governance

### Infrastructure & Architecture
System design, infrastructure planning, architecture decisions.
- **Who I'm writing for:** IT managers, system architects, infrastructure engineers
- **Examples:** Docker networking, Proxmox setups, cloud-init templates
- **SEO angle:** Infrastructure design, virtualization, system architecture

### Automation & Efficiency
PowerShell scripts, process improvement, workflow optimization.
- **Who I'm writing for:** IT practitioners, sysadmins, DevOps folks
- **Examples:** PowerShell automation, permission management scripts
- **SEO angle:** IT automation, PowerShell scripting, operational efficiency

### Operations & Troubleshooting
Problem-solving, incident response, how-to-fix-this-thing.
- **Who I'm writing for:** IT practitioners, support teams, MSPs
- **Examples:** Veeam errors, QNAP issues, O365 proxy conflicts
- **SEO angle:** IT troubleshooting, problem resolution, technical support

### Resources & Guides
Tool recommendations, reference materials, curated lists.
- **Who I'm writing for:** Everyone
- **Examples:** Tool lists, software recommendations, setup guides
- **SEO angle:** IT tools, resource guides, technology recommendations

---

## My Tag Vocabulary (47 tags)

Use 4-6 tags per post. More than that is just noise.

### Technology Tags (22)

**Microsoft Stuff:**
- PowerShell
- Microsoft 365
- Exchange Online
- Entra ID (not "Azure AD" anymore)
- Windows Server
- Windows OS
- SharePoint
- OneDrive

**Infrastructure:**
- Docker
- Proxmox
- Linux
- Debian Linux
- Virtualization
- Hyper-V
- Cloud-Init
- Networking

**Tools:**
- Git
- Hugo
- QNAP
- Veeam
- 3CX
- K-9 Mail

### Strategic Tags (12)

These support the pivot to leadership content:
- Risk Management
- IT Governance
- Business Continuity
- Incident Response
- Process Improvement
- Team Management
- Disaster Recovery
- Compliance
- Migration
- Scalability
- Cost Optimization
- Professional Services

### Technical Domain Tags (7)

- Security
- Access Control
- Backup & Recovery
- Storage
- Performance
- Efficiency
- Productivity

### Content Type Tags (6)

Always use one of these:
- How-To (step-by-step instructions)
- Tutorial (comprehensive guides)
- Deep-Dive (in-depth analysis)
- Opinion (thought leadership pieces)
- Quick-Fix (brief troubleshooting)
- Reference Guide (cheat sheets, documentation)

---

## How I Tag Posts

For each post, pick tags from different layers:

1. **Tech tags (1-2):** What specific platforms/tools?
2. **Strategic OR Domain tags (1-2):** What's the topic area?
3. **Content type (1):** How-To, Tutorial, Opinion, etc.
4. **Extra context (0-2):** Anything else relevant

**Example - M365 automation post:**
```yaml
tags:
  - PowerShell          # Technology
  - Microsoft 365       # Technology
  - Process Improvement # Strategic
  - How-To             # Content type
```

---

## Naming Rules

Don't want inconsistency breaking things.

**Product/Technology:** Use official capitalization
- ✅ PowerShell (not powershell)
- ✅ Entra ID (not Azure AD)
- ✅ Microsoft 365 (not M365 or Office 365)

**Concepts:** Title Case
- ✅ Risk Management (not risk management)
- ✅ Business Continuity (not Business continuity)

**Multi-word:** Spaces, not hyphens (except where it's the official name like Cloud-Init)
- ✅ Windows Server (not Windows-Server)

**YAML Format:**
```yaml
categories:
  - Category Name

tags:
  - Tag One
  - Tag Two
```

No inline arrays like `tags: [one, two]` - keep it consistent.

---

## SEO Notes to Self

**Don't duplicate category and tag terms** - causes keyword cannibalization.

❌ Bad:
```yaml
categories:
  - Security & Compliance
tags:
  - Security
  - Compliance
```

✅ Good:
```yaml
categories:
  - Security & Compliance
tags:
  - Access Control
  - PowerShell
  - How-To
```

**Tag archive pages need:**
- Unique meta description (70-160 chars)
- H1 heading
- Intro paragraph (100-200 words)
- Post excerpts (not full content)

Example structure for PowerShell tag page:
```
# PowerShell Automation & Scripting

Meta: "PowerShell guides for IT automation. Learn scripting techniques, best practices, and practical solutions for Windows administration."

PowerShell is a powerful scripting language and automation framework for Windows administration. These articles provide practical PowerShell solutions ranging from quick one-liners to complex automation scripts for Microsoft 365, Active Directory, and infrastructure management.
```

---

## Content Planning

### 2026 Target Mix

Supporting the strategic pivot:
- **Strategy & Leadership:** 40% (monthly thought leadership)
- **Security & Compliance:** 25% (bi-weekly security content)
- **Automation & Efficiency:** 20% (keep technical audience engaged)
- **Infrastructure & Architecture:** 10% (deep technical)
- **Operations & Troubleshooting:** 5% (as-needed)

### Monthly Template

- Week 1: Strategic/Leadership piece
- Week 2: Security topic
- Week 3: Technical how-to or automation
- Week 4: Case study or deep-dive

---

## Maintenance

**Quarterly:** Check tag usage stats
- Remove/merge underused tags
- Split overused tags if needed
- Check consistency

**Annually:** Full vocabulary review
- Add tags for new topics
- Deprecate obsolete tags
- Update this doc

**Before adding new tags, ask:**
1. Is this already covered?
2. Will I use this on 3+ posts?
3. Does it fit the structure (tech/strategic/domain/content)?
4. Is naming consistent?

**When deprecating/renaming:**
1. Update this doc
2. Update all affected posts
3. Set up 301 redirects
4. Monitor search console for 404s

---

## Examples from My Posts

### Strategic Content

"Cybersecurity Isn't an IT Problem. It's a Leadership Failure"

```yaml
categories:
  - Strategy & Leadership

tags:
  - Risk Management
  - IT Governance
  - Business Continuity
  - Opinion
  - Professional Services
  - Team Management
```

Why this works: Single category, mix of strategic tags, content type clear, 6 tags (sweet spot).

### Technical How-To

"Create Dynamic User Pilot Groups in Microsoft Entra"

```yaml
categories:
  - Infrastructure & Architecture

tags:
  - Entra ID
  - Microsoft 365
  - Process Improvement
  - Efficiency
  - How-To
  - Scalability
```

Why: Appropriate category, primary/secondary tech tags, shows strategic benefit, content type identified.

### Troubleshooting

"How to Fix QNAP NAS Web GUI Timeout Issues"

```yaml
categories:
  - Operations & Troubleshooting

tags:
  - QNAP
  - Storage
  - Networking
  - Linux
  - How-To
```

Why: Clear troubleshooting category, specific product, relevant domains, 5 tags.

---

## Common Mistakes (Don't Do These)

### ❌ Too Many Tags (11+ tags)

Dilutes everything, creates duplicates, adds no value.

### ❌ Too Few Tags (1-2 tags)

Limits discoverability, no context about content type or domain.

### ❌ Inconsistent Naming

powershell, Microsoft-365, risk management, Azure AD → All wrong. Follow the conventions above.

### ❌ Category/Tag Overlap

Category "Security & Compliance" + Tags "Security" and "Compliance" = keyword cannibalization.

Instead: Category "Security & Compliance" + Tags like "Access Control", "PowerShell", "How-To"

---

## Quick Checklist Before Publishing

- [ ] 1 category (2 max)
- [ ] 4-6 tags
- [ ] Tags from this vocabulary list
- [ ] Naming conventions followed
- [ ] No category/tag duplication
- [ ] At least one content type tag
- [ ] At least one tech OR strategic tag
- [ ] YAML formatted consistently
- [ ] Exact capitalization from vocab

---
