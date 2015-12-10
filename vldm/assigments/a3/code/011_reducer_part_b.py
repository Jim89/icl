#! /usr/bin/python

from itertools import groupby
from operator import itemgetter
import sys

# define utility to read mapper output
def read_mapper_output(file, separator = '\t'):
    for line in file:
        yield line.rstrip().split(separator)
        
def main(separator = '\t'):
    # get the mapper output and split it up by the separator
    data = read_mapper_output(sys.stdin, separator = separator)
    # group by the key (artist and song)
    for artist_song, group in groupby(data, itemgetter(0)):
        try:
            artist = artist_song.split(',')[0]  # get the artist on its own
            song = artist_song.split(',')[1]	# get the song on its own
            total_count = sum(int(plays) for artist_song, plays in group) # sum up the plays for the artist, song combination
	    # as long as the song has been played more than 600,000,000 times
            if total_count >= 600000000:
            # print the total number of plays
                print '%s%s%s%s%d' % (artist, 		# print out the artist
                                      separator,	# then a tab
                                      song,		# then the song
                                      separator,	# then a tab
                                      total_count)	# then the total number of plays
            else:
                    pass
        except ValueError:
            pass
        
if __name__ == '__main__':
    main()
    
