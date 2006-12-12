#!/usr/bin/perl

# Copyright (c) 2002 Kevin L. Pauba


# License:
#
# SDCC is licensed under the GNU Public license (GPL) v2.  Note that
# this license covers the code to the compiler and other executables,
# but explicitly does not cover any code or objects generated by sdcc.
# We have not yet decided on a license for the run time libraries, but
# it will not put any requirements on code linked against it. See:
# 
# http://www.gnu.org/copyleft/gpl.html
#
# See http://sdcc.sourceforge.net/ for the latest information on sdcc.


$rcsid = q~$Id$~;
($junk, $file, $version, $date, $time, $programmer, $status)
    = split(/\s+/, $rcsid);
($programName) = ($file =~ /(\S+),v/);

if ($#ARGV < 0 || $#ARGV > 1 ) {
    Usage();
}
$processor = uc(shift);
$path = shift;

if ($^O eq 'MSWin32') {
    if ($path eq '') {
	if (defined($path = $ENV{'GPUTILS_HEADER_PATH'}) || defined($path = $ENV{'GPUTILS_LKR_PATH'})) {
	    $path .= '\\..';
	}
	else {
	    die "Could not find gpasm includes.\n";
	}
    }
    $path_delim = '\\';
}
else {
    # Nathan Hurst <njh@mail.csse.monash.edu.au>: find gputils on Debian
    if ($path eq '') {
	if ( -x "/usr/share/gputils") {
	    $path = "/usr/share/gputils";
	} elsif ( -x "/usr/share/gpasm") {
	    $path = "/usr/share/gpasm";
	} else {
	    die "Could not find gpasm includes.\n";
	}
    }
    $path_delim = '/';
}

