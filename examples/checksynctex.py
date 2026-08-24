#!/usr/bin/env python3

# Check that SyncTeX maps words of a PDF to the expected source lines.
#
# usage: checksynctex.py file.pdf expectations
#
# Each non-blank, non-comment line of the expectations file reads either
#   <page> <word> <file> <line>
# meaning that the first occurrence of <word> on page <page> of the PDF is
# expected to be attributed by SyncTeX to line <line> of <file> (compared
# by basename; this is inverse search, from the PDF to the source), or
#   view <file> <line> <pages>
# meaning that forward search (from the source to the PDF) for line <line>
# of <file> is expected to yield exactly the comma-separated set <pages> of
# pages. Words are located with pdftotext -bbox and SyncTeX is queried with
# the synctex command-line tool, as an editor would.
#
# requirements: Poppler's pdftotext, and synctex (part of TeX Live)

import os
import re
import subprocess
import sys
import xml.etree.ElementTree as ET


def words(pdf):
    xml = subprocess.check_output(['pdftotext', '-bbox', pdf, '-'])
    xml = re.sub(rb'\sxmlns="[^"]*"', b'', xml, count=1)
    root = ET.fromstring(xml)
    result = {}
    for number, page in enumerate(root.iter('page'), start=1):
        result[number] = [(w.text, float(w.get('xMin')), float(w.get('yMin')),
                           float(w.get('xMax')), float(w.get('yMax')))
                          for w in page.iter('word')]
    return result


def synctex_edit(pdf, page, x, y):
    out = subprocess.check_output(
        ['synctex', 'edit', '-o', '%d:%f:%f:%s' % (page, x, y, pdf)],
        stderr=subprocess.DEVNULL, universal_newlines=True)
    source = line = None
    for l in out.splitlines():
        if l.startswith('Input:'):
            source = l[len('Input:'):]
        elif l.startswith('Line:'):
            line = int(l[len('Line:'):])
        if source is not None and line is not None:
            break
    return source, line


def synctex_view(pdf, source, line):
    out = subprocess.check_output(
        ['synctex', 'view', '-i', '%d:0:%s' % (line, source), '-o', pdf],
        stderr=subprocess.DEVNULL, universal_newlines=True)
    return sorted(set(int(l[len('Page:'):]) for l in out.splitlines()
                      if l.startswith('Page:')))


def main():
    pdf, expectations = sys.argv[1:3]
    pages = words(pdf)
    ok = True
    with open(expectations) as f:
        for spec in f:
            spec = spec.split('#')[0].split()
            if not spec:
                continue
            if spec[0] == 'view':
                source, line = spec[1], int(spec[2])
                expected = sorted(int(p) for p in spec[3].split(','))
                got = synctex_view(pdf, os.path.join(os.path.dirname(pdf), source), line)
                if got != expected:
                    print('%s: forward search for %s:%d yields pages %s, expected %s'
                          % (pdf, source, line, got, expected))
                    ok = False
                continue
            page, word, source, line = int(spec[0]), spec[1], spec[2], int(spec[3])
            found = [(i, w) for i, w in enumerate(pages.get(page, []))
                     if w[0].strip('.,;:()[]') == word]
            if not found:
                print('%s: word %s not found on page %d' % (pdf, word, page))
                ok = False
                continue
            # Query in the middle of the space before the word: the nearest
            # SyncTeX record is then the interword glue, whose position is
            # reliable, rather than a font kern inside the word (LuaTeX
            # records those with a stale position and origin).
            i, (_, x0, y0, x1, y1) = found[0]
            x = x0 - 2
            if i > 0:
                _, px0, py0, px1, py1 = pages[page][i - 1]
                if py0 == y0 and px1 < x0:
                    x = (px1 + x0) / 2
            got_source, got_line = synctex_edit(pdf, page, x, (y0 + y1) / 2)
            if got_source is None or os.path.basename(got_source) != source or got_line != line:
                print('%s: %s on page %d maps to %s:%s, expected %s:%d'
                      % (pdf, word, page, got_source, got_line, source, line))
                ok = False
    sys.exit(0 if ok else 1)


if __name__ == '__main__':
    main()
