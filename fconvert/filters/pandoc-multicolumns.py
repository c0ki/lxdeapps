#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to manage markdown multi columns
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, stringify, RawInline
import re, sys

FLAG_COLUMNS = re.compile('§§({(\d+)\})?')
#§§{2}
#§§

def filterMutiColumns(key, value, fmt, meta):
    if fmt == 'beamer':
        fmt = 'latex'
    if (key == "Str" and fmt == 'latex'):
        global fmc_lastStr
        try:
            fmc_lastStr
        except NameError:
            fmc_lastStr = ""
        #sys.stderr.write("key %s\n" % key)
        #sys.stderr.write("value %s\n" % value.encode('utf-8'))
        if FLAG_COLUMNS.match(value.encode('utf-8')):
            global incols
            try:
                incols
            except NameError:
                incols = 0
            size = FLAG_COLUMNS.match(value.encode('utf-8')).group(2)
            #sys.stderr.write("size %s\n" % size)
            if (incols and size is None):
                incols = 0
                return RawInline(fmt, r'\end{multicols}\vspace{-\the\parskip}')
            else:
                output = []
                if fmc_lastStr[-1] == ':':
                    output = output + [RawInline(fmt, r'\vspace{-\the\parskip}')]
                if not incols:
                    incols = 1
                    output = output + [RawInline(fmt, r'\begin{multicols}{' + size + '}')]
                return output
        fmc_lastStr = value

if __name__ == '__main__':
    toJSONFilter(filterMutiColumns)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
