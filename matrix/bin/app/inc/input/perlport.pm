=head1 NAME
 
perlport - Writing portable Perl
 
=head1 DESCRIPTION
 
Perl runs on numerous operating systems.  While most of them share
much in common, they also have their own unique features.
 
This document is meant to help you to find out what constitutes portable
Perl code.  That way once you make a decision to write portably,
you know where the lines are drawn, and you can stay within them.
 
There is a tradeoff between taking full advantage of one particular
type of computer and taking advantage of a full range of them.
Naturally, as you broaden your range and become more diverse, the
common factors drop, and you are left with an increasingly smaller
area of common ground in which you can operate to accomplish a
particular task.  Thus, when you begin attacking a problem, it is
important to consider under which part of the tradeoff curve you
want to operate.  Specifically, you must decide whether it is
important that the task that you are coding has the full generality
of being portable, or whether to just get the job done right now.
This is the hardest choice to be made.  The rest is easy, because
Perl provides many choices, whichever way you want to approach your
problem.
 
Looking at it another way, writing portable code is usually about
willfully limiting your available choices.  Naturally, it takes
discipline and sacrifice to do that.  The product of portability
and convenience may be a constant.  You have been warned.
 
Be aware of two important points:
 
=over 4
 
=item Not all Perl programs have to be portable
 
There is no reason you should not use Perl as a language to glue Unix
tools together, or to prototype a Macintosh application, or to manage the
Windows registry.  If it makes no sense to aim for portability for one
reason or another in a given program, then don't bother.
 
=item Nearly all of Perl already I<is> portable
 
Don't be fooled into thinking that it is hard to create portable Perl
code.  It isn't.  Perl tries its level-best to bridge the gaps between
what's available on different platforms, and all the means available to
use those features.  Thus almost all Perl code runs on any machine
without modification.  But there are some significant issues in
writing portable code, and this document is entirely about those issues.
 
=back
 
Here's the general rule: When you approach a task commonly done
using a whole range of platforms, think about writing portable
code.  That way, you don't sacrifice much by way of the implementation
choices you can avail yourself of, and at the same time you can give
your users lots of platform choices.  On the other hand, when you have to
take advantage of some unique feature of a particular platform, as is
often the case with systems programming (whether for Unix, Windows,
VMS, etc.), consider writing platform-specific code.
 
When the code will run on only two or three operating systems, you
may need to consider only the differences of those particular systems.
The important thing is to decide where the code will run and to be
deliberate in your decision.
 
The material below is separated into three main sections: main issues of
portability (L</"ISSUES">), platform-specific issues (L</"PLATFORMS">), and
built-in Perl functions that behave differently on various ports
(L</"FUNCTION IMPLEMENTATIONS">).
 
This information should not be considered complete; it includes possibly
transient information about idiosyncrasies of some of the ports, almost
all of which are in a state of constant evolution.  Thus, this material
should be considered a perpetual work in progress
(C<< <IMG SRC="yellow_sign.gif" ALT="Under Construction"> >>).
 
=head1 ISSUES
 
=head2 Newlines
 
In most operating systems, lines in files are terminated by newlines.
Just what is used as a newline may vary from OS to OS.  Unix
traditionally uses C<\012>, one type of DOSish I/O uses C<\015\012>,
S<Mac OS> uses C<\015>, and z/OS uses C<\025>.
 
Perl uses C<\n> to represent the "logical" newline, where what is
logical may depend on the platform in use.  In MacPerl, C<\n> always
means C<\015>.  On EBCDIC platforms, C<\n> could be C<\025> or C<\045>.
In DOSish perls, C<\n> usually means C<\012>, but when
accessing a file in "text" mode, perl uses the C<:crlf> layer that
translates it to (or from) C<\015\012>, depending on whether you're
reading or writing. Unix does the same thing on ttys in canonical
mode.  C<\015\012> is commonly referred to as CRLF.
 
To trim trailing newlines from text lines use
L<C<chomp>|perlfunc/chomp VARIABLE>.  With default settings that function
looks for a trailing C<\n> character and thus trims in a portable way.
 
When dealing with binary files (or text files in binary mode) be sure
to explicitly set L<C<$E<sol>>|perlvar/$E<sol>> to the appropriate value for
your file format before using L<C<chomp>|perlfunc/chomp VARIABLE>.
 
Because of the "text" mode translation, DOSish perls have limitations in
using L<C<seek>|perlfunc/seek FILEHANDLE,POSITION,WHENCE> and
L<C<tell>|perlfunc/tell FILEHANDLE> on a file accessed in "text" mode.
Stick to L<C<seek>|perlfunc/seek FILEHANDLE,POSITION,WHENCE>-ing to
locations you got from L<C<tell>|perlfunc/tell FILEHANDLE> (and no
others), and you are usually free to use
L<C<seek>|perlfunc/seek FILEHANDLE,POSITION,WHENCE> and
L<C<tell>|perlfunc/tell FILEHANDLE> even in "text" mode.  Using
L<C<seek>|perlfunc/seek FILEHANDLE,POSITION,WHENCE> or
L<C<tell>|perlfunc/tell FILEHANDLE> or other file operations may be
non-portable.  If you use L<C<binmode>|perlfunc/binmode FILEHANDLE> on a
file, however, you can usually
L<C<seek>|perlfunc/seek FILEHANDLE,POSITION,WHENCE> and
L<C<tell>|perlfunc/tell FILEHANDLE> with arbitrary values safely.
 
A common misconception in socket programming is that S<C<\n eq \012>>
everywhere.  When using protocols such as common Internet protocols,
C<\012> and C<\015> are called for specifically, and the values of
the logical C<\n> and C<\r> (carriage return) are not reliable.
 
    print $socket "Hi there, client!\r\n";      # WRONG
    print $socket "Hi there, client!\015\012";  # RIGHT
 
However, using C<\015\012> (or C<\cM\cJ>, or C<\x0D\x0A>) can be tedious
and unsightly, as well as confusing to those maintaining the code.  As
such, the L<C<Socket>|Socket> module supplies the Right Thing for those
who want it.
 
    use Socket qw(:DEFAULT :crlf);
    print $socket "Hi there, client!$CRLF"      # RIGHT
 
When reading from a socket, remember that the default input record
separator L<C<$E<sol>>|perlvar/$E<sol>> is C<\n>, but robust socket code
will recognize as either C<\012> or C<\015\012> as end of line:
 
    while (<$socket>) {  # NOT ADVISABLE!
        # ...
    }
 
Because both CRLF and LF end in LF, the input record separator can
be set to LF and any CR stripped later.  Better to write:
 
    use Socket qw(:DEFAULT :crlf);
    local($/) = LF;      # not needed if $/ is already \012
 
    while (<$socket>) {
        s/$CR?$LF/\n/;   # not sure if socket uses LF or CRLF, OK
    #   s/\015?\012/\n/; # same thing
    }
 
This example is preferred over the previous one--even for Unix
platforms--because now any C<\015>'s (C<\cM>'s) are stripped out
(and there was much rejoicing).
 
Similarly, functions that return text data--such as a function that
fetches a web page--should sometimes translate newlines before
returning the data, if they've not yet been translated to the local
newline representation.  A single line of code will often suffice:
 
    $data =~ s/\015?\012/\n/g;
    return $data;
 
Some of this may be confusing.  Here's a handy reference to the ASCII CR
and LF characters.  You can print it out and stick it in your wallet.
 
    LF  eq  \012  eq  \x0A  eq  \cJ  eq  chr(10)  eq  ASCII 10
    CR  eq  \015  eq  \x0D  eq  \cM  eq  chr(13)  eq  ASCII 13
 
             | Unix | DOS  | Mac  |
        ---------------------------
        \n   |  LF  |  LF  |  CR  |
        \r   |  CR  |  CR  |  LF  |
        \n * |  LF  | CRLF |  CR  |
        \r * |  CR  |  CR  |  LF  |
        ---------------------------
        * text-mode STDIO
 
The Unix column assumes that you are not accessing a serial line
(like a tty) in canonical mode.  If you are, then CR on input becomes
"\n", and "\n" on output becomes CRLF.
 
These are just the most common definitions of C<\n> and C<\r> in Perl.
There may well be others.  For example, on an EBCDIC implementation
such as z/OS (OS/390) or OS/400 (using the ILE, the PASE is ASCII-based)
the above material is similar to "Unix" but the code numbers change:
 
    LF  eq  \025  eq  \x15  eq  \cU  eq  chr(21)  eq  CP-1047 21
    LF  eq  \045  eq  \x25  eq           chr(37)  eq  CP-0037 37
    CR  eq  \015  eq  \x0D  eq  \cM  eq  chr(13)  eq  CP-1047 13
    CR  eq  \015  eq  \x0D  eq  \cM  eq  chr(13)  eq  CP-0037 13
 
             | z/OS | OS/400 |
        ----------------------
        \n   |  LF  |  LF    |
        \r   |  CR  |  CR    |
        \n * |  LF  |  LF    |
        \r * |  CR  |  CR    |
        ----------------------
        * text-mode STDIO
 
=head2 Numbers endianness and Width
 
Different CPUs store integers and floating point numbers in different
orders (called I<endianness>) and widths (32-bit and 64-bit being the
most common today).  This affects your programs when they attempt to transfer
numbers in binary format from one CPU architecture to another,
usually either "live" via network connection, or by storing the
numbers to secondary storage such as a disk file or tape.
 
Conflicting storage orders make an utter mess out of the numbers.  If a
little-endian host (Intel, VAX) stores 0x12345678 (305419896 in
decimal), a big-endian host (Motorola, Sparc, PA) reads it as
0x78563412 (2018915346 in decimal).  Alpha and MIPS can be either:
Digital/Compaq used/uses them in little-endian mode; SGI/Cray uses
them in big-endian mode.  To avoid this problem in network (socket)
connections use the L<C<pack>|perlfunc/pack TEMPLATE,LIST> and
L<C<unpack>|perlfunc/unpack TEMPLATE,EXPR> formats C<n> and C<N>, the
"network" orders.  These are guaranteed to be portable.
 
As of Perl 5.10.0, you can also use the C<E<gt>> and C<E<lt>> modifiers
to force big- or little-endian byte-order.  This is useful if you want
to store signed integers or 64-bit integers, for example.
 
You can explore the endianness of your platform by unpacking a
data structure packed in native format such as:
 
    print unpack("h*", pack("s2", 1, 2)), "\n";
    # '10002000' on e.g. Intel x86 or Alpha 21064 in little-endian mode
    # '00100020' on e.g. Motorola 68040
 
If you need to distinguish between endian architectures you could use
either of the variables set like so:
 
    $is_big_endian   = unpack("h*", pack("s", 1)) =~ /01/;
    $is_little_endian = unpack("h*", pack("s", 1)) =~ /^1/;
 
Differing widths can cause truncation even between platforms of equal
endianness.  The platform of shorter width loses the upper parts of the
number.  There is no good solution for this problem except to avoid
transferring or storing raw binary numbers.
 
One can circumnavigate both these problems in two ways.  Either
transfer and store numbers always in text format, instead of raw
binary, or else consider using modules like
L<C<Data::Dumper>|Data::Dumper> and L<C<Storable>|Storable> (included as
of Perl 5.8).  Keeping all data as text significantly simplifies matters.
 
=head2 Files and Filesystems
 
Most platforms these days structure files in a hierarchical fashion.
So, it is reasonably safe to assume that all platforms support the
notion of a "path" to uniquely identify a file on the system.  How
that path is really written, though, differs considerably.
 
