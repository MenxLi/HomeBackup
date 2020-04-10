# HomeBackup

Want to put various configration files under git contorl but don't want to setup git everywhere? Try this!  
These lightweight scripts can backup or restore files configured in `config.py` while calling git commands in one call.

**Note:**
* Only work with linux
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
```

#### Usage
```bash
# Back up
$ ./backUpHome.py                 # Simply backup files
$ ./backUpHome.py -g              # Backup files -> git add -> commit -m "{Time}"
$ ./backUpHome.py -gm "Message"   # Backup files -> git add -> commit -m "Message"
$ ./backUpHome.py -gpm "Message"  # Backup files -> git add -> commit -m "Message" -> push
# Restore
$ ./backUpHome.py -r              # Restore files
$ ./backUpHome.py -rp             # git pull -> restore files
$ ./backUpHome.py -rpf            # git pull -> restore files (All backup files will be copied to designated destination even if some files do not exist in current computer)
```
```
# Example
# Back up files into --{/Path/ToStore/Backup/Files}/Backup-- => git add --all => commit -m "{Time}" => push
$ ./backUpHome.py -gp                                                         
>>
  * </home/{User}/.home/Backup/.vimrc> Updated                        
  + </home/{User}/.home/Backup/.config/Code/User/settings.json> Created     
  ? </home/{User}/.zshrc> not exists                                        
  ...  
  [master 82e7c70] 2020-04-10 00:30:48.914778 @ Auto commit                   
  2 files changed, 10 insertions(+), 5 deletions(-)  
```
