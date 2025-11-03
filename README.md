* General Guides and Scripts for:
* Ubuntu Server LAMP (20.04 LTS)
* Dark Web Hosting (LAMP on 20.04 LTS)
* General Windows 10 and mobile security guide

Install customscripts on linux
with full upgrade and package install
```bash
script=/tmp/install_script.sh && curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh > $script && chmod +x $script && $SHELL -c "$script full" && $SHELL /usr/share/customscripts/configure_webhook.sh full && exec $SHELL
```
without full upgrade and package install
```bash
script=/tmp/install_script.sh && curl -s https://raw.githubusercontent.com/PrincessPi3/general-scripts-and-system-ssssssetup/refs/heads/main/customscripts/install_script.sh > $script && chmod +x $script && $SHELL -c "$script" && $SHELL /usr/share/customscripts/configure_webhook.sh full && exec $SHELL
```

## Usage
### Linux
#### git helpers
* `gitinitshit`
* `gitshit`
* `gitsync`
* `syncstatus`
* `waypoint`
* `setup_git.sh`
  
#### security helpers
* `add_user_ssh`
* `backup.sh`
* `binwalk-tool`
* `configuree_webhook.sh`
* `connect-wifi`
* `crowdsec.sh`
* `find_bytes`
* `fix-wifi`
* `add_user_ssh`
* `wifi_monitor`
* `wifi-monitor-airX`
* `recursive-analysis`
* `large_file_search_for_hash`
* `randomtoken`
* `alfa_install_kali.sh`

#### monitoring
* `mon-watch`
* `monitor_pid`
* `ifnet`
* `webhook`
* `FIND_THE_FUCKING_PI`

#### hosting
* `add_apache2_site`

#### setup and general scripts
* `ifnet`
* `install_script.sh`
* `pyenv_setup`
* `python_pyenv_setup.sh`
* `xrdp-start`
* `add_apache2_site`
* `download_file_list`
* `message_users`
* `UNFUCK_HOMEDIR_PERMS.sh`
* `pi_create_image`

#### for fun
* `donut`
* `friendlyfriend`

#### media
* `easylistdownload`
* `download_file_list`

### Windowwz
#### git helpers
* `gitshit.ps1`
* `gitsync.ps1`
* `syncstatus.ps1`
* `waypoint.ps1`
#### linux-like hashing helpers
* `winhash.ps1`
* `md5sum.ps1`
* `sha256sum.ps1`
* `sha384sum.ps1`
* `sha512sum.ps1`
#### remote host tools
* `ssh-wait-loop.ps1`
* `wait-on-host.ps1`
* `testtime.ps1`
#### Windows system 
* `redundant-backup.ps1`
#### anti-productivity
* `IM_SO_TIRED_BOSS.ps1`

todo:
1. windwows gitinitshit
2. convert windows-repair.bat to powershell and add more features and checks
   1. automatic elevation request
   2. update and improve security scan via windows defender