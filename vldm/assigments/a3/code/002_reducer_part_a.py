#! /usr/bin/python

from itertools import groupby
from operator import itemgetter
import sys

# define utility to read mapper output
def read_mapper_output(file, separator = '\t'):
    for line in file:
        yield line.rstrip().split(separator)
        
def main(separator = '\t'):
    data = read_mapper_output(sys.stdin, separator = separator)
#    print data
    for artist, group in groupby(data, itemgetter(0)):
        try:
            total_count = sum(int(mentions) for artist, mentions in group)
            print '%s%s%d' % (artist, separator, total_count)
        except ValueError:
            pass
        
if __name__ == '__main__':
    main()
    