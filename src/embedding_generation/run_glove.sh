#!/bin/bash

#SBATCH --qos=batch
#SBATCH --job-name=glove_aus_200_10Kvocab
#SBATCH --output=glove_aus_200_10Kvocab
#SBATCH --mem=48g
#SBATCH --time=24:00:00 

# Makes programs, downloads sample data, trains a GloVe model, and then evaluates it.
# One optional argument can specify the language used for eval script: matlab, octave or [default] python

SITENAME=askubuntu_unix_superuser
#SITENAME=Home_and_Kitchen

DATADIR=/fs/clip-amr/clarification_question_generation_pytorch/embeddings/$SITENAME/200_10Kvocab

CORPUS=/fs/clip-amr/clarification_question_generation_pytorch/embeddings/$SITENAME/${SITENAME}_data.txt
VOCAB_FILE=$DATADIR/vocab.txt
COOCCURRENCE_FILE=$DATADIR/cooccurrence.bin
COOCCURRENCE_SHUF_FILE=$DATADIR/cooccurrence.shuf.bin
BUILDDIR=/fs/clip-sw/user-supported/GloVe-1.2/build
SAVE_FILE=$DATADIR/vectors
VERBOSE=2
MEMORY=4.0
#VOCAB_MIN_COUNT=10
VOCAB_MIN_COUNT=50
#VECTOR_SIZE=100
VECTOR_SIZE=200
MAX_ITER=30
WINDOW_SIZE=15
BINARY=2
NUM_THREADS=4
X_MAX=10

$BUILDDIR/vocab_count -min-count $VOCAB_MIN_COUNT -verbose $VERBOSE < $CORPUS > $VOCAB_FILE
$BUILDDIR/cooccur -memory $MEMORY -vocab-file $VOCAB_FILE -verbose $VERBOSE -window-size $WINDOW_SIZE < $CORPUS > $COOCCURRENCE_FILE
$BUILDDIR/shuffle -memory $MEMORY -verbose $VERBOSE < $COOCCURRENCE_FILE > $COOCCURRENCE_SHUF_FILE
$BUILDDIR/glove -save-file $SAVE_FILE -eta 0.05 -threads $NUM_THREADS -input-file $COOCCURRENCE_SHUF_FILE -x-max $X_MAX -iter $MAX_ITER -vector-size $VECTOR_SIZE -binary $BINARY -vocab-file $VOCAB_FILE -verbose $VERBOSE
