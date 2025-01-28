# this script extracts the start:end of each block
import argparse
import os


def main(args):
    
    block_pos = open(args.block_pos, 'r')
    lines = block_pos.readlines()
    if lines:
        first = lines[0]
        last = lines[-1]
    
    out = open(args.outfile, "a")
        
    block_start_end = [args.block_pos.split("_sorted")[0], first.rstrip("\n"), last.rstrip("\n")]
    print("\t".join(block_start_end), file=out)
    out.close()
    
def parse_args():
    parser = argparse.ArgumentParser(description="This script extracts the start:end of each block in the pVCF file")
    parser.add_argument("--block_pos", required=True, help="Output from the command bcftools query -f '%POS\n'")
    parser.add_argument("--outfile", required=True, help="Path to output file")
    return parser.parse_args()

main(parse_args())