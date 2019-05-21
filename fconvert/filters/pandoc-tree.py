#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to manage markdown tree
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, stringify, RawInline, Para, Str
import re, sys

def filterTree(key, value, fmt, meta):
    if fmt == 'beamer':
        fmt = 'latex'

    #sys.stderr.write("key %s\n" % key)
    #sys.stderr.write("value %s\n" % value)

    if ((key == "Para" or key == "Plain") and fmt == 'latex'):
        if (len(value) and value[0]['t'] == 'Str' and value[0]['c'] == '.1'):
            idx = 0
            for val in value:
                if (val['t'] == 'SoftBreak'):
                    value[idx] = Str(".\n")
                idx = idx + 1
            value = [RawInline(fmt, r'\dirtree{%'), Str("\n")] + value + [Str(".\n"), RawInline(fmt, r'}')]

            if key == "Para":
                return [Para(value)]
            elif key == "Plain":
                return [Plain(value)]

if __name__ == '__main__':
    toJSONFilter(filterTree)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