#
# Read the symbols at the end of this file.
#
while (<DATA>) {
    next if /^\s*#/;

    if (/^\s*alias\s+(\S+)\s+(\S+)/) {
	#
	# Set an alias for a special function register.
	# Some MPASM include files are not entirely consistent
	# with sfr names.
	#
	$alias{$2} = $1;
    } elsif (/^\s*address\s+(\S+)\s+(\S+)/) {
	#
	# Set a default address for a special function register.
	# Some MPASM include files don't specify the address
	# of all registers.
	# 
	# $addr{"$1"} = $2;
	foreach $device (split(/[,\s]+/, $devices)) {
	    $addr{"p$device", "$1"} = $2;
	}
    } elsif (/^\s*bitmask\s+(\S+)\s+/) {
	#
	# Set the bitmask that will be used in the 'memmap' pragma.
	#
	$bitmask = "$1";
	foreach $register (split(/\s+/, $')) {
	    $bitmask{"$register"} = $bitmask;
	}
    } elsif (/^\s*ram\s+(\S+)\s+(\S+)\s+(\S+)/) {
	# This info is now provided in "include/pic/pic14devices.txt".
	#$lo = $1;
	#$hi = $2;
	#$bitmask = $3;
	#foreach $device (split(/[,\s]+/, $devices)) {
	#    $ram{"p$device"} .= "#pragma memmap $lo $hi RAM $bitmask$'";
	#}
    } elsif (/^\s*processor\s+/) {
	$devices = $';
	$type = '';
    } elsif (/^\s*(\S+)/) {
	$type = $1;
	$_ = $';
	foreach $key (split) {
	    eval "\$type{'$key'} = $type;";
	}
    } else {
	foreach $key (split) {
	    eval "\$type{'$key'} = $type;";
	}
    }
}

#
# Read the linker file.
#
#  $linkFile = "$path/lkr/" . lc $processor . ".lkr";
#  open(LINK, "<$linkFile")
#      || die "$programName: Error: Cannot open linker file $linkFile ($!)\n";
#  while (<LINK>) {
#      if (/^(\S+)\s+NAME=(\S+)\s+START=(\S+)\s+END=(\S+)\s+(PROTECTED)?/) {
#  	$type = $1;
#  	$name = $2;
#  	$start = $3;
#  	$end = $4;
#  	$protected = 1 if ($5 =~ /protected/i);

#  	if ($type =~ /(SHAREBANK)|(DATABANK)/i) {
#  	    $ram{"p$processor"} .=
#  		sprintf("#pragma memmap %7s %7s RAM 0x000\t// $name\n",
#  			$start, $end);
#  	}
#      } elsif (/^SECTION\s+NAME=(\S+)\s+ROM=(\S+)\s+/) {
#      }
#  }

# Create header for pic${processor}.c file
$lcproc = "pic" . lc($processor);
$c_head = <<EOT;
/* Register definitions for $lcproc.
 * This file was automatically generated by:
 *   $programName V$version
 *   Copyright (c) 2002, Kevin L. Pauba, All Rights Reserved
 */
#include <${lcproc}.h>

EOT

#
# Convert the file.
#
$defaultType = 'other';
$includeFile = $path.$path_delim.'header'.$path_delim.'p'.lc($processor).'.inc';
$defsFile = "pic" . lc($processor) . ".c";
open(HEADER, "<$includeFile")
    || die "$programName: Error: Cannot open include file $includeFile ($!)\n";

while (<HEADER>) {
    if (/^;-+ (\S+) Bits/i) {
        # also accept "UIE/UIR Bits"
	foreach $name (split(/\//, $1)) {
	    if (defined($alias{$name})) {
		$defaultType = "bits $alias{$name}";
	    } else {
		$defaultType = "bits $name";
	    }
	}
	s/;/\/\//;
	$body .= "$_";
    } elsif (/^;-+ Register Files/i) {
	$defaultType = 'sfr';
	s/;/\/\//;
	$body .= "$_";
    } elsif (/^;=+/i) {
	$defaultType = '';
	s/;/\/\//;
	$body .= "$_";
    } elsif (/^\s*;/) {
	#
	# Convert ASM comments to C style.
	#
	$body .= "//$'";
    } elsif (/^\s*IFNDEF __(\S+)/) {
	#
	# Processor type.
	#
	$processor = $1;
	$body .= "//$_";
    } elsif (/^\s*(\S+)\s+EQU\s+H'(.+)'/) {
	#
	# Useful bit of information.
	#
	$name = $1;
	$value = $2;
	$rest = $';
	$rest =~ s/;/\/\//;
	chomp($rest);

	if (defined($type{"p$processor", "$name"})) {
	    $type = $type{"p$processor", "$name"};
	} elsif (defined($type{"$name"})) {
	    $type = $type{"$name"};
	} else {
	    $type = $defaultType;
	}

	if (defined($bitmask{"p$processor", "$name"})) {
	    $bitmask = $bitmask{"p$processor", "$name"};
#	} elsif (defined($bitmask{"$name"})) {
#	    $bitmask = $bitmask{"$name"};
	} else {
	    $bitmask = "0x000";
	}

	if ($type eq 'sfr') {
	    #
	    # A special function register.
	    #
	    $pragmas .= sprintf("#pragma memmap %s_ADDR %s_ADDR "
				. "SFR %s\t// %s\n",
				$name, $name, $bitmask, $name);
	    if (defined $addr{"p$processor", "$name"}) {
		$addresses .= sprintf("#define %s_ADDR\t0x%s\n", $name, $addr{"p$processor", "$name"});
	    } else {
		$addresses .= sprintf("#define %s_ADDR\t0x%s\n", $name, $value);
	    }
	    $body .= sprintf("extern __sfr  __at %-30s $name;$rest\n", "(${name}_ADDR)" );
	    $c_head .= sprintf("__sfr  __at %-30s $name;\n", "(${name}_ADDR)");
	    $addr{"p$processor", "$name"} = "0x$value";
	} elsif ($type eq 'volatile') {
	    #
	    # A location that can change without 
	    # direct program manipulation.
	    #
	    $pragmas .= sprintf("#pragma memmap %s_ADDR %s_ADDR "
				. "SFR %s\t// %s\n",
				$name, $name, $bitmask, $name);
	    $body .= sprintf("extern __data __at %-30s $name;$rest\n", "(${name}_ADDR) volatile char");
	    $c_head .= sprintf("__data __at %-30s $name;\n", "(${name}_ADDR) volatile char");
	    if (defined $addr{"p$processor", "$name"}) {
		$addresses .= sprintf("#define %s_ADDR\t0x%s\n", $name, $addr{"p$processor", "$name"});
	    } else {
		$addresses .= sprintf("#define %s_ADDR\t0x%s\n", $name, $value);
	    }
	} elsif ($type =~ /^bits/) {
	    ($junk, $register) = split(/\s/, $type);
	    $bit = hex($value);
	    $addr = $addr{"$register"};
	    # prepare struct declaration
	    for ($k=0; $k < scalar @{$bits{"$register"}->{oct($bit)}}; $k++) {
	      $name = "" if ($bits{"$register"}->{oct($bit)} eq $name)
	    }
	    if ($name ne "") {
	      push @{$bits{"$register"}->{oct($bit)}}, $name;
	    }
	} else {
	    #
	    # Other registers, bits and/or configurations.
	    #
	    if ($type eq 'other') {
		#
		# A known symbol.
		#
		$body .= sprintf("#define %-20s 0x%s$rest\n", $name, $value);
	    } else {
		#
		# A symbol that isn't defined in the data
		# section at the end of the file.  Let's 
		# add a comment so that we can add it later.
		#
		$body .= sprintf("#define %-20s 0x%s$rest\n",
				 $name, $value);
	    }
	}
    } elsif (/^\s*$/) {
	#
	# Blank line.
	#
	$body .= "\n";
    } elsif (/__MAXRAM\s+H'([0-9a-fA-F]+)'/) {
	$maxram .= "//\n// Memory organization.\n//\n";
	$pragmas = $maxram
	    . $ram{"p$processor"} . "\n"
		. $pragmas;
	$body .= "// $_";
    } else {
	#
	# Anything else we'll just comment out.
	#
	$body .= "// $_";
    }
}
$header .= <<EOT;
//
// Register Declarations for Microchip $processor Processor
//
//
// This header file was automatically generated by:
//
//\t$programName V$version
//
//\tCopyright (c) 2002, Kevin L. Pauba, All Rights Reserved
//
//\tSDCC is licensed under the GNU Public license (GPL) v2.  Note that
//\tthis license covers the code to the compiler and other executables,
//\tbut explicitly does not cover any code or objects generated by sdcc.
//\tWe have not yet decided on a license for the run time libraries, but
//\tit will not put any requirements on code linked against it. See:
// 
//\thttp://www.gnu.org/copyleft/gpl/html
//
//\tSee http://sdcc.sourceforge.net/ for the latest information on sdcc.
//
// 
#ifndef P${processor}_H
#define P${processor}_H

//
// Register addresses.
//
EOT

$c_head .= <<EOT;

// 
// bitfield definitions
// 
EOT

$structs = "";
## create struct declarations
foreach $reg (sort keys %bits)
{
  $structs .= "// ----- $reg bits --------------------\n";
  $structs .= "typedef union {\n";
  $idx = 0; $max = 1;
  do {
    $structs .= "  struct {\n";
    for ($i=0; $i < 8; $i++)
    {
      @names = @{$bits{$reg}->{oct($i)}};
      if ($max < scalar @names) { $max = scalar @names; }
      if ($idx >= scalar @names) {
	$structs .= "    unsigned char :1;\n";
      } else { # (1 == scalar @names) {
	$structs .= "    unsigned char " . $names[$idx] . ":1;\n";
#      } else {
#	$structs .= "  union {\n";
#	foreach $name (@names) {
#	  $structs .= "    unsigned char " . $name . ":1;\n";
#	} # foreach
#	$structs .= "  };\n";
      }
    } # for
    $structs .= "  };\n";
    $idx++;
  } while ($idx < $max);
  $structs .= "} __${reg}_bits_t;\n";
  $structs .= "extern volatile __${reg}_bits_t __at(${reg}_ADDR) ${reg}_bits;\n\n";
  $c_head .= "volatile __${reg}_bits_t __at(${reg}_ADDR) ${reg}_bits;\n";
  
  # emit defines for individual bits
  for ($i=0; $i < 8; $i++)
  {
    @names = @{$bits{$reg}->{oct($i)}};
    foreach $field (@names) {
      $structs .= sprintf("#define %-20s ${reg}_bits.$field\n", $field);
    } # foreach
  }
  $structs .= "\n";
} # foreach

print $header
    . $addresses . "\n"
    . $pragmas . "\n\n"
    . $body . "\n"
    . $structs
    . "#endif\n";

open(DEFS, ">$defsFile") or die "Could not open $defsFile for writing.";
print DEFS $c_head . "\n";
close DEFS;

sub Usage {
	print STDERR <<EOT;

inc2h.pl - A utility to convert MPASM include files to header files
           suitable for the SDCC compiler.

License: Copyright (c) 2002 Kevin L. Pauba

	 SDCC is licensed under the GNU Public license (GPL) v2; see
	 http://www.gnu.org/copyleft/gpl.html See http://sdcc.sourceforge.net/
	 for the latest information on sdcc.

Usage:   $programName processor [path]

	 where:

         processor	The name of the processor (16f84, 16f877, etc.)

         path           The path to the parent of the "header" and "lkr"
                        directories.  The default is "/usr/share/gpasm".

	 The header file will be written to the standard output.

	 $#ARGV
EOT
	exit;
}

__END__

#
# processor <processor_name>
# address <register_name> <hex_address>
# bitmask <bitmask> <register_list>
# ram <lo_address> <hi_address> <bitmask>
# sfr <register_list>
# volatile <address_list>
# bit <address_list>
#

alias OPTION_REG OPTION
volatile INDF PCL
