#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to manage markdown colums
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, stringify, RawInline
import re, sys

FLAG_COLUMNS = re.compile('\|\|\|({(\d+\.?\d+?)\})?')
#|||{0.5}
#|||{0.5}
#|||

def filterColumns(key, value, fmt, meta):
    if fmt == 'beamer':
        fmt = 'latex'
    if (key == "Str" and fmt == 'latex'):
        #sys.stderr.write("value %s\n" % stringify(value).encode('utf-8'))
        if FLAG_COLUMNS.match(value):
            global incols
            try:
                incols
            except NameError:
                incols = 0
            size = FLAG_COLUMNS.match(value).group(2)
            #sys.stderr.write("size %s\n" % size)
            if (incols and size is None):
                incols = 0
                return RawInline(fmt, r'\end{columns}')
            else:
                output = []
                if not incols:
                    incols = 1
                    output = output + [RawInline(fmt, r'\begin{columns}[t]')]
                output = output + [RawInline(fmt, r'\column{' + size + '\linewidth}')]
                return output

if __name__ == '__main__':
    toJSONFilter(filterColumns)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
