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
            comment = 0
            for val in value:
                if (val['t'] == 'Str'):
                    if (idx > 0  and re.compile('\.\d+').match(val['c'])):
                        value[idx] = Str(".\n" + val['c'])
                        if (comment):
                            value.insert(idx, RawInline(fmt, r'}'))
                        comment = 0
                    if (val['c'] == '>'):
                        if (comment):
                            value[idx] = RawInline(fmt, r'}\DTcomment{')
                        else:
                            value[idx] = RawInline(fmt, r'\DTcomment{')
                        comment = 1
                idx = idx + 1
            if (comment):
                value = value + [RawInline(fmt, r'}')]
            value = [RawInline(fmt, r'\vspace{\the\parskip}\dirtree{%'), Str("\n")] + value + [Str(".\n"), RawInline(fmt, r'}')]

            if key == "Para":
                return [Para(value)]
            elif key == "Plain":
                return [Plain(value)]

if __name__ == '__main__':
    toJSONFilter(filterTree)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
