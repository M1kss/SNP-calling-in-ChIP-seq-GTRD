#!/bin/bash

REFERENCE=$6
FA="$REFERENCE/$7"
BAMNAME=$1
CTRLNAME=$2
VCF=$3
VCFctrl=$4
OUT=$5

python3 make_table_refined.py $VCF $VCFctrl "$OUT/$1_table_11.txt" "$OUT/$1_table_01_pre.txt" "$OUT/$1_table_10_pre.txt" "$OUT/$1_bed01.bed" "$OUT/$1_bed10.bed"

bcftools mpileup "$OUT/$2_final.bam" -A -R "$OUT/$1_bed10.bed" -f $FA -Ov -o "$OUT/$1_pile_10.vcf"

bcftools mpileup "$OUT/$1_final.bam" -A -R "$OUT/$1_bed01.bed" -f $FA -Ov -o "$OUT/$1_pile_01.vcf"

python3 remake_tables.py "$OUT/$1_pile_01.vcf" "$OUT/$1_pile_10.vcf" "$OUT/$1_table_01_pre.txt" "$OUT/$1_table_10_pre.txt" "$OUT/$1_table_01.txt" "$OUT/$1_table_10.txt"

cat "$OUT/$1_table_01.txt" "$OUT/$1_table_10.txt" "$OUT/$1_table_11.txt" | bedtools sort -i > "$OUT/$1_table_pre.txt"

python3 filter_table.py "$OUT/$1_table_pre.txt" "$OUT/$1_table.txt"

rm "$OUT/$1_table_10_pre.txt"
rm "$OUT/$1_table_01_pre.txt"
rm "$OUT/$1_bed01.bed"
rm "$OUT/$1_bed10.bed"
rm "$OUT/$1_table_pre.txt"

exit 0
