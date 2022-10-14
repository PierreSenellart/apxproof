#!/usr/bin/env python3

# Reproduced with modifications from Brecht Machiels's script at
# https://github.com/brechtm/rinohtype/blob/stable/tests_regression/helpers/diffpdf.py
# This file is under the Affero GPL 3.0 license, see
# https://www.gnu.org/licenses/agpl-3.0.html

# usage: diffpdf.py file1.pdf file2.pdf

# requirements:
# - ImageMagick (convert)
# - Poppler's pdftoppm and pdfinfo tools (works with 0.18.4 and 0.41.0,
#                                         fails with 0.42.0)

import os
import re
import shutil
import sys

from decimal import Decimal
from functools import partial
from multiprocessing import Pool, cpu_count
from subprocess import Popen, PIPE, DEVNULL, check_output


DIFF_DIR = 'pdfdiff'
SHELL = sys.platform == 'win32'


def diff_pdf(a_filename, b_filename, max_diff_threshold):
    # The following calls to check_output are potentially dangerous as
    # they launch a shell with a variable provided by the user -- first
    # check the a_filename and b_filename are harmless and look like
    # simple relative paths
    pattern = re.compile('^([A-Za-z0-9-_]+/)*[A-Za-z0-9-_]+(\\.[A-Za-z0-9]+)?$')
    if not pattern.match(a_filename) or not pattern.match(b_filename):
        raise Exception("Filenames contain unexpected characters")

    a_pages = int(check_output("pdfinfo %s | grep Pages: | sed 's/.* //'" %
                               (a_filename),
                               shell=True))
    b_pages = int(check_output("pdfinfo %s | grep Pages: | sed 's/.* //'" %
                               (b_filename),
                               shell=True))
    if a_pages != b_pages:
        # print('PDF files have different lengths ({} and {})'
        #       .format(a_pages, b_pages), file=sys.stderr)
        return False

    if os.path.exists(DIFF_DIR):
        for item in os.listdir(DIFF_DIR):
            item_path = os.path.join(DIFF_DIR, item)
            if os.path.isfile(item_path):
                os.unlink(item_path)
            elif os.path.isdir(item_path):
                shutil.rmtree(item_path)
    else:
        os.mkdir(DIFF_DIR)

    min_pages = min(a_pages, b_pages)
    page_numbers = list(range(1, min_pages + 1))
    # https://pymotw.com/2/multiprocessing/communication.html#process-pools
    pool_size = cpu_count()
    pool = Pool(processes=pool_size)
    # print('Running {} processes in parallel'.format(pool_size))
    perform_diff = partial(diff_page, a_filename, b_filename)
    try:
        pool_outputs = pool.map(perform_diff, page_numbers)
    except CommandFailed as exc:
        raise SystemExit('Problem running pdftoppm or convert (page {})!'
                         .format(exc.page_number))
    pool.close()  # no more tasks
    pool.join()   # wrap up current tasks

    max_diff = 0
    for page_number, page_diff in zip(page_numbers, pool_outputs):
        if page_diff > max_diff:
            max_diff = page_diff
        # if max_diff > 0:
        #     print('page {} ({})'.format(page_number, page_diff),
        #           file=sys.stderr)
    return (max_diff < max_diff_threshold)


class CommandFailed(Exception):
    def __init__(self, page_number):
        self.page_number = page_number


def diff_page(a_filename, b_filename, page_number):
    if compare_page(a_filename, b_filename, page_number):
        return 0

    diff_jpg_path = os.path.join(DIFF_DIR, '{}.jpg'.format(page_number))
    # http://stackoverflow.com/a/28779982/438249
    diff = Popen(['convert', '-', '(', '-clone', '0-1', '-compose', 'darken',
                                       '-composite', ')',
                  '-channel', 'RGB', '-combine', diff_jpg_path],
                 shell=SHELL, stdin=PIPE)
    a_page = pdf_page_to_ppm(a_filename, page_number, diff.stdin, gray=True)
    if a_page.wait() != 0:
        raise CommandFailed(page_number)
    b_page = pdf_page_to_ppm(b_filename, page_number, diff.stdin, gray=True)
    diff.stdin.close()
    if b_page.wait() != 0 or diff.wait() != 0:
        raise CommandFailed(page_number)
    grayscale = Popen(['convert', diff_jpg_path, '-colorspace', 'HSL',
                       '-channel', 'g', '-separate', '+channel', '-format',
                       '%[fx:mean]', 'info:'], shell=SHELL, stdout=PIPE)
    return Decimal(grayscale.stdout.read().decode('ascii'))


def compare_page(a_filename, b_filename, page_number):
    """Returns ``True`` if the pages at ``page_number`` are identical"""
    compare = Popen(['compare', '-', '-metric', 'AE', 'null:'],
                    shell=SHELL, stdin=PIPE, stdout=DEVNULL, stderr=DEVNULL)
    a_page = pdf_page_to_ppm(a_filename, page_number, compare.stdin)
    if a_page.wait() != 0:
        raise CommandFailed(page_number)
    b_page = pdf_page_to_ppm(b_filename, page_number, compare.stdin)
    compare.stdin.close()
    if b_page.wait() != 0:
        raise CommandFailed(page_number)
    return compare.wait() == 0


def pdf_page_to_ppm(pdf_path, page_number, stdout, gray=False):
    command = ['pdftoppm', '-f', str(page_number), '-singlefile', pdf_path]
    if gray:
        command.insert(-1, '-gray')
    pdftoppm = Popen(command, shell=SHELL, stdout=stdout)
    return pdftoppm


if __name__ == '__main__':
    _, a_filename, b_filename, max_diff_threshold = sys.argv
    if diff_pdf(a_filename, b_filename, float(max_diff_threshold)):
        rc = 0
    else:
        rc = 1
    raise SystemExit(rc)