Although similar, file path specifications differ between Unix,
Windows, S<Mac OS>, OS/2, VMS, VOS, S<RISC OS>, and probably others.
Unix, for example, is one of the few OSes that has the elegant idea
of a single root directory.
 
DOS, OS/2, VMS, VOS, and Windows can work similarly to Unix with C</>
as path separator, or in their own idiosyncratic ways (such as having
several root directories and various "unrooted" device files such NIL:
and LPT:).
 
S<Mac OS> 9 and earlier used C<:> as a path separator instead of C</>.
 
The filesystem may support neither hard links
(L<C<link>|perlfunc/link OLDFILE,NEWFILE>) nor symbolic links
(L<C<symlink>|perlfunc/symlink OLDFILE,NEWFILE>,
L<C<readlink>|perlfunc/readlink EXPR>,
L<C<lstat>|perlfunc/lstat FILEHANDLE>).
 
The filesystem may support neither access timestamp nor change
timestamp (meaning that about the only portable timestamp is the
modification timestamp), or one second granularity of any timestamps
(e.g. the FAT filesystem limits the time granularity to two seconds).
 
The "inode change timestamp" (the L<C<-C>|perlfunc/-X FILEHANDLE>
filetest) may really be the "creation timestamp" (which it is not in
Unix).
 
VOS perl can emulate Unix filenames with C</> as path separator.  The
native pathname characters greater-than, less-than, number-sign, and
percent-sign are always accepted.
 
S<RISC OS> perl can emulate Unix filenames with C</> as path
separator, or go native and use C<.> for path separator and C<:> to
signal filesystems and disk names.
 
Don't assume Unix filesystem access semantics: that read, write,
and execute are all the permissions there are, and even if they exist,
that their semantics (for example what do C<r>, C<w>, and C<x> mean on
a directory) are the Unix ones.  The various Unix/POSIX compatibility
layers usually try to make interfaces like L<C<chmod>|perlfunc/chmod LIST>
work, but sometimes there simply is no good mapping.
 
The L<C<File::Spec>|File::Spec> modules provide methods to manipulate path
specifications and return the results in native format for each
platform.  This is often unnecessary as Unix-style paths are
understood by Perl on every supported platform, but if you need to
produce native paths for a native utility that does not understand
Unix syntax, or if you are operating on paths or path components
in unknown (and thus possibly native) syntax, L<C<File::Spec>|File::Spec>
is your friend.  Here are two brief examples:
 
    use File::Spec::Functions;
    chdir(updir());        # go up one directory
 
    # Concatenate a path from its components
    my $file = catfile(updir(), 'temp', 'file.txt');
    # on Unix:    '../temp/file.txt'
    # on Win32:   '..\temp\file.txt'
    # on VMS:     '[-.temp]file.txt'
 
In general, production code should not have file paths hardcoded.
Making them user-supplied or read from a configuration file is
better, keeping in mind that file path syntax varies on different
machines.
 
This is especially noticeable in scripts like Makefiles and test suites,
which often assume C</> as a path separator for subdirectories.
 
Also of use is L<C<File::Basename>|File::Basename> from the standard
distribution, which splits a pathname into pieces (base filename, full
path to directory, and file suffix).
 
Even when on a single platform (if you can call Unix a single platform),
remember not to count on the existence or the contents of particular
system-specific files or directories, like F</etc/passwd>,
F</etc/sendmail.conf>, F</etc/resolv.conf>, or even F</tmp/>.  For
example, F</etc/passwd> may exist but not contain the encrypted
passwords, because the system is using some form of enhanced security.
Or it may not contain all the accounts, because the system is using NIS.
If code does need to rely on such a file, include a description of the
file and its format in the code's documentation, then make it easy for
the user to override the default location of the file.
 
Don't assume a text file will end with a newline.  They should,
but people forget.
 
Do not have two files or directories of the same name with different
case, like F<test.pl> and F<Test.pl>, as many platforms have
case-insensitive (or at least case-forgiving) filenames.  Also, try
not to have non-word characters (except for C<.>) in the names, and
keep them to the 8.3 convention, for maximum portability, onerous a
burden though this may appear.
 
Likewise, when using the L<C<AutoSplit>|AutoSplit> module, try to keep
your functions to 8.3 naming and case-insensitive conventions; or, at the
least, make it so the resulting files have a unique (case-insensitively)
first 8 characters.
 
Whitespace in filenames is tolerated on most systems, but not all,
and even on systems where it might be tolerated, some utilities
might become confused by such whitespace.
 
Many systems (DOS, VMS ODS-2) cannot have more than one C<.> in their
filenames.
 
Don't assume C<< > >> won't be the first character of a filename.
Always use the three-arg version of
L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR>:
 
    open my $fh, '<', $existing_file) or die $!;
 
Two-arg L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> is magic and can
translate characters like C<< > >>, C<< < >>, and C<|> in filenames,
which is usually the wrong thing to do.
L<C<sysopen>|perlfunc/sysopen FILEHANDLE,FILENAME,MODE> and three-arg
L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> don't have this problem.
 
Don't use C<:> as a part of a filename since many systems use that for
their own semantics (Mac OS Classic for separating pathname components,
many networking schemes and utilities for separating the nodename and
the pathname, and so on).  For the same reasons, avoid C<@>, C<;> and
C<|>.
 
Don't assume that in pathnames you can collapse two leading slashes
C<//> into one: some networking and clustering filesystems have special
semantics for that.  Let the operating system sort it out.
 
The I<portable filename characters> as defined by ANSI C are
 
 a b c d e f g h i j k l m n o p q r s t u v w x y z
 A B C D E F G H I J K L M N O P Q R S T U V W X Y Z
 0 1 2 3 4 5 6 7 8 9
 . _ -
 
and C<-> shouldn't be the first character.  If you want to be
hypercorrect, stay case-insensitive and within the 8.3 naming
convention (all the files and directories have to be unique within one
directory if their names are lowercased and truncated to eight
characters before the C<.>, if any, and to three characters after the
C<.>, if any).  (And do not use C<.>s in directory names.)
 
=head2 System Interaction
 
Not all platforms provide a command line.  These are usually platforms
that rely primarily on a Graphical User Interface (GUI) for user
interaction.  A program requiring a command line interface might
not work everywhere.  This is probably for the user of the program
to deal with, so don't stay up late worrying about it.
 
Some platforms can't delete or rename files held open by the system,
this limitation may also apply to changing filesystem metainformation
like file permissions or owners.  Remember to
L<C<close>|perlfunc/close FILEHANDLE> files when you are done with them.
Don't L<C<unlink>|perlfunc/unlink LIST> or
L<C<rename>|perlfunc/rename OLDNAME,NEWNAME> an open file.  Don't
L<C<tie>|perlfunc/tie VARIABLE,CLASSNAME,LIST> or
L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> a file already tied or opened;
L<C<untie>|perlfunc/untie VARIABLE> or
L<C<close>|perlfunc/close FILEHANDLE> it first.
 
Don't open the same file more than once at a time for writing, as some
operating systems put mandatory locks on such files.
 
Don't assume that write/modify permission on a directory gives the
right to add or delete files/directories in that directory.  That is
filesystem specific: in some filesystems you need write/modify
permission also (or even just) in the file/directory itself.  In some
filesystems (AFS, DFS) the permission to add/delete directory entries
is a completely separate permission.
 
Don't assume that a single L<C<unlink>|perlfunc/unlink LIST> completely
gets rid of the file: some filesystems (most notably the ones in VMS) have
versioned filesystems, and L<C<unlink>|perlfunc/unlink LIST> removes only
the most recent one (it doesn't remove all the versions because by default
the native tools on those platforms remove just the most recent version,
too).  The portable idiom to remove all the versions of a file is
 
    1 while unlink "file";
 
This will terminate if the file is undeletable for some reason
(protected, not there, and so on).
 
Don't count on a specific environment variable existing in
L<C<%ENV>|perlvar/%ENV>.  Don't count on L<C<%ENV>|perlvar/%ENV> entries
being case-sensitive, or even case-preserving.  Don't try to clear
L<C<%ENV>|perlvar/%ENV> by saying C<%ENV = ();>, or, if you really have
to, make it conditional on C<$^O ne 'VMS'> since in VMS the
L<C<%ENV>|perlvar/%ENV> table is much more than a per-process key-value
string table.
 
On VMS, some entries in the L<C<%ENV>|perlvar/%ENV> hash are dynamically
created when their key is used on a read if they did not previously
exist.  The values for C<$ENV{HOME}>, C<$ENV{TERM}>, C<$ENV{PATH}>, and
C<$ENV{USER}>, are known to be dynamically generated.  The specific names
that are dynamically generated may vary with the version of the C library
on VMS, and more may exist than are documented.
 
On VMS by default, changes to the L<C<%ENV>|perlvar/%ENV> hash persist
after perl exits.  Subsequent invocations of perl in the same process can
inadvertently inherit environment settings that were meant to be
temporary.
 
Don't count on signals or L<C<%SIG>|perlvar/%SIG> for anything.
 
Don't count on filename globbing.  Use
L<C<opendir>|perlfunc/opendir DIRHANDLE,EXPR>,
L<C<readdir>|perlfunc/readdir DIRHANDLE>, and
L<C<closedir>|perlfunc/closedir DIRHANDLE> instead.
 
Don't count on per-program environment variables, or per-program current
directories.
 
Don't count on specific values of L<C<$!>|perlvar/$!>, neither numeric nor
especially the string values. Users may switch their locales causing
error messages to be translated into their languages.  If you can
trust a POSIXish environment, you can portably use the symbols defined
by the L<C<Errno>|Errno> module, like C<ENOENT>.  And don't trust on the
values of L<C<$!>|perlvar/$!> at all except immediately after a failed
system call.
 
=head2 Command names versus file pathnames
 
Don't assume that the name used to invoke a command or program with
L<C<system>|perlfunc/system LIST> or L<C<exec>|perlfunc/exec LIST> can
also be used to test for the existence of the file that holds the
executable code for that command or program.
First, many systems have "internal" commands that are built-in to the
shell or OS and while these commands can be invoked, there is no
corresponding file.  Second, some operating systems (e.g., Cygwin,
DJGPP, OS/2, and VOS) have required suffixes for executable files;
these suffixes are generally permitted on the command name but are not
required.  Thus, a command like C<perl> might exist in a file named
F<perl>, F<perl.exe>, or F<perl.pm>, depending on the operating system.
The variable L<C<$Config{_exe}>|Config/C<_exe>> in the
L<C<Config>|Config> module holds the executable suffix, if any.  Third,
the VMS port carefully sets up L<C<$^X>|perlvar/$^X> and
L<C<$Config{perlpath}>|Config/C<perlpath>> so that no further processing
is required.  This is just as well, because the matching regular
expression used below would then have to deal with a possible trailing
version number in the VMS file name.
 
To convert L<C<$^X>|perlvar/$^X> to a file pathname, taking account of
the requirements of the various operating system possibilities, say:
 
 use Config;
 my $thisperl = $^X;
 if ($^O ne 'VMS') {
     $thisperl .= $Config{_exe}
         unless $thisperl =~ m/\Q$Config{_exe}\E$/i;
 }
 
To convert L<C<$Config{perlpath}>|Config/C<perlpath>> to a file pathname, say:
 
 use Config;
 my $thisperl = $Config{perlpath};
 if ($^O ne 'VMS') {
     $thisperl .= $Config{_exe}
         unless $thisperl =~ m/\Q$Config{_exe}\E$/i;
 }
 
