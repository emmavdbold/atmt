#!usr/bin/env bash

scripts=`dirname "$(readlink -f "$0")"`
assign4=$scripts/..
base=$scripts/../../..
src=fr
tgt=en
data=$base/data/$tgt-$src/
translations=$assign4/translations
bleu_scores=$assign4/bleu_scores

# Create folder for files with bleu scores
mkdir -p $bleu_scores

# Get beam size
k=$1

# change into base directory to ensure paths are valid
cd $base

# Undo preprocessing
bash $base/scripts/postprocess.sh $translations/translations_$k.txt $translations/translations_$k.p.txt $tgt

# Calculate BLEU
cat $translations/translations_$k.p.txt | sacrebleu $data/raw/test.en > $bleu_scores/bleu_$k.txt
