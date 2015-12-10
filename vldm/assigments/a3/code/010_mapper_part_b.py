#! /usr/bin/python

# import system functions
import sys

# utility function to split up input file
def read_data_input(file, separator = '\t'):
    for line in file:
        yield line.split(separator)

# define main mapping function        
def main(separator = '\t'):
    # get the data from standard input and split it up
    data = read_data_input(sys.stdin, separator)
    for words in data:
	# for each row ('words') print out: 
        print '%s,%s%s%d' % (words[2].lstrip().rstrip(), # the 3rd element (the artist) then a comma then
                             words[1].lstrip().rstrip(), # the 2nd element (the song)
                             separator, 
                             int(words[3]))		 # the times it was played
            
# ensure THIS function runs and not something else
if __name__ == '__main__':
    main()
