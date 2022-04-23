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

class BackUp(BasicConfig):
    def __init__(self, query: bool = True):
        super().__init__()
        self.abs_path = []
        self.query = query
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
                os.system("git commit -m \"{} @ Auto commit from {}\"".format(date_time, platform.node()))
            else:
                os.system("git commit -m \"{}\"".format(msg))
            if push:
                os.system("git push")

    def __backUpFile(self, f_path):
        if not os.path.exists(f_path):
            print("? <{}> not exits".format(f_path))
            return
        if self.query:
            print(f"Backup {f_path} ?(y/[else]): ")
            ans = self.getch()
            if ans != "y":
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
        """Creat dst_path, no matter whether the base/parent folders exists"""
        if os.path.exists(dst_path):
            return
        else:
            parent_path = os.path.dirname(dst_path)
            self.createFolder(parent_path)
            os.mkdir(dst_path)

class Restore(BasicConfig):
    def __init__(self, query: bool = True):
        self.query = query
    def __call__(self, pull = False, force = False):
        if pull:
            os.system("git pull")
        for file_ in os.listdir(self.backup_dir):
            local_path = os.path.abspath(os.path.join(self.backup_dir, file_))
            dst_path = os.path.join(self.HOME, file_)
            if self.query:
                print(f"Restore {dst_path} ?(y/[else]): ")
                ans = self.getch()
                if ans != "y":
                    continue

            if (not os.path.exists(dst_path)) and (not force):
                print("{} not exists and is ignored, to force copy using -f".format(dst_path))
                continue

            if os.path.isfile(local_path):
                os.system("cp {} {}".format(local_path, self.HOME))
            elif os.path.isdir(local_path):
                os.system("cp -r {} {}".format(local_path, self.HOME))
            print("{} -> {}".format(file_, dst_path))
