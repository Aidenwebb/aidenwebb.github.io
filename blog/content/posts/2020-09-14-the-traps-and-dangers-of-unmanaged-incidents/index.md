---
title: Traps and Dangers of Unmanaged Incidents and How to Solve Them
author: Aiden Arnkels-Webb
#type: post
date: 2020-09-14T17:48:17+00:00
aliases:
  - /the-traps-and-dangers-of-unmanaged-incidents/
cover:
    image: "cover.jpg" # image path/url
    alt: "Picture of an ice cream fallen on the floor" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page  
neve_meta_enable_content_width:
  - off
tags: ["Explainers","Strategy","IT & Tech"]

---
# Introduction

ITIL defines an incident as &#8220;an unplanned interruption to or quality reduction of an IT service&#8221;.

  In order to minimise disruption caused by an incident and restore normal service as quickly as possible, it's vital to have an efficient incident management process. Unfortunately, this is something a lot of IT teams get wrong.

# Unmanaged Incidents

It's 1 PM and your team has just started receiving calls from one of your users that the network drives are down. No-one can access anything or save anything and the business cannot function. You don't know it yet but 4 separate people in your IT team are now trying everything they can to get the drives back up and running.

James is logging in to the file servers, he calls on previous experience and triggers a restart, hoping they'll pop back up and be OK. They take a while to shutdown.

Kirsty tries pinging the server and gets no response. She starts looking at the firewalls and finds a rule that looks a bit funny. She changes it, thinking that traffic can no longer reach the file servers. The server now responds to ping but after a minute it stops responding again. Unknown to her, this rule was used for testing an FTP server before that IP was assigned to a file server. The file server is now exposed to the internet.

Ryan jumps in remembering a switch in the users' office was displaying some errors when he checked it yesterday. He hops in and sees some dropped packets on one interface. He thinks it might be a broadcast storm and disables the interface. Unbeknownst to him, this interface handles VOIP traffic.

Sam also checks the file servers and sees them waiting to shut down, so Sam forces a power-off thinking that they've hung and now they won't boot at all.

It's been 5 minutes. You don't know it yet, but a firewall rule has changed, a switch port has been disabled, production servers have been rebooted, no-one has spoken to each other and now you're getting a call from the VP of Sales telling you that all the phone lines are down in his office and no-one can access the network. He's pissed and wants to know how on earth everything can collapse so quickly without warning.

After some time, you manage to unravel everything, undo the changes to the firewall, the switch and restore the servers from a backup, but it takes a long time and was complicated by the additional changes. After re-enabling the switch rule, you're not seeing any traffic flowing through the interface. You can't seem to get it to detect any traffic and decide to reboot it. It works and 3 hours later and the incident is resolved. You come to the conclusion that maybe the VOIP port might be being used for non-VOIP traffic but you're going to have to investigate that later. Right now you're being called into a meeting with the VP of Sales and the Managing Director to explain the situation. You're not really sure if the firewall, switch, or file servers being down was the actual cause, but you know that rebooting the switch was the last thing you did before it started working.

## What went wrong?

It's easy to see that everyone in the above scenario was doing their job and working towards a solution, but at the same time, within minutes additional breaking changes have been introduced to the system.

### Tunnel vision on a technical problem

It's not surprising that members of a technical IT team are keen to jump in and fix a technical problem, however, none took the time to gather information and acquire a broader picture of the error at hand.

### Poor communication

Because everyone was too busy rushing to resolve a technical problem, no-one took the time to communicate with each other about who was doing what. Customers did not know what to expect, the VP is angry, members of the team are blaming each other for shutting down the servers, enabling firewall rules and disabling switch ports.

### Breaking Changes

Each member of the team made changes to the system without consulting each other or following a Change Management Process. It may be there wasn't one in place. However, despite good intentions from each member, these breaking changes made a bad situation worse.

* An unclean shutdown of a production file server causing some system corruption requiring recovery
* A port was opened on the firewall exposing the file server to the internet which could have caused a security incident
* A switch port was disabled which blocked VOIP traffic in the office.

# What can we do better? - Manage the incident

It's 1 PM. James, Kirtsy, Ryan and Sam each finish a call with someone at the office, and each of their users are unable to access the network drives. James and Kirsty each think that this is big enough to report to you, and do so. You ask if anyone else has seen the issue and Ryan and Sam each flag to you that they have spoken to users with the same issue.

You get to work, each of your team members gives their ideas on where the problem might be. You ask each to investigate, test functionality and report back on what they find.