=head2 Networking
 
Don't assume that you can reach the public Internet.
 
Don't assume that there is only one way to get through firewalls
to the public Internet.
 
Don't assume that you can reach outside world through any other port
than 80, or some web proxy.  ftp is blocked by many firewalls.
 
Don't assume that you can send email by connecting to the local SMTP port.
 
Don't assume that you can reach yourself or any node by the name
'localhost'.  The same goes for '127.0.0.1'.  You will have to try both.
 
Don't assume that the host has only one network card, or that it
can't bind to many virtual IP addresses.
 
Don't assume a particular network device name.
 
Don't assume a particular set of
L<C<ioctl>|perlfunc/ioctl FILEHANDLE,FUNCTION,SCALAR>s will work.
 
Don't assume that you can ping hosts and get replies.
 
Don't assume that any particular port (service) will respond.
 
Don't assume that L<C<Sys::Hostname>|Sys::Hostname> (or any other API or
command) returns either a fully qualified hostname or a non-qualified
hostname: it all depends on how the system had been configured.  Also
remember that for things such as DHCP and NAT, the hostname you get back
might not be very useful.
 
All the above I<don't>s may look daunting, and they are, but the key
is to degrade gracefully if one cannot reach the particular network
service one wants.  Croaking or hanging do not look very professional.
 
=head2 Interprocess Communication (IPC)
 
In general, don't directly access the system in code meant to be
portable.  That means, no L<C<system>|perlfunc/system LIST>,
L<C<exec>|perlfunc/exec LIST>, L<C<fork>|perlfunc/fork>,
L<C<pipe>|perlfunc/pipe READHANDLE,WRITEHANDLE>,
L<C<``> or C<qxE<sol>E<sol>>|perlop/C<qxE<sol>I<STRING>E<sol>>>,
L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> with a C<|>, nor any of the other
things that makes being a Perl hacker worth being.
 
