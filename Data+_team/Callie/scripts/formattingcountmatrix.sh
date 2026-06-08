# Notes for formatting the output of `featureCounts` command correctly to set it up for a gene count matrix with the sample metadata file

# featureCounts will output a .txt file and a .txt.summary file with information for (1) all your BAM files if run in one iteration or 
    # (2) one of each of those files for EACH BAM file if you run featureCounts as an array (each BAM file independently)

## Instructions for working with a .txt and .txt.summary file from all BAM together ##
    # the following are all potential/necessary steps 

# Remove the first row/line (Which starts with `# Program:` and gives background on the featureCounts program run)
cat gene_counts.txt | sed 1d 

# Fetch only the first (GeneID) and last (samples/BAM samples) field from the gene_count.txt file 
cat gene_counts.txt | cut -f1,7-24

# need to fix the names of the columns (samples/BAM files) from including the name of the path to the file to just the sample name (must match sample annotation file)
    # What is going on here
    # First line: setting the input field seperator (FS) and output FS (OFS) as tab deliminated
    # Second line: Saying "to Row #1" do the following...
    # Third line: creating a for loop to run through all of the columns with this path name we are trying to replace:
        # i=1 means start at the first column
        # i<NF means loop through until i is less than or equal to the total number of fields (NF)
        # i++ means after each loop, add 1 to the i count (i.e. move on to the next column)
    # Fourth line: first substitution with gsub() --> it is taking everything (^) up until the last / and replacing it with nothing ("") for the given column $i
    # Fifth line: second substitution with gsub() --> it is taking everything starting with `_sorted.bam` until the end ($) and replacing it with nothing ("")
    # Closing brackets and then the 1 is shorthand for "print"
awk 'BEGIN{FS=OFS="\t"}
NR==1 {
    for(i=1;i<=NF;i++) {
        gsub(/^.*\//,"",$i) #
        gsub(/_sorted\.bam$/,"",$i)
    }
}
1'

# All together now! 
cat gene_counts.txt | sed 1d | cut -f1,7-24 | awk 'BEGIN{FS=OFS="\t"}
NR==1 {
    for(i=1;i<=NF;i++) {
        gsub(/^.*\//,"",$i) #
        gsub(/_sorted\.bam$/,"",$i)
    }
}
1'

# Now that we know this gives us the formatted output we want, we should save this as a new file! 
cat gene_counts.txt | sed 1d | cut -f1,7-24 | awk 'BEGIN{FS=OFS="\t"}
NR==1 {
    for(i=1;i<=NF;i++) {
        gsub(/^.*\//,"",$i) #
        gsub(/_sorted\.bam$/,"",$i)
    }
}
1' > gene_counts_matrix.txt
