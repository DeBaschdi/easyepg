#!/usr/bin/perl

#      Copyright (C) 2019 Jan-Luca Neumann
#      https://github.com/sunsettrack4/easyepg/hzn
#
#      Collaborators:
#      - DeBaschdi ( https://github.com/DeBaschdi )
#
#  This Program is free software; you can redistribute it and/or modify
#  it under the terms of the GNU General Public License as published by
#  the Free Software Foundation; either version 3, or (at your option)
#  any later version.
#
#  This Program is distributed in the hope that it will be useful,
#  but WITHOUT ANY WARRANTY; without even the implied warranty of
#  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
#  GNU General Public License for more details.
#
#  You should have received a copy of the GNU General Public License
#  along with easyepg. If not, see <http://www.gnu.org/licenses/>.

# #################################
# MAGENTA TV CHANNEL LIST CREATOR #
# #################################

# CREATE JSON FILE FOR COMPARISM

use strict;
use warnings;
 
binmode STDOUT, ":utf8";
use utf8;
 
use JSON;

# READ JSON INPUT FILE: NEW CHLIST
my $chlist_new;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "/tmp/chlist" or die;
    $chlist_new = <$fh>;
    close $fh;
}

# READ JSON INPUT FILE: OLD CHLIST
my $chlist_old;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "chlist_old" or die;
    $chlist_old = <$fh>;
    close $fh;
}

# READ JSON INPUT FILE: CHANNEL CONFIG
my $chlist_config;
{
    local $/; #Enable 'slurp' mode
    open my $fh, "<", "channels.json" or die;
    $chlist_config = <$fh>;
    close $fh;
}

# CONVERT JSON TO PERL STRUCTURES
my $newdata      = decode_json($chlist_new);
my $olddata      = decode_json($chlist_old);
my $configdata   = decode_json($chlist_config);


# ##################
# NEW CHANNEL LIST #
# ##################

# TOOL: NAME ==> ID

print "{ \"newname2id\": {\n";

my @newchannels_name2id = @{ $newdata->{'channellist'} };
foreach my $newchannels ( @newchannels_name2id ) {
		
	#
	# DEFINE JSON VALUES
	#
        
	# DEFINE NEW CHANNEL NAME
	my $newcname   = $newchannels->{'name'};
	$newcname =~ s/\&/\&amp;/g; # REQUIRED TO READ XML FILE CORRECTLY
		
	# DEFINE NEW CHANNEL ID
	my $newcid     = $newchannels->{'contentId'};
		
	# PRINT NEW CHANNEL NAMES
	print "\"$newcname\": \"$newcid\",\n";
}

# TOOL: ID ==> NAME

print "\"DUMMY\": \"DUMMY\" },\n\"newid2name\": {\n";

my @newchannels_id2name = @{ $newdata->{'channellist'} };
foreach my $newchannels ( @newchannels_id2name ) {
		
	#
	# DEFINE JSON VALUES
	#
        
	# DEFINE NEW CHANNEL NAME
	my $newcname   = $newchannels->{'name'};
	$newcname =~ s/\&/\&amp;/g; # REQUIRED TO READ XML FILE CORRECTLY
	
	# DEFINE NEW CHANNEL ID
	my $newcid     = $newchannels->{'contentId'};
	
	# PRINT NEW CHANNEL NAMES newcid
	print "\"$newcid\": \"$newcname\",\n";
}

				
# ##################
# OLD CHANNEL LIST #
# ##################

# TOOL: NAME ==> ID

print "\"DUMMY\": \"DUMMY\" },\n\"oldname2id\": {\n";
						
my @oldchannels_name2id = @{ $olddata->{'channellist'} };
foreach my $oldchannels ( @oldchannels_name2id ) {
						
	#
	# DEFINE JSON VALUES
	#
								
	# DEFINE OLD CHANNEL NAME
	my $oldcname   = $oldchannels->{'name'};
	$oldcname =~ s/\&/\&amp;/g; # REQUIRED TO READ XML FILE CORRECTLY
		
	# DEFINE OLD CHANNEL ID
	my $oldcid     = $oldchannels->{'contentId'};
							
	# PRINT OLD CHANNEL NAMES
	print "\"$oldcname\": \"$oldcid\",\n";
}

# TOOL: ID ==> NAME

print "\"DUMMY\": \"DUMMY\" },\n\"oldid2name\": {\n";
						
my @oldchannels_id2name = @{ $olddata->{'channellist'} };
foreach my $oldchannels ( @oldchannels_id2name ) {

	#
	# DEFINE JSON VALUES
	#
								
	# DEFINE OLD CHANNEL NAME
	my $oldcname   = $oldchannels->{'name'};
	$oldcname =~ s/\&/\&amp;/g; # REQUIRED TO READ XML FILE CORRECTLY
	
	# DEFINE OLD CHANNEL ID
	my $oldcid     = $oldchannels->{'contentId'};
						
	# PRINT OLD CHANNEL NAMES
	print "\"$oldcid\": \"$oldcname\",\n";
}

							
# #######################
# CHANNEL CONFIGURATION #
# #######################

print "\"DUMMY\": \"DUMMY\" },\n\"config\": [\n";	
												
my @configdata = @{ $configdata->{'channels'} };
		
foreach my $configname ( @configdata ) {
	print "\"$configname\",\n";
}

print "\"DUMMY\"]\n}";
