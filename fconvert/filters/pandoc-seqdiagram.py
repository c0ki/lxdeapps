#! /usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Pandoc filter to manage markdown sequence diagram
"""

__author__ = "c0kinou"

from pandocfilters import toJSONFilter, get_filename4code, get_extension, get_caption, Image, Para
import re, sys, os, subprocess

def filterSeqDiagram(key, value, format, meta):
    global idSeqDiagram

    #sys.stderr.write("key %s\n" % key)
    #sys.stderr.write("value %s\n" % value)
    #sys.stderr.write("meta %s\n" % meta)

    if (key == "CodeBlock"):
        [ident, classes, keyvals], code = value
        classes = map(unicode.lower, classes)
        if "seqdiagram" in classes:
            caption, typef, keyvals = get_caption(keyvals)
            inputFile = get_filename4code("seqDiagram", code, 'txt')
            outputFile, ext = os.path.splitext(inputFile)
            outputFile += get_extension(format, ".svg", html=".png")

            # Write input file
            with open(inputFile, 'w') as f:
                f.write(code.encode('utf-8'))

            inputDir = os.path.abspath(os.path.dirname(inputFile))

            cmd_line = 'docker run --rm -v /home/data/sequencediagramorgbackend:/usr/src/app -w /usr/src/app -p 89:8080'.split(' ')
            cmd_line += ['-v', inputDir + ':/usr/src/app/work']
            cmd_line += ['node', 'node', 'generate.js']
            cmd_line += ['--input', 'work/' + os.path.basename(inputFile)]
            cmd_line += ['--output', 'work/' + os.path.basename(outputFile)]
            sys.stderr.write("Running %s\n" % " ".join(cmd_line))
            subprocess.call(cmd_line, stdout=sys.stderr.fileno())

            return Para([Image([ident, classes, keyvals], caption, [os.path.abspath(outputFile), typef])])

if __name__ == '__main__':
    toJSONFilter(filterSeqDiagram)
    sys.stdout.flush() # Should fix issue #1 (pipe error)


