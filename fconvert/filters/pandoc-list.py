#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to add title (ended by ':') on list
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, Str, OrderedList, BulletList, RawInline, RawBlock
import sys

def filterList(key, value, fmt, meta):
    if fmt == 'beamer':
        fmt = 'latex'
    if fmt == 'latex':
        latex_begin = r'\vspace{-\the\parskip}'
        latex_end = r''
        global lastStr
        try:
            lastStr
        except NameError:
            lastStr = None
        
        if key == 'Str':
            #sys.stderr.write("value %s\n" % value.encode('utf-8'))
            lastStr = value
        elif (key == 'OrderedList' and lastStr[-1] == ':'):
            attrs, items = value
            return [RawBlock(fmt, latex_begin)] + [OrderedList(attrs, items)] + [RawBlock(fmt, latex_end)]
        elif (key == 'BulletList' and lastStr[-1] == ':'):
            items = value
            return [RawBlock(fmt, latex_begin)] + [BulletList(items)] + [RawBlock(fmt, latex_end)]

if __name__ == '__main__':
    toJSONFilter(filterList)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
