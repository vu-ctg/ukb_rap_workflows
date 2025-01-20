import argparse
import os

def main(args):
    outfile = open(args.outfile, "w")
    header = ['"userId"', '"exposure"']
    print(",".join(header), file=outfile)
    
    participants_to_subset = set()
    with open(args.in_phenotypes, "r") as f:
        for line in f:
            if line.startswith("participant.eid"):
                continue
            participants_to_subset.add(line.rstrip("\n").split(",")[0])
    
    with open(args.in_genocount, "r") as f:
        for line in f: 
            if line.startswith("FID"): 
                continue
            items = line.rstrip("\n").split(" ")
            if items[1] in participants_to_subset:
                print(",".join([items[1], items[6]]), file=outfile)
    outfile.close()
    
def parse_args():
    parser = argparse.ArgumentParser(description="Format to use with flag --traitofinterestfile in PHESANT.")
    parser.add_argument("--in_genocount", required=True, help="Input. This is the output of the plink command used to get the genocount for 1 snp. Header is: FID IID PAT MAT SEX PHENOTYPE rs1260326_T")
    parser.add_argument("--in_phenotypes", required=True, help="Input. This is the output of the dx extract_data command.")
    parser.add_argument("--outfile", required=True, help="Input. This is the path to the output")

    return parser.parse_args()

main(parse_args())