#!/usr/bin/python3

import os, platform
import datetime
from typing import List

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
    src_dir = os.path.dirname(os.path.realpath(__file__))
    backup_dir = os.path.abspath(
        os.path.join(src_dir, "files")
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
        print(f1, f2)
        if os.path.isfile(f1) and os.path.isfile(f2):
            return cls.fileSameContent(f1, f2)
        elif os.path.isdir(f1) and os.path.isdir(f2):
            return cls.dirSameContent(f1, f2)
        else:
            print("Type error")
            return False

    @classmethod
    def dirSameContent(cls, d1, d2):
        """
        Check if 2 dirs have same content
        """
        f1s = cls.recursivelyFindFiles(d1)
        f2s = cls.recursivelyFindFiles(d2)

        def _relPath(pth: str, root_pth: str):
            assert pth[:len(root_pth)] == root_pth
            out = pth[len(root_pth):]
            if out[0] == "/":
                out = out[1:]
            return out

        if set([_relPath(f1, d1) for f1 in f1s ]) != set([_relPath(f2, d2) for f2 in f2s ]):
            return False

        for f1 in f1s:
            rel_pth1 = _relPath(f1, d1)
            f2 = os.path.join(d2, rel_pth1)
            if not cls.fileSameContent(f1, f2):
                return False
        return True

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

    @classmethod
    def recursivelyFindFiles(cls, src_dir: str) -> List[str]:
        assert os.path.isdir(src_dir)
        out = []
        for f in os.listdir(src_dir):
            f_path = os.path.join(src_dir, f)
            if os.path.isfile(f_path):
                out.append(f_path)
            else:
                out += cls.recursivelyFindFiles(f_path)
        return out

class BackUp(BasicConfig):
    def __init__(self, query: bool = True):
        super().__init__()
        self.abs_path = []
        self.query = query
        for path_ in file_path:
            p = os.path.join(self.HOME, self.getRelPath(path_))
            self.abs_path.append(p)

    def __call__(self, git = False, push = False, msg = ""):
        os.chdir(self.src_dir)
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
        dst_path = f_path.replace(self.HOME, self.backup_dir)
        dst_dir = os.path.dirname(f_path).replace(self.HOME, self.backup_dir)   # directory to store files
        if f_path.endswith(os.sep):
            # os.dirname applied to <.../> will result in <...>
            dst_dir = os.path.dirname(dst_dir)

        if os.path.exists(dst_path) and self.sameContent(dst_path, f_path):
            print(f" [-] {f_path} same content as before, ignored. ")
            return

        if self.query:
            print(f"Backup {f_path} ?(y/[else]): ")
            ans = self.getch()
            if ans != "y":
                return
        # Creat folder
        dst_dir = os.path.abspath(dst_dir)
        if not os.path.exists(dst_dir):
            self.createFolder(dst_dir)
        # Print
        if os.path.exists(dst_path):
            print(" [*] <{}> Updated".format(dst_path))
        else: print(" [+] <{}> Created".format(dst_path))
        # Copy
        if os.path.isfile(f_path):
            os.system("cp {} {}".format(f_path, dst_path))
        elif os.path.isdir(f_path):
            os.system("cp -r {} {}".format(f_path, dst_dir))

class Restore(BasicConfig):
    def __init__(self, query: bool = True):
        self.query = query
    def __call__(self, pull = False, force = False):
        os.chdir(self.src_dir)
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
            print(" [+] {} -> {}".format(local_path, dst_path))
            self.createFolder(os.path.dirname(dst_path))
        else:
            print(" [*] {} -> {}".format(local_path, dst_path))
        if os.path.isfile(local_path):
            os.system("cp {} {}".format(local_path, dst_path))
        elif os.path.isdir(local_path):
            dst_dir = os.path.dirname(dst_path)
            if dst_path.endswith(os.sep):
                dst_dir = os.path.dirname(dst_dir)
            os.system("cp -r {} {}".format(local_path, dst_dir))
