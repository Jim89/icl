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
    for artist_song, group in groupby(data, itemgetter(0)):
        try:
            artist = artist_song.split(',')[0]
            song = artist_song.split(',')[1]
            total_count = sum(int(plays) for artist_song, plays in group)
            if total_count >= 600000000:
            # print total_count
                print '%s%s%s%s%d' % (artist, 
                                      separator,
                                      song,
                                      separator,
                                      total_count)
            else:
                    pass
        except ValueError:
            pass
        
if __name__ == '__main__':
    main()
    
