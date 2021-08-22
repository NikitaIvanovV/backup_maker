# backup_maker

A simple bash script that allows you to backup your data

## Table of contents

- [Installation](#installation)
- [Usage](#usage)
  - [List directories or files to backup](#list-directories-or-files-to-backup)
    - [Example](#example)
  - [Run script](#run-script)
  - [Schedule backuping](#schedule-backuping)
- [Configuring](#configuring)
  - [Example](#example-1)

## Installation

```bash
git clone https://github.com/ViChyavIn/backup_maker && cd backup_maker
```

## Usage

### List directories or files to backup

Create a file named `backup_paths_list.txt` in the backup_maker script directory:

```bash
touch backup_paths_list.txt
```

Use the following syntax to add paths for backuping:

```
<backup name> <absolute path>
```

Backup name should contain only this set of characters: `A-Z`, `a-z`, `0-9`, `-`, `_`.

#### Example

backup_paths_list.txt:

```
my-photos /home/user/photos
my-project-database /home/user/some-project/database.db
# You can comment like this
```

### Run script

To use the script, run `main.bash` file:

```bash
./main.bash
```

It will create `backups/` folder in the script directory that will contain subfolders named the same way as your backups defined in `backup_paths_list.txt` file. Each subfolder will contain backups as compressed tar archives.

For example, running the script with [this backup list](#example) will produce this folder:

```
backups
├── my-photos
│   └── my-photos_2021-08-22_10-10-28.tar.bz2
└── my-project-database
    └── my-project-database_2021-08-22_10-10-28.tar.bz2
```

### Schedule backuping

Usually you don't run the script by yourself but use some another program that runs it every X hours to make sure you always have fresh backups. [Cron](https://en.wikipedia.org/wiki/Cron) is such a program, read [this answer](https://askubuntu.com/a/2369) for more info on how to schedule backuping.

## Configuring 

Create `settings.conf` in backup_maker script directory to alter some behavior.

| Variable             | Default value | Description                                                                                                                                    |
| -------------------- | ------------- | ---------------------------------------------------------------------------------------------------------------------------------------------- |
| max_backups_to_store |               | Sets max amount of backups to store. If the amount of backups exceeds this value, the oldest backup is deleted. Empty means don't delete anything. |

### Example

settings.conf:

```conf
max_backups_to_store=10
```
