#!usr/bin/env bash

pwd=`dirname "$(readlink -f "$0")"`
base=$pwd/../..
src=fr
tgt=en
data=$base/data/$tgt-$src/
bpe=$pwd/bpe_drop

# change into base directory to ensure paths are valid
cd $base

# Undo BPE
cat $bpe/translations.bpe.txt | sed 's/\@\@ //g' > $bpe/translations.txt

# Undo further preprocessing
bash $base/scripts/postprocess.sh $bpe/translations.txt $bpe/translations.p.txt $tgt

# Calculate BLEU
cat $bpe/translations.p.txt | sacrebleu $data/raw/test.en > $bpe/bpe_drop_bleu.txt
