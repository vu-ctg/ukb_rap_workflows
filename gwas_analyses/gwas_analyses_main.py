import argparse
from gwas_analyses_helper_func import get_phenotype_missing, subset_all_fields


def main(args):
    
    ###############################################################
    # Subset all_fields.txt file for the field of interest for gwas
    ###############################################################
    # format outout
    if args.cmd == "subset_field":
        print("Subset the file all_fields.txt and format to be used as an input file to dx extract_dataset --fields-file")
        outfile = open(args.outfile, "w")
        print("participant.eid", file=outfile)
        subset_all_fields(fields_interest_fp=args.fields_interest, all_fields=args.all_fields, outfile=outfile)
        outfile.close()
    
    #######################################
    # compute the missingness per phenotype
    #######################################
    if args.cmd == "pheno_miss":
        missing_summary_out = open(args.missing_summary_out, "w")
        print("\t".join(["N_Samples", "Phenotype", "Perc_Missing"]), file=missing_summary_out)
        get_phenotype_missing(phenotype_fp=args.phenotype, missing_summary_out=missing_summary_out, missing_threshold=args.missing_threshold, phenotype_filter_out=args.phenotype_filter_out, sample_colname=args.sample_colname, kept_samples_fp=args.kept_samples)
    
def parse_args():
    parser = argparse.ArgumentParser(description="Package for help with gwas analyses specifically for on UKB-RAP")
    subparsers = parser.add_subparsers(help='')
    sp = subparsers.add_parser('subset_field', help='Subset the file all_fields.txt and format to be used as an input file to dx extract_dataset --fields-file')
    sp.set_defaults(cmd = 'subset_field')
    sp.add_argument('--all_fields', required=True, help="Input. This is the output of the command dx extract_dataset pid:rid --list-fields.")
    sp.add_argument('--fields_interest', required=True, help="Input. This is a csv file with header FieldID. Each line is a field ID number.")
    sp.add_argument('--outfile', required=True, help="Path to the output directory")
    
    sp = subparsers.add_parser('pheno_miss', help='')
    sp.set_defaults(cmd = 'pheno_miss')
    sp.add_argument('--phenotype', help='')
    sp.add_argument('--missing_summary_out', help='')
    sp.add_argument('--missing_threshold', help='')
    sp.add_argument('--phenotype_filter_out', help='')
    sp.add_argument('--sample_colname', help='')
    sp.add_argument('--kept_samples', help='', default=None)

    return parser.parse_args()

if __name__ == "__main__":
    main(parse_args())