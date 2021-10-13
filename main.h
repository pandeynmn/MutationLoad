#ifndef MAIN_H_INCLUDED
#define MAIN_H_INCLUDED 1

#include <stdio.h>
#include <float.h>
#include <string.h>
#include <math.h>
#include <sys/stat.h>
#include <sys/types.h>
#include <unistd.h>
#include <gsl/gsl_sf_gamma.h>
#include <gsl/gsl_rng.h>
#include <gsl/gsl_randist.h>
#include <gsl/gsl_fit.h>
#include <err.h>
#include "dependencies/pcg_basic.h"
#include "sharedfunc_flag.h"
#include "relative_functions.h"
#include "global_vars.h"
#include "main.h"

//fitness
void UpdateLast200NTimeSteps(double *last200Ntimesteps, double newNtimesteps);
void DoubleSwap(long double *x, long double *y);
void DoubleBubbleSort(long double *arraytobesorted, int arraysize);
double CalculateVarianceInLogFitness(int popsize, long double *wholepopulationwisarray, long double sumofwis);
long double FindFittestWi(long double *wisarray, int popsize);
double CalculateSlopeOfLogFitness(int endofsimulation, int endofburninphase, double *logaveragefitnesseachgeneration);

//Fenwick trees
long double Fen_sum(long double *tree, int i);
void Fen_add(long double *tree, int numberofelementsintree, long double amounttoadd, int i);
long double Fen_range(long double *tree, int i, int j);
long double Fen_get(long double *tree, int i);
void Fen_set(long double *tree, int numberofelementsintree, long double newvalue, int i);
int SearchTree(int leftbound, int rightbound, long double targetvalue, long double *Fenwicktree);

//Distribution
int SampleFromPoisson(float poissonmean);

//Gametes. UH might want to remove all the currenttimestep in these functions. It's not used
void ProduceMutatedRecombinedGamete(int totaltimesteps, int currenttimestep, double *wholepopulationgenomes, int chromosomesize, int numberofchromosomes, int totalindividualgenomelength, int currentparent, double deleteriousmutationrate, double beneficialmutationrate, double Sb, char * beneficialdistribution, double *parentgamete, gsl_rng * randomnumbergeneratorforgamma);
//UH change to two recombination sites. //UH change determineNumberOfMutations outside the loop
void RecombineChromosomesIntoGamete(int totaltimesteps, int currenttimestep, int persontorecombine, int chromosomesize, int numberofchromosomes, double *gamete, double *populationgenomes, int totalindividualgenomelength, int * recombinationsites);
int DetermineNumberOfMutations(int chromosomesize, int numberofchromosomes, float mutationrate);
void MutateGamete(int chromosomesize, int numberofchromosomes, double *gamete, double mutationeffectsize);

//root simulations. UH might move them to shared with flags and remove files pointers (they are declared globally)
int BracketZeroForSb(double *Sb1, double *Sb2, char * Nxtimestepsname, char * popsizename, char * delmutratename, char * chromsizename, char * chromnumname, char * mubname, char * typeofrun, int Nxtimesteps, int popsize, int chromosomesize, int numberofchromosomes, double deleteriousmutationrate, double beneficialmutationrate, double slopeforcontourline, char * beneficialdistribution, gsl_rng * randomnumbergeneratorforgamma, FILE * veryverbosefilepointer, FILE * verbosefilepointer, FILE * miscfilepointer);
double BisectionMethodToFindSbWithZeroSlope(double * Sb1, double * Sb2, char * Nxtimestepsname, char * popsizename, char * delmutratename, char * chromsizename, char * chromnumname, char * mubname, char * typeofrun, int Nxtimesteps, int popsize, int chromosomesize, int numberofchromosomes, double deleteriousmutationrate, double beneficialmutationrate, double slopeforcontourline, char * beneficialdistribution, gsl_rng * randomnumbergeneratorforgamma, FILE * veryverbosefilepointer, FILE * verbosefilepointer, FILE * miscfilepointer);


#endif // MAIN_H_INCLUDED
