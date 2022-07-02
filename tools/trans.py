#!/usr/bin/python3
# Copyright (C) FIXME
'''Parse the output files of glibc-bench

'''
import os
import sys
import re
import argparse
import json
import fileinput

STATE_INIT = 0
STATE_NEW_CASE = 1

def _line_case_start(line):
    '''
    === case XXX
    '''
    return line.startswith("===")

def _line_blank(line):
    return ( len(line.strip()) == 0 )


def _add_result(obj, line):
    [k,v] = line.split(":")
    if k not in obj:
        obj[k]=[v]
    else:
        obj[k].append(v)

def _print_objs(objs):
    for obj in objs:
        for item in obj:
            context=item+" : "
            context+= "   ".join(obj[item])
            print(context)

def trans(filename):
    objs=[]
    state = STATE_INIT
    if filename == "-":
        text_file=sys.stdin
    else:
        text_file=open(filename)

    obj=dict()
    for line in text_file:
        line=line.strip()
        if _line_case_start(line):
            if state != STATE_INIT:
                objs.append(obj)
                obj=dict()
            state = STATE_NEW_CASE
        elif _line_blank(line):
            continue
        else:
            _add_result(obj, line)
    objs.append(obj)
    return objs
    

def main(filename):
    objs = trans(filename)
    _print_objs(objs)

if __name__ == '__main__':
    app_parser = argparse.ArgumentParser()
    app_parser.add_argument(
        '-f', type=str, help='file name', dest='filename')
    args = app_parser.parse_args()

    if args.filename != None:
        main(args.filename)
    else:
        main("-")
    
