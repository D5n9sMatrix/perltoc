=head1 NAME
 
perlrun - how to execute the Perl interpreter
 
=head1 SYNOPSIS
 
B<perl> [switches] filename args
 
=head1 DESCRIPTION
 
Upon startup, Perl looks for your script in one of the following
places:
 
=over 4
 
=item 1.
 
Specified line by line via B<-e> switches on the command line.
 
=item 2.
 
Contained in the file specified by the first filename on the command line.
(Note that systems supporting the #! notation invoke interpreters this way.)
 
=item 3.
 
Passed in implicitly via standard input.  This only works if there are
no filename arguments--to pass arguments to a STDIN script you
must explicitly specify a "-" for the script name.
 
=back
 
With methods 2 and 3, Perl starts parsing the input file from the
beginning, unless you've specified a B<-x> switch, in which case it
scans for the first line starting with #! and containing the word
"perl", and starts there instead.  This is useful for running a script
embedded in a larger message.  (In this case you would indicate the end
of the script using the __END__ token.)
 
As of Perl 5, the #! line is always examined for switches as the line is
being parsed.  Thus, if you're on a machine that only allows one argument
with the #! line, or worse, doesn't even recognize the #! line, you still
can get consistent switch behavior regardless of how Perl was invoked,
even if B<-x> was used to find the beginning of the script.
 
Because many operating systems silently chop off kernel interpretation of
the #! line after 32 characters, some switches may be passed in on the
command line, and some may not; you could even get a "-" without its
letter, if you're not careful.  You probably want to make sure that all
your switches fall either before or after that 32 character boundary.
Most switches don't actually care if they're processed redundantly, but
getting a - instead of a complete switch could cause Perl to try to
execute standard input instead of your script.  And a partial B<-I> switch
could also cause odd results.
 
Parsing of the #! switches starts wherever "perl" is mentioned in the line.
The sequences "-*" and "- " are specifically ignored so that you could,
if you were so inclined, say
 
    #!/bin/sh -- # -*- perl -*- -p
    eval 'exec perl $0 -S ${1+"$@"}'
        if 0;
 
to let Perl see the B<-p> switch.
 
If the #! line does not contain the word "perl", the program named after
the #! is executed instead of the Perl interpreter.  This is slightly
bizarre, but it helps people on machines that don't do #!, because they
can tell a program that their SHELL is /usr/bin/perl, and Perl will then
dispatch the program to the correct interpreter for them.
 
After locating your script, Perl compiles the entire script to an
internal form.  If there are any compilation errors, execution of the
script is not attempted.  (This is unlike the typical shell script,
which might run partway through before finding a syntax error.)
 
If the script is syntactically correct, it is executed.  If the script
runs off the end without hitting an exit() or die() operator, an implicit
C<exit(0)> is provided to indicate successful completion.
 
=head2 Switches
 
A single-character switch may be combined with the following switch, if
any.
 
    #!/usr/bin/perl -spi.bak    # same as -s -p -i.bak
 
Switches include:
 
=over 5
 
=item B<-0>I<digits>
 
specifies the record separator (C<$/>) as an octal number.  If there are
no digits, the null character is the separator.  Other switches may
precede or follow the digits.  For example, if you have a version of
B<find> which can print filenames terminated by the null character, you
can say this:
 
    find . -name '*.bak' -print0 | perl -n0e unlink
 
The special value 00 will cause Perl to slurp files in paragraph mode.
The value 0777 will cause Perl to slurp files whole since there is no
legal character with that value.
 
=item B<-a>
 
turns on autosplit mode when used with a B<-n> or B<-p>.  An implicit
split command to the @F array is done as the first thing inside the
implicit while loop produced by the B<-n> or B<-p>.
 
    perl -ane 'print pop(@F), "\n";'
 
is equivalent to
 
    while (<>) {
        @F = split(' ');
        print pop(@F), "\n";
    }
 
An alternate delimiter may be specified using B<-F>.
 
=item B<-c>
 
causes Perl to check the syntax of the script and then exit without
executing it.  Actually, it will execute C<BEGIN> and C<use> blocks,
since these are considered part of the compilation.
 
=item B<-d>
 
runs the script under the Perl debugger.  See L<perldebug>.
 
=item B<-D>I<number>
 
=item B<-D>I<list>
 
sets debugging flags.  To watch how it executes your script, use
B<-D14>.  (This only works if debugging is compiled into your
Perl.)  Another nice value is B<-D1024>, which lists your compiled
syntax tree.  And B<-D512> displays compiled regular expressions. As an
alternative specify a list of letters instead of numbers (e.g. B<-D14> is
equivalent to B<-Dtls>):
 
        1  p  Tokenizing and Parsing
        2  s  Stack Snapshots
        4  l  Label Stack Processing
        8  t  Trace Execution
       16  o  Operator Node Construction
       32  c  String/Numeric Conversions
       64  P  Print Preprocessor Command for -P
      128  m  Memory Allocation
      256  f  Format Processing
      512  r  Regular Expression Parsing
     1024  x  Syntax Tree Dump
     2048  u  Tainting Checks
     4096  L  Memory Leaks (not supported anymore)
     8192  H  Hash Dump -- usurps values()
    16384  X  Scratchpad Allocation
    32768  D  Cleaning Up
 
=item B<-e> I<commandline>
 
may be used to enter one line of script.  
If B<-e> is given, Perl
will not look for a script filename in the argument list.  
Multiple B<-e> commands may
be given to build up a multi-line script.  
Make sure to use semicolons where you would in a normal program.
 
=item B<-F>I<regexp>
 
specifies a regular expression to split on if B<-a> is also in effect.
If regexp has C<//> around it, the slashes will be ignored.
 
=item B<-i>I<extension>
 
specifies that files processed by the C<E<lt>E<gt>> construct are to be edited
in-place.  It does this by renaming the input file, opening the output
file by the original name, and selecting that output file as the default
for print() statements.  The extension, if supplied, is added to the name
of the old file to make a backup copy.  If no extension is supplied, no
backup is made.  From the shell, saying
 
    $ perl -p -i.bak -e "s/foo/bar/; ... "
 
is the same as using the script:
 
    #!/usr/bin/perl -pi.bak
    s/foo/bar/;
 
which is equivalent to
 
    #!/usr/bin/perl
    while (<>) {
        if ($ARGV ne $oldargv) {
            rename($ARGV, $ARGV . '.bak');
            open(ARGVOUT, ">$ARGV");
            select(ARGVOUT);
            $oldargv = $ARGV;
        }
        s/foo/bar/;
    }
    continue {
        print;  # this prints to original filename
    }
    select(STDOUT);
 
except that the B<-i> form doesn't need to compare $ARGV to $oldargv to
know when the filename has changed.  It does, however, use ARGVOUT for
the selected filehandle.  Note that STDOUT is restored as the
default output filehandle after the loop.
 
You can use C<eof> without parenthesis to locate the end of each input file, 
in case you want to append to each file, or reset line numbering (see 
example in L<perlfunc/eof>).
 
=item B<-I>I<directory>
 
may be used in conjunction with B<-P> to tell the C preprocessor where
to look for include files.  By default /usr/include and /usr/lib/perl
are searched.
 
=item B<-l>I<octnum>
 
enables automatic line-ending processing.  It has two effects:  first,
it automatically chomps the line terminator when used with B<-n> or
B<-p>, and second, it assigns "C<$\>" to have the value of I<octnum> so that
any print statements will have that line terminator added back on.  If
I<octnum> is omitted, sets "C<$\>" to the current value of "C<$/>".  For
instance, to trim lines to 80 columns:
 
    perl -lpe 'substr($_, 80) = ""'
 
Note that the assignment C<$\ = $/> is done when the switch is processed,
so the input record separator can be different than the output record
separator if the B<-l> switch is followed by a B<-0> switch:
 
    gnufind / -print0 | perl -ln0e 'print "found $_" if -p'
 
This sets $\ to newline and then sets $/ to the null character.
 
=item B<-n>
 
causes Perl to assume the following loop around your script, which
makes it iterate over filename arguments somewhat like B<sed -n> or
B<awk>:
 
    while (<>) {
        ...             # your script goes here
    }
 
Note that the lines are not printed by default.  See B<-p> to have
lines printed.  Here is an efficient way to delete all files older than
a week:
 
    find . -mtime +7 -print | perl -nle 'unlink;'
 
This is faster than using the C<-exec> switch of B<find> because you don't
have to start a process on every filename found.
 
C<BEGIN> and C<END> blocks may be used to capture control before or after
the implicit loop, just as in B<awk>.
 
=item B<-p>
 
causes Perl to assume the following loop around your script, which
makes it iterate over filename arguments somewhat like B<sed>:
 
 
    while (<>) {
        ...             # your script goes here
    } continue {
        print;
    }
 
Note that the lines are printed automatically.  To suppress printing
use the B<-n> switch.  A B<-p> overrides a B<-n> switch.
 
C<BEGIN> and C<END> blocks may be used to capture control before or after
the implicit loop, just as in awk.
 
=item B<-P>
 
causes your script to be run through the C preprocessor before
compilation by Perl.  (Since both comments and cpp directives begin
with the # character, you should avoid starting comments with any words
recognized by the C preprocessor such as "if", "else" or "define".)
 
=item B<-s>
 
enables some rudimentary switch parsing for switches on the command
line after the script name but before any filename arguments (or before
a B<-->).  Any switch found there is removed from @ARGV and sets the
corresponding variable in the Perl script.  The following script
prints "true" if and only if the script is invoked with a B<-xyz> switch.
 
    #!/usr/bin/perl -s
    if ($xyz) { print "true\n"; }
 
=item B<-S>
 
makes Perl use the PATH environment variable to search for the
script (unless the name of the script starts with a slash).  Typically
this is used to emulate #! startup on machines that don't support #!,
in the following manner:
 
    #!/usr/bin/perl
    eval "exec /usr/bin/perl -S $0 $*"
            if $running_under_some_shell;
 
The system ignores the first line and feeds the script to /bin/sh,
which proceeds to try to execute the Perl script as a shell script.
The shell executes the second line as a normal shell command, and thus
starts up the Perl interpreter.  On some systems $0 doesn't always
contain the full pathname, so the B<-S> tells Perl to search for the
script if necessary.  After Perl locates the script, it parses the
lines and ignores them because the variable $running_under_some_shell
is never true.  A better construct than C<$*> would be C<${1+"$@"}>, which
handles embedded spaces and such in the filenames, but doesn't work if
the script is being interpreted by csh.  In order to start up sh rather
than csh, some systems may have to replace the #! line with a line
containing just a colon, which will be politely ignored by Perl.  Other
systems can't control that, and need a totally devious construct that
will work under any of csh, sh or Perl, such as the following:
 
        eval '(exit $?0)' && eval 'exec /usr/bin/perl -S $0 ${1+"$@"}'
        & eval 'exec /usr/bin/perl -S $0 $argv:q'
                if 0;
 
=item B<-T>
 
forces "taint" checks to be turned on.  Ordinarily these checks are
done only when running setuid or setgid.  See L<perlsec>.
 
=item B<-u>
 
causes Perl to dump core after compiling your script.  You can then
take this core dump and turn it into an executable file by using the
B<undump> program (not supplied).  This speeds startup at the expense of
some disk space (which you can minimize by stripping the executable).
(Still, a "hello world" executable comes out to about 200K on my
machine.)  If you want to execute a portion of your script before dumping,
use the dump() operator instead.  Note: availability of B<undump> is
platform specific and may not be available for a specific port of
Perl.
 
=item B<-U>
 
allows Perl to do unsafe operations.  Currently the only "unsafe"
operations are the unlinking of directories while running as superuser,
and running setuid programs with fatal taint checks turned into
warnings.
 
=item B<-v>
 
prints the version and patchlevel of your Perl executable.
 
=item B<-w>
 
prints warnings about identifiers that are mentioned only once, and
scalar variables that are used before being set.  Also warns about
redefined subroutines, and references to undefined filehandles or
filehandles opened readonly that you are attempting to write on.  Also
warns you if you use values as a number that doesn't look like numbers, using
an array as though it were a scalar, if
your subroutines recurse more than 100 deep, and innumerable other things.
See L<perldiag> and L<perltrap>.
 
=item B<-x> I<directory>
 
tells Perl that the script is embedded in a message.  Leading
garbage will be discarded until the first line that starts with #! and
contains the string "perl".  Any meaningful switches on that line will
be applied (but only one group of switches, as with normal #!
processing).  If a directory name is specified, Perl will switch to
that directory before running the script.  The B<-x> switch only
controls the the disposal of leading garbage.  The script must be
terminated with C<__END__> if there is trailing garbage to be ignored (the
script can process any or all of the trailing garbage via the DATA
filehandle if desired).
 
 
=back