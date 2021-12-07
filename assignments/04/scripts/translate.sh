#!usr/bin/env bash

scripts=`dirname "$(readlink -f "$0")"`
assign4=$scripts/..
base=$scripts/../../..
src=fr
tgt=en
data=$base/data/$tgt-$src/

# New folders
translations=$assign4/translations
translations_ln=$assign4/translations_ln
translations_bs=$assign4/translations_bs

# Create folders for translations
mkdir -p $translations
mkdir -p $translations_ln
mkdir -p $translations_bs

# Get beam size and alpha for length normalisation from command line
k=$1
a=$2

# change into base directory to ensure paths are valid
cd $base

# Translate with given beam size
python translate_beam.py \
    --data $data/prepared \
    --dicts $data/prepared \
    --checkpoint-path $assign4/baseline/checkpoints/checkpoint_best.pt \
    --output $translations_bs/translations_$k.txt \
    --beam-size $k \
    --alpha $a
