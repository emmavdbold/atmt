#!usr/bin/env bash

scripts=`dirname "$(readlink -f "$0")"`
assign4=$scripts/..
base=$scripts/../../..
src=fr
tgt=en
data=$base/data/$tgt-$src/
translations=$assign4/translations
translations_ln=$assign4/translations_ln
translations_bs=$assign4/translations_bs

# New folders
bleu_scores=$assign4/bleu_scores
bleu_scores_ln=$assign4/bleu_scores_ln
bleu_scores_bs=$assign4/bleu_scores_bs

# Create folders for files with bleu scores
mkdir -p $bleu_scores
mkdir -p $bleu_scores_ln
mkdir -p $bleu_scores_bs

# Get beam size and alpha
k=$1
a=$2

# change into base directory to ensure paths are valid
cd $base

# Undo preprocessing
bash $base/scripts/postprocess.sh $translations_bs/translations_$k.txt $translations_bs/translations_$k.p.txt $tgt

# Calculate BLEU
cat $translations_bs/translations_$k.p.txt | sacrebleu $data/raw/test.en > $bleu_scores_bs/bleu_$k.txt
