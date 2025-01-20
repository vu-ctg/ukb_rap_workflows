import argparse
import os

def main(args):
    
    fields_interest = set()
    with open(args.fields_interest, "r") as f:
        for line in f:
            if line.startswith("Field ID"):
                continue
            fields_interest.add(line.rstrip("\n").split(",")[0])
            
    out_list = []
    with open(args.all_fields, "r") as f:
        for line in f:
            if line.startswith("participant.eid"):
                continue
            items = line.rstrip("\n").split("\t")
            if items[0].split("participant.p")[1].split("_")[0] in fields_interest:
                out_list.append(items[0])
                
    # split outputs into multiple files because dx extract_dataset does not handle many phenotypes well. TODO: investigate using SQL 
    steps = len(out_list)/30
    for i in range(0, round(steps) + 1):
        my_range = (30*i, 30*i + 30)
        outfile = open(os.path.join(args.outdir, "ukb_category_220_fields_for_export_part_" + str(i) + ".txt"), "w") #TODO: remove hard-coded path here
        print("participant.eid", file=outfile)
        for j in out_list[my_range[0]:my_range[1]]:
            print(j, file=outfile)
    
def parse_args():
    parser = argparse.ArgumentParser(description="Subset the file all_fields.txt and format to be used as an input file to dx extract_dataset --fields-file")
    parser.add_argument("--all_fields", required=True, help="Input. This is the output of the command dx extract_dataset pid:rid --list-fields.")
    parser.add_argument("--fields_interest", required=True, help="Input. This is the output of the script ukb_showcase_webscrape.py.")
    parser.add_argument("--outdir", required=True, help="Path to the output directory")

    return parser.parse_args()

main(parse_args())

# NOTE: for now this script returns the field ID but at some point might want to also find the Description