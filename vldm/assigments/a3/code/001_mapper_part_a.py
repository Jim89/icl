#! /usr/bin/python

# import system functions
import sys

# utility function to split up input file
def read_data_input(file, separator = '\t'):
    for line in file:
        yield line.split(separator)

# define main mapping function        
def main(separator = '\t'):
    # get the data from standard input and split it up by the separator
    data = read_data_input(sys.stdin, separator)
    # for each line in the data
    for words in data:
	# if it contains 'u2', we're interested
        if 'u2' in words[2].lower():
	    # so print back out (to standard output) with a 1, so we can count later
            print '%s%s%d' % ('u2'.lower(), separator, 1)
            
# ensure THIS function runs and not something else
if __name__ == '__main__':
    main()
