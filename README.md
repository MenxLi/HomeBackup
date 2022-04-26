# HomeBackup

Want to put various configration files under git contorl but don't want to setup git everywhere? Try this!  
These lightweight scripts can backup or restore files configured in `config.py` while calling git commands in one call.

**Note:**
* Work with Linux and (should work) Mac
* All files to be backed up should be under (sub-directories of) `$HOME`
* Git and git remote have to be set up in `{/Path/ToStore/Backup/Files}` before calling related functions

## Installation and Usage
#### Installation
```bash
$ git clone git@github.com:MenxLi/HomeBackup.git
$ mkdir {/Path/ToStore/Backup/Files}
$ cp HomeBackup/*.py {/Path/ToStore/Backup/Files}
$ cd {/Path/ToStore/Backup/Files}
$ sudo chmod 755 backUpHome.py
$ # make soft link if desired.
```

#### Usage
```bash
# Back up
$ ./backUpHome.py -b              # Simply backup files
$ ./backUpHome.py -bg             # Backup files -> git add -> commit -m "{Time}"
$ ./backUpHome.py -bgm "Message"  # Backup files -> git add -> commit -m "Message"
$ ./backUpHome.py -bgpm "Message" # Backup files -> git add -> commit -m "Message" -> push
# Restore
$ ./backUpHome.py -r              # Restore files
$ ./backUpHome.py -rp             # git pull -> restore files
$ ./backUpHome.py -rpf            # git pull -> restore files (All backup files will be copied to designated destination even if some files do not exist in current computer)
```
```
# Example
# Back up files into --{/Path/ToStore/Backup/Files}/Backup-- => git add --all => commit -m "{Time}" => push
$ ./backUpHome.py -bgp                                                         
```
