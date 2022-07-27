---
title: How to fix QNAP NAS web GUI interface timing out or never loading
author: Aiden Arnkels-Webb
#type: post
date: 2020-02-07T20:55:29+00:00
aliases:
  - /how-to-fix-qnap-nas-web-gui-interface-timing-out-or-never-loading/
cover:
    image: "cover.jpg" # image path/url
    alt: "Picture of a QNAP NAS" # alt text
    caption: "<text>" # display caption under cover
    relative: false # when using page bundles set this to true
    hidden: false # only hide on current single page
neve_meta_enable_content_width:
  - off
tags: ['Troubleshooting','IT & Tech','QNAP']

---
### The Problem

You're trying to connect to your NAS's web interface but it's just spinning forever and not actually loading. 

### The Cause

The cause can be a number of things, but it boils down to an issue with the http service or proxy service on the QNAP. 

Sometimes a configuration problem will cause the service to behave badly. A firmware update may cause a mismatch between the config file and the service being run.

### The Fix

I'm assuming at this point that you've tried rebooting the NAS and that hasn't resolved the issue. Here are some other things you can try.

#### Reset the Admin account config

1. Download, install and run [WinSCP](https://winscp.net/eng/index.php)
2. In WinSCP, set the option to show hidden files (keyboard shortcut Ctrl-Alt-H or Click Options > Preferences > Panels and ensure that "Show hidden files" is checked, then click OK )
3. Connect to the IP of your QNAP NAS as Admin
4. Click Open Directory and enter: `/etc/config/.qos_config/users/admin/`
5. Download the config and .qtoken files to your local machine as a backup
6. Delete the config and .qtoken files on the QNAP
7. Click Commands > Open Terminal
8. Type "reboot" and click execute to reboot the NAS

Note it may take a long time for the NAS to reboot. Leave it to do what it needs to do for at least half an hour. Periodically attempt to reconnect to WinSCP / the Web page, or use QFinder to determine when the QNAP is back online.

#### Restart the HTTP server / amend configuration

If the above does not work, you may have a different problem, not currently covered in this guide. It's worth restarting the http service and confirming both start OK. Note all commands here are case sensitive. Slashes (\\) and backslashes (/) are also not interchangeable as they are in a Windows environment.

1. Download and run [Putty](https://www.putty.org/)
2. Connect to your QNAP via SSH and log in as Admin
3. Navigate to the init.d directory
    ``` bash
    cd /etc/init.d/ 
    ```
4. List all the http shell scripts, you should see both "Qthttpd.sh" (Web Server) and "thttpd.sh" (Apache Proxy)
    ```bash
    ls -1 | grep 'http'
    ``` 
5. Restart Qthttpd, confirm that shutdown and start both return OK.
    ```bash
    ./Qthttpd.sh restart
    ```
6. Restart thttpd, confirm that shutdown and start both return OK
    ```bash
    ./thttpd.sh restart
    ```

#### If the apache proxy does not start:

1. Get the Web Access Port config, you should see "8080" being displayed. If it does not, go to Step 2.
    ```bash
    /sbin/getcfg SYSTEM "Web Access Port"
    ```
2. Set the Web Access Port to 8080 as should be default
    ```bash
    /sbin/setcfg SYSTEM "Web Access Port" 8080
    ``` 
3. Restart the thttpd service and apache proxy
    ```bash
    /etc/init.d/thttpd.sh restart
    ```