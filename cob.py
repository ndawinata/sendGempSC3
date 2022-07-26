import argparse

parser = argparse.ArgumentParser(description='A test program.')

parser.add_argument("-p", "--print_string", help="Prints the supplied argument.", action="store_true")

parser.add_argument('-t', action="store", dest="isi")

args = parser.parse_args()

file1 = open("logGempa.txt", "a")  # append mode
file1.write("%s \n" % args.isi)
file1.close()