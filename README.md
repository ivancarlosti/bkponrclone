Artigo: https://suporte.ivancarlos.com.br/hc/pt-br/articles/25861271868301

Artigo: https://suporte.ivancarlos.com.br/hc/pt-br/articles/25731464664461

# BackBlaze using Rclone script

These scripts generate backup of webservers and databases for backup purposes and send it to BackBlase buckets configured on Rclone, also check BackBlaze repositories for outdated buckets.

## Instructions

* Setup `checkbackup.sh` file to check outdated buckets
* Setup `rclone-mariadb.sh` file to run backup of webserver and MariaDB database
* Setup `rclone-postgres.sh` to run backup of webserver and Postgres database
Check the articles below for additional information (Google Translator may be required)

* [Setting up a script to notify by email that a repository in Rclone is without a recent backup](https://suporte.ivancarlos.com.br/hc/pt-br/articles/25861271868301)
* [Configuring Rclone to send backup to its destination](https://suporte.ivancarlos.com.br/hc/pt-br/articles/25731464664461)

## Requirements

* Linux Server
* Rclone
* BackBlaze bucket
