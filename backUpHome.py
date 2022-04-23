#!/usr/bin/python3

import argparse
from _backUpClass import BackUp, Restore

parser = argparse.ArgumentParser(description="\
    Copy and restore files in config.py\
    ")
parser.add_argument("-b", "--backup", \
    help = "Backup files.",\
    action = "store_true")
parser.add_argument("-r", "--restore", \
    help = "Restore files.",\
    action = "store_true")

parser.add_argument("-p", "--push_pull",\
    help = "Call git push <or> pull | depending on the designated behaviour",\
    action = "store_true")

parser.add_argument("-g", "--git", 
    help = "Back up and call git add all and commit",
    action = "store_true")
parser.add_argument("-m", "--msg", \
    type = str, default="",\
    help = "Git commit messege, defaut -> time")

parser.add_argument("-f", "--force",\
    help = "Force creating files when restore even if files not exist",\
    action = "store_true")

parser.add_argument("-y", "--yes", \
    help = "answer all queres with 'y'",\
    action = "store_false")


if __name__ == "__main__":
    args = parser.parse_args()
    b, r = BackUp(args.yes), Restore(args.yes)

    if args.restore:
        r(args.push_pull, args.force)
    if args.backup:
        b(args.git, args.push_pull, args.msg)
