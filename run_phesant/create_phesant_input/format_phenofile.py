import argparse
import os

def main(args):
    outfile = open(args.outfile, "w")
    
    participants_to_subset = set()
    with open(args.in_traitofinterest, "r") as f:
        for line in f:
            if line.startswith('"userId"'):
                continue
            participants_to_subset.add(line.rstrip("\n").split(",")[0])
            
    with open(args.in_phenotypes, "r") as f:
        for line in f:
            if line.startswith("participant.eid"):
                header = ['"userId"']
                items = line.rstrip("\n").split(",")
                for item in items[1:]: #participant.p23473_i0
                    field = item.split("participant.p")[1].split("_i") #23473_i0
                    field_fmt = "x" + field[0] + "_" + field[1] + "_0" #x21022_0_0
                    header.append('"{}"'.format(field_fmt))
                print(",".join(header), file=outfile)
            else:
                if line.rstrip("\n").split(",")[0] in participants_to_subset:
                    print(line.rstrip("\n"), file=outfile)
    outfile.close()
    
def parse_args():
    parser = argparse.ArgumentParser(description="Format to use with flag --phenofile in PHESANT.")
    parser.add_argument("--in_phenotypes", required=True, help="Input. This is the output of the dx extract_data command.")
    parser.add_argument("--in_traitofinterest", required=True, help="Input. This is the output of the file format_traitofinterestfile.py. This file is needed to subset the individuals")
    parser.add_argument("--outfile", required=True, help="Path to the output file.")

    return parser.parse_args()

main(parse_args())