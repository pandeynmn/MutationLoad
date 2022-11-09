#!/bin/bash

# set library path for shared libraries
LD_LIBRARY_PATH=/home/npandey/gsl/lib
export LD_LIBRARY_PATH

timeSteps=50000
initialPopsize=20000
# mud=1.0
mud=2.0
chromosomesize=50
numberofchromosomes=23
bentodelrateratio=0.0
sb="0.0"
#0 for point; 1 for exponential; and 2 for uniform
bendist=0
#0 for root; 1 for single
typeofrun=1
slope=0
seed=57
K=20000
#0 for relative; 1 for absolute
fitnesstype=1
r=0.98
# r=1.0
i_init=400
s=0.1
tskit=0
#0 for runs without modular epistasis; 1 for runs with modular epistasis; 2 for modular epistasis in diploids
modularepis=2
elementsperl=1
#This ratio should be between 1 and 10
SdtoSbratio="1.0000"
#0 for point; 1 for exponential
deldist=0
rawfilesize=$timeSteps/100

if [ $fitnesstype -eq 0 ]
then
	fitnessstring="relative_"
elif [ $fitnesstype -eq 1 ]
then
	fitnessstring="absolute_"
fi

if [ $tskit -eq 0 ]
then
	tskitstring="OFF_"
elif [ $tskit -eq 1 ]
then
	tskitstring="ON_"
fi


if [ $bendist -eq 0 ]
then
	bendiststring="point_"
elif [ $bendist -eq 1 ]
then
	bendiststring="exponential_"
elif [ $bendist -eq 2 ]
then
	bendiststring="uniform_"
fi

if [ $deldist -eq 0 ]
then
	deldiststring="point_"
elif [ $deldist -eq 1 ]
then
	deldiststring="exponential_"
fi

#mub is written as a formated double in mutation load program
mub=$(echo "$mud * $bentodelrateratio" | bc -l)
mub=$(printf "%.4f" $mub)

#creates 2 strings; directory refers to the folder where data for the specified parameters will be stored; file is the snapshot of the simulation at its end.
if [ $modularepis -eq 0 ]
then
	directory="./r_"$r"/datafor_"$fitnessstring"tskit_"$tskitstring"r_"$r"_iinit_"$i_init"_s_"$s"_K_"$K"_deldist_"$deldiststring"bendist_"$bendiststring"mub_"$mub"_chromnum_"$numberofchromosomes"_N0_"$initialPopsize"_mud_"$mud"_L_"$chromosomesize"_seed_"$seed"/"
elif [ $modularepis -eq 1 ]
then
	directory="datafor_"$fitnessstring"tskit_"$tskitstring"elementsperlb_"$elementsperl"_r_"$r"_iinit_"$i_init"_s_"$s"_K_"$K"_deldist_"$deldiststring"bendist_"$bendiststring"mub_"$mub"_chromnum_"$numberofchromosomes"_N0_"$initialPopsize"_mud_"$mud"_L_"$chromosomesize"_seed_"$seed"/"
# diploid
elif [ $modularepis -eq 2 ]
then
	directory="datafor_"$fitnessstring"diploid_tskit_"$tskitstring"elementsperlb_"$elementsperl"_r_"$r"_iinit_"$i_init"_s_"$s"_K_"$K"_deldist_"$deldiststring"bendist_"$bendiststring"mub_"$mub"_chromnum_"$numberofchromosomes"_N0_"$initialPopsize"_mud_"$mud"_L_"$chromosomesize"_seed_"$seed"/"
fi

file1='popsnapshotfor_Sb_'$SdtoSbratio'mub_'$mub".txt"

#checks if a previous snapshot of the simulation exist. Snapshots are saved as compressed files (.gz) to save space
prevsim=$([ -f $directory$file1".gz" ] && echo 1 || echo 0)

if [ $prevsim -eq 0 ]
then
	snapshot=0
elif [ $prevsim -eq 1 ]
then
	gzip -d $directory$file1".gz"
	snapshot=1
fi


time ./mutationload $timeSteps $initialPopsize $mud $chromosomesize $numberofchromosomes $bentodelrateratio $sb $bendist $typeofrun $slope $seed $K $fitnesstype $r $i_init $s $tskit $modularepis $elementsperl $snapshot $file1 $SdtoSbratio $deldist $rawfilesize

# $snapshot $directory$file1
echo $directory$file1

gzip $directory$file1
