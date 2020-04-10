# HomeBackup

Want to put various configration files under git contorl but don't want to setup git everywhere? Try this!  
This lightweight scripts can backup or restore files configured in `config.py` while calling git commands in one call.

**Note:**
* Only work for linux
* All files to be backed up should be under (sub-directories of) $HOME
* Git has to be set up in `{/Path/ToStore/Backup/Files}` before calling git related funtions

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
# Back up files into --{/Path/ToStore/Backup/Files}/Backup-- and call git add->commit->push
$ ./backUpHome.py -gp                                                         
>>
* </home/{User}>/.home/Backup/.vimrc> Updated                        
+ </home/{User}>/.home/Backup/.config/Code/User/settings.json> Created     
? </home/{User}>/.zshrc> not exists                                        
...  
[master 82e7c70] 2020-04-10 00:30:48.914778 @ Auto commit                   
11  2 files changed, 10 insertions(+), 5 deletions(-)  
```
