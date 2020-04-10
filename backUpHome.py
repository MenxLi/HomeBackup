#!/usr/bin/python3

from _backUpClass import BackUp, Restore
import argparse

parser = argparse.ArgumentParser(description="\
    Copy and restore files in config.py\
    ")
parser.add_argument("-g", "--git", 
    help = "Back up and call git add all and commit",
    action = "store_true")
parser.add_argument("-r", "--restore", \
    help = "Restore files instead of back up",\
    action = "store_true")
parser.add_argument("-p", "--push_pull",\
    help = "Call git push <or> pull | depending on the designated behaviour",\
    action = "store_true")
parser.add_argument("-m", "--msg", \
    type = str, default="",\
    help = "Git commit messege, defaut -> time")
parser.add_argument("-f", "--force",\
    help = "Force creating files when restore even if files not exist",\
    action = "store_true")

if __name__ == "__main__":
    args = parser.parse_args()
    b, r = BackUp(), Restore()
    if args.restore:
        r(args.push_pull, args.force)
    else: 
        b(args.git, args.push_pull, args.msg)
