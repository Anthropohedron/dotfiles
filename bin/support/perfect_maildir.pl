#!/usr/bin/perl

# "Simple but Perfect" mbox to Maildir converter v0.2
# Copyright (C) 2001-2003  Philip Mak <pmak@aaanime.net>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU General Public License
# as published by the Free Software Foundation; either version 2
# of the License, or (at your option) any later version.
# 
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
# 
# You should have received a copy of the GNU General Public License
# along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.

# Get the hostname

my $hostname = `hostname`;
chomp ($hostname);

# check for valid arguments

my ($maildir) = @ARGV;
if (!$maildir) {
  print STDERR "Usage: perfect_maildir ~/Maildir < mbox\n";
  exit 1;
}

# check for writable maildir
unless (-w "$maildir/cur") {
  print STDERR "Cannot write to $maildir/cur\n";
  exit 1;
}
unless (-w "$maildir/new") {
  print STDERR "Cannot write to $maildir/new\n";
  exit 1;
}

my $num = 0;
my $time = time;

repeat:

# read header
my $headers = '';
my $flags = '';
my $subject = '';
while (my $line = <STDIN>) {
  # detect end of headers
  last if $line eq "\n";

  # strip "From" line from header
  $headers .= $line unless $line =~ /^From ./;

  # detect flags
  $flags .= $1 if $line =~ /^Status: ([A-Z]+)/;
  $flags .= $1 if $line =~ /^X-Status: ([A-Z]+)/;
  $subject = $1 if $line =~ /^Subject: (.*)$/;
}

$num++;

# open output file
my $file;
if ($flags =~ /O/) {
  $file = "$maildir/cur/$time.$num.$hostname";
  my $extra = '';
  $extra .= 'F' if $flags =~ /F/; # flagged
  $extra .= 'R' if $flags =~ /A/; # replied
  $extra .= 'S' if (($flags =~ /R/) || ($flags =~ /O/)); # seen
  $extra .= 'T' if $flags =~ /D/; # trashed
  $file .= ":2,$extra" if $extra;
} else {
  $file = "$maildir/new/$time.$num.$hostname";
}

# filter out the "DON'T DELETE THIS MESSAGE -- FOLDER INTERNAL DATA" message or the message doesn't exists
if (($num == 1 and $subject eq "DON'T DELETE THIS MESSAGE -- FOLDER INTERNAL DATA") || (!$headers)) {
	$file = '/dev/null';
	$num--;
}

open(FILE, ">$file");
print FILE "$headers\n";
while (my $line = <STDIN>) {
  # detect end of message
  last if $line =~ /^From ./;

  # unescape "From"
  $line =~ s/^>From (.)/From $1/;

  print FILE $line;
}
close(FILE);
goto repeat unless eof(STDIN);

my $elapsed = time - $time;
print "Inserted $num messages into maildir $maildir in $elapsed seconds\n";
