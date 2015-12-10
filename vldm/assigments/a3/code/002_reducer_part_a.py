#! /usr/bin/python

# import some useful functions 
from itertools import groupby
from operator import itemgetter
import sys

# define utility to read mapper output
def read_mapper_output(file, separator = '\t'):
    for line in file:
        yield line.rstrip().split(separator)
        
def main(separator = '\t'):
    # get the output from the mapper and split it up by the separator (tabs)
    data = read_mapper_output(sys.stdin, separator = separator)
    # group by the key (artist) and get the count
    for artist, group in groupby(data, itemgetter(0)):
        try:
	    # count the total number of mentions for each artist
            total_count = sum(int(mentions) for artist, mentions in group)
	    # print the value out to the console
            print '%s%s%d' % (artist, separator, total_count)
        except ValueError:
            pass
        
if __name__ == '__main__':
    main()
    
