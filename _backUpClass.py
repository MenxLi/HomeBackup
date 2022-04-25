#!/usr/bin/python3

import os, platform
import datetime

from config import file_path

# https://stackoverflow.com/questions/510357/how-to-read-a-single-character-from-the-user
class _Getch:
    """Gets a single character from standard input.  Does not echo to the
screen."""
    def __init__(self):
        try:
            self.impl = _GetchWindows()
        except ImportError:
            self.impl = _GetchUnix()

    def __call__(self): return self.impl()

class _GetchUnix:
    def __init__(self):
        import tty, sys

    def __call__(self):
        import sys, tty, termios
        fd = sys.stdin.fileno()
        old_settings = termios.tcgetattr(fd)
        try:
            tty.setraw(sys.stdin.fileno())
            ch = sys.stdin.read(1)
        finally:
            termios.tcsetattr(fd, termios.TCSADRAIN, old_settings)
        return ch

class _GetchWindows:
    def __init__(self):
        import msvcrt

    def __call__(self):
        import msvcrt
        return msvcrt.getch()

class BasicConfig:
    HOME = os.environ["HOME"]
    backup_dir = os.path.abspath(
        os.path.join(os.path.dirname(os.path.realpath(__file__)), "files")
        )
    getch = _Getch()
    def __init__(self):
        pass

    @classmethod
    def getRelPath(cls, b_path: str):
        """
        Get relative file path from b_path
        i.e. the path under $HOME
         - backup config file path
        """
        b_path = b_path.replace("~/", "")
        b_path = b_path.replace(cls.HOME + "/", "")
        b_path = b_path.replace("$HOME/", "")
        return b_path

    @classmethod
    def createFolder(cls, dst_path):
        """Creat dst_path, no matter whether the base/parent folders exists"""
        if os.path.exists(dst_path):
            return
        else:
            parent_path = os.path.dirname(dst_path)
            cls.createFolder(parent_path)
            os.mkdir(dst_path)

    @classmethod
    def sameContent(cls, f1: str, f2: str):
        #  print(f1, f2)
        if os.path.isfile(f1) and os.path.isfile(f2):
            return cls.fileSameContent(f1, f2)
        elif os.path.isdir(f1) and os.path.isdir(f2):
            return cls.dirSameContent(f1, f2)
        else:
            return False

    @classmethod
    def dirSameContent(cls, d1, d2):
        """
        Check if 2 dirs have same content
        """
        return False    ## TO DO LATER

    @classmethod
    def fileSameContent(cls, f1: str, f2: str) -> bool:
        """
        Check if 2 files have same content
        """
        with open(f1, "r") as fp:
            f1_v = fp.read()
        with open(f2, "r") as fp:
            f2_v = fp.read()
        if f1_v == f2_v:
            return True
        else:
            return False

class BackUp(BasicConfig):
    def __init__(self, query: bool = True):
        super().__init__()
        self.abs_path = []
        self.query = query
        for path_ in file_path:
            p = os.path.join(self.HOME, self.getRelPath(path_))
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
                os.system("git commit -m \"{} @ Auto commit from {}\"".format(date_time, platform.node()))
            else:
                os.system("git commit -m \"{}\"".format(msg))
            if push:
                os.system("git push")

    def __backUpFile(self, f_path):
        if not os.path.exists(f_path):
            print(" [?] <{}> not exits".format(f_path))
            return
        dst_path = os.path.dirname(f_path).replace(self.HOME, self.backup_dir)   # directory to store files
        backup_file_path = os.path.join(dst_path, os.path.basename(f_path))
        if os.path.exists(backup_file_path) and self.sameContent(backup_file_path, f_path):
            print(f" [-] {f_path} same content as before, ignored. ")
            return

        if self.query:
            print(f"Backup {f_path} ?(y/[else]): ")
            ans = self.getch()
            if ans != "y":
                return
        # Creat folder
        if not os.path.exists(dst_path):
            self.createFolder(dst_path)
        # Print
        if os.path.exists(backup_file_path):
            print(" [*] <{}> Updated".format(backup_file_path))
        else: print(" [+] <{}> Created".format(backup_file_path))
        # Copy
        if os.path.isfile(f_path):
            os.system("cp {} {}".format(f_path, dst_path))
        elif os.path.isdir(f_path):
            os.system("cp -r {} {}".format(f_path, dst_path))

class Restore(BasicConfig):
    def __init__(self, query: bool = True):
        self.query = query
    def __call__(self, pull = False, force = False):
        if pull:
            os.system("git pull")
        for file_ in file_path:
            self.__restore(self.getRelPath(file_), force)

    def __restore(self, rel_path: str, force: bool):
        """
        - rel_path: relative path
        """
        local_path = os.path.join(self.backup_dir, rel_path)
        dst_path = os.path.join(self.HOME, rel_path)
        if not os.path.exists(local_path):
            print(" [x] {} not exists in BACKUP and is ignored".format(dst_path))
            return

        if (not os.path.exists(dst_path)) and (not force):
            print(" [x] {} not exists in HOME and is ignored, to force copy using -f.".format(dst_path))
            return

        if os.path.exists(dst_path) and self.sameContent(dst_path, local_path):
            print(" [-] {} same content as before, ignored.".format(dst_path))
            return

        if self.query:
            print(f"Restore {dst_path} ?(y/[else]): ")
            ans = self.getch()
            if ans != "y":
                return 

        if (not os.path.exists(dst_path)) and force:
            print(" [+] {} -> {}".format(rel_path, dst_path))
        else:
            print(" [*] {} -> {}".format(rel_path, dst_path))
        if os.path.isfile(local_path):
            os.system("cp {} {}".format(local_path, self.HOME))
        elif os.path.isdir(local_path):
            os.system("cp -r {} {}".format(local_path, self.HOME))
