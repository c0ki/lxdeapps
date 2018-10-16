#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to manage highlight
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, stringify, Para, Plain, Str, RawInline
import re, sys

FLAG_HL = re.compile('(\{\+(.*?)\+\})')
LATEX_HL_BEGIN = r'\hl{'
LATEX_HL_END = r'}'

def filterWdiff(key, value, fmt, meta):
    if fmt == 'beamer':
        fmt = 'latex'

    if ((key == "Para" or key == "Plain") and fmt == 'latex'):
        value = stringify(value)
        # ~ sys.stderr.write("value: %s\n" % value.encode('utf-8'))

        if (FLAG_HL.search(value)):
            flagValues = FLAG_HL.findall(value)
            for idx, flagValue in enumerate(flagValues):
                value = value.replace(flagValue[0], LATEX_HL_BEGIN + " " + flagValue[1] + " " + LATEX_HL_END)

            values = re.split('\s+', value)
            newvalues = []
            addspace = False
            for value in values:
                if (value == LATEX_HL_BEGIN):
                    newvalues = newvalues + [Str(' '), RawInline(fmt, value)]
                    addspace = False
                elif (value == LATEX_HL_END):
                    newvalues = newvalues + [RawInline(fmt, value), Str(' ')]
                    addspace = False
                else:
                    if addspace:
                        newvalues = newvalues + [Str(' ')]
                    newvalues = newvalues + [Str(value)]
                    addspace = True

            if key == "Para":
                return [Para(newvalues)]
            elif key == "Plain":
                return [Plain(newvalues)]

if __name__ == '__main__':
    toJSONFilter(filterWdiff)
    sys.stdout.flush() # Should fix issue #1 (pipe error)
