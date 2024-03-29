# Before `make install' is performed this script should be runnable with
# `make test'. After `make install' it should work as `perl test.pl'

######################### We start with some black magic to print on failure.

# Change 1..1 below to 1..last_test_to_print .
# (It may become useful if the test is moved to ./t subdirectory.)

BEGIN { $| = 1; print "1..5\n"; }
END {print "not ok 1\n" unless $loaded;}
use GlobWalker qw(get_subs get_arrays get_filehandles);
$loaded = 1;
print "ok 1\n";

######################### End of black magic.

# Insert your test code below (better if it prints "ok 13"
# (correspondingly "not ok 13") depending on the success of chunk 13
# of the test code):

local $" = '|';

sub sub1 {
  return
}

sub sub2 {
  return
}

print "@{[sort {$a cmp $b} get_subs]}" eq 'get_arrays|get_filehandles|get_subs|sub1|sub2' ? '' : 'not ', "ok 2\n";

print "@{[sort {$a cmp $b} get_subs('Another')]}" eq 'asub1|asub2' ? '' : 'not', "ok 3\n";

print "@{[sort {$a cmp $b} get_arrays]}" eq 'ARGV|INC|_' ? '' : 'not ', "ok 4\n";

print "@{[sort {$a cmp $b} get_filehandles]}" eq 'ARGV|STDERR|STDIN|STDOUT|stderr|stdin|stdout' ? '' : 'not ', "ok 5\n";

package Another;

sub asub1 {
  return
}

sub asub2 {
  return
}
