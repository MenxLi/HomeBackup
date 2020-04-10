#!/usr/bin/python3

import os, sys
#from pathlib import Path
import json
import datetime

from config import file_path


class BackUp_Base(object):
    """Base class for BackUp and Restore"""
    HOME = os.environ["HOME"]
    backup_dir = os.path.abspath(
        os.path.join(os.path.dirname(__file__), "Backup")
        )
    def __init__(self):
        pass

class BackUp(BackUp_Base):
    def __init__(self):
        super().__init__()
        self.abs_path = []
        for path_ in file_path:
            p = path_.replace("~", self.HOME)
            self.abs_path.append(p)
    
    def __call__(self, git = False, push = False, msg = ""):
        if not os.path.exists(self.backup_dir):
            print("Created directory: ", self.backup_dir)
            os.mkdir(self.backup_dir)
        for file_ in self.abs_path:
            self.__backUpFile(file_)
        if git:
            date_time = datetime.datetime.now()
            os.system("git add --all")
            if msg == "":
                os.system("git commit -m \"{} @ Auto commit\"".format(date_time))
            else:
                os.system("git commit -m \"{}\"".format(msg))
            if push:
                os.system("git push")

    def __backUpFile(self, f_path):
        if not os.path.exists(f_path):
            print("? <{}> not exits".format(f_path))
            return
        # Creat folder
        dst_path = os.path.dirname(f_path).replace(self.HOME, self.backup_dir)   # directory to store files
        if not os.path.exists(dst_path):
            self.createFolder(dst_path)
        # Print
        backup_file_path = os.path.join(dst_path, os.path.basename(f_path))
        if os.path.exists(backup_file_path):
            print("* <{}> Updated".format(backup_file_path))
        else: print("+ <{}> Created".format(backup_file_path))
        # Copy
        if os.path.isfile(f_path):
            os.system("cp {} {}".format(f_path, dst_path))
        elif os.path.isdir(f_path):
            os.system("cp -r {} {}".format(f_path, dst_path))

    def createFolder(self, dst_path):
        """Creat correspounding folder, no matter whether the base/parent folders exists"""
        if os.path.exists(dst_path):
            return
        else:
            parent_path = os.path.dirname(dst_path)
            self.createFolder(parent_path)
            os.mkdir(dst_path)

class Restore(BackUp_Base):
    def __init__(self):
        pass
    def __call__(self, pull = False, force = False):
        if pull:
            os.system("git pull")
        for file_ in os.listdir(self.backup_dir):
            file_path = os.path.abspath(os.path.join(self.backup_dir, file_))
            dst_path = os.path.join(self.HOME, file_)
            if os.path.isfile(file_path):
                os.system("cp {} {}".format(file_path, self.HOME))
            elif os.path.isdir(file_path):
                if (not os.path.exists(dst_path)) and (not force):
                    print("{} not exists and is ignored, to force copy using ...")
                    continue
                os.system("cp -r {} {}".format(file_path, self.HOME))
            print("{} -> {}".format(file_, dst_path))