Commands that launch external processes are generally supported on
most platforms (though many of them do not support any type of
forking).  The problem with using them arises from what you invoke
them on.  External tools are often named differently on different
platforms, may not be available in the same location, might accept
different arguments, can behave differently, and often present their
results in a platform-dependent way.  Thus, you should seldom depend
on them to produce consistent results.  (Then again, if you're calling
C<netstat -a>, you probably don't expect it to run on both Unix and CP/M.)
 
One especially common bit of Perl code is opening a pipe to B<sendmail>:
 
    open(my $mail, '|-', '/usr/lib/sendmail -t')
        or die "cannot fork sendmail: $!";
 
This is fine for systems programming when sendmail is known to be
available.  But it is not fine for many non-Unix systems, and even
some Unix systems that may not have sendmail installed.  If a portable
solution is needed, see the various distributions on CPAN that deal
with it.  L<C<Mail::Mailer>|Mail::Mailer> and L<C<Mail::Send>|Mail::Send>
in the C<MailTools> distribution are commonly used, and provide several
mailing methods, including C<mail>, C<sendmail>, and direct SMTP (via
L<C<Net::SMTP>|Net::SMTP>) if a mail transfer agent is not available.
L<C<Mail::Sendmail>|Mail::Sendmail> is a standalone module that provides
simple, platform-independent mailing.
 
The Unix System V IPC (C<msg*(), sem*(), shm*()>) is not available
even on all Unix platforms.
 
Do not use either the bare result of C<pack("N", 10, 20, 30, 40)> or
bare v-strings (such as C<v10.20.30.40>) to represent IPv4 addresses:
both forms just pack the four bytes into network order.  That this
would be equal to the C language C<in_addr> struct (which is what the
socket code internally uses) is not guaranteed.  To be portable use
the routines of the L<C<Socket>|Socket> module, such as
L<C<inet_aton>|Socket/$ip_address = inet_aton $string>,
L<C<inet_ntoa>|Socket/$string = inet_ntoa $ip_address>, and
L<C<sockaddr_in>|Socket/$sockaddr = sockaddr_in $port, $ip_address>.
 
The rule of thumb for portable code is: Do it all in portable Perl, or
use a module (that may internally implement it with platform-specific
code, but exposes a common interface).
 
=head2 External Subroutines (XS)
 
XS code can usually be made to work with any platform, but dependent
libraries, header files, etc., might not be readily available or
portable, or the XS code itself might be platform-specific, just as Perl
code might be.  If the libraries and headers are portable, then it is
normally reasonable to make sure the XS code is portable, too.
 
A different type of portability issue arises when writing XS code:
availability of a C compiler on the end-user's system.  C brings
with it its own portability issues, and writing XS code will expose
you to some of those.  Writing purely in Perl is an easier way to
achieve portability.
 
=head2 Standard Modules
 
In general, the standard modules work across platforms.  Notable
exceptions are the L<C<CPAN>|CPAN> module (which currently makes
connections to external programs that may not be available),
platform-specific modules (like L<C<ExtUtils::MM_VMS>|ExtUtils::MM_VMS>),
and DBM modules.
 
There is no one DBM module available on all platforms.
L<C<SDBM_File>|SDBM_File> and the others are generally available on all
Unix and DOSish ports, but not in MacPerl, where only
L<C<NDBM_File>|NDBM_File> and L<C<DB_File>|DB_File> are available.
 
The good news is that at least some DBM module should be available, and
L<C<AnyDBM_File>|AnyDBM_File> will use whichever module it can find.  Of
course, then the code needs to be fairly strict, dropping to the greatest
common factor (e.g., not exceeding 1K for each record), so that it will
work with any DBM module.  See L<AnyDBM_File> for more details.
 
=head2 Time and Date
 
The system's notion of time of day and calendar date is controlled in
widely different ways.  Don't assume the timezone is stored in C<$ENV{TZ}>,
and even if it is, don't assume that you can control the timezone through
that variable.  Don't assume anything about the three-letter timezone
abbreviations (for example that MST would be the Mountain Standard Time,
it's been known to stand for Moscow Standard Time).  If you need to
use timezones, express them in some unambiguous format like the
exact number of minutes offset from UTC, or the POSIX timezone
format.
 
Don't assume that the epoch starts at 00:00:00, January 1, 1970,
because that is OS- and implementation-specific.  It is better to
store a date in an unambiguous representation.  The ISO 8601 standard
defines YYYY-MM-DD as the date format, or YYYY-MM-DDTHH:MM:SS
(that's a literal "T" separating the date from the time).
Please do use the ISO 8601 instead of making us guess what
date 02/03/04 might be.  ISO 8601 even sorts nicely as-is.
A text representation (like "1987-12-18") can be easily converted
into an OS-specific value using a module like
L<C<Time::Piece>|Time::Piece> (see L<Time::Piece/Date Parsing>) or
L<C<Date::Parse>|Date::Parse>.  An array of values, such as those
returned by L<C<localtime>|perlfunc/localtime EXPR>, can be converted to an OS-specific
representation using L<C<Time::Local>|Time::Local>.
 
When calculating specific times, such as for tests in time or date modules,
it may be appropriate to calculate an offset for the epoch.
 
    use Time::Local qw(timegm);
    my $offset = timegm(0, 0, 0, 1, 0, 1970);
 
The value for C<$offset> in Unix will be C<0>, but in Mac OS Classic
will be some large number.  C<$offset> can then be added to a Unix time
value to get what should be the proper value on any system.
 
=head2 Character sets and character encoding
 
Assume very little about character sets.
 
Assume nothing about numerical values (L<C<ord>|perlfunc/ord EXPR>,
L<C<chr>|perlfunc/chr NUMBER>) of characters.
Do not use explicit code point ranges (like C<\xHH-\xHH)>.  However,
starting in Perl v5.22, regular expression pattern bracketed character
class ranges specified like C<qr/[\N{U+HH}-\N{U+HH}]/> are portable,
and starting in Perl v5.24, the same ranges are portable in
L<C<trE<sol>E<sol>E<sol>>|perlop/C<trE<sol>I<SEARCHLIST>E<sol>I<REPLACEMENTLIST>E<sol>cdsr>>.
You can portably use symbolic character classes like C<[:print:]>.
 
Do not assume that the alphabetic characters are encoded contiguously
(in the numeric sense).  There may be gaps.  Special coding in Perl,
however, guarantees that all subsets of C<qr/[A-Z]/>, C<qr/[a-z]/>, and
C<qr/[0-9]/> behave as expected.
L<C<trE<sol>E<sol>E<sol>>|perlop/C<trE<sol>I<SEARCHLIST>E<sol>I<REPLACEMENTLIST>E<sol>cdsr>>
behaves the same for these ranges.  In patterns, any ranges specified with
end points using the C<\N{...}> notations ensures character set
portability, but it is a bug in Perl v5.22 that this isn't true of
L<C<trE<sol>E<sol>E<sol>>|perlop/C<trE<sol>I<SEARCHLIST>E<sol>I<REPLACEMENTLIST>E<sol>cdsr>>,
fixed in v5.24.
 
Do not assume anything about the ordering of the characters.
The lowercase letters may come before or after the uppercase letters;
the lowercase and uppercase may be interlaced so that both "a" and "A"
come before "b"; the accented and other international characters may
be interlaced so that E<auml> comes before "b".
L<Unicode::Collate> can be used to sort this all out.
 
=head2 Internationalisation
 
If you may assume POSIX (a rather large assumption), you may read
more about the POSIX locale system from L<perllocale>.  The locale
system at least attempts to make things a little bit more portable,
or at least more convenient and native-friendly for non-English
users.  The system affects character sets and encoding, and date
and time formatting--amongst other things.
 
If you really want to be international, you should consider Unicode.
See L<perluniintro> and L<perlunicode> for more information.
 
By default Perl assumes your source code is written in an 8-bit ASCII
superset. To embed Unicode characters in your strings and regexes, you can
use the L<C<\x{HH}> or (more portably) C<\N{U+HH}>
notations|perlop/Quote and Quote-like Operators>. You can also use the
L<C<utf8>|utf8> pragma and write your code in UTF-8, which lets you use
Unicode characters directly (not just in quoted constructs but also in
identifiers).
 
=head2 System Resources
 
If your code is destined for systems with severely constrained (or
missing!) virtual memory systems then you want to be I<especially> mindful
of avoiding wasteful constructs such as:
 
    my @lines = <$very_large_file>;            # bad
 
    while (<$fh>) {$file .= $_}                # sometimes bad
    my $file = join('', <$fh>);                # better
 
The last two constructs may appear unintuitive to most people.  The
first repeatedly grows a string, whereas the second allocates a
large chunk of memory in one go.  On some systems, the second is
more efficient than the first.
 
=head2 Security
 
Most multi-user platforms provide basic levels of security, usually
implemented at the filesystem level.  Some, however, unfortunately do
not.  Thus the notion of user id, or "home" directory,
or even the state of being logged-in, may be unrecognizable on many
platforms.  If you write programs that are security-conscious, it
is usually best to know what type of system you will be running
under so that you can write code explicitly for that platform (or
class of platforms).
 
Don't assume the Unix filesystem access semantics: the operating
system or the filesystem may be using some ACL systems, which are
richer languages than the usual C<rwx>.  Even if the C<rwx> exist,
their semantics might be different.
 
(From the security viewpoint, testing for permissions before attempting to
do something is silly anyway: if one tries this, there is potential
for race conditions. Someone or something might change the
permissions between the permissions check and the actual operation.
Just try the operation.)
 
Don't assume the Unix user and group semantics: especially, don't
expect L<C<< $< >>|perlvar/$E<lt>> and L<C<< $> >>|perlvar/$E<gt>> (or
L<C<$(>|perlvar/$(> and L<C<$)>|perlvar/$)>) to work for switching
identities (or memberships).
 
Don't assume set-uid and set-gid semantics.  (And even if you do,
think twice: set-uid and set-gid are a known can of security worms.)
 
=head2 Style
 
For those times when it is necessary to have platform-specific code,
consider keeping the platform-specific code in one place, making porting
to other platforms easier.  Use the L<C<Config>|Config> module and the
special variable L<C<$^O>|perlvar/$^O> to differentiate platforms, as
described in L</"PLATFORMS">.
 
Beware of the "else syndrome":
 
  if ($^O eq 'MSWin32') {
    # code that assumes Windows
  } else {
    # code that assumes Linux
  }
 
The C<else> branch should be used for the really ultimate fallback,
not for code specific to some platform.
 
Be careful in the tests you supply with your module or programs.
Module code may be fully portable, but its tests might not be.  This
often happens when tests spawn off other processes or call external
programs to aid in the testing, or when (as noted above) the tests
assume certain things about the filesystem and paths.  Be careful not
to depend on a specific output style for errors, such as when checking
L<C<$!>|perlvar/$!> after a failed system call.  Using
L<C<$!>|perlvar/$!> for anything else than displaying it as output is
doubtful (though see the L<C<Errno>|Errno> module for testing reasonably
portably for error value). Some platforms expect a certain output format,
and Perl on those platforms may have been adjusted accordingly.  Most
specifically, don't anchor a regex when testing an error value.
 
=head1 CPAN Testers
 
Modules uploaded to CPAN are tested by a variety of volunteers on
different platforms.  These CPAN testers are notified by mail of each
new upload, and reply to the list with PASS, FAIL, NA (not applicable to
this platform), or UNKNOWN (unknown), along with any relevant notations.
 
The purpose of the testing is twofold: one, to help developers fix any
problems in their code that crop up because of lack of testing on other
platforms; two, to provide users with information about whether
a given module works on a given platform.
 
Also see:
 
=over 4
 
=item *
 
Mailing list: cpan-testers-discuss@perl.org
 
=item *
 
Testing results: L<https://www.cpantesters.org/>
 
=back
 
=head1 PLATFORMS
 
Perl is built with a L<C<$^O>|perlvar/$^O> variable that indicates the
operating system it was built on.  This was implemented
to help speed up code that would otherwise have to C<use Config>
and use the value of L<C<$Config{osname}>|Config/C<osname>>.  Of course,
to get more detailed information about the system, looking into
L<C<%Config>|Config/DESCRIPTION> is certainly recommended.
 
L<C<%Config>|Config/DESCRIPTION> cannot always be trusted, however,
because it was built at compile time.  If perl was built in one place,
then transferred elsewhere, some values may be wrong.  The values may
even have been edited after the fact.
 
=head2 Unix
 
Perl works on a bewildering variety of Unix and Unix-like platforms (see
e.g. most of the files in the F<hints/> directory in the source code kit).
On most of these systems, the value of L<C<$^O>|perlvar/$^O> (hence
L<C<$Config{osname}>|Config/C<osname>>, too) is determined either by
lowercasing and stripping punctuation from the first field of the string
returned by typing C<uname -a> (or a similar command) at the shell prompt
or by testing the file system for the presence of uniquely named files
such as a kernel or header file.  Here, for example, are a few of the
more popular Unix flavors:
 
    uname         $^O        $Config{archname}
    --------------------------------------------
    AIX           aix        aix
    BSD/OS        bsdos      i386-bsdos
    Darwin        darwin     darwin
    DYNIX/ptx     dynixptx   i386-dynixptx
    FreeBSD       freebsd    freebsd-i386
    Haiku         haiku      BePC-haiku
    Linux         linux      arm-linux
    Linux         linux      armv5tel-linux
    Linux         linux      i386-linux
    Linux         linux      i586-linux
    Linux         linux      ppc-linux
    HP-UX         hpux       PA-RISC1.1
    IRIX          irix       irix
    Mac OS X      darwin     darwin
    NeXT 3        next       next-fat
    NeXT 4        next       OPENSTEP-Mach
    openbsd       openbsd    i386-openbsd
    OSF1          dec_osf    alpha-dec_osf
    reliantunix-n svr4       RM400-svr4
    SCO_SV        sco_sv     i386-sco_sv
    SINIX-N       svr4       RM400-svr4
    sn4609        unicos     CRAY_C90-unicos
    sn6521        unicosmk   t3e-unicosmk
    sn9617        unicos     CRAY_J90-unicos
    SunOS         solaris    sun4-solaris
    SunOS         solaris    i86pc-solaris
    SunOS4        sunos      sun4-sunos
 
Because the value of L<C<$Config{archname}>|Config/C<archname>> may
depend on the hardware architecture, it can vary more than the value of
L<C<$^O>|perlvar/$^O>.
 
=head2 DOS and Derivatives
 
Perl has long been ported to Intel-style microcomputers running under
systems like PC-DOS, MS-DOS, OS/2, and most Windows platforms you can
bring yourself to mention (except for Windows CE, if you count that).
Users familiar with I<COMMAND.COM> or I<CMD.EXE> style shells should
be aware that each of these file specifications may have subtle
differences:
 
    my $filespec0 = "c:/foo/bar/file.txt";
    my $filespec1 = "c:\\foo\\bar\\file.txt";
    my $filespec2 = 'c:\foo\bar\file.txt';
    my $filespec3 = 'c:\\foo\\bar\\file.txt';
 
System calls accept either C</> or C<\> as the path separator.
However, many command-line utilities of DOS vintage treat C</> as
the option prefix, so may get confused by filenames containing C</>.
Aside from calling any external programs, C</> will work just fine,
and probably better, as it is more consistent with popular usage,
and avoids the problem of remembering what to backwhack and what
not to.
 
The DOS FAT filesystem can accommodate only "8.3" style filenames.  Under
the "case-insensitive, but case-preserving" HPFS (OS/2) and NTFS (NT)
filesystems you may have to be careful about case returned with functions
like L<C<readdir>|perlfunc/readdir DIRHANDLE> or used with functions like
L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> or
L<C<opendir>|perlfunc/opendir DIRHANDLE,EXPR>.
 
DOS also treats several filenames as special, such as F<AUX>, F<PRN>,
F<NUL>, F<CON>, F<COM1>, F<LPT1>, F<LPT2>, etc.  Unfortunately, sometimes
these filenames won't even work if you include an explicit directory
prefix.  It is best to avoid such filenames, if you want your code to be
portable to DOS and its derivatives.  It's hard to know what these all
are, unfortunately.
 
Users of these operating systems may also wish to make use of
scripts such as F<pl2bat.bat> to put wrappers around your scripts.
 
Newline (C<\n>) is translated as C<\015\012> by the I/O system when
reading from and writing to files (see L</"Newlines">).
C<binmode($filehandle)> will keep C<\n> translated as C<\012> for that
filehandle.
L<C<binmode>|perlfunc/binmode FILEHANDLE> should always be used for code
that deals with binary data.  That's assuming you realize in advance that
your data is in binary.  General-purpose programs should often assume
nothing about their data.
 
The L<C<$^O>|perlvar/$^O> variable and the
L<C<$Config{archname}>|Config/C<archname>> values for various DOSish
perls are as follows:
 
    OS             $^O       $Config{archname}  ID    Version
    ---------------------------------------------------------
    MS-DOS         dos       ?
    PC-DOS         dos       ?
    OS/2           os2       ?
    Windows 3.1    ?         ?                  0     3 01
    Windows 95     MSWin32   MSWin32-x86        1     4 00
    Windows 98     MSWin32   MSWin32-x86        1     4 10
    Windows ME     MSWin32   MSWin32-x86        1     ?
    Windows NT     MSWin32   MSWin32-x86        2     4 xx
    Windows NT     MSWin32   MSWin32-ALPHA      2     4 xx
    Windows NT     MSWin32   MSWin32-ppc        2     4 xx
    Windows 2000   MSWin32   MSWin32-x86        2     5 00
    Windows XP     MSWin32   MSWin32-x86        2     5 01
    Windows 2003   MSWin32   MSWin32-x86        2     5 02
    Windows Vista  MSWin32   MSWin32-x86        2     6 00
    Windows 7      MSWin32   MSWin32-x86        2     6 01
    Windows 7      MSWin32   MSWin32-x64        2     6 01
    Windows 2008   MSWin32   MSWin32-x86        2     6 01
    Windows 2008   MSWin32   MSWin32-x64        2     6 01
    Windows CE     MSWin32   ?                  3
    Cygwin         cygwin    cygwin
 
The various MSWin32 Perl's can distinguish the OS they are running on
via the value of the fifth element of the list returned from
L<C<Win32::GetOSVersion()>|Win32/Win32::GetOSVersion()>.  For example:
 
    if ($^O eq 'MSWin32') {
        my @os_version_info = Win32::GetOSVersion();
        print +('3.1','95','NT')[$os_version_info[4]],"\n";
    }
 
There are also C<Win32::IsWinNT()|Win32/Win32::IsWinNT()>,
C<Win32::IsWin95()|Win32/Win32::IsWin95()>, and
L<C<Win32::GetOSName()>|Win32/Win32::GetOSName()>; try
L<C<perldoc Win32>|Win32>.
The very portable L<C<POSIX::uname()>|POSIX/C<uname>> will work too:
 
    c:\> perl -MPOSIX -we "print join '|', uname"
    Windows NT|moonru|5.0|Build 2195 (Service Pack 2)|x86
 
Errors set by Winsock functions are now put directly into C<$^E>,
and the relevant C<WSAE*> error codes are now exported from the
L<Errno> and L<POSIX> modules for testing this against.
 
The previous behavior of putting the errors (converted to POSIX-style
C<E*> error codes since Perl 5.20.0) into C<$!> was buggy due to
the non-equivalence of like-named Winsock and POSIX error constants,
a relationship between which has unfortunately been established
in one way or another since Perl 5.8.0.
 
The new behavior provides a much more robust solution for checking
Winsock errors in portable software without accidentally matching
POSIX tests that were intended for other OSes and may have different
meanings for Winsock.
 
The old behavior is currently retained, warts and all, for backwards
compatibility, but users are encouraged to change any code that
tests C<$!> against C<E*> constants for Winsock errors to instead
test C<$^E> against C<WSAE*> constants.  After a suitable deprecation
period, which started with Perl 5.24, the old behavior may be
removed, leaving C<$!> unchanged after Winsock function calls, to
avoid any possible confusion over which error variable to check.
 
Also see:
 
=over 4
 
=item *
 
The djgpp environment for DOS, L<http://www.delorie.com/djgpp/>
and L<perldos>.
 
=item *
 
The EMX environment for DOS, OS/2, etc. emx@iaehv.nl,
L<ftp://hobbes.nmsu.edu/pub/os2/dev/emx/>  Also L<perlos2>.
 
=item *
 
Build instructions for Win32 in L<perlwin32>, or under the Cygnus environment
in L<perlcygwin>.
 
=item *
 
The C<Win32::*> modules in L<Win32>.
 
=item *
 
The ActiveState Pages, L<https://www.activestate.com/>
 
=item *
 
The Cygwin environment for Win32; F<README.cygwin> (installed
as L<perlcygwin>), L<https://www.cygwin.com/>
 
=item *
 
The U/WIN environment for Win32,
L<http://www.research.att.com/sw/tools/uwin/>
 
=item *
 
Build instructions for OS/2, L<perlos2>
 
=back
 
=head2 VMS
 
Perl on VMS is discussed in L<perlvms> in the Perl distribution.
 
The official name of VMS as of this writing is OpenVMS.
 
Interacting with Perl from the Digital Command Language (DCL) shell
often requires a different set of quotation marks than Unix shells do.
For example:
 
    $ perl -e "print ""Hello, world.\n"""
    Hello, world.
 
There are several ways to wrap your Perl scripts in DCL F<.COM> files, if
you are so inclined.  For example:
 
    $ write sys$output "Hello from DCL!"
    $ if p1 .eqs. ""
    $ then perl -x 'f$environment("PROCEDURE")
    $ else perl -x - 'p1 'p2 'p3 'p4 'p5 'p6 'p7 'p8
    $ deck/dollars="__END__"
    #!/usr/bin/perl
 
    print "Hello from Perl!\n";
 
    __END__
    $ endif
 
Do take care with C<$ ASSIGN/nolog/user SYS$COMMAND: SYS$INPUT> if your
Perl-in-DCL script expects to do things like C<< $read = <STDIN>; >>.
 
The VMS operating system has two filesystems, designated by their
on-disk structure (ODS) level: ODS-2 and its successor ODS-5.  The
initial port of Perl to VMS pre-dates ODS-5, but all current testing and
development assumes ODS-5 and its capabilities, including case
preservation, extended characters in filespecs, and names up to 8192
bytes long.
 
Perl on VMS can accept either VMS- or Unix-style file
specifications as in either of the following:
 
    $ perl -ne "print if /perl_setup/i" SYS$LOGIN:LOGIN.COM
    $ perl -ne "print if /perl_setup/i" /sys$login/login.com
 
but not a mixture of both as in:
 
    $ perl -ne "print if /perl_setup/i" sys$login:/login.com
    Can't open sys$login:/login.com: file specification syntax error
 
In general, the easiest path to portability is always to specify
filenames in Unix format unless they will need to be processed by native
commands or utilities.  Because of this latter consideration, the
L<File::Spec> module by default returns native format specifications
regardless of input format.  This default may be reversed so that
filenames are always reported in Unix format by specifying the
C<DECC$FILENAME_UNIX_REPORT> feature logical in the environment.
 
The file type, or extension, is always present in a VMS-format file
specification even if it's zero-length.  This means that, by default,
L<C<readdir>|perlfunc/readdir DIRHANDLE> will return a trailing dot on a
file with no extension, so where you would see C<"a"> on Unix you'll see
C<"a."> on VMS.  However, the trailing dot may be suppressed by enabling
the C<DECC$READDIR_DROPDOTNOTYPE> feature in the environment (see the CRTL
documentation on feature logical names).
 
What C<\n> represents depends on the type of file opened.  It usually
represents C<\012> but it could also be C<\015>, C<\012>, C<\015\012>,
C<\000>, C<\040>, or nothing depending on the file organization and
record format.  The L<C<VMS::Stdio>|VMS::Stdio> module provides access to
the special C<fopen()> requirements of files with unusual attributes on
VMS.
 
The value of L<C<$^O>|perlvar/$^O> on OpenVMS is "VMS".  To determine the
architecture that you are running on refer to
L<C<$Config{archname}>|Config/C<archname>>.
 
On VMS, perl determines the UTC offset from the C<SYS$TIMEZONE_DIFFERENTIAL>
logical name.  Although the VMS epoch began at 17-NOV-1858 00:00:00.00,
calls to L<C<localtime>|perlfunc/localtime EXPR> are adjusted to count
offsets from 01-JAN-1970 00:00:00.00, just like Unix.
 
Also see:
 
=over 4
 
=item *
 
F<README.vms> (installed as F<README_vms>), L<perlvms>
 
=item *
 
vmsperl list, vmsperl-subscribe@perl.org
 
=item *
 
vmsperl on the web, L<http://www.sidhe.org/vmsperl/index.html>
 
=item *
 
VMS Software Inc. web site, L<http://www.vmssoftware.com>
 
=back
 
=head2 VOS
 
Perl on VOS (also known as OpenVOS) is discussed in F<README.vos>
in the Perl distribution (installed as L<perlvos>).  Perl on VOS
can accept either VOS- or Unix-style file specifications as in
either of the following:
 
    $ perl -ne "print if /perl_setup/i" >system>notices
    $ perl -ne "print if /perl_setup/i" /system/notices
 
or even a mixture of both as in:
 
    $ perl -ne "print if /perl_setup/i" >system/notices
 
Even though VOS allows the slash character to appear in object
names, because the VOS port of Perl interprets it as a pathname
delimiting character, VOS files, directories, or links whose
names contain a slash character cannot be processed.  Such files
must be renamed before they can be processed by Perl.
 
Older releases of VOS (prior to OpenVOS Release 17.0) limit file
names to 32 or fewer characters, prohibit file names from
starting with a C<-> character, and prohibit file names from
containing C< > (space) or any character from the set C<< !#%&'()*;<=>? >>.
 
Newer releases of VOS (OpenVOS Release 17.0 or later) support a
feature known as extended names.  On these releases, file names
can contain up to 255 characters, are prohibited from starting
with a C<-> character, and the set of prohibited characters is
reduced to C<< #%*<>? >>.  There are
restrictions involving spaces and apostrophes:  these characters
must not begin or end a name, nor can they immediately precede or
follow a period.  Additionally, a space must not immediately
precede another space or hyphen.  Specifically, the following
character combinations are prohibited:  space-space,
space-hyphen, period-space, space-period, period-apostrophe,
apostrophe-period, leading or trailing space, and leading or
trailing apostrophe.  Although an extended file name is limited
to 255 characters, a path name is still limited to 256
characters.
 
The value of L<C<$^O>|perlvar/$^O> on VOS is "vos".  To determine the
architecture that you are running on refer to
L<C<$Config{archname}>|Config/C<archname>>.
 
Also see:
 
=over 4
 
=item *
 
F<README.vos> (installed as L<perlvos>)
 
=item *
 
The VOS mailing list.
 
There is no specific mailing list for Perl on VOS.  You can contact
the Stratus Technologies Customer Assistance Center (CAC) for your
region, or you can use the contact information located in the
distribution files on the Stratus Anonymous FTP site.
 
=item *
 
Stratus Technologies on the web at L<http://www.stratus.com>
 
=item *
 
VOS Open-Source Software on the web at L<http://ftp.stratus.com/pub/vos/vos.html>
 
=back
 
=head2 EBCDIC Platforms
 
v5.22 core Perl runs on z/OS (formerly OS/390).  Theoretically it could
run on the successors of OS/400 on AS/400 minicomputers as well as
VM/ESA, and BS2000 for S/390 Mainframes.  Such computers use EBCDIC
character sets internally (usually Character Code Set ID 0037 for OS/400
and either 1047 or POSIX-BC for S/390 systems).
 
The rest of this section may need updating, but we don't know what it
should say.  Please submit comments to
L<https://github.com/Perl/perl5/issues>.
 
On the mainframe Perl currently works under the "Unix system
services for OS/390" (formerly known as OpenEdition), VM/ESA OpenEdition, or
the BS200 POSIX-BC system (BS2000 is supported in Perl 5.6 and greater).
See L<perlos390> for details.  Note that for OS/400 there is also a port of
Perl 5.8.1/5.10.0 or later to the PASE which is ASCII-based (as opposed to
ILE which is EBCDIC-based), see L<perlos400>.
 
As of R2.5 of USS for OS/390 and Version 2.3 of VM/ESA these Unix
sub-systems do not support the C<#!> shebang trick for script invocation.
Hence, on OS/390 and VM/ESA Perl scripts can be executed with a header
similar to the following simple script:
 
    : # use perl
        eval 'exec /usr/local/bin/perl -S $0 ${1+"$@"}'
            if 0;
    #!/usr/local/bin/perl     # just a comment really
 
    print "Hello from perl!\n";
 
OS/390 will support the C<#!> shebang trick in release 2.8 and beyond.
Calls to L<C<system>|perlfunc/system LIST> and backticks can use POSIX
shell syntax on all S/390 systems.
 
On the AS/400, if PERL5 is in your library list, you may need
to wrap your Perl scripts in a CL procedure to invoke them like so:
 
    BEGIN
      CALL PGM(PERL5/PERL) PARM('/QOpenSys/hello.pl')
    ENDPGM
 
This will invoke the Perl script F<hello.pl> in the root of the
QOpenSys file system.  On the AS/400 calls to
L<C<system>|perlfunc/system LIST> or backticks must use CL syntax.
 
On these platforms, bear in mind that the EBCDIC character set may have
an effect on what happens with some Perl functions (such as
L<C<chr>|perlfunc/chr NUMBER>, L<C<pack>|perlfunc/pack TEMPLATE,LIST>,
L<C<print>|perlfunc/print FILEHANDLE LIST>,
L<C<printf>|perlfunc/printf FILEHANDLE FORMAT, LIST>,
L<C<ord>|perlfunc/ord EXPR>, L<C<sort>|perlfunc/sort SUBNAME LIST>,
L<C<sprintf>|perlfunc/sprintf FORMAT, LIST>,
L<C<unpack>|perlfunc/unpack TEMPLATE,EXPR>), as
well as bit-fiddling with ASCII constants using operators like
L<C<^>, C<&> and C<|>|perlop/Bitwise String Operators>, not to mention
dealing with socket interfaces to ASCII computers (see L</"Newlines">).
 
Fortunately, most web servers for the mainframe will correctly
translate the C<\n> in the following statement to its ASCII equivalent
(C<\r> is the same under both Unix and z/OS):
 
    print "Content-type: text/html\r\n\r\n";
 
The values of L<C<$^O>|perlvar/$^O> on some of these platforms include:
 
    uname         $^O        $Config{archname}
    --------------------------------------------
    OS/390        os390      os390
    OS400         os400      os400
    POSIX-BC      posix-bc   BS2000-posix-bc
 
Some simple tricks for determining if you are running on an EBCDIC
platform could include any of the following (perhaps all):
 
    if ("\t" eq "\005")  { print "EBCDIC may be spoken here!\n"; }
 
    if (ord('A') == 193) { print "EBCDIC may be spoken here!\n"; }
 
    if (chr(169) eq 'z') { print "EBCDIC may be spoken here!\n"; }
 
One thing you may not want to rely on is the EBCDIC encoding
of punctuation characters since these may differ from code page to code
page (and once your module or script is rumoured to work with EBCDIC,
folks will want it to work with all EBCDIC character sets).
 
Also see:
 
=over 4
 
=item *
 
L<perlos390>, L<perlos400>, L<perlbs2000>, L<perlebcdic>.
 
=item *
 
The perl-mvs@perl.org list is for discussion of porting issues as well as
general usage issues for all EBCDIC Perls.  Send a message body of
"subscribe perl-mvs" to majordomo@perl.org.
 
=item *
 
AS/400 Perl information at
L<http://as400.rochester.ibm.com/>
as well as on CPAN in the F<ports/> directory.
 
=back
 
=head2 Acorn RISC OS
 
Because Acorns use ASCII with newlines (C<\n>) in text files as C<\012> like
Unix, and because Unix filename emulation is turned on by default,
most simple scripts will probably work "out of the box".  The native
filesystem is modular, and individual filesystems are free to be
case-sensitive or insensitive, and are usually case-preserving.  Some
native filesystems have name length limits, which file and directory
names are silently truncated to fit.  Scripts should be aware that the
standard filesystem currently has a name length limit of B<10>
characters, with up to 77 items in a directory, but other filesystems
may not impose such limitations.
 
Native filenames are of the form
 
    Filesystem#Special_Field::DiskName.$.Directory.Directory.File
 
where
 
    Special_Field is not usually present, but may contain . and $ .
    Filesystem =~ m|[A-Za-z0-9_]|
    DsicName   =~ m|[A-Za-z0-9_/]|
    $ represents the root directory
    . is the path separator
    @ is the current directory (per filesystem but machine global)
    ^ is the parent directory
    Directory and File =~ m|[^\0- "\.\$\%\&:\@\\^\|\177]+|
 
The default filename translation is roughly C<tr|/.|./|>, swapping dots
and slashes.
 
Note that C<"ADFS::HardDisk.$.File" ne 'ADFS::HardDisk.$.File'> and that
the second stage of C<$> interpolation in regular expressions will fall
foul of the L<C<$.>|perlvar/$.> variable if scripts are not careful.
 
Logical paths specified by system variables containing comma-separated
search lists are also allowed; hence C<System:Modules> is a valid
filename, and the filesystem will prefix C<Modules> with each section of
C<System$Path> until a name is made that points to an object on disk.
Writing to a new file C<System:Modules> would be allowed only if
C<System$Path> contains a single item list.  The filesystem will also
expand system variables in filenames if enclosed in angle brackets, so
C<< <System$Dir>.Modules >> would look for the file
S<C<$ENV{'System$Dir'} . 'Modules'>>.  The obvious implication of this is
that B<fully qualified filenames can start with C<< <> >>> and the
three-argument form of L<C<open>|perlfunc/open FILEHANDLE,MODE,EXPR> should
always be used.
 
Because C<.> was in use as a directory separator and filenames could not
be assumed to be unique after 10 characters, Acorn implemented the C
compiler to strip the trailing C<.c> C<.h> C<.s> and C<.o> suffix from
filenames specified in source code and store the respective files in
subdirectories named after the suffix.  Hence files are translated:
 
    foo.h           h.foo
    C:foo.h         C:h.foo        (logical path variable)
    sys/os.h        sys.h.os       (C compiler groks Unix-speak)
    10charname.c    c.10charname
    10charname.o    o.10charname
    11charname_.c   c.11charname   (assuming filesystem truncates at 10)
 
The Unix emulation library's translation of filenames to native assumes
that this sort of translation is required, and it allows a user-defined list
of known suffixes that it will transpose in this fashion.  This may
seem transparent, but consider that with these rules F<foo/bar/baz.h>
and F<foo/bar/h/baz> both map to F<foo.bar.h.baz>, and that
L<C<readdir>|perlfunc/readdir DIRHANDLE> and L<C<glob>|perlfunc/glob EXPR>
cannot and do not attempt to emulate the reverse mapping.  Other
C<.>'s in filenames are translated to C</>.
 
As implied above, the environment accessed through
L<C<%ENV>|perlvar/%ENV> is global, and the convention is that program
specific environment variables are of the form C<Program$Name>.
Each filesystem maintains a current directory,
and the current filesystem's current directory is the B<global> current
directory.  Consequently, sociable programs don't change the current
directory but rely on full pathnames, and programs (and Makefiles) cannot
assume that they can spawn a child process which can change the current
directory without affecting its parent (and everyone else for that
matter).
 
Because native operating system filehandles are global and are currently
allocated down from 255, with 0 being a reserved value, the Unix emulation
library emulates Unix filehandles.  Consequently, you can't rely on
passing C<STDIN>, C<STDOUT>, or C<STDERR> to your children.
 
The desire of users to express filenames of the form
C<< <Foo$Dir>.Bar >> on the command line unquoted causes problems,
too: L<C<``>|perlop/C<qxE<sol>I<STRING>E<sol>>> command output capture has
to perform a guessing game.  It assumes that a string C<< <[^<>]+\$[^<>]> >>
is a reference to an environment variable, whereas anything else involving
C<< < >> or C<< > >> is redirection, and generally manages to be 99%
right.  Of course, the problem remains that scripts cannot rely on any
Unix tools being available, or that any tools found have Unix-like command
line arguments.
 
Extensions and XS are, in theory, buildable by anyone using free
tools.  In practice, many don't, as users of the Acorn platform are
used to binary distributions.  MakeMaker does run, but no available
make currently copes with MakeMaker's makefiles; even if and when
this should be fixed, the lack of a Unix-like shell will cause
problems with makefile rules, especially lines of the form
C<cd sdbm && make all>, and anything using quoting.
 
S<"RISC OS"> is the proper name for the operating system, but the value
in L<C<$^O>|perlvar/$^O> is "riscos" (because we don't like shouting).
 
=head2 Other perls
 
Perl has been ported to many platforms that do not fit into any of
the categories listed above.  Some, such as AmigaOS,
QNX, Plan 9, and VOS, have been well-integrated into the standard
Perl source code kit.  You may need to see the F<ports/> directory
on CPAN for information, and possibly binaries, for the likes of:
aos, Atari ST, lynxos, riscos, Novell Netware, Tandem Guardian,
I<etc.>  (Yes, we know that some of these OSes may fall under the
Unix category, but we are not a standards body.)
 
Some approximate operating system names and their L<C<$^O>|perlvar/$^O>
values in the "OTHER" category include:
 
    OS            $^O        $Config{archname}
    ------------------------------------------
    Amiga DOS     amigaos    m68k-amigos
 
See also:
 
=over 4
 
=item *
 
Amiga, F<README.amiga> (installed as L<perlamiga>).
 
=item *
 
A free perl5-based PERL.NLM for Novell Netware is available in
precompiled binary and source code form from L<http://www.novell.com/>
as well as from CPAN.
 
=item  *
 
S<Plan 9>, F<README.plan9>
 
=back
 
=head1 FUNCTION IMPLEMENTATIONS
 
Listed below are functions that are either completely unimplemented
or else have been implemented differently on various platforms.
Preceding each description will be, in parentheses, a list of
platforms that the description applies to.
 
The list may well be incomplete, or even wrong in some places.  When
in doubt, consult the platform-specific README files in the Perl
source distribution, and any other documentation resources accompanying
a given port.
 
Be aware, moreover, that even among Unix-ish systems there are variations.
 
For many functions, you can also query L<C<%Config>|Config/DESCRIPTION>,
exported by default from the L<C<Config>|Config> module.  For example, to
check whether the platform has the L<C<lstat>|perlfunc/lstat FILEHANDLE>
call, check L<C<$Config{d_lstat}>|Config/C<d_lstat>>.  See L<Config> for a
full description of available variables.
 
=head2 Alphabetical Listing of Perl Functions
 
=over 8
 
=item -X
 
(Win32)
C<-w> only inspects the read-only file attribute (FILE_ATTRIBUTE_READONLY),
which determines whether the directory can be deleted, not whether it can
be written to. Directories always have read and write access unless denied
by discretionary access control lists (DACLs).
 
(VMS)
C<-r>, C<-w>, C<-x>, and C<-o> tell whether the file is accessible,
which may not reflect UIC-based file protections.
 
(S<RISC OS>)
C<-s> by name on an open file will return the space reserved on disk,
rather than the current extent.  C<-s> on an open filehandle returns the
current size.
 
(Win32, VMS, S<RISC OS>)
C<-R>, C<-W>, C<-X>, C<-O> are indistinguishable from C<-r>, C<-w>,
C<-x>, C<-o>.
 
(Win32, VMS, S<RISC OS>)
C<-g>, C<-k>, C<-l>, C<-u>, C<-A> are not particularly meaningful.
 
(VMS, S<RISC OS>)
C<-p> is not particularly meaningful.
 
(VMS)
C<-d> is true if passed a device spec without an explicit directory.
 
(Win32)
C<-x> (or C<-X>) determine if a file ends in one of the executable
suffixes.  C<-S> is meaningless.
 
(S<RISC OS>)
C<-x> (or C<-X>) determine if a file has an executable file type.
 
=item alarm
 
(Win32)
Emulated using timers that must be explicitly polled whenever Perl
wants to dispatch "safe signals" and therefore cannot interrupt
blocking system calls.
 
=item atan2
 
(Tru64, HP-UX 10.20)
Due to issues with various CPUs, math libraries, compilers, and standards,
results for C<atan2> may vary depending on any combination of the above.
Perl attempts to conform to the Open Group/IEEE standards for the results
returned from C<atan2>, but cannot force the issue if the system Perl is
run on does not allow it.
 
The current version of the standards for C<atan2> is available at
L<http://www.opengroup.org/onlinepubs/009695399/functions/atan2.html>.
 
=item binmode
 
(S<RISC OS>)
Meaningless.
 
(VMS)
Reopens file and restores pointer; if function fails, underlying
filehandle may be closed, or pointer may be in a different position.
 
(Win32)
The value returned by L<C<tell>|perlfunc/tell FILEHANDLE> may be affected
after the call, and the filehandle may be flushed.
 
=item chmod
 
(Win32)
Only good for changing "owner" read-write access; "group" and "other"
bits are meaningless.
 
(S<RISC OS>)
Only good for changing "owner" and "other" read-write access.
 
(VOS)
Access permissions are mapped onto VOS access-control list changes.
 
(Cygwin)
The actual permissions set depend on the value of the C<CYGWIN> variable
in the SYSTEM environment settings.
 
(Android)
Setting the exec bit on some locations (generally F</sdcard>) will return true
but not actually set the bit.
 
(VMS)
A mode argument of zero sets permissions to the user's default permission mask
rather than disabling all permissions.
 
=item chown
 
(S<Plan 9>, S<RISC OS>)
Not implemented.
 
(Win32)
Does nothing, but won't fail.
 
(VOS)
A little funky, because VOS's notion of ownership is a little funky.
 
=item chroot
 
(Win32, VMS, S<Plan 9>, S<RISC OS>, VOS)
Not implemented.
 
=item crypt
 
(Win32)
May not be available if library or source was not provided when building
perl.
 
(Android)
Not implemented.
 
=item dbmclose
 
(VMS, S<Plan 9>, VOS)
Not implemented.
 
=item dbmopen
 
(VMS, S<Plan 9>, VOS)
Not implemented.
 
=item dump
 
(S<RISC OS>)
Not useful.
 
(Cygwin, Win32)
Not supported.
 
(VMS)
Invokes VMS debugger.
 
=item exec
 
(Win32)
C<exec LIST> without the use of indirect object syntax (C<exec PROGRAM LIST>)
may fall back to trying the shell if the first C<spawn()> fails.
 
Note that the list form of exec() is emulated since the Win32 API
CreateProcess() accepts a simple string rather than an array of
command-line arguments.  This may have security implications for your
code.
 
(SunOS, Solaris, HP-UX)
Does not automatically flush output handles on some platforms.
 
(Symbian OS)
Not supported.
 
=item exit
 
(VMS)
Emulates Unix C<exit> (which considers C<exit 1> to indicate an error) by
mapping the C<1> to C<SS$_ABORT> (C<44>).  This behavior may be overridden
with the pragma L<C<use vmsish 'exit'>|vmsish/C<vmsish exit>>.  As with
the CRTL's C<exit()> function, C<exit 0> is also mapped to an exit status
of C<SS$_NORMAL> (C<1>); this mapping cannot be overridden.  Any other
argument to C<exit>
is used directly as Perl's exit status.  On VMS, unless the future
POSIX_EXIT mode is enabled, the exit code should always be a valid
VMS exit code and not a generic number.  When the POSIX_EXIT mode is
enabled, a generic number will be encoded in a method compatible with
the C library _POSIX_EXIT macro so that it can be decoded by other
programs, particularly ones written in C, like the GNV package.
 
(Solaris)
C<exit> resets file pointers, which is a problem when called
from a child process (created by L<C<fork>|perlfunc/fork>) in
L<C<BEGIN>|perlmod/BEGIN, UNITCHECK, CHECK, INIT and END>.
A workaround is to use L<C<POSIX::_exit>|POSIX/C<_exit>>.
 
    exit unless $Config{archname} =~ /\bsolaris\b/;
    require POSIX;
    POSIX::_exit(0);
 
=item fcntl
 
(Win32)
Not implemented.
 
(VMS)
Some functions available based on the version of VMS.
 
=item flock
 
(VMS, S<RISC OS>, VOS)
Not implemented.
 
=item fork
 
(AmigaOS, S<RISC OS>, VMS)
Not implemented.
 
(Win32)
Emulated using multiple interpreters.  See L<perlfork>.
 
(SunOS, Solaris, HP-UX)
Does not automatically flush output handles on some platforms.
 
=item getlogin
 
(S<RISC OS>)
Not implemented.
 
=item getpgrp
 
(Win32, VMS, S<RISC OS>)
Not implemented.
 
=item getppid
 
(Win32, S<RISC OS>)
Not implemented.
 
=item getpriority
 
(Win32, VMS, S<RISC OS>, VOS)
Not implemented.
 
=item getpwnam
 
(Win32)
Not implemented.
 
(S<RISC OS>)
Not useful.
 
=item getgrnam
 
(Win32, VMS, S<RISC OS>)
Not implemented.
 
=item getnetbyname
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item getpwuid
 
(Win32)
Not implemented.
 
(S<RISC OS>)
Not useful.
 
=item getgrgid
 
(Win32, VMS, S<RISC OS>)
Not implemented.
 
=item getnetbyaddr
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item getprotobynumber
 
(Android)
Not implemented.
 
=item getpwent
 
(Android, Win32)
Not implemented.
 
=item getgrent
 
(Android, Win32, VMS)
Not implemented.
 
=item gethostbyname
 
(S<Irix 5>)
C<gethostbyname('localhost')> does not work everywhere: you may have
to use C<gethostbyname('127.0.0.1')>.
 
=item gethostent
 
(Win32)
Not implemented.
 
=item getnetent
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item getprotoent
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item getservent
 
(Win32, S<Plan 9>)
Not implemented.
 
=item seekdir
 
(Android)
Not implemented.
 
=item sethostent
 
(Android, Win32, S<Plan 9>, S<RISC OS>)
Not implemented.
 
=item setnetent
 
(Win32, S<Plan 9>, S<RISC OS>)
Not implemented.
 
=item setprotoent
 
(Android, Win32, S<Plan 9>, S<RISC OS>)
Not implemented.
 
=item setservent
 
(S<Plan 9>, Win32, S<RISC OS>)
Not implemented.
 
=item endpwent
 
(Win32)
Not implemented.
 
(Android)
Either not implemented or a no-op.
 
=item endgrent
 
(Android, S<RISC OS>, VMS, Win32)
Not implemented.
 
=item endhostent
 
(Android, Win32)
Not implemented.
 
=item endnetent
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item endprotoent
 
(Android, Win32, S<Plan 9>)
Not implemented.
 
=item endservent
 
(S<Plan 9>, Win32)
Not implemented.
 
=item getsockopt
 
(S<Plan 9>)
Not implemented.
 
=item glob
 
This operator is implemented via the L<C<File::Glob>|File::Glob> extension
on most platforms.  See L<File::Glob> for portability information.
 
=item gmtime
 
In theory, C<gmtime> is reliable from -2**63 to 2**63-1.  However,
because work-arounds in the implementation use floating point numbers,
it will become inaccurate as the time gets larger.  This is a bug and
will be fixed in the future.
 
(VOS)
Time values are 32-bit quantities.
 
=item ioctl
 
(VMS)
Not implemented.
 
(Win32)
Available only for socket handles, and it does what the C<ioctlsocket()> call
in the Winsock API does.
 
(S<RISC OS>)
Available only for socket handles.
 
=item kill
 
(S<RISC OS>)
Not implemented, hence not useful for taint checking.
 
(Win32)
C<kill> doesn't send a signal to the identified process like it does on
Unix platforms.  Instead C<kill($sig, $pid)> terminates the process
identified by C<$pid>, and makes it exit immediately with exit status
C<$sig>.  As in Unix, if C<$sig> is 0 and the specified process exists, it
returns true without actually terminating it.
 
(Win32)
C<kill(-9, $pid)> will terminate the process specified by C<$pid> and
recursively all child processes owned by it.  This is different from
the Unix semantics, where the signal will be delivered to all
processes in the same process group as the process specified by
C<$pid>.
 
(VMS)
A pid of -1 indicating all processes on the system is not currently
supported.
 
=item link
 
(S<RISC OS>, VOS)
Not implemented.
 
(AmigaOS)
Link count not updated because hard links are not quite that hard
(They are sort of half-way between hard and soft links).
 
(Win32)
Hard links are implemented on Win32 under NTFS only. They are
natively supported on Windows 2000 and later.  On Windows NT they
are implemented using the Windows POSIX subsystem support and the
Perl process will need Administrator or Backup Operator privileges
to create hard links.
 
(VMS)
Available on 64 bit OpenVMS 8.2 and later.
 
=item localtime
 
C<localtime> has the same range as L</gmtime>, but because time zone
rules change, its accuracy for historical and future times may degrade
but usually by no more than an hour.
 
=item lstat
 
(S<RISC OS>)
Not implemented.
 
(Win32)
Return values (especially for device and inode) may be bogus.
 
=item msgctl
 
=item msgget
 
=item msgsnd
 
=item msgrcv
 
(Android, Win32, VMS, S<Plan 9>, S<RISC OS>, VOS)
Not implemented.
 
=item open
 
(S<RISC OS>)
Open modes C<|-> and C<-|> are unsupported.
 
(SunOS, Solaris, HP-UX)
Opening a process does not automatically flush output handles on some
platforms.
 
(Win32)
Both of modes C<|-> and C<-|> are supported, but the list form is
emulated since the Win32 API CreateProcess() accepts a simple string
rather than an array of arguments.  This may have security
implications for your code.
 
=item readlink
 
(Win32, VMS, S<RISC OS>)
Not implemented.
 
=item rename
 
(Win32)
Can't move directories between directories on different logical volumes.
 
=item rewinddir
 
(Win32)
Will not cause L<C<readdir>|perlfunc/readdir DIRHANDLE> to re-read the
directory stream.  The entries already read before the C<rewinddir> call
will just be returned again from a cache buffer.
 
=item select
 
(Win32, VMS)
Only implemented on sockets.
 
(S<RISC OS>)
Only reliable on sockets.
 
Note that the L<C<select FILEHANDLE>|perlfunc/select FILEHANDLE> form is
generally portable.
 
=item semctl
 
=item semget
 
=item semop
 
(Android, Win32, VMS, S<RISC OS>)
Not implemented.
 
=item setgrent
 
(Android, VMS, Win32, S<RISC OS>)
Not implemented.
 
=item setpgrp
 
(Win32, VMS, S<RISC OS>, VOS)
Not implemented.
 
=item setpriority
 
(Win32, VMS, S<RISC OS>, VOS)
Not implemented.
 
=item setpwent
 
(Android, Win32, S<RISC OS>)
Not implemented.
 
=item setsockopt
 
(S<Plan 9>)
Not implemented.
 
=item shmctl
 
=item shmget
 
=item shmread
 
=item shmwrite
 
(Android, Win32, VMS, S<RISC OS>)
Not implemented.
 
=item sleep
 
(Win32)
Emulated using synchronization functions such that it can be
interrupted by L<C<alarm>|perlfunc/alarm SECONDS>, and limited to a
maximum of 4294967 seconds, approximately 49 days.
 
=item socketpair
 
(S<RISC OS>)
Not implemented.
 
(VMS)
Available on 64 bit OpenVMS 8.2 and later.
 
=item stat
 
Platforms that do not have C<rdev>, C<blksize>, or C<blocks> will return
these as C<''>, so numeric comparison or manipulation of these fields may
cause 'not numeric' warnings.
 
(S<Mac OS X>)
C<ctime> not supported on UFS.
 
(Win32)
C<ctime> is creation time instead of inode change time.
 
(Win32)
C<dev> and C<ino> are not meaningful.
 
(VMS)
C<dev> and C<ino> are not necessarily reliable.
 
(S<RISC OS>)
C<mtime>, C<atime> and C<ctime> all return the last modification time.
C<dev> and C<ino> are not necessarily reliable.
 
(OS/2)
C<dev>, C<rdev>, C<blksize>, and C<blocks> are not available.  C<ino> is not
meaningful and will differ between stat calls on the same file.
 
(Cygwin)
Some versions of cygwin when doing a C<stat("foo")> and not finding it
may then attempt to C<stat("foo.exe")>.
 
(Win32)
C<stat> needs to open the file to determine the link count
and update attributes that may have been changed through hard links.
Setting L<C<${^WIN32_SLOPPY_STAT}>|perlvar/${^WIN32_SLOPPY_STAT}> to a
true value speeds up C<stat> by not performing this operation.
 
=item symlink
 
(Win32, S<RISC OS>)
Not implemented.
 
(VMS)
Implemented on 64 bit VMS 8.3.  VMS requires the symbolic link to be in Unix
syntax if it is intended to resolve to a valid path.
 
=item syscall
 
(Win32, VMS, S<RISC OS>, VOS)
Not implemented.
 
=item sysopen
 
(S<Mac OS>, OS/390)
The traditional C<0>, C<1>, and C<2> MODEs are implemented with different
numeric values on some systems.  The flags exported by L<C<Fcntl>|Fcntl>
(C<O_RDONLY>, C<O_WRONLY>, C<O_RDWR>) should work everywhere though.
 
=item system
 
(Win32)
As an optimization, may not call the command shell specified in
C<$ENV{PERL5SHELL}>.  C<system(1, @args)> spawns an external
process and immediately returns its process designator, without
waiting for it to terminate.  Return value may be used subsequently
in L<C<wait>|perlfunc/wait> or L<C<waitpid>|perlfunc/waitpid PID,FLAGS>.
Failure to C<spawn()> a subprocess is indicated by setting
L<C<$?>|perlvar/$?> to C<<< 255 << 8 >>>.  L<C<$?>|perlvar/$?> is set in a
way compatible with Unix (i.e. the exit status of the subprocess is
obtained by C<<< $? >> 8 >>>, as described in the documentation).
 
Note that the list form of system() is emulated since the Win32 API
CreateProcess() accepts a simple string rather than an array of
command-line arguments.  This may have security implications for your
code.
 
(S<RISC OS>)
There is no shell to process metacharacters, and the native standard is
to pass a command line terminated by "\n" "\r" or "\0" to the spawned
program.  Redirection such as C<< > foo >> is performed (if at all) by
the run time library of the spawned program.  C<system LIST> will call
the Unix emulation library's L<C<exec>|perlfunc/exec LIST> emulation,
which attempts to provide emulation of the stdin, stdout, stderr in force
in the parent, provided the child program uses a compatible version of the
emulation library.  C<system SCALAR> will call the native command line
directly and no such emulation of a child Unix program will occur.
Mileage B<will> vary.
 
(Win32)
C<system LIST> without the use of indirect object syntax (C<system PROGRAM LIST>)
may fall back to trying the shell if the first C<spawn()> fails.
 
(SunOS, Solaris, HP-UX)
Does not automatically flush output handles on some platforms.
 
(VMS)
As with Win32, C<system(1, @args)> spawns an external process and
immediately returns its process designator without waiting for the
process to terminate.  In this case the return value may be used subsequently
in L<C<wait>|perlfunc/wait> or L<C<waitpid>|perlfunc/waitpid PID,FLAGS>.
Otherwise the return value is POSIX-like (shifted up by 8 bits), which only
allows room for a made-up value derived from the severity bits of the native
32-bit condition code (unless overridden by
L<C<use vmsish 'status'>|vmsish/C<vmsish status>>).  If the native
condition code is one that has a POSIX value encoded, the POSIX value will
be decoded to extract the expected exit value.  For more details see
L<perlvms/$?>.
 
=item telldir
 
(Android)
Not implemented.
 
=item times
 
(Win32)
"Cumulative" times will be bogus.  On anything other than Windows NT
or Windows 2000, "system" time will be bogus, and "user" time is
actually the time returned by the L<C<clock()>|clock(3)> function in the C
runtime library.
 
(S<RISC OS>)
Not useful.
 
=item truncate
 
(Older versions of VMS)
Not implemented.
 
(VOS)
Truncation to same-or-shorter lengths only.
 
(Win32)
If a FILEHANDLE is supplied, it must be writable and opened in append
mode (i.e., use C<<< open(my $fh, '>>', 'filename') >>>
or C<sysopen(my $fh, ..., O_APPEND|O_RDWR)>.  If a filename is supplied, it
should not be held open elsewhere.
 
=item umask
 
Returns C<undef> where unavailable.
 
(AmigaOS)
C<umask> works but the correct permissions are set only when the file
is finally closed.
 
=item utime
 
(VMS, S<RISC OS>)
Only the modification time is updated.
 
(Win32)
May not behave as expected.  Behavior depends on the C runtime
library's implementation of L<C<utime()>|utime(2)>, and the filesystem
being used.  The FAT filesystem typically does not support an "access
time" field, and it may limit timestamps to a granularity of two seconds.
 
=item wait
 
=item waitpid
 
(Win32)
Can only be applied to process handles returned for processes spawned
using C<system(1, ...)> or pseudo processes created with
L<C<fork>|perlfunc/fork>.
 
(S<RISC OS>)
Not useful.
 
=back
 
 
=head1 Supported Platforms
 
The following platforms are known to build Perl 5.12 (as of April 2010,
its release date) from the standard source code distribution available
at L<http://www.cpan.org/src>
 
=over
 
=item Linux (x86, ARM, IA64)
 
=item HP-UX
 
=item AIX
 
=item Win32
 
=over
 
=item Windows 2000
 
=item Windows XP
 
=item Windows Server 2003
 
=item Windows Vista
 
=item Windows Server 2008
 
=item Windows 7
 
=back
 
=item Cygwin
 
Some tests are known to fail:
 
=over
 
=item *
 
F<ext/XS-APItest/t/call_checker.t> - see
L<https://github.com/Perl/perl5/issues/10750>
 
=item *
 
F<dist/I18N-Collate/t/I18N-Collate.t>
 
=item *
 
F<ext/Win32CORE/t/win32core.t> - may fail on recent cygwin installs.
 
=back
 
=item Solaris (x86, SPARC)
 
=item OpenVMS
 
=over
 
=item Alpha (7.2 and later)
 
=item I64 (8.2 and later)
 
=back
 
=item Symbian
 
=item NetBSD
 
=item FreeBSD
 
=item Debian GNU/kFreeBSD
 
=item Haiku
 
=item Irix (6.5. What else?)
 
=item OpenBSD
 
=item Dragonfly BSD
 
=item Midnight BSD
 
=item QNX Neutrino RTOS (6.5.0)
 
=item MirOS BSD
 
=item Stratus OpenVOS (17.0 or later)
 
Caveats:
 
=over
 
=item time_t issues that may or may not be fixed
 
=back
 
=item Symbian (Series 60 v3, 3.2 and 5 - what else?)
 
=item Stratus VOS / OpenVOS
 
=item AIX
 
=item Android
 
=item FreeMINT
 
Perl now builds with FreeMiNT/Atari. It fails a few tests, that needs
some investigation.
 
The FreeMiNT port uses GNU dld for loadable module capabilities. So
ensure you have that library installed when building perl.
 
=back
 
=head1 EOL Platforms
 
=head2 (Perl 5.20)
 
The following platforms were supported by a previous version of
Perl but have been officially removed from Perl's source code
as of 5.20:
 
=over
 
=item AT&T 3b1
 
=back
 
=head2 (Perl 5.14)
 
The following platforms were supported up to 5.10.  They may still
have worked in 5.12, but supporting code has been removed for 5.14:
 
=over
 
=item Windows 95
 
=item Windows 98
 
=item Windows ME
 
=item Windows NT4
 
=back
 
=head2 (Perl 5.12)
 
The following platforms were supported by a previous version of
Perl but have been officially removed from Perl's source code
as of 5.12:
 
=over
 
=item Atari MiNT
 
=item Apollo Domain/OS
 
=item Apple Mac OS 8/9
 
=item Tenon Machten
 
=back
 
 
=head1 Supported Platforms (Perl 5.8)
 
As of July 2002 (the Perl release 5.8.0), the following platforms were
able to build Perl from the standard source code distribution
available at L<http://www.cpan.org/src/>
 
        AIX
        BeOS
        BSD/OS          (BSDi)
        Cygwin
        DG/UX
        DOS DJGPP       1)
        DYNIX/ptx
        EPOC R5
        FreeBSD
        HI-UXMPP        (Hitachi) (5.8.0 worked but we didn't know it)
        HP-UX
        IRIX
        Linux
        Mac OS Classic
        Mac OS X        (Darwin)
        MPE/iX
        NetBSD
        NetWare
        NonStop-UX
        ReliantUNIX     (formerly SINIX)
        OpenBSD
        OpenVMS         (formerly VMS)
        Open UNIX       (Unixware) (since Perl 5.8.1/5.9.0)
        OS/2
        OS/400          (using the PASE) (since Perl 5.8.1/5.9.0)
        POSIX-BC        (formerly BS2000)
        QNX
        Solaris
        SunOS 4
        SUPER-UX        (NEC)
        Tru64 UNIX      (formerly DEC OSF/1, Digital UNIX)
        UNICOS
        UNICOS/mk
        UTS
        VOS / OpenVOS
        Win95/98/ME/2K/XP 2)
        WinCE
        z/OS            (formerly OS/390)
        VM/ESA
 
        1) in DOS mode either the DOS or OS/2 ports can be used
        2) compilers: Borland, MinGW (GCC), VC6
 
The following platforms worked with the previous releases (5.6 and
5.7), but we did not manage either to fix or to test these in time
for the 5.8.0 release.  There is a very good chance that many of these
will work fine with the 5.8.0.
 
        BSD/OS
        DomainOS
        Hurd
        LynxOS
        MachTen
        PowerMAX
        SCO SV
        SVR4
        Unixware
        Windows 3.1
 
Known to be broken for 5.8.0 (but 5.6.1 and 5.7.2 can be used):
 
        AmigaOS 3
 
The following platforms have been known to build Perl from source in
the past (5.005_03 and earlier), but we haven't been able to verify
their status for the current release, either because the
hardware/software platforms are rare or because we don't have an
active champion on these platforms--or both.  They used to work,
though, so go ahead and try compiling them, and let
L<https://github.com/Perl/perl5/issues> know
of any trouble.
 
        3b1
        A/UX
        ConvexOS
        CX/UX
        DC/OSx
        DDE SMES
        DOS EMX
        Dynix
        EP/IX
        ESIX
        FPS
        GENIX
        Greenhills
        ISC
        MachTen 68k
        MPC
        NEWS-OS
        NextSTEP
        OpenSTEP
        Opus
        Plan 9
        RISC/os
        SCO ODT/OSR
        Stellar
        SVR2
        TI1500
        TitanOS
        Ultrix
        Unisys Dynix
 
The following platforms have their own source code distributions and
binaries available via L<http://www.cpan.org/ports/>
 
                                Perl release
 
        OS/400 (ILE)            5.005_02
        Tandem Guardian         5.004
 
The following platforms have only binaries available via
L<http://www.cpan.org/ports/index.html> :
 
                                Perl release
 
        Acorn RISCOS            5.005_02
        AOS                     5.002
        LynxOS                  5.004_02
 
Although we do suggest that you always build your own Perl from
the source code, both for maximal configurability and for security,
in case you are in a hurry you can check
L<http://www.cpan.org/ports/index.html> for binary distributions.
 
=head1 SEE ALSO
 
L<perlaix>, L<perlamiga>, L<perlbs2000>,
L<perlcygwin>, L<perldos>,
L<perlebcdic>, L<perlfreebsd>, L<perlhurd>, L<perlhpux>, L<perlirix>,
L<perlmacos>, L<perlmacosx>,
L<perlnetware>, L<perlos2>, L<perlos390>, L<perlos400>,
L<perlplan9>, L<perlqnx>, L<perlsolaris>, L<perltru64>,
L<perlunicode>, L<perlvms>, L<perlvos>, L<perlwin32>, and L<Win32>.
 
=head1 AUTHORS / CONTRIBUTORS
 
Abigail <abigail@abigail.be>,
Charles Bailey <bailey@newman.upenn.edu>,
Graham Barr <gbarr@pobox.com>,
Tom Christiansen <tchrist@perl.com>,
Nicholas Clark <nick@ccl4.org>,
Thomas Dorner <Thomas.Dorner@start.de>,
Andy Dougherty <doughera@lafayette.edu>,
Dominic Dunlop <domo@computer.org>,
Neale Ferguson <neale@vma.tabnsw.com.au>,
David J. Fiander <davidf@mks.com>,
Paul Green <Paul.Green@stratus.com>,
M.J.T. Guy <mjtg@cam.ac.uk>,
Jarkko Hietaniemi <jhi@iki.fi>,
Luther Huffman <lutherh@stratcom.com>,
Nick Ing-Simmons <nick@ing-simmons.net>,
Andreas J. KE<ouml>nig <a.koenig@mind.de>,
Markus Laker <mlaker@contax.co.uk>,
Andrew M. Langmead <aml@world.std.com>,
Lukas Mai <l.mai@web.de>,
Larry Moore <ljmoore@freespace.net>,
Paul Moore <Paul.Moore@uk.origin-it.com>,
Chris Nandor <pudge@pobox.com>,
Matthias Neeracher <neeracher@mac.com>,
Philip Newton <pne@cpan.org>,
Gary Ng <71564.1743@CompuServe.COM>,
Tom Phoenix <rootbeer@teleport.com>,
AndrE<eacute> Pirard <A.Pirard@ulg.ac.be>,
Peter Prymmer <pvhp@forte.com>,
Hugo van der Sanden <hv@crypt0.demon.co.uk>,
Gurusamy Sarathy <gsar@activestate.com>,
Paul J. Schinder <schinder@pobox.com>,
Michael G Schwern <schwern@pobox.com>,
Dan Sugalski <dan@sidhe.org>,
Nathan Torkington <gnat@frii.com>,
John Malmberg <wb8tyw@qsl.net>