James logs in to the file servers, checks the services are running and the health of the shares. He tests the shares from another system in the data centre. All are fine, he reports. You ask him to test from multiple different offices to determine if there's a pattern.

Kirsty tries pinging the server and gets no response. She checks the firewall and finds a suspicious rule. She notes down the configuration and reports back to you. You note it down as a potential cause to investigate shortly.

Ryan checks the switch at the office and sees it dropping packets. He flags this to you and you note this as another potential cause.

Sam writes an email to send to the users at the office, including the VP of Sales, informing them that you know about and are working towards resolving their network drive issue.

Kirsty and you investigate the Firewall rule while Ryan investigates further on the switch. You decide the firewall rule is unlikely to be the cause, as it is disabled, and it's configured to allow FTP traffic, not SMB. You acknowledge that the firewall rule may need addressing separately and ask Kirsty to log a ticket for it.

Ryan reports he doesn't know why the switch is dropping packets, but the CPU is running at 100%.

James comes back to you and confirms that all other offices besides the one that reported the problem are able to connect to the network drives.

You ask Sam to contact users at the office to test their internet connectivity as well as VOIP quality. He comes back to you saying the internet is slow and the VOIP quality is poor.

After further investigating you discover the network switch is faulty. You reboot it and it comes back up. Phew! 30 minutes after the outage, the issue is resolved.

Sam contacts users to confirm that they are now able to access the network shares and you raise a business case for a replacement switch.

## What went right?

The managed situation was a far more efficient resolution that managed user expectations and resolved the incident cleanly without introducing further problems. What's more, you were able to test and verify components in isolation in order to narrow down on the root cause.

### Broad vision and teamwork

Because some members of the team recognised that the outage wasn't isolated to a single user, and let you know, you were able to take command and lead the team towards resolution. You were able to collectively take stock of what was working before jumping to conclusions.

### Good communication

Not only did your team communicate with you, but Sam took the role of keeping the users updated. As a result, the VP of Sales is informed and, while a little grumpy at some lost time, is pleased that the issue was resolved and you're able to prevent a recurrence. The users are happy because rather than constantly refreshing the network share to check if it's working yet, they were able to get on with other tasks or take a break safe in the knowledge that you'd let them know when the issue was resolved. The team are pleased with each other and feel they all made a meaningful contribution towards the resolution of the incident.

### No Breaking Changes

Because we all took account of what was working, what was broken, and where, we were able to isolate the incident to a single piece of infrastructure. We were also able to gather and preserve data that we can use as evidence for our business case to replace the switch. We have a good amount of information about where the problem did and not occur, and which components were faulty.

# In Summary

With a strong incident management strategy, we're able to reduce the mean time to resolution (MTTR) of incidents, as well as reduce the amount of stress both our users and IT team are subject to when things go wrong. Any company that values reliability and efficiency would benefit from planning their incident response strategy in advance.

**Prepare:** Build and document your incident management strategy and train staff in its implementation.

**Investigate:** Confirm functionality of components to narrow down the cause before making any changes

**Prioritise:** Restore service as soon as possible, while preserving evidence and logs for deeper root cause analysis

**Separate:** Spread the workload, giving each member of the incident management team a specific role. Vital roles are Manager, Operations, Comms and Planning.

* Manager has the job of holding the high-level state of the incident and orchestrating the response.
* Operations has the job of investigating and implementing resolution steps to the incident. 
* Comms has the job of communicating with users and stakeholders, providing updates and flagging new information.
* Support has the job of supporting the other roles by logging additional tickets for things to check in on later, tracking changes to the system, arranging handovers and regular coffee. 

**Trust:** Allow your IT team autonomy within their role in the incident management process. Reducing crossover prevents people from feeling overwhelmed!

**Manage Emotion:** Be aware of the emotional state of you, your staff, and your users when managing an incident. If people are starting to feel panicked and overwhelmed, they're more likely to make mistakes. Take high emotions as a signal to solicit further help.

**Review:** After the incident, review with your team and users to determine if there's anything you could have done better. Continually improving the process over time and tailoring it to your culture and organisation is vital to the continued success of the process.

#  Footnotes
This incident management strategy is adapted from [FEMA's National Incident Management System][1]. 

On Page 52: Communications management.

  * Manager corresponds to Strategic communication
  * Operations corresponds to Tactical communication
  * Support corresponds to... well, Support
  * Comms corresponds to Public communication

 

 [1]: https://www.fema.gov/media-library-data/1508151197225-ced8c60378c3936adb92c1a3ee6f6564/FINAL_NIMS_2017.pdf