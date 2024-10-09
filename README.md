# Backup on Rclone script

<a target="_blank" href="https://github.com/ivancarlosti/bkponrclone"><img src="https://img.shields.io/github/stars/ivancarlosti/bkponrclone?style=flat" /></a>
<a target="_blank" href="https://github.com/ivancarlosti/bkponrclone"><img src="https://img.shields.io/github/last-commit/ivancarlosti/bkponrclone" /></a>
[![GitHub Sponsors](https://img.shields.io/github/sponsors/ivancarlosti?label=GitHub%20Sponsors)](https://github.com/sponsors/ivancarlosti)

These scripts generate backup of webservers and databases for backup purposes and send it to BackBlase buckets configured on Rclone, also check BackBlaze repositories for outdated buckets and send email messages when find uptdated buckets to you through Amazon SES. You can change the script to fit it for other backup storage services and messaging.

## Instructions

* Setup `rclone.sh` file to run backup of webserver and MariaDB/MySQL or Postgres database
* Setup `checkbackup.sh` file to check outdated buckets
* Run `chmod +x rclone.sh` to make the script executable
* Run `crontab -e` to add execution line to run periodically
  * Suggestion to run script `/home/username/rclone.sh` everyday at 02:00:
```
0 2 * * * cd /home/username; ./rclone.sh  >/dev/null 2>&1
```
 
#### Set password DB on file if needed to setup MariaDB/MySQL backup

* Write and edit file `.dbpassword.cnf`
* Setup permission running `chmod 0600 .dbpassword.cnf`

#### Check the articles below for additional information (Google Translator may be required)

* [Setting up a script to notify by email that a repository in Rclone is without a recent backup](https://suporte.ivancarlos.com.br/hc/pt-br/articles/25861271868301)
* [Configuring Rclone to send backup to its destination](https://suporte.ivancarlos.com.br/hc/pt-br/articles/25731464664461)

## Requirements

* Linux Server
* Rclone
* BackBlaze bucket
