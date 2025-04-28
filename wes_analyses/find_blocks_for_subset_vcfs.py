# this script extracts the start:end of each block
import argparse
import os


def main(args):
    
    chrom = args.chrom
    start = int(args.start)
    end = int(args.end)
    
    blocks = []
    all_start_pos = []
    all_end_pos = []
    
    with open(os.path.join("data/chr" + chrom + "_block_ranges.txt"),"r") as f:
        for line in f:
            items = line.rstrip("\n").split("\t")
            blocks.append(items[0])
            all_start_pos.append(int(items[1]))
            all_end_pos.append(int(items[2]))
    
    start_block = ""
    if start < all_start_pos[0]:
        print("Start position of region of interest is smaller than the first position in the VCF files. Setting the start_block to the first block")
        start_block = blocks[0]
    else:
        for i in range(len(blocks)):
            if start >= all_start_pos[i] and start <= all_end_pos[i]:
                start_block = blocks[i]
                break
            elif start > all_end_pos[i] and start <= all_start_pos[i+1]:
                start_block = blocks[i+1]
                
    end_block = ""
    if end > all_end_pos[-1]:
        print("End position of region of interest is bigger than the last position in the VCF files. Setting the end_block to the last block")
        end_block = blocks[-1]
    else:
        for i in range(len(blocks)):
            if end >= all_start_pos[i] and end <= all_end_pos[i]:
                end_block = blocks[i]
                break
            elif end > all_end_pos[i] and end < all_start_pos[i+1]:
                end_block = blocks[i]
    
    print(f"Start block: {start_block}")
    print(f"End block: {end_block}")
    
    if start_block == end_block: 
        print(f"For region of interest {chrom}:{start}-{end}, subset the VCF from block {start_block}.")
    else:
        print(f"You need to merge the VCFs between {start_block} and {end_block}.")
    
    
    
def parse_args():
    parser = argparse.ArgumentParser(description="This script finds which blocks to be used to extract region/gene of interest from the VCF.")
    parser.add_argument("--chrom", required=True, help="Chromosome number")
    parser.add_argument("--start", required=True, help="Start position of region of interest")
    parser.add_argument("--end", required=True, help="End position of region of interest")
    return parser.parse_args()

main(parse_args())

# rationale
# 1. If the start and end positions of the region of interest fall within the block, then that's easy, the start_block and end_block is the block where it is falling into 
# 2. If the region of interest's start is smaller than the start of the first block, assign the start_block to the first block
# 3. If the region of interest's start is between the end of a block and start of the next block, assign the start_block to the next block
# 4. If the region of interest's end is bigger than the end of the last block, assign the end_block to the last block
# 5. If the region of interest's end is between the end of a block and start of the next block, assign the end_block to the block

# test
# 1. region of interest: chrX:101894360-107603400 (b15)
# python find_blocks_for_subset_vcfs.py --chrom X --start 101894360 --end 107603400
# ukb23157_cX_b15_v1
# ukb23157_cX_b15_v1
# 2. region of interest: chrX:334100-7219600 (b0)
# python find_blocks_for_subset_vcfs.py --chrom X --start 334100 --end 7219600
# ukb23157_cX_b0_v1
# ukb23157_cX_b0_v1
# 3. region of interest: chrX:51900400-54797000 (b9)
# python find_blocks_for_subset_vcfs.py --chrom X --start 51900400 --end 54797000
# ukb23157_cX_b9_v1
# ukb23157_cX_b9_v1
# 4. region of interest: chrX:153788300-155775000 (b23)
# python find_blocks_for_subset_vcfs.py --chrom X --start 153788300 --end 155775000
# ukb23157_cX_b23_v1
# ukb23157_cX_b23_v1
# 5. region of interest: chrX:152168700-153788230 (b22)
# python find_blocks_for_subset_vcfs.py --chrom X --start 152168700 --end 153788225
# ukb23157_cX_b22_v1
# ukb23157_cX_b22_v1
# 6. region of interest: chrX:334222-41123824 (b0, b1, b2, b3, b4, b5)
# python find_blocks_for_subset_vcfs.py --chrom X --start 334222 --end 41123824
# ukb23157_cX_b0_v1
# ukb23157_cX_b5_v1