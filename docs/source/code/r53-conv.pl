#!/usr/bin/perl -w
#
#
# r53-conv.pl ZONE [PROFILE]
#
# Grab a zone from Route53 accessed with the either the named profile or the AWS_PROFILE value and convert to a format suitable for upload to another account
#
# ZONE:  A public zone in the account pointed to by the credentials. This is the name of the zone, not the zone id.
#        If there are identical zones with the same name the script will abort.
# PROFILE: a named AWS CLI profile that contains credentials and a region for access to Route 53.
#        If not supplied the environment variable AWS_PROFILE will be used.
#
# The CLI command to upload to a new account is:
#  aws route53 change-resource-record-sets --hosted-zone-id ZONEID --change-batch file://OUTPUT-FROM-r53.conv
#  Where ZONEID is the DNS zone id for the destination zone in the account currenlty active from either the
#  default .aws/credentials file or the AWS_PROFILE environment variable.
#  OUTPUT-FROM-R53.conv is the output file presumably saved from this command which writes to stdout

# Tom Arons January 2022
#
use strict;
use warnings;
use JSON;
use POSIX qw(strftime);
use File::Map qw(map_file);
use File::Basename;
my $json;

die "usage $0 ZONE [PROFILE]" if $#ARGV ==  -1;
my $ZONE=$ARGV[0];
my $PROFILE='';
$PROFILE="--profile $ARGV[1]" if $#ARGV == 1;
# hang a trailing '.' on the ZONE
$ZONE="$ZONE.";


# grab the zones from PROFILE and look for a public zone name ZONE
$json=`aws $PROFILE route53 list-hosted-zones`;
die "aws $PROFILE route53 list-hosted-zones failed" if $? != 0;
my $decoded=decode_json($json);
my @H=@{ $decoded->{'HostedZones'}};
my $ZONEID="";
foreach my $HZ (@H) {
	next if $HZ->{'Name'} ne $ZONE;
	my $PUB=$HZ->{'Config'}{'PrivateZone'};
	next if $PUB == 1;
	die "duplicate public zone found: $ZONE" if $ZONEID ne "";
	$ZONEID=$HZ->{'Id'};
}
die "No zone $ZONE found" if $ZONEID eq "";

#
# Get the records
$json=`aws  $PROFILE route53 list-resource-record-sets --hosted-zone-id $ZONEID`;
die "aws  $PROFILE route53 list-resource-record-sets --hosted-zone-id $ZONEID failed" if $? != 0;
$decoded=decode_json($json);

print "{\n";
print "\"Comment\": \"Converted Zone from $ZONE in $ZONEID\",\n";
print "\"Changes\": [\n";

my @R = @{ $decoded->{'ResourceRecordSets'}};
my $first=0;
foreach my $RR (@R) {
	next if $RR->{'Type'} ne 'A';
	my %JOUT;
	$JOUT{'Action'}="UPSERT";
	$JOUT{'ResourceRecordSet'}=$RR;
	my $s=encode_json(\%JOUT);
	if ($first==1) {
		print ",";
	} else {
		$first=1;
	}
	print "$s\n";
}

print "]}\n";
