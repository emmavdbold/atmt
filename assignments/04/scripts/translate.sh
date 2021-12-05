#!usr/bin/env bash

scripts=`dirname "$(readlink -f "$0")"`
assign4=$scripts/..
base=$scripts/../../..
src=fr
tgt=en
data=$base/data/$tgt-$src/
translations=$assign4/translations

# Create folder for translations
mkdir -p $translations

# Get beam size from command line
k=$1

# change into base directory to ensure paths are valid
cd $base

# Translate with given beam size
python translate_beam.py \
    --data $data/prepared \
    --dicts $data/prepared \
    --checkpoint-path $assign4/baseline/checkpoints/checkpoint_best.pt \
    --output $translations/translations_$k.txt \
    --beam-size $k
