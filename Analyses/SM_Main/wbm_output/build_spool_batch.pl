#!/usr/bin/perl

#######################################################################
#
#	WBM spool files processing:
#
#	Written by Dr. A. Prusevich (alex.proussevitch@unh.edu)
#
#	July 2021	Adopted from a stand alone script
#
#######################################################################

use strict;
use File::Basename;
use Getopt::Long;

#######################################################################
#############   Process and check command line inputs   ###############

my ($help,$quiet,$nc,$forks) = (0,0,0,12);
			# Get command line options
usage() if !GetOptions( 'h'=>\$help, 'q'=>\$quiet, 'nc'=>\$nc, 'f=i'=>\$forks ) or $help;

#######################################################################
#############   Build Spool   #########################################

my @list = (
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc gridMET_ppt_4kmD2_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc gridMET_tmean_4kmD2_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc merra2_cldtot_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc gridMET_u10m_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc gridMET_v10m_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 2007-01-01 -ed 2022-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc gridMET_rh2m_d",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 0000-01-01 -ed 0000-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc merra_albedo_dc",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 0000-01-01 -ed 0000-12-31    -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc merra2_lai2_dc",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 0000-01-01 -ed 0000-12-31 -spDelta -r 0  -pp 0 -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc MC_crop1",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 0000-01-01 -ed 0000-12-31 -spDelta -r 0  -pp 0 -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc MC_maize_1_rfd_Kc",
   "/wbm/utilities//build_spool.pl -v -f _FORKS_ -sd 0000-01-01 -ed 0000-12-31 -spDelta -r 0  -pp 0 -spDir /wbm/spool/ -mt /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/wbm_output/US_CDL.MT.csv /gpfs/group/kaf26/default/users/aqa6478/WBM/SM_Main/data/network/Network6.asc MC_fallow_fr"
);
map(s/_FORKS_/$forks/,	@list);		# Set forks
map(s/ -v / -v  -nc /,	@list) if $nc;	# Add nc output,  if needed
map(s/ -v //,		@list) if $quiet;	# Remove verbose, if needed
map(s/\s+/ /g,		@list);		# Remove extra spaces

print "\n" unless $quiet;

foreach my $cmd (@list) {
  system "$cmd";
}
print "\nAll Done!\n\n" unless $quiet;

exit;

#######################################################################
######################  Functions  ####################################

sub usage
{
  my $app_name = basename($0);
  print <<EOF;

Usage:
	$app_name [-h] [-q] [-nc] [-f FORKS]

This code pre-builds spool files for a WBM run.

Options:

h	Display this help.
q	Quiet mode.
f	Number of forks to use. Default is $forks.
nc	Build additional NetCDF copy of spool binary data.

Example:
$app_name -q -f 24

EOF
  exit;
}

