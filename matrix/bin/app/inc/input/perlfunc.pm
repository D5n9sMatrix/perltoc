=head1 NAME
X<function>
 
perlfunc - Perl builtin functions
 
=head1 DESCRIPTION
 
The functions in this section can serve as terms in an expression.
They fall into two major categories: list operators and named unary
operators.  These differ in their precedence relationship with a
following comma.  (See the precedence table in L<perlop>.)  List
operators take more than one argument, while unary operators can never
take more than one argument.  Thus, a comma terminates the argument of
a unary operator, but merely separates the arguments of a list
operator.  A unary operator generally provides scalar context to its
argument, while a list operator may provide either scalar or list
contexts for its arguments.  If it does both, scalar arguments
come first and list argument follow, and there can only ever
be one such list argument.  For instance,
L<C<splice>|/splice ARRAY,OFFSET,LENGTH,LIST> has three scalar arguments
followed by a list, whereas L<C<gethostbyname>|/gethostbyname NAME> has
four scalar arguments.
 
In the syntax descriptions that follow, list operators that expect a
list (and provide list context for elements of the list) are shown
with LIST as an argument.  Such a list may consist of any combination
of scalar arguments or list values; the list values will be included
in the list as if each individual element were interpolated at that
point in the list, forming a longer single-dimensional list value.
Commas should separate literal elements of the LIST.
 
Any function in the list below may be used either with or without
parentheses around its arguments.  (The syntax descriptions omit the
parentheses.)  If you use parentheses, the simple but occasionally
surprising rule is this: It I<looks> like a function, therefore it I<is> a
function, and precedence doesn't matter.  Otherwise it's a list
operator or unary operator, and precedence does matter.  Whitespace
between the function and left parenthesis doesn't count, so sometimes
you need to be careful:
 
    print 1+2+4;      # Prints 7.
    print(1+2) + 4;   # Prints 3.
    print (1+2)+4;    # Also prints 3!
    print +(1+2)+4;   # Prints 7.
    print ((1+2)+4);  # Prints 7.
 
If you run Perl with the L<C<use warnings>|warnings> pragma, it can warn
you about this.  For example, the third line above produces:
 
    print (...) interpreted as function at - line 1.
    Useless use of integer addition in void context at - line 1.
 
A few functions take no arguments at all, and therefore work as neither
unary nor list operators.  These include such functions as
L<C<time>|/time> and L<C<endpwent>|/endpwent>.  For example,
C<time+86_400> always means C<time() + 86_400>.
 
For functions that can be used in either a scalar or list context,
nonabortive failure is generally indicated in scalar context by
returning the undefined value, and in list context by returning the
empty list.
 
Remember the following important rule: There is B<no rule> that relates
the behavior of an expression in list context to its behavior in scalar
context, or vice versa.  It might do two totally different things.
Each operator and function decides which sort of value would be most
appropriate to return in scalar context.  Some operators return the
length of the list that would have been returned in list context.  Some
operators return the first value in the list.  Some operators return the
last value in the list.  Some operators return a count of successful
operations.  In general, they do what you want, unless you want
consistency.
X<context>
 
A named array in scalar context is quite different from what would at
first glance appear to be a list in scalar context.  You can't get a list
like C<(1,2,3)> into being in scalar context, because the compiler knows
the context at compile time.  It would generate the scalar comma operator
there, not the list concatenation version of the comma.  That means it
was never a list to start with.
 
In general, functions in Perl that serve as wrappers for system calls
("syscalls") of the same name (like L<chown(2)>, L<fork(2)>,
L<closedir(2)>, etc.) return true when they succeed and
L<C<undef>|/undef EXPR> otherwise, as is usually mentioned in the
descriptions below.  This is different from the C interfaces, which
return C<-1> on failure.  Exceptions to this rule include
L<C<wait>|/wait>, L<C<waitpid>|/waitpid PID,FLAGS>, and
L<C<syscall>|/syscall NUMBER, LIST>.  System calls also set the special
L<C<$!>|perlvar/$!> variable on failure.  Other functions do not, except
accidentally.
 
Extension modules can also hook into the Perl parser to define new
kinds of keyword-headed expression.  These may look like functions, but
may also look completely different.  The syntax following the keyword
is defined entirely by the extension.  If you are an implementor, see
L<perlapi/PL_keyword_plugin> for the mechanism.  If you are using such
a module, see the module's documentation for details of the syntax that
it defines.
 
=head2 Perl Functions by Category
X<function>
 
Here are Perl's functions (including things that look like
functions, like some keywords and named operators)
arranged by category.  Some functions appear in more
than one place.  Any warnings, including those produced by
keywords, are described in L<perldiag> and L<warnings>.
 
=over 4
 
=item Functions for SCALARs or strings
X<scalar> X<string> X<character>
 
=for Pod::Functions =String
 
L<C<chomp>|/chomp VARIABLE>, L<C<chop>|/chop VARIABLE>,
L<C<chr>|/chr NUMBER>, L<C<crypt>|/crypt PLAINTEXT,SALT>,
L<C<fc>|/fc EXPR>, L<C<hex>|/hex EXPR>,
L<C<index>|/index STR,SUBSTR,POSITION>, L<C<lc>|/lc EXPR>,
L<C<lcfirst>|/lcfirst EXPR>, L<C<length>|/length EXPR>,
L<C<oct>|/oct EXPR>, L<C<ord>|/ord EXPR>,
L<C<pack>|/pack TEMPLATE,LIST>,
L<C<qE<sol>E<sol>>|/qE<sol>STRINGE<sol>>,
L<C<qqE<sol>E<sol>>|/qqE<sol>STRINGE<sol>>, L<C<reverse>|/reverse LIST>,
L<C<rindex>|/rindex STR,SUBSTR,POSITION>,
L<C<sprintf>|/sprintf FORMAT, LIST>,
L<C<substr>|/substr EXPR,OFFSET,LENGTH,REPLACEMENT>,
L<C<trE<sol>E<sol>E<sol>>|/trE<sol>E<sol>E<sol>>, L<C<uc>|/uc EXPR>,
L<C<ucfirst>|/ucfirst EXPR>,
L<C<yE<sol>E<sol>E<sol>>|/yE<sol>E<sol>E<sol>>
 
L<C<fc>|/fc EXPR> is available only if the
L<C<"fc"> feature|feature/The 'fc' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"fc"> feature|feature/The 'fc' feature> is enabled automatically
with a C<use v5.16> (or higher) declaration in the current scope.
 
=item Regular expressions and pattern matching
X<regular expression> X<regex> X<regexp>
 
=for Pod::Functions =Regexp
 
L<C<mE<sol>E<sol>>|/mE<sol>E<sol>>, L<C<pos>|/pos SCALAR>,
L<C<qrE<sol>E<sol>>|/qrE<sol>STRINGE<sol>>,
L<C<quotemeta>|/quotemeta EXPR>,
L<C<sE<sol>E<sol>E<sol>>|/sE<sol>E<sol>E<sol>>,
L<C<split>|/split E<sol>PATTERNE<sol>,EXPR,LIMIT>,
L<C<study>|/study SCALAR>
 
=item Numeric functions
X<numeric> X<number> X<trigonometric> X<trigonometry>
 
=for Pod::Functions =Math
 
L<C<abs>|/abs VALUE>, L<C<atan2>|/atan2 Y,X>, L<C<cos>|/cos EXPR>,
L<C<exp>|/exp EXPR>, L<C<hex>|/hex EXPR>, L<C<int>|/int EXPR>,
L<C<log>|/log EXPR>, L<C<oct>|/oct EXPR>, L<C<rand>|/rand EXPR>,
L<C<sin>|/sin EXPR>, L<C<sqrt>|/sqrt EXPR>, L<C<srand>|/srand EXPR>
 
=item Functions for real @ARRAYs
X<array>
 
=for Pod::Functions =ARRAY
 
L<C<each>|/each HASH>, L<C<keys>|/keys HASH>, L<C<pop>|/pop ARRAY>,
L<C<push>|/push ARRAY,LIST>, L<C<shift>|/shift ARRAY>,
L<C<splice>|/splice ARRAY,OFFSET,LENGTH,LIST>,
L<C<unshift>|/unshift ARRAY,LIST>, L<C<values>|/values HASH>
 
=item Functions for list data
X<list>
 
=for Pod::Functions =LIST
 
L<C<grep>|/grep BLOCK LIST>, L<C<join>|/join EXPR,LIST>,
L<C<map>|/map BLOCK LIST>, L<C<qwE<sol>E<sol>>|/qwE<sol>STRINGE<sol>>,
L<C<reverse>|/reverse LIST>, L<C<sort>|/sort SUBNAME LIST>,
L<C<unpack>|/unpack TEMPLATE,EXPR>
 
=item Functions for real %HASHes
X<hash>
 
=for Pod::Functions =HASH
 
L<C<delete>|/delete EXPR>, L<C<each>|/each HASH>,
L<C<exists>|/exists EXPR>, L<C<keys>|/keys HASH>,
L<C<values>|/values HASH>
 
=item Input and output functions
X<I/O> X<input> X<output> X<dbm>
 
=for Pod::Functions =I/O
 
L<C<binmode>|/binmode FILEHANDLE, LAYER>, L<C<close>|/close FILEHANDLE>,
L<C<closedir>|/closedir DIRHANDLE>, L<C<dbmclose>|/dbmclose HASH>,
L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK>, L<C<die>|/die LIST>,
L<C<eof>|/eof FILEHANDLE>, L<C<fileno>|/fileno FILEHANDLE>,
L<C<flock>|/flock FILEHANDLE,OPERATION>, L<C<format>|/format>,
L<C<getc>|/getc FILEHANDLE>, L<C<print>|/print FILEHANDLE LIST>,
L<C<printf>|/printf FILEHANDLE FORMAT, LIST>,
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<readdir>|/readdir DIRHANDLE>, L<C<readline>|/readline EXPR>,
L<C<rewinddir>|/rewinddir DIRHANDLE>, L<C<say>|/say FILEHANDLE LIST>,
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<seekdir>|/seekdir DIRHANDLE,POS>,
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT>,
L<C<syscall>|/syscall NUMBER, LIST>,
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>,
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<tell>|/tell FILEHANDLE>, L<C<telldir>|/telldir DIRHANDLE>,
L<C<truncate>|/truncate FILEHANDLE,LENGTH>, L<C<warn>|/warn LIST>,
L<C<write>|/write FILEHANDLE>
 
L<C<say>|/say FILEHANDLE LIST> is available only if the
L<C<"say"> feature|feature/The 'say' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"say"> feature|feature/The 'say' feature> is enabled automatically
with a C<use v5.10> (or higher) declaration in the current scope.
 
=item Functions for fixed-length data or records
 
=for Pod::Functions =Binary
 
L<C<pack>|/pack TEMPLATE,LIST>,
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<syscall>|/syscall NUMBER, LIST>,
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>,
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<unpack>|/unpack TEMPLATE,EXPR>, L<C<vec>|/vec EXPR,OFFSET,BITS>
 
=item Functions for filehandles, files, or directories
X<file> X<filehandle> X<directory> X<pipe> X<link> X<symlink>
 
=for Pod::Functions =File
 
L<C<-I<X>>|/-X FILEHANDLE>, L<C<chdir>|/chdir EXPR>,
L<C<chmod>|/chmod LIST>, L<C<chown>|/chown LIST>,
L<C<chroot>|/chroot FILENAME>,
L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR>, L<C<glob>|/glob EXPR>,
L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>,
L<C<link>|/link OLDFILE,NEWFILE>, L<C<lstat>|/lstat FILEHANDLE>,
L<C<mkdir>|/mkdir FILENAME,MODE>, L<C<open>|/open FILEHANDLE,MODE,EXPR>,
L<C<opendir>|/opendir DIRHANDLE,EXPR>, L<C<readlink>|/readlink EXPR>,
L<C<rename>|/rename OLDNAME,NEWNAME>, L<C<rmdir>|/rmdir FILENAME>,
L<C<select>|/select FILEHANDLE>, L<C<stat>|/stat FILEHANDLE>,
L<C<symlink>|/symlink OLDFILE,NEWFILE>,
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE>,
L<C<umask>|/umask EXPR>, L<C<unlink>|/unlink LIST>,
L<C<utime>|/utime LIST>
 
=item Keywords related to the control flow of your Perl program
X<control flow>
 
=for Pod::Functions =Flow
 
L<C<break>|/break>, L<C<caller>|/caller EXPR>,
L<C<continue>|/continue BLOCK>, L<C<die>|/die LIST>, L<C<do>|/do BLOCK>,
L<C<dump>|/dump LABEL>, L<C<eval>|/eval EXPR>,
L<C<evalbytes>|/evalbytes EXPR>, L<C<exit>|/exit EXPR>,
L<C<__FILE__>|/__FILE__>, L<C<goto>|/goto LABEL>,
L<C<last>|/last LABEL>, L<C<__LINE__>|/__LINE__>,
L<C<next>|/next LABEL>, L<C<__PACKAGE__>|/__PACKAGE__>,
L<C<redo>|/redo LABEL>, L<C<return>|/return EXPR>,
L<C<sub>|/sub NAME BLOCK>, L<C<__SUB__>|/__SUB__>,
L<C<wantarray>|/wantarray>
 
L<C<break>|/break> is available only if you enable the experimental
L<C<"switch"> feature|feature/The 'switch' feature> or use the C<CORE::>
prefix.  The L<C<"switch"> feature|feature/The 'switch' feature> also
enables the C<default>, C<given> and C<when> statements, which are
documented in L<perlsyn/"Switch Statements">.
The L<C<"switch"> feature|feature/The 'switch' feature> is enabled
automatically with a C<use v5.10> (or higher) declaration in the current
scope.  In Perl v5.14 and earlier, L<C<continue>|/continue BLOCK>
required the L<C<"switch"> feature|feature/The 'switch' feature>, like
the other keywords.
 
L<C<evalbytes>|/evalbytes EXPR> is only available with the
L<C<"evalbytes"> feature|feature/The 'unicode_eval' and 'evalbytes' features>
(see L<feature>) or if prefixed with C<CORE::>.  L<C<__SUB__>|/__SUB__>
is only available with the
L<C<"current_sub"> feature|feature/The 'current_sub' feature> or if
prefixed with C<CORE::>.  Both the
L<C<"evalbytes">|feature/The 'unicode_eval' and 'evalbytes' features>
and L<C<"current_sub">|feature/The 'current_sub' feature> features are
enabled automatically with a C<use v5.16> (or higher) declaration in the
current scope.
 
=item Keywords related to scoping
 
=for Pod::Functions =Namespace
 
L<C<caller>|/caller EXPR>, L<C<import>|/import LIST>,
L<C<local>|/local EXPR>, L<C<my>|/my VARLIST>, L<C<our>|/our VARLIST>,
L<C<package>|/package NAMESPACE>, L<C<state>|/state VARLIST>,
L<C<use>|/use Module VERSION LIST>
 
L<C<state>|/state VARLIST> is available only if the
L<C<"state"> feature|feature/The 'state' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"state"> feature|feature/The 'state' feature> is enabled
automatically with a C<use v5.10> (or higher) declaration in the current
scope.
 
=item Miscellaneous functions
 
=for Pod::Functions =Misc
 
L<C<defined>|/defined EXPR>, L<C<formline>|/formline PICTURE,LIST>,
L<C<lock>|/lock THING>, L<C<prototype>|/prototype FUNCTION>,
L<C<reset>|/reset EXPR>, L<C<scalar>|/scalar EXPR>,
L<C<undef>|/undef EXPR>
 
=item Functions for processes and process groups
X<process> X<pid> X<process id>
 
=for Pod::Functions =Process
 
L<C<alarm>|/alarm SECONDS>, L<C<exec>|/exec LIST>, L<C<fork>|/fork>,
L<C<getpgrp>|/getpgrp PID>, L<C<getppid>|/getppid>,
L<C<getpriority>|/getpriority WHICH,WHO>, L<C<kill>|/kill SIGNAL, LIST>,
L<C<pipe>|/pipe READHANDLE,WRITEHANDLE>,
L<C<qxE<sol>E<sol>>|/qxE<sol>STRINGE<sol>>,
L<C<readpipe>|/readpipe EXPR>, L<C<setpgrp>|/setpgrp PID,PGRP>,
L<C<setpriority>|/setpriority WHICH,WHO,PRIORITY>,
L<C<sleep>|/sleep EXPR>, L<C<system>|/system LIST>, L<C<times>|/times>,
L<C<wait>|/wait>, L<C<waitpid>|/waitpid PID,FLAGS>
 
=item Keywords related to Perl modules
X<module>
 
=for Pod::Functions =Modules
 
L<C<do>|/do EXPR>, L<C<import>|/import LIST>,
L<C<no>|/no MODULE VERSION LIST>, L<C<package>|/package NAMESPACE>,
L<C<require>|/require VERSION>, L<C<use>|/use Module VERSION LIST>
 
=item Keywords related to classes and object-orientation
X<object> X<class> X<package>
 
=for Pod::Functions =Objects
 
L<C<bless>|/bless REF,CLASSNAME>, L<C<dbmclose>|/dbmclose HASH>,
L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK>,
L<C<package>|/package NAMESPACE>, L<C<ref>|/ref EXPR>,
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST>, L<C<tied>|/tied VARIABLE>,
L<C<untie>|/untie VARIABLE>, L<C<use>|/use Module VERSION LIST>
 
=item Low-level socket functions
X<socket> X<sock>
 
=for Pod::Functions =Socket
 
L<C<accept>|/accept NEWSOCKET,GENERICSOCKET>,
L<C<bind>|/bind SOCKET,NAME>, L<C<connect>|/connect SOCKET,NAME>,
L<C<getpeername>|/getpeername SOCKET>,
L<C<getsockname>|/getsockname SOCKET>,
L<C<getsockopt>|/getsockopt SOCKET,LEVEL,OPTNAME>,
L<C<listen>|/listen SOCKET,QUEUESIZE>,
L<C<recv>|/recv SOCKET,SCALAR,LENGTH,FLAGS>,
L<C<send>|/send SOCKET,MSG,FLAGS,TO>,
L<C<setsockopt>|/setsockopt SOCKET,LEVEL,OPTNAME,OPTVAL>,
L<C<shutdown>|/shutdown SOCKET,HOW>,
L<C<socket>|/socket SOCKET,DOMAIN,TYPE,PROTOCOL>,
L<C<socketpair>|/socketpair SOCKET1,SOCKET2,DOMAIN,TYPE,PROTOCOL>
 
=item System V interprocess communication functions
X<IPC> X<System V> X<semaphore> X<shared memory> X<memory> X<message>
 
=for Pod::Functions =SysV
 
L<C<msgctl>|/msgctl ID,CMD,ARG>, L<C<msgget>|/msgget KEY,FLAGS>,
L<C<msgrcv>|/msgrcv ID,VAR,SIZE,TYPE,FLAGS>,
L<C<msgsnd>|/msgsnd ID,MSG,FLAGS>,
L<C<semctl>|/semctl ID,SEMNUM,CMD,ARG>,
L<C<semget>|/semget KEY,NSEMS,FLAGS>, L<C<semop>|/semop KEY,OPSTRING>,
L<C<shmctl>|/shmctl ID,CMD,ARG>, L<C<shmget>|/shmget KEY,SIZE,FLAGS>,
L<C<shmread>|/shmread ID,VAR,POS,SIZE>,
L<C<shmwrite>|/shmwrite ID,STRING,POS,SIZE>
 
=item Fetching user and group info
X<user> X<group> X<password> X<uid> X<gid>  X<passwd> X</etc/passwd>
 
=for Pod::Functions =User
 
L<C<endgrent>|/endgrent>, L<C<endhostent>|/endhostent>,
L<C<endnetent>|/endnetent>, L<C<endpwent>|/endpwent>,
L<C<getgrent>|/getgrent>, L<C<getgrgid>|/getgrgid GID>,
L<C<getgrnam>|/getgrnam NAME>, L<C<getlogin>|/getlogin>,
L<C<getpwent>|/getpwent>, L<C<getpwnam>|/getpwnam NAME>,
L<C<getpwuid>|/getpwuid UID>, L<C<setgrent>|/setgrent>,
L<C<setpwent>|/setpwent>
 
=item Fetching network info
X<network> X<protocol> X<host> X<hostname> X<IP> X<address> X<service>
 
=for Pod::Functions =Network
 
L<C<endprotoent>|/endprotoent>, L<C<endservent>|/endservent>,
L<C<gethostbyaddr>|/gethostbyaddr ADDR,ADDRTYPE>,
L<C<gethostbyname>|/gethostbyname NAME>, L<C<gethostent>|/gethostent>,
L<C<getnetbyaddr>|/getnetbyaddr ADDR,ADDRTYPE>,
L<C<getnetbyname>|/getnetbyname NAME>, L<C<getnetent>|/getnetent>,
L<C<getprotobyname>|/getprotobyname NAME>,
L<C<getprotobynumber>|/getprotobynumber NUMBER>,
L<C<getprotoent>|/getprotoent>,
L<C<getservbyname>|/getservbyname NAME,PROTO>,
L<C<getservbyport>|/getservbyport PORT,PROTO>,
L<C<getservent>|/getservent>, L<C<sethostent>|/sethostent STAYOPEN>,
L<C<setnetent>|/setnetent STAYOPEN>,
L<C<setprotoent>|/setprotoent STAYOPEN>,
L<C<setservent>|/setservent STAYOPEN>
 
=item Time-related functions
X<time> X<date>
 
=for Pod::Functions =Time
 
L<C<gmtime>|/gmtime EXPR>, L<C<localtime>|/localtime EXPR>,
L<C<time>|/time>, L<C<times>|/times>
 
=item Non-function keywords
 
=for Pod::Functions =!Non-functions
 
C<and>, C<AUTOLOAD>, C<BEGIN>, C<CHECK>, C<cmp>, C<CORE>, C<__DATA__>,
C<default>, C<DESTROY>, C<else>, C<elseif>, C<elsif>, C<END>, C<__END__>,
C<eq>, C<for>, C<foreach>, C<ge>, C<given>, C<gt>, C<if>, C<INIT>, C<le>,
C<lt>, C<ne>, C<not>, C<or>, C<UNITCHECK>, C<unless>, C<until>, C<when>,
C<while>, C<x>, C<xor>
 
=back
 
=head2 Portability
X<portability> X<Unix> X<portable>
 
Perl was born in Unix and can therefore access all common Unix
system calls.  In non-Unix environments, the functionality of some
Unix system calls may not be available or details of the available
functionality may differ slightly.  The Perl functions affected
by this are:
 
L<C<-I<X>>|/-X FILEHANDLE>, L<C<binmode>|/binmode FILEHANDLE, LAYER>,
L<C<chmod>|/chmod LIST>, L<C<chown>|/chown LIST>,
L<C<chroot>|/chroot FILENAME>, L<C<crypt>|/crypt PLAINTEXT,SALT>,
L<C<dbmclose>|/dbmclose HASH>, L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK>,
L<C<dump>|/dump LABEL>, L<C<endgrent>|/endgrent>,
L<C<endhostent>|/endhostent>, L<C<endnetent>|/endnetent>,
L<C<endprotoent>|/endprotoent>, L<C<endpwent>|/endpwent>,
L<C<endservent>|/endservent>, L<C<exec>|/exec LIST>,
L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR>,
L<C<flock>|/flock FILEHANDLE,OPERATION>, L<C<fork>|/fork>,
L<C<getgrent>|/getgrent>, L<C<getgrgid>|/getgrgid GID>,
L<C<gethostbyname>|/gethostbyname NAME>, L<C<gethostent>|/gethostent>,
L<C<getlogin>|/getlogin>,
L<C<getnetbyaddr>|/getnetbyaddr ADDR,ADDRTYPE>,
L<C<getnetbyname>|/getnetbyname NAME>, L<C<getnetent>|/getnetent>,
L<C<getppid>|/getppid>, L<C<getpgrp>|/getpgrp PID>,
L<C<getpriority>|/getpriority WHICH,WHO>,
L<C<getprotobynumber>|/getprotobynumber NUMBER>,
L<C<getprotoent>|/getprotoent>, L<C<getpwent>|/getpwent>,
L<C<getpwnam>|/getpwnam NAME>, L<C<getpwuid>|/getpwuid UID>,
L<C<getservbyport>|/getservbyport PORT,PROTO>,
L<C<getservent>|/getservent>,
L<C<getsockopt>|/getsockopt SOCKET,LEVEL,OPTNAME>,
L<C<glob>|/glob EXPR>, L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>,
L<C<kill>|/kill SIGNAL, LIST>, L<C<link>|/link OLDFILE,NEWFILE>,
L<C<lstat>|/lstat FILEHANDLE>, L<C<msgctl>|/msgctl ID,CMD,ARG>,
L<C<msgget>|/msgget KEY,FLAGS>,
L<C<msgrcv>|/msgrcv ID,VAR,SIZE,TYPE,FLAGS>,
L<C<msgsnd>|/msgsnd ID,MSG,FLAGS>, L<C<open>|/open FILEHANDLE,MODE,EXPR>,
L<C<pipe>|/pipe READHANDLE,WRITEHANDLE>, L<C<readlink>|/readlink EXPR>,
L<C<rename>|/rename OLDNAME,NEWNAME>,
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT>,
L<C<semctl>|/semctl ID,SEMNUM,CMD,ARG>,
L<C<semget>|/semget KEY,NSEMS,FLAGS>, L<C<semop>|/semop KEY,OPSTRING>,
L<C<setgrent>|/setgrent>, L<C<sethostent>|/sethostent STAYOPEN>,
L<C<setnetent>|/setnetent STAYOPEN>, L<C<setpgrp>|/setpgrp PID,PGRP>,
L<C<setpriority>|/setpriority WHICH,WHO,PRIORITY>,
L<C<setprotoent>|/setprotoent STAYOPEN>, L<C<setpwent>|/setpwent>,
L<C<setservent>|/setservent STAYOPEN>,
L<C<setsockopt>|/setsockopt SOCKET,LEVEL,OPTNAME,OPTVAL>,
L<C<shmctl>|/shmctl ID,CMD,ARG>, L<C<shmget>|/shmget KEY,SIZE,FLAGS>,
L<C<shmread>|/shmread ID,VAR,POS,SIZE>,
L<C<shmwrite>|/shmwrite ID,STRING,POS,SIZE>,
L<C<socket>|/socket SOCKET,DOMAIN,TYPE,PROTOCOL>,
L<C<socketpair>|/socketpair SOCKET1,SOCKET2,DOMAIN,TYPE,PROTOCOL>,
L<C<stat>|/stat FILEHANDLE>, L<C<symlink>|/symlink OLDFILE,NEWFILE>,
L<C<syscall>|/syscall NUMBER, LIST>,
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE>,
L<C<system>|/system LIST>, L<C<times>|/times>,
L<C<truncate>|/truncate FILEHANDLE,LENGTH>, L<C<umask>|/umask EXPR>,
L<C<unlink>|/unlink LIST>, L<C<utime>|/utime LIST>, L<C<wait>|/wait>,
L<C<waitpid>|/waitpid PID,FLAGS>
 
For more information about the portability of these functions, see
L<perlport> and other available platform-specific documentation.
 
=head2 Alphabetical Listing of Perl Functions
 
=over
 
=item -X FILEHANDLE
X<-r>X<-w>X<-x>X<-o>X<-R>X<-W>X<-X>X<-O>X<-e>X<-z>X<-s>X<-f>X<-d>X<-l>X<-p>
X<-S>X<-b>X<-c>X<-t>X<-u>X<-g>X<-k>X<-T>X<-B>X<-M>X<-A>X<-C>
 
=item -X EXPR
 
=item -X DIRHANDLE
 
=item -X
 
=for Pod::Functions a file test (-r, -x, etc)
 
A file test, where X is one of the letters listed below.  This unary
operator takes one argument, either a filename, a filehandle, or a dirhandle,
and tests the associated file to see if something is true about it.  If the
argument is omitted, tests L<C<$_>|perlvar/$_>, except for C<-t>, which
tests STDIN.  Unless otherwise documented, it returns C<1> for true and
C<''> for false.  If the file doesn't exist or can't be examined, it
returns L<C<undef>|/undef EXPR> and sets L<C<$!>|perlvar/$!> (errno).
With the exception of the C<-l> test they all follow symbolic links
because they use C<stat()> and not C<lstat()> (so dangling symlinks can't
be examined and will therefore report failure).
 
Despite the funny names, precedence is the same as any other named unary
operator.  The operator may be any of:
 
    -r  File is readable by effective uid/gid.
    -w  File is writable by effective uid/gid.
    -x  File is executable by effective uid/gid.
    -o  File is owned by effective uid.
 
    -R  File is readable by real uid/gid.
    -W  File is writable by real uid/gid.
    -X  File is executable by real uid/gid.
    -O  File is owned by real uid.
 
    -e  File exists.
    -z  File has zero size (is empty).
    -s  File has nonzero size (returns size in bytes).
 
    -f  File is a plain file.
    -d  File is a directory.
    -l  File is a symbolic link (false if symlinks aren't
        supported by the file system).
    -p  File is a named pipe (FIFO), or Filehandle is a pipe.
    -S  File is a socket.
    -b  File is a block special file.
    -c  File is a character special file.
    -t  Filehandle is opened to a tty.
 
    -u  File has setuid bit set.
    -g  File has setgid bit set.
    -k  File has sticky bit set.
 
    -T  File is an ASCII or UTF-8 text file (heuristic guess).
    -B  File is a "binary" file (opposite of -T).
 
    -M  Script start time minus file modification time, in days.
    -A  Same for access time.
    -C  Same for inode change time (Unix, may differ for other
        platforms)
 
Example:
 
    while (<>) {
        chomp;
        next unless -f $_;  # ignore specials
        #...
    }
 
Note that C<-s/a/b/> does not do a negated substitution.  Saying
C<-exp($foo)> still works as expected, however: only single letters
following a minus are interpreted as file tests.
 
These operators are exempt from the "looks like a function rule" described
above.  That is, an opening parenthesis after the operator does not affect
how much of the following code constitutes the argument.  Put the opening
parentheses before the operator to separate it from code that follows (this
applies only to operators with higher precedence than unary operators, of
course):
 
    -s($file) + 1024   # probably wrong; same as -s($file + 1024)
    (-s $file) + 1024  # correct
 
The interpretation of the file permission operators C<-r>, C<-R>,
C<-w>, C<-W>, C<-x>, and C<-X> is by default based solely on the mode
of the file and the uids and gids of the user.  There may be other
reasons you can't actually read, write, or execute the file: for
example network filesystem access controls, ACLs (access control lists),
read-only filesystems, and unrecognized executable formats.  Note
that the use of these six specific operators to verify if some operation
is possible is usually a mistake, because it may be open to race
conditions.
 
Also note that, for the superuser on the local filesystems, the C<-r>,
C<-R>, C<-w>, and C<-W> tests always return 1, and C<-x> and C<-X> return 1
if any execute bit is set in the mode.  Scripts run by the superuser
may thus need to do a L<C<stat>|/stat FILEHANDLE> to determine the
actual mode of the file, or temporarily set their effective uid to
something else.
 
If you are using ACLs, there is a pragma called L<C<filetest>|filetest>
that may produce more accurate results than the bare
L<C<stat>|/stat FILEHANDLE> mode bits.
When under C<use filetest 'access'>, the above-mentioned filetests
test whether the permission can(not) be granted using the L<access(2)>
family of system calls.  Also note that the C<-x> and C<-X> tests may
under this pragma return true even if there are no execute permission
bits set (nor any extra execute permission ACLs).  This strangeness is
due to the underlying system calls' definitions.  Note also that, due to
the implementation of C<use filetest 'access'>, the C<_> special
filehandle won't cache the results of the file tests when this pragma is
in effect.  Read the documentation for the L<C<filetest>|filetest>
pragma for more information.
 
The C<-T> and C<-B> tests work as follows.  The first block or so of
the file is examined to see if it is valid UTF-8 that includes non-ASCII
characters.  If so, it's a C<-T> file.  Otherwise, that same portion of
the file is examined for odd characters such as strange control codes or
characters with the high bit set.  If more than a third of the
characters are strange, it's a C<-B> file; otherwise it's a C<-T> file.
Also, any file containing a zero byte in the examined portion is
considered a binary file.  (If executed within the scope of a L<S<use
locale>|perllocale> which includes C<LC_CTYPE>, odd characters are
anything that isn't a printable nor space in the current locale.)  If
C<-T> or C<-B> is used on a filehandle, the current IO buffer is
examined
rather than the first block.  Both C<-T> and C<-B> return true on an empty
file, or a file at EOF when testing a filehandle.  Because you have to
read a file to do the C<-T> test, on most occasions you want to use a C<-f>
against the file first, as in C<next unless -f $file && -T $file>.
 
If any of the file tests (or either the L<C<stat>|/stat FILEHANDLE> or
L<C<lstat>|/lstat FILEHANDLE> operator) is given the special filehandle
consisting of a solitary underline, then the stat structure of the
previous file test (or L<C<stat>|/stat FILEHANDLE> operator) is used,
saving a system call.  (This doesn't work with C<-t>, and you need to
remember that L<C<lstat>|/lstat FILEHANDLE> and C<-l> leave values in
the stat structure for the symbolic link, not the real file.)  (Also, if
the stat buffer was filled by an L<C<lstat>|/lstat FILEHANDLE> call,
C<-T> and C<-B> will reset it with the results of C<stat _>).
Example:
 
    print "Can do.\n" if -r $a || -w _ || -x _;
 
    stat($filename);
    print "Readable\n" if -r _;
    print "Writable\n" if -w _;
    print "Executable\n" if -x _;
    print "Setuid\n" if -u _;
    print "Setgid\n" if -g _;
    print "Sticky\n" if -k _;
    print "Text\n" if -T _;
    print "Binary\n" if -B _;
 
As of Perl 5.10.0, as a form of purely syntactic sugar, you can stack file
test operators, in a way that C<-f -w -x $file> is equivalent to
C<-x $file && -w _ && -f _>.  (This is only fancy syntax: if you use
the return value of C<-f $file> as an argument to another filetest
operator, no special magic will happen.)
 
Portability issues: L<perlport/-X>.
 
To avoid confusing would-be users of your code with mysterious
syntax errors, put something like this at the top of your script:
 
    use 5.010;  # so filetest ops can stack
 
=item abs VALUE
X<abs> X<absolute>
 
=item abs
 
=for Pod::Functions absolute value function
 
Returns the absolute value of its argument.
If VALUE is omitted, uses L<C<$_>|perlvar/$_>.
 
=item accept NEWSOCKET,GENERICSOCKET
X<accept>
 
=for Pod::Functions accept an incoming socket connect
 
Accepts an incoming socket connect, just as L<accept(2)>
does.  Returns the packed address if it succeeded, false otherwise.
See the example in L<perlipc/"Sockets: Client/Server Communication">.
 
On systems that support a close-on-exec flag on files, the flag will
be set for the newly opened file descriptor, as determined by the
value of L<C<$^F>|perlvar/$^F>.  See L<perlvar/$^F>.
 
=item alarm SECONDS
X<alarm>
X<SIGALRM>
X<timer>
 
=item alarm
 
=for Pod::Functions schedule a SIGALRM
 
Arranges to have a SIGALRM delivered to this process after the
specified number of wallclock seconds has elapsed.  If SECONDS is not
specified, the value stored in L<C<$_>|perlvar/$_> is used.  (On some
machines, unfortunately, the elapsed time may be up to one second less
or more than you specified because of how seconds are counted, and
process scheduling may delay the delivery of the signal even further.)
 
Only one timer may be counting at once.  Each call disables the
previous timer, and an argument of C<0> may be supplied to cured the
previous timer without starting a new one.  The returned value is the
amount of time remaining on the previous timer.
 
For delays of finer granularity than one second, the L<Time::HiRes> module
(from CPAN, and starting from Perl 5.8 part of the standard
distribution) provides
L<C<ualarm>|Time::HiRes/ualarm ( $useconds [, $interval_useconds ] )>.
You may also use Perl's four-argument version of
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> leaving the first three
arguments undefined, or you might be able to use the
L<C<syscall>|/syscall NUMBER, LIST> interface to access L<setitimer(2)>
if your system supports it.  See L<perlfaq8> for details.
 
It is usually a mistake to intermix L<C<alarm>|/alarm SECONDS> and
L<C<sleep>|/sleep EXPR> calls, because L<C<sleep>|/sleep EXPR> may be
internally implemented on your system with L<C<alarm>|/alarm SECONDS>.
 
If you want to use L<C<alarm>|/alarm SECONDS> to time out a system call
you need to use an L<C<eval>|/eval EXPR>/L<C<die>|/die LIST> pair.  You
can't rely on the alarm causing the system call to fail with
L<C<$!>|perlvar/$!> set to C<EINTR> because Perl sets up signal handlers
to restart system calls on some systems.  Using
L<C<eval>|/eval EXPR>/L<C<die>|/die LIST> always works, modulo the
caveats given in L<perlipc/"Signals">.
 
    eval {
        local $SIG{ALRM} = sub { die "alarm\n" }; # NB: \n required
        alarm $timeout;
        my $nread = sysread $socket, $buffer, $size;
        alarm 0;
    };
    if ($@) {
        die unless $@ eq "alarm\n";   # propagate unexpected errors
        # timed out
    }
    else {
        # didn't
    }
 
For more information see L<perlipc>.
 
Portability issues: L<perlport/alarm>.
 
=item atan2 Y,X
X<atan2> X<arctangent> X<tan> X<tangent>
 
=for Pod::Functions arctangent of Y/X in the range -PI to PI
 
Returns the arctangent of Y/X in the range -PI to PI.
 
For the tangent operation, you may use the
L<C<Math::Trig::tan>|Math::Trig/B<tan>> function, or use the familiar
relation:
 
    sub tan { sin($_[0]) / cos($_[0])  }
 
The return value for C<atan2(0,0)> is implementation-defined; consult
your L<atan2(3)> manpage for more information.
 
Portability issues: L<perlport/atan2>.
 
=item bind SOCKET,NAME
X<bind>
 
=for Pod::Functions binds an address to a socket
 
Binds a network address to a socket, just as L<bind(2)>
does.  Returns true if it succeeded, false otherwise.  NAME should be a
packed address of the appropriate type for the socket.  See the examples in
L<perlipc/"Sockets: Client/Server Communication">.
 
=item binmode FILEHANDLE, LAYER
X<binmode> X<binary> X<text> X<DOS> X<Windows>
 
=item binmode FILEHANDLE
 
=for Pod::Functions prepare binary files for I/O
 
Arranges for FILEHANDLE to be read or written in "binary" or "text"
mode on systems where the run-time libraries distinguish between
binary and text files.  If FILEHANDLE is an expression, the value is
taken as the name of the filehandle.  Returns true on success,
otherwise it returns L<C<undef>|/undef EXPR> and sets
L<C<$!>|perlvar/$!> (errno).
 
On some systems (in general, DOS- and Windows-based systems)
L<C<binmode>|/binmode FILEHANDLE, LAYER> is necessary when you're not
working with a text file.  For the sake of portability it is a good idea
always to use it when appropriate, and never to use it when it isn't
appropriate.  Also, people can set their I/O to be by default
UTF8-encoded Unicode, not bytes.
 
In other words: regardless of platform, use
L<C<binmode>|/binmode FILEHANDLE, LAYER> on binary data, like images,
for example.
 
If LAYER is present it is a single string, but may contain multiple
directives.  The directives alter the behaviour of the filehandle.
When LAYER is present, using binmode on a text file makes sense.
 
If LAYER is omitted or specified as C<:raw> the filehandle is made
suitable for passing binary data.  This includes turning off possible CRLF
translation and marking it as bytes (as opposed to Unicode characters).
Note that, despite what may be implied in I<"Programming Perl"> (the
Camel, 3rd edition) or elsewhere, C<:raw> is I<not> simply the inverse of C<:crlf>.
Other layers that would affect the binary nature of the stream are
I<also> disabled.  See L<PerlIO>, and the discussion about the PERLIO
environment variable in L<perlrun|perlrun/PERLIO>.
 
The C<:bytes>, C<:crlf>, C<:utf8>, and any other directives of the
form C<:...>, are called I/O I<layers>.  The L<open> pragma can be used to
establish default I/O layers.
 
I<The LAYER parameter of the L<C<binmode>|/binmode FILEHANDLE, LAYER>
function is described as "DISCIPLINE" in "Programming Perl, 3rd
Edition".  However, since the publishing of this book, by many known as
"Camel III", the consensus of the naming of this functionality has moved
from "discipline" to "layer".  All documentation of this version of Perl
therefore refers to "layers" rather than to "disciplines".  Now back to
the regularly scheduled documentation...>
 
To mark FILEHANDLE as UTF-8, use C<:utf8> or C<:encoding(UTF-8)>.
C<:utf8> just marks the data as UTF-8 without further checking,
while C<:encoding(UTF-8)> checks the data for actually being valid
UTF-8.  More details can be found in L<PerlIO::encoding>.
 
In general, L<C<binmode>|/binmode FILEHANDLE, LAYER> should be called
after L<C<open>|/open FILEHANDLE,MODE,EXPR> but before any I/O is done on the
filehandle.  Calling L<C<binmode>|/binmode FILEHANDLE, LAYER> normally
flushes any pending buffered output data (and perhaps pending input
data) on the handle.  An exception to this is the C<:encoding> layer
that changes the default character encoding of the handle.
The C<:encoding> layer sometimes needs to be called in
mid-stream, and it doesn't flush the stream.  C<:encoding>
also implicitly pushes on top of itself the C<:utf8> layer because
internally Perl operates on UTF8-encoded Unicode characters.
 
The operating system, device drivers, C libraries, and Perl run-time
system all conspire to let the programmer treat a single
character (C<\n>) as the line terminator, irrespective of external
representation.  On many operating systems, the native text file
representation matches the internal representation, but on some
platforms the external representation of C<\n> is made up of more than
one character.
 
All variants of Unix, Mac OS (old and new), and Stream_LF files on VMS use
a single character to end each line in the external representation of text
(even though that single character is CARRIAGE RETURN on old, pre-Darwin
flavors of Mac OS, and is LINE FEED on Unix and most VMS files).  In other
systems like OS/2, DOS, and the various flavors of MS-Windows, your program
sees a C<\n> as a simple C<\cJ>, but what's stored in text files are the
two characters C<\cM\cJ>.  That means that if you don't use
L<C<binmode>|/binmode FILEHANDLE, LAYER> on these systems, C<\cM\cJ>
sequences on disk will be converted to C<\n> on input, and any C<\n> in
your program will be converted back to C<\cM\cJ> on output.  This is
what you want for text files, but it can be disastrous for binary files.
 
Another consequence of using L<C<binmode>|/binmode FILEHANDLE, LAYER>
(on some systems) is that special end-of-file markers will be seen as
part of the data stream.  For systems from the Microsoft family this
means that, if your binary data contain C<\cZ>, the I/O subsystem will
regard it as the end of the file, unless you use
L<C<binmode>|/binmode FILEHANDLE, LAYER>.
 
L<C<binmode>|/binmode FILEHANDLE, LAYER> is important not only for
L<C<readline>|/readline EXPR> and L<C<print>|/print FILEHANDLE LIST>
operations, but also when using
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET> and
L<C<tell>|/tell FILEHANDLE> (see L<perlport> for more details).  See the
L<C<$E<sol>>|perlvar/$E<sol>> and L<C<$\>|perlvar/$\> variables in
L<perlvar> for how to manually set your input and output
line-termination sequences.
 
Portability issues: L<perlport/binmode>.
 
=item bless REF,CLASSNAME
X<bless>
 
=item bless REF
 
=for Pod::Functions create an object
 
This function tells the thingy referenced by REF that it is now an object
in the CLASSNAME package.  If CLASSNAME is an empty string, it is
interpreted as referring to the C<main> package.
If CLASSNAME is omitted, the current package
is used.  Because a L<C<bless>|/bless REF,CLASSNAME> is often the last
thing in a constructor, it returns the reference for convenience.
Always use the two-argument version if a derived class might inherit the
method doing the blessing.  See L<perlobj> for more about the blessing
(and blessings) of objects.
 
Consider always blessing objects in CLASSNAMEs that are mixed case.
Namespaces with all lowercase names are considered reserved for
Perl pragmas.  Builtin types have all uppercase names.  To prevent
confusion, you may wish to avoid such package names as well.
It is advised to avoid the class name C<0>, because much code erroneously
uses the result of L<C<ref>|/ref EXPR> as a truth value.
 
See L<perlmod/"Perl Modules">.
 
=item break
 
=for Pod::Functions +switch break out of a C<given> block
 
Break out of a C<given> block.
 
L<C<break>|/break> is available only if the
L<C<"switch"> feature|feature/The 'switch' feature> is enabled or if it
is prefixed with C<CORE::>. The
L<C<"switch"> feature|feature/The 'switch' feature> is enabled
automatically with a C<use v5.10> (or higher) declaration in the current
scope.
 
=item caller EXPR
X<caller> X<call stack> X<stack> X<stack trace>
 
=item caller
 
=for Pod::Functions get context of the current subroutine call
 
Returns the context of the current pure perl subroutine call.  In scalar
context, returns the caller's package name if there I<is> a caller (that is, if
we're in a subroutine or L<C<eval>|/eval EXPR> or
L<C<require>|/require VERSION>) and the undefined value otherwise.
caller never returns XS subs and they are skipped.  The next pure perl
sub will appear instead of the XS sub in caller's return values.  In
list context, caller returns
 
       # 0         1          2
    my ($package, $filename, $line) = caller;
 
Like L<C<__FILE__>|/__FILE__> and L<C<__LINE__>|/__LINE__>, the filename and
line number returned here may be altered by the mechanism described at
L<perlsyn/"Plain Old Comments (Not!)">.
 
With EXPR, it returns some extra information that the debugger uses to
print a stack trace.  The value of EXPR indicates how many call frames
to go back before the current one.
 
    #  0         1          2      3            4
 my ($package, $filename, $line, $subroutine, $hasargs,
 
    #  5          6          7            8       9         10
    $wantarray, $evaltext, $is_require, $hints, $bitmask, $hinthash)
  = caller($i);
 
Here, $subroutine is the function that the caller called (rather than the
function containing the caller).  Note that $subroutine may be C<(eval)> if
the frame is not a subroutine call, but an L<C<eval>|/eval EXPR>.  In
such a case additional elements $evaltext and C<$is_require> are set:
C<$is_require> is true if the frame is created by a
L<C<require>|/require VERSION> or L<C<use>|/use Module VERSION LIST>
statement, $evaltext contains the text of the C<eval EXPR> statement.
In particular, for an C<eval BLOCK> statement, $subroutine is C<(eval)>,
but $evaltext is undefined.  (Note also that each
L<C<use>|/use Module VERSION LIST> statement creates a
L<C<require>|/require VERSION> frame inside an C<eval EXPR> frame.)
$subroutine may also be C<(unknown)> if this particular subroutine
happens to have been deleted from the symbol table.  C<$hasargs> is true
if a new instance of L<C<@_>|perlvar/@_> was set up for the frame.
C<$hints> and C<$bitmask> contain pragmatic hints that the caller was
compiled with.  C<$hints> corresponds to L<C<$^H>|perlvar/$^H>, and
C<$bitmask> corresponds to
L<C<${^WARNING_BITS}>|perlvar/${^WARNING_BITS}>.  The C<$hints> and
C<$bitmask> values are subject to change between versions of Perl, and
are not meant for external use.
 
C<$hinthash> is a reference to a hash containing the value of
L<C<%^H>|perlvar/%^H> when the caller was compiled, or
L<C<undef>|/undef EXPR> if L<C<%^H>|perlvar/%^H> was empty.  Do not
modify the values of this hash, as they are the actual values stored in
the optree.
 
Furthermore, when called from within the DB package in
list context, and with an argument, caller returns more
detailed information: it sets the list variable C<@DB::args> to be the
arguments with which the subroutine was invoked.
 
Be aware that the optimizer might have optimized call frames away before
L<C<caller>|/caller EXPR> had a chance to get the information.  That
means that C<caller(N)> might not return information about the call
frame you expect it to, for C<< N > 1 >>.  In particular, C<@DB::args>
might have information from the previous time L<C<caller>|/caller EXPR>
was called.
 
Be aware that setting C<@DB::args> is I<best effort>, intended for
debugging or generating backtraces, and should not be relied upon.  In
particular, as L<C<@_>|perlvar/@_> contains aliases to the caller's
arguments, Perl does not take a copy of L<C<@_>|perlvar/@_>, so
C<@DB::args> will contain modifications the subroutine makes to
L<C<@_>|perlvar/@_> or its contents, not the original values at call
time.  C<@DB::args>, like L<C<@_>|perlvar/@_>, does not hold explicit
references to its elements, so under certain cases its elements may have
become freed and reallocated for other variables or temporary values.
Finally, a side effect of the current implementation is that the effects
of C<shift @_> can I<normally> be undone (but not C<pop @_> or other
splicing, I<and> not if a reference to L<C<@_>|perlvar/@_> has been
taken, I<and> subject to the caveat about reallocated elements), so
C<@DB::args> is actually a hybrid of the current state and initial state
of L<C<@_>|perlvar/@_>.  Buyer beware.
 
=item chdir EXPR
X<chdir>
X<cd>
X<directory, change>
 
=item chdir FILEHANDLE
 
=item chdir DIRHANDLE
 
=item chdir
 
=for Pod::Functions change your current working directory
 
Changes the working directory to EXPR, if possible.  If EXPR is omitted,
changes to the directory specified by C<$ENV{HOME}>, if set; if not,
changes to the directory specified by C<$ENV{LOGDIR}>.  (Under VMS, the
variable C<$ENV{'SYS$LOGIN'}> is also checked, and used if it is set.)  If
neither is set, L<C<chdir>|/chdir EXPR> does nothing and fails.  It
returns true on success, false otherwise.  See the example under
L<C<die>|/die LIST>.
 
On systems that support L<fchdir(2)>, you may pass a filehandle or
directory handle as the argument.  On systems that don't support L<fchdir(2)>,
passing handles raises an exception.
 
=item chmod LIST
X<chmod> X<permission> X<mode>
 
=for Pod::Functions changes the permissions on a list of files
 
Changes the permissions of a list of files.  The first element of the
list must be the numeric mode, which should probably be an octal
number, and which definitely should I<not> be a string of octal digits:
C<0644> is okay, but C<"0644"> is not.  Returns the number of files
successfully changed.  See also L<C<oct>|/oct EXPR> if all you have is a
string.
 
    my $cnt = chmod 0755, "foo", "bar";
    chmod 0755, @executables;
    my $mode = "0644"; chmod $mode, "foo";      # !!! sets mode to
                                                # --w----r-T
    my $mode = "0644"; chmod oct($mode), "foo"; # this is better
    my $mode = 0644;   chmod $mode, "foo";      # this is best
 
On systems that support L<fchmod(2)>, you may pass filehandles among the
files.  On systems that don't support L<fchmod(2)>, passing filehandles raises
an exception.  Filehandles must be passed as globs or glob references to be
recognized; barewords are considered filenames.
 
    open(my $fh, "<", "foo");
    my $perm = (stat $fh)[2] & 07777;
    chmod($perm | 0600, $fh);
 
You can also import the symbolic C<S_I*> constants from the
L<C<Fcntl>|Fcntl> module:
 
    use Fcntl qw( :mode );
    chmod S_IRWXU|S_IRGRP|S_IXGRP|S_IROTH|S_IXOTH, @executables;
    # Identical to the chmod 0755 of the example above.
 
Portability issues: L<perlport/chmod>.
 
=item chomp VARIABLE
X<chomp> X<INPUT_RECORD_SEPARATOR> X<$/> X<newline> X<eol>
 
=item chomp( LIST )
 
=item chomp
 
=for Pod::Functions remove a trailing record separator from a string
 
This safer version of L<C<chop>|/chop VARIABLE> removes any trailing
string that corresponds to the current value of
L<C<$E<sol>>|perlvar/$E<sol>> (also known as C<$INPUT_RECORD_SEPARATOR>
in the L<C<English>|English> module).  It returns the total
number of characters removed from all its arguments.  It's often used to
remove the newline from the end of an input record when you're worried
that the final record may be missing its newline.  When in paragraph
mode (C<$/ = ''>), it removes all trailing newlines from the string.
When in slurp mode (C<$/ = undef>) or fixed-length record mode
(L<C<$E<sol>>|perlvar/$E<sol>> is a reference to an integer or the like;
see L<perlvar>), L<C<chomp>|/chomp VARIABLE> won't remove anything.
If VARIABLE is omitted, it chomps L<C<$_>|perlvar/$_>.  Example:
 
    while (<>) {
        chomp;  # avoid \n on last field
        my @array = split(/:/);
        # ...
    }
 
If VARIABLE is a hash, it chomps the hash's values, but not its keys,
resetting the L<C<each>|/each HASH> iterator in the process.
 
You can actually chomp anything that's an lvalue, including an assignment:
 
    chomp(my $cwd = `pwd`);
    chomp(my $answer = <STDIN>);
 
If you chomp a list, each element is chomped, and the total number of
characters removed is returned.
 
Note that parentheses are necessary when you're chomping anything
that is not a simple variable.  This is because C<chomp $cwd = `pwd`;>
is interpreted as C<(chomp $cwd) = `pwd`;>, rather than as
C<chomp( $cwd = `pwd` )> which you might expect.  Similarly,
C<chomp $a, $b> is interpreted as C<chomp($a), $b> rather than
as C<chomp($a, $b)>.
 
=item chop VARIABLE
X<chop>
 
=item chop( LIST )
 
=item chop
 
=for Pod::Functions remove the last character from a string
 
Chops off the last character of a string and returns the character
chopped.  It is much more efficient than C<s/.$//s> because it neither
scans nor copies the string.  If VARIABLE is omitted, chops
L<C<$_>|perlvar/$_>.
If VARIABLE is a hash, it chops the hash's values, but not its keys,
resetting the L<C<each>|/each HASH> iterator in the process.
 
You can actually chop anything that's an lvalue, including an assignment.
 
If you chop a list, each element is chopped.  Only the value of the
last L<C<chop>|/chop VARIABLE> is returned.
 
Note that L<C<chop>|/chop VARIABLE> returns the last character.  To
return all but the last character, use C<substr($string, 0, -1)>.
 
See also L<C<chomp>|/chomp VARIABLE>.
 
=item chown LIST
X<chown> X<owner> X<user> X<group>
 
=for Pod::Functions change the ownership on a list of files
 
Changes the owner (and group) of a list of files.  The first two
elements of the list must be the I<numeric> uid and gid, in that
order.  A value of -1 in either position is interpreted by most
systems to leave that value unchanged.  Returns the number of files
successfully changed.
 
    my $cnt = chown $uid, $gid, 'foo', 'bar';
    chown $uid, $gid, @filenames;
 
On systems that support L<fchown(2)>, you may pass filehandles among the
files.  On systems that don't support L<fchown(2)>, passing filehandles raises
an exception.  Filehandles must be passed as globs or glob references to be
recognized; barewords are considered filenames.
 
Here's an example that looks up nonnumeric uids in the passwd file:
 
    print "User: ";
    chomp(my $user = <STDIN>);
    print "Files: ";
    chomp(my $pattern = <STDIN>);
 
    my ($login,$pass,$uid,$gid) = getpwnam($user)
        or die "$user not in passwd file";
 
    my @ary = glob($pattern);  # expand filenames
    chown $uid, $gid, @ary;
 
On most systems, you are not allowed to change the ownership of the
file unless you're the superuser, although you should be able to change
the group to any of your secondary groups.  On insecure systems, these
restrictions may be relaxed, but this is not a portable assumption.
On POSIX systems, you can detect this condition this way:
 
    use POSIX qw(sysconf _PC_CHOWN_RESTRICTED);
    my $can_chown_giveaway = ! sysconf(_PC_CHOWN_RESTRICTED);
 
Portability issues: L<perlport/chown>.
 
=item chr NUMBER
X<chr> X<character> X<ASCII> X<Unicode>
 
=item chr
 
=for Pod::Functions get character this number represents
 
Returns the character represented by that NUMBER in the character set.
For example, C<chr(65)> is C<"A"> in either ASCII or Unicode, and
chr(0x263a) is a Unicode smiley face.
 
Negative values give the Unicode replacement character (chr(0xfffd)),
except under the L<bytes> pragma, where the low eight bits of the value
(truncated to an integer) are used.
 
If NUMBER is omitted, uses L<C<$_>|perlvar/$_>.
 
For the reverse, use L<C<ord>|/ord EXPR>.
 
Note that characters from 128 to 255 (inclusive) are by default
internally not encoded as UTF-8 for backward compatibility reasons.
 
See L<perlunicode> for more about Unicode.
 
=item chroot FILENAME
X<chroot> X<root>
 
=item chroot
 
=for Pod::Functions make directory new root for path lookups
 
This function works like the system call by the same name: it makes the
named directory the new root directory for all further pathnames that
begin with a C</> by your process and all its children.  (It doesn't
change your current working directory, which is unaffected.)  For security
reasons, this call is restricted to the superuser.  If FILENAME is
omitted, does a L<C<chroot>|/chroot FILENAME> to L<C<$_>|perlvar/$_>.
 
B<NOTE:>  It is mandatory for security to C<chdir("/")>
(L<C<chdir>|/chdir EXPR> to the root directory) immediately after a
L<C<chroot>|/chroot FILENAME>, otherwise the current working directory
may be outside of the new root.
 
Portability issues: L<perlport/chroot>.
 
=item close FILEHANDLE
X<close>
 
=item close
 
=for Pod::Functions close file (or pipe or socket) handle
 
Closes the file or pipe associated with the filehandle, flushes the IO
buffers, and closes the system file descriptor.  Returns true if those
operations succeed and if no error was reported by any PerlIO
layer.  Closes the currently selected filehandle if the argument is
omitted.
 
You don't have to close FILEHANDLE if you are immediately going to do
another L<C<open>|/open FILEHANDLE,MODE,EXPR> on it, because
L<C<open>|/open FILEHANDLE,MODE,EXPR> closes it for you.  (See
L<C<open>|/open FILEHANDLE,MODE,EXPR>.) However, an explicit
L<C<close>|/close FILEHANDLE> on an input file resets the line counter
(L<C<$.>|perlvar/$.>), while the implicit close done by
L<C<open>|/open FILEHANDLE,MODE,EXPR> does not.
 
If the filehandle came from a piped open, L<C<close>|/close FILEHANDLE>
returns false if one of the other syscalls involved fails or if its
program exits with non-zero status.  If the only problem was that the
program exited non-zero, L<C<$!>|perlvar/$!> will be set to C<0>.
Closing a pipe also waits for the process executing on the pipe to
exit--in case you wish to look at the output of the pipe afterwards--and
implicitly puts the exit status value of that command into
L<C<$?>|perlvar/$?> and
L<C<${^CHILD_ERROR_NATIVE}>|perlvar/${^CHILD_ERROR_NATIVE}>.
 
If there are multiple threads running, L<C<close>|/close FILEHANDLE> on
a filehandle from a piped open returns true without waiting for the
child process to terminate, if the filehandle is still open in another
thread.
 
Closing the read end of a pipe before the process writing to it at the
other end is done writing results in the writer receiving a SIGPIPE.  If
the other end can't handle that, be sure to read all the data before
closing the pipe.
 
Example:
 
    open(OUTPUT, '|sort >foo')  # pipe to sort
        or die "Can't start sort: $!";
    #...                        # print stuff to output
    close OUTPUT                # wait for sort to finish
        or warn $! ? "Error closing sort pipe: $!"
                   : "Exit status $? from sort";
    open(INPUT, 'foo')          # get sort's results
        or die "Can't open 'foo' for input: $!";
 
FILEHANDLE may be an expression whose value can be used as an indirect
filehandle, usually the real filehandle name or an autovivified handle.
 
=item closedir DIRHANDLE
X<closedir>
 
=for Pod::Functions close directory handle
 
Closes a directory opened by L<C<opendir>|/opendir DIRHANDLE,EXPR> and
returns the success of that system call.
 
=item connect SOCKET,NAME
X<connect>
 
=for Pod::Functions connect to a remote socket
 
Attempts to connect to a remote socket, just like L<connect(2)>.
Returns true if it succeeded, false otherwise.  NAME should be a
packed address of the appropriate type for the socket.  See the examples in
L<perlipc/"Sockets: Client/Server Communication">.
 
=item continue BLOCK
X<continue>
 
=item continue
 
=for Pod::Functions optional trailing block in a while or foreach
 
When followed by a BLOCK, L<C<continue>|/continue BLOCK> is actually a
flow control statement rather than a function.  If there is a
L<C<continue>|/continue BLOCK> BLOCK attached to a BLOCK (typically in a
C<while> or C<foreach>), it is always executed just before the
conditional is about to be evaluated again, just like the third part of
a C<for> loop in C.  Thus it can be used to increment a loop variable,
even when the loop has been continued via the L<C<next>|/next LABEL>
statement (which is similar to the C L<C<continue>|/continue BLOCK>
statement).
 
L<C<last>|/last LABEL>, L<C<next>|/next LABEL>, or
L<C<redo>|/redo LABEL> may appear within a
L<C<continue>|/continue BLOCK> block; L<C<last>|/last LABEL> and
L<C<redo>|/redo LABEL> behave as if they had been executed within the
main block.  So will L<C<next>|/next LABEL>, but since it will execute a
L<C<continue>|/continue BLOCK> block, it may be more entertaining.
 
    while (EXPR) {
        ### redo always comes here
        do_something;
    } continue {
        ### next always comes here
        do_something_else;
        # then back the top to re-check EXPR
    }
    ### last always comes here
 
Omitting the L<C<continue>|/continue BLOCK> section is equivalent to
using an empty one, logically enough, so L<C<next>|/next LABEL> goes
directly back to check the condition at the top of the loop.
 
When there is no BLOCK, L<C<continue>|/continue BLOCK> is a function
that falls through the current C<when> or C<default> block instead of
iterating a dynamically enclosing C<foreach> or exiting a lexically
enclosing C<given>.  In Perl 5.14 and earlier, this form of
L<C<continue>|/continue BLOCK> was only available when the
L<C<"switch"> feature|feature/The 'switch' feature> was enabled.  See
L<feature> and L<perlsyn/"Switch Statements"> for more information.
 
=item cos EXPR
X<cos> X<cosine> X<acos> X<arccosine>
 
=item cos
 
=for Pod::Functions cosine function
 
Returns the cosine of EXPR (expressed in radians).  If EXPR is omitted,
takes the cosine of L<C<$_>|perlvar/$_>.
 
For the inverse cosine operation, you may use the
L<C<Math::Trig::acos>|Math::Trig> function, or use this relation:
 
    sub acos { atan2( sqrt(1 - $_[0] * $_[0]), $_[0] ) }
 
=item crypt PLAINTEXT,SALT
X<crypt> X<digest> X<hash> X<salt> X<plaintext> X<password>
X<decrypt> X<cryptography> X<passwd> X<encrypt>
 
=for Pod::Functions one-way passwd-style encryption
 
Creates a digest string exactly like the L<crypt(3)> function in the C
library (assuming that you actually have a version there that has not
been extirpated as a potential munition).
 
L<C<crypt>|/crypt PLAINTEXT,SALT> is a one-way hash function.  The
PLAINTEXT and SALT are turned
into a short string, called a digest, which is returned.  The same
PLAINTEXT and SALT will always return the same string, but there is no
(known) way to get the original PLAINTEXT from the hash.  Small
changes in the PLAINTEXT or SALT will result in large changes in the
digest.
 
There is no decrypt function.  This function isn't all that useful for
cryptography (for that, look for F<Crypt> modules on your nearby CPAN
mirror) and the name "crypt" is a bit of a misnomer.  Instead it is
primarily used to check if two pieces of text are the same without
having to transmit or store the text itself.  An example is checking
if a correct password is given.  The digest of the password is stored,
not the password itself.  The user types in a password that is
L<C<crypt>|/crypt PLAINTEXT,SALT>'d with the same salt as the stored
digest.  If the two digests match, the password is correct.
 
When verifying an existing digest string you should use the digest as
the salt (like C<crypt($plain, $digest) eq $digest>).  The SALT used
to create the digest is visible as part of the digest.  This ensures
L<C<crypt>|/crypt PLAINTEXT,SALT> will hash the new string with the same
salt as the digest.  This allows your code to work with the standard
L<C<crypt>|/crypt PLAINTEXT,SALT> and with more exotic implementations.
In other words, assume nothing about the returned string itself nor
about how many bytes of SALT may matter.
 
Traditionally the result is a string of 13 bytes: two first bytes of
the salt, followed by 11 bytes from the set C<[./0-9A-Za-z]>, and only
the first eight bytes of PLAINTEXT mattered.  But alternative
hashing schemes (like MD5), higher level security schemes (like C2),
and implementations on non-Unix platforms may produce different
strings.
 
When choosing a new salt create a random two character string whose
characters come from the set C<[./0-9A-Za-z]> (like C<join '', ('.',
'/', 0..9, 'A'..'Z', 'a'..'z')[rand 64, rand 64]>).  This set of
characters is just a recommendation; the characters allowed in
the salt depend solely on your system's crypt library, and Perl can't
restrict what salts L<C<crypt>|/crypt PLAINTEXT,SALT> accepts.
 
Here's an example that makes sure that whoever runs this program knows
their password:
 
    my $pwd = (getpwuid($<))[1];
 
    system "stty -echo";
    print "Password: ";
    chomp(my $word = <STDIN>);
    print "\n";
    system "stty echo";
 
    if (crypt($word, $pwd) ne $pwd) {
        die "Sorry...\n";
    } else {
        print "ok\n";
    }
 
Of course, typing in your own password to whoever asks you
for it is unwise.
 
The L<C<crypt>|/crypt PLAINTEXT,SALT> function is unsuitable for hashing
large quantities of data, not least of all because you can't get the
information back.  Look at the L<Digest> module for more robust
algorithms.
 
If using L<C<crypt>|/crypt PLAINTEXT,SALT> on a Unicode string (which
I<potentially> has characters with codepoints above 255), Perl tries to
make sense of the situation by trying to downgrade (a copy of) the
string back to an eight-bit byte string before calling
L<C<crypt>|/crypt PLAINTEXT,SALT> (on that copy).  If that works, good.
If not, L<C<crypt>|/crypt PLAINTEXT,SALT> dies with
L<C<Wide character in crypt>|perldiag/Wide character in %s>.
 
Portability issues: L<perlport/crypt>.
 
=item dbmclose HASH
X<dbmclose>
 
=for Pod::Functions breaks binding on a tied dbm file
 
[This function has been largely superseded by the
L<C<untie>|/untie VARIABLE> function.]
 
Breaks the binding between a DBM file and a hash.
 
Portability issues: L<perlport/dbmclose>.
 
=item dbmopen HASH,DBNAME,MASK
X<dbmopen> X<dbm> X<ndbm> X<sdbm> X<gdbm>
 
=for Pod::Functions create binding on a tied dbm file
 
[This function has been largely superseded by the
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST> function.]
 
This binds a L<dbm(3)>, L<ndbm(3)>, L<sdbm(3)>, L<gdbm(3)>, or Berkeley
DB file to a hash.  HASH is the name of the hash.  (Unlike normal
L<C<open>|/open FILEHANDLE,MODE,EXPR>, the first argument is I<not> a
filehandle, even though it looks like one).  DBNAME is the name of the
database (without the F<.dir> or F<.pag> extension if any).  If the
database does not exist, it is created with protection specified by MASK
(as modified by the L<C<umask>|/umask EXPR>).  To prevent creation of
the database if it doesn't exist, you may specify a MODE of 0, and the
function will return a false value if it can't find an existing
database.  If your system supports only the older DBM functions, you may
make only one L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK> call in your
program.  In older versions of Perl, if your system had neither DBM nor
ndbm, calling L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK> produced a fatal
error; it now falls back to L<sdbm(3)>.
 
If you don't have write access to the DBM file, you can only read hash
variables, not set them.  If you want to test whether you can write,
either use file tests or try setting a dummy hash entry inside an
L<C<eval>|/eval EXPR> to trap the error.
 
Note that functions such as L<C<keys>|/keys HASH> and
L<C<values>|/values HASH> may return huge lists when used on large DBM
files.  You may prefer to use the L<C<each>|/each HASH> function to
iterate over large DBM files.  Example:
 
    # print out history file offsets
    dbmopen(%HIST,'/usr/lib/news/history',0666);
    while (($key,$val) = each %HIST) {
        print $key, ' = ', unpack('L',$val), "\n";
    }
    dbmclose(%HIST);
 
See also L<AnyDBM_File> for a more general description of the pros and
cons of the various dbm approaches, as well as L<DB_File> for a particularly
rich implementation.
 
You can control which DBM library you use by loading that library
before you call L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK>:
 
    use DB_File;
    dbmopen(%NS_Hist, "$ENV{HOME}/.netscape/history.db")
        or die "Can't open netscape history file: $!";
 
Portability issues: L<perlport/dbmopen>.
 
=item defined EXPR
X<defined> X<undef> X<undefined>
 
=item defined
 
=for Pod::Functions test whether a value, variable, or function is defined
 
Returns a Boolean value telling whether EXPR has a value other than the
undefined value L<C<undef>|/undef EXPR>.  If EXPR is not present,
L<C<$_>|perlvar/$_> is checked.
 
Many operations return L<C<undef>|/undef EXPR> to indicate failure, end
of file, system error, uninitialized variable, and other exceptional
conditions.  This function allows you to distinguish
L<C<undef>|/undef EXPR> from other values.  (A simple Boolean test will
not distinguish among L<C<undef>|/undef EXPR>, zero, the empty string,
and C<"0">, which are all equally false.)  Note that since
L<C<undef>|/undef EXPR> is a valid scalar, its presence doesn't
I<necessarily> indicate an exceptional condition: L<C<pop>|/pop ARRAY>
returns L<C<undef>|/undef EXPR> when its argument is an empty array,
I<or> when the element to return happens to be L<C<undef>|/undef EXPR>.
 
You may also use C<defined(&func)> to check whether subroutine C<func>
has ever been defined.  The return value is unaffected by any forward
declarations of C<func>.  A subroutine that is not defined
may still be callable: its package may have an C<AUTOLOAD> method that
makes it spring into existence the first time that it is called; see
L<perlsub>.
 
Use of L<C<defined>|/defined EXPR> on aggregates (hashes and arrays) is
no longer supported. It used to report whether memory for that
aggregate had ever been allocated.  You should instead use a simple
test for size:
 
    if (@an_array) { print "has array elements\n" }
    if (%a_hash)   { print "has hash members\n"   }
 
When used on a hash element, it tells you whether the value is defined,
not whether the key exists in the hash.  Use L<C<exists>|/exists EXPR>
for the latter purpose.
 
Examples:
 
    print if defined $switch{D};
    print "$val\n" while defined($val = pop(@ary));
    die "Can't readlink $sym: $!"
        unless defined($value = readlink $sym);
    sub foo { defined &$bar ? $bar->(@_) : die "No bar"; }
    $debugging = 0 unless defined $debugging;
 
Note:  Many folks tend to overuse L<C<defined>|/defined EXPR> and are
then surprised to discover that the number C<0> and C<""> (the
zero-length string) are, in fact, defined values.  For example, if you
say
 
    "ab" =~ /a(.*)b/;
 
The pattern match succeeds and C<$1> is defined, although it
matched "nothing".  It didn't really fail to match anything.  Rather, it
matched something that happened to be zero characters long.  This is all
very above-board and honest.  When a function returns an undefined value,
it's an admission that it couldn't give you an honest answer.  So you
should use L<C<defined>|/defined EXPR> only when questioning the
integrity of what you're trying to do.  At other times, a simple
comparison to C<0> or C<""> is what you want.
 
See also L<C<undef>|/undef EXPR>, L<C<exists>|/exists EXPR>,
L<C<ref>|/ref EXPR>.
 
=item delete EXPR
X<delete>
 
=for Pod::Functions deletes a value from a hash
 
Given an expression that specifies an element or slice of a hash,
L<C<delete>|/delete EXPR> deletes the specified elements from that hash
so that L<C<exists>|/exists EXPR> on that element no longer returns
true.  Setting a hash element to the undefined value does not remove its
key, but deleting it does; see L<C<exists>|/exists EXPR>.
 
In list context, usually returns the value or values deleted, or the last such
element in scalar context.  The return list's length corresponds to that of
the argument list: deleting non-existent elements returns the undefined value
in their corresponding positions. When a
L<keyE<sol>value hash slice|perldata/KeyE<sol>Value Hash Slices> is passed to
C<delete>, the return value is a list of key/value pairs (two elements for each
item deleted from the hash).
 
L<C<delete>|/delete EXPR> may also be used on arrays and array slices,
but its behavior is less straightforward.  Although
L<C<exists>|/exists EXPR> will return false for deleted entries,
deleting array elements never changes indices of existing values; use
L<C<shift>|/shift ARRAY> or L<C<splice>|/splice
ARRAY,OFFSET,LENGTH,LIST> for that.  However, if any deleted elements
fall at the end of an array, the array's size shrinks to the position of
the highest element that still tests true for L<C<exists>|/exists EXPR>,
or to 0 if none do.  In other words, an array won't have trailing
nonexistent elements after a delete.
 
B<WARNING:> Calling L<C<delete>|/delete EXPR> on array values is
strongly discouraged.  The
notion of deleting or checking the existence of Perl array elements is not
conceptually coherent, and can lead to surprising behavior.
 
Deleting from L<C<%ENV>|perlvar/%ENV> modifies the environment.
Deleting from a hash tied to a DBM file deletes the entry from the DBM
file.  Deleting from a L<C<tied>|/tied VARIABLE> hash or array may not
necessarily return anything; it depends on the implementation of the
L<C<tied>|/tied VARIABLE> package's DELETE method, which may do whatever
it pleases.
 
The C<delete local EXPR> construct localizes the deletion to the current
block at run time.  Until the block exits, elements locally deleted
temporarily no longer exist.  See L<perlsub/"Localized deletion of elements
of composite types">.
 
    my %hash = (foo => 11, bar => 22, baz => 33);
    my $scalar = delete $hash{foo};         # $scalar is 11
    $scalar = delete @hash{qw(foo bar)}; # $scalar is 22
    my @array  = delete @hash{qw(foo baz)}; # @array  is (undef,33)
 
The following (inefficiently) deletes all the values of %HASH and @ARRAY:
 
    foreach my $key (keys %HASH) {
        delete $HASH{$key};
    }
 
    foreach my $index (0 .. $#ARRAY) {
        delete $ARRAY[$index];
    }
 
And so do these:
 
    delete @HASH{keys %HASH};
 
    delete @ARRAY[0 .. $#ARRAY];
 
But both are slower than assigning the empty list
or undefining %HASH or @ARRAY, which is the customary
way to empty out an aggregate:
 
    %HASH = ();     # completely empty %HASH
    undef %HASH;    # forget %HASH ever existed
 
    @ARRAY = ();    # completely empty @ARRAY
    undef @ARRAY;   # forget @ARRAY ever existed
 
The EXPR can be arbitrarily complicated provided its
final operation is an element or slice of an aggregate:
 
    delete $ref->[$x][$y]{$key};
    delete @{$ref->[$x][$y]}{$key1, $key2, @morekeys};
 
    delete $ref->[$x][$y][$index];
    delete @{$ref->[$x][$y]}[$index1, $index2, @moreindices];
 
=item die LIST
X<die> X<throw> X<exception> X<raise> X<$@> X<abort>
 
=for Pod::Functions raise an exception or bail out
 
L<C<die>|/die LIST> raises an exception.  Inside an L<C<eval>|/eval EXPR>
the exception is stuffed into L<C<$@>|perlvar/$@> and the L<C<eval>|/eval
EXPR> is terminated with the undefined value.  If the exception is
outside of all enclosing L<C<eval>|/eval EXPR>s, then the uncaught
exception is printed to C<STDERR> and perl exits with an exit code
indicating failure.  If you need to exit the process with a specific
exit code, see L<C<exit>|/exit EXPR>.
 
Equivalent examples:
 
    die "Can't cd to spool: $!\n" unless chdir '/usr/spool/news';
    chdir '/usr/spool/news' or die "Can't cd to spool: $!\n"
 
Most of the time, C<die> is called with a string to use as the exception.
You may either give a single non-reference operand to serve as the
exception, or a list of two or more items, which will be stringified
and concatenated to make the exception.
 
If the string exception does not end in a newline, the current
script line number and input line number (if any) and a newline
are appended to it.  Note that the "input line number" (also
known as "chunk") is subject to whatever notion of "line" happens to
be currently in effect, and is also available as the special variable
L<C<$.>|perlvar/$.>.  See L<perlvar/"$/"> and L<perlvar/"$.">.
 
Hint: sometimes appending C<", stopped"> to your message will cause it
to make better sense when the string C<"at foo line 123"> is appended.
Suppose you are running script "canasta".
 
    die "/etc/games is no good";
    die "/etc/games is no good, stopped";
 
produce, respectively
 
    /etc/games is no good at canasta line 123.
    /etc/games is no good, stopped at canasta line 123.
 
If LIST was empty or made an empty string, and L<C<$@>|perlvar/$@>
already contains an exception value (typically from a previous
L<C<eval>|/eval EXPR>), then that value is reused after
appending C<"\t...propagated">.  This is useful for propagating exceptions:
 
    eval { ... };
    die unless $@ =~ /Expected exception/;
 
If LIST was empty or made an empty string,
and L<C<$@>|perlvar/$@> contains an object
reference that has a C<PROPAGATE> method, that method will be called
with additional file and line number parameters.  The return value
replaces the value in L<C<$@>|perlvar/$@>;  i.e., as if
C<< $@ = eval { $@->PROPAGATE(__FILE__, __LINE__) }; >> were called.
 
If LIST was empty or made an empty string, and L<C<$@>|perlvar/$@>
is also empty, then the string C<"Died"> is used.
 
You can also call L<C<die>|/die LIST> with a reference argument, and if
this is trapped within an L<C<eval>|/eval EXPR>, L<C<$@>|perlvar/$@>
contains that reference.  This permits more elaborate exception handling
using objects that maintain arbitrary state about the exception.  Such a
scheme is sometimes preferable to matching particular string values of
L<C<$@>|perlvar/$@> with regular expressions.
 
Because Perl stringifies uncaught exception messages before display,
you'll probably want to overload stringification operations on
exception objects.  See L<overload> for details about that.
The stringified message should be non-empty, and should end in a newline,
in order to fit in with the treatment of string exceptions.
Also, because an exception object reference cannot be stringified
without destroying it, Perl doesn't attempt to append location or other
information to a reference exception.  If you want location information
with a complex exception object, you'll have to arrange to put the
location information into the object yourself.
 
Because L<C<$@>|perlvar/$@> is a global variable, be careful that
analyzing an exception caught by C<eval> doesn't replace the reference
in the global variable.  It's
easiest to make a local copy of the reference before any manipulations.
Here's an example:
 
    use Scalar::Util "blessed";
 
    eval { ... ; die Some::Module::Exception->new( FOO => "bar" ) };
    if (my $ev_err = $@) {
        if (blessed($ev_err)
            && $ev_err->isa("Some::Module::Exception")) {
            # handle Some::Module::Exception
        }
        else {
            # handle all other possible exceptions
        }
    }
 
If an uncaught exception results in interpreter exit, the exit code is
determined from the values of L<C<$!>|perlvar/$!> and
L<C<$?>|perlvar/$?> with this pseudocode:
 
    exit $! if $!;              # errno
    exit $? >> 8 if $? >> 8;    # child exit status
    exit 255;                   # last resort
 
As with L<C<exit>|/exit EXPR>, L<C<$?>|perlvar/$?> is set prior to
unwinding the call stack; any C<DESTROY> or C<END> handlers can then
alter this value, and thus Perl's exit code.
 
The intent is to squeeze as much possible information about the likely cause
into the limited space of the system exit code.  However, as
L<C<$!>|perlvar/$!> is the value of C's C<errno>, which can be set by
any system call, this means that the value of the exit code used by
L<C<die>|/die LIST> can be non-predictable, so should not be relied
upon, other than to be non-zero.
 
You can arrange for a callback to be run just before the
L<C<die>|/die LIST> does its deed, by setting the
L<C<$SIG{__DIE__}>|perlvar/%SIG> hook.  The associated handler is called
with the exception as an argument, and can change the exception,
if it sees fit, by
calling L<C<die>|/die LIST> again.  See L<perlvar/%SIG> for details on
setting L<C<%SIG>|perlvar/%SIG> entries, and L<C<eval>|/eval EXPR> for some
examples.  Although this feature was to be run only right before your
program was to exit, this is not currently so: the
L<C<$SIG{__DIE__}>|perlvar/%SIG> hook is currently called even inside
L<C<eval>|/eval EXPR>ed blocks/strings!  If one wants the hook to do
nothing in such situations, put
 
    die @_ if $^S;
 
as the first line of the handler (see L<perlvar/$^S>).  Because
this promotes strange action at a distance, this counterintuitive
behavior may be fixed in a future release.
 
See also L<C<exit>|/exit EXPR>, L<C<warn>|/warn LIST>, and the L<Carp>
module.
 
=item do BLOCK
X<do> X<block>
 
=for Pod::Functions turn a BLOCK into a TERM
 
Not really a function.  Returns the value of the last command in the
sequence of commands indicated by BLOCK.  When modified by the C<while> or
C<until> loop modifier, executes the BLOCK once before testing the loop
condition.  (On other statements the loop modifiers test the conditional
first.)
 
C<do BLOCK> does I<not> count as a loop, so the loop control statements
L<C<next>|/next LABEL>, L<C<last>|/last LABEL>, or
L<C<redo>|/redo LABEL> cannot be used to leave or restart the block.
See L<perlsyn> for alternative strategies.
 
=item do EXPR
X<do>
 
Uses the value of EXPR as a filename and executes the contents of the
file as a Perl script:
 
    # load the exact specified file (./ and ../ special-cased)
    do '/foo/stat.pl';
    do './stat.pl';
    do '../foo/stat.pl';
 
    # search for the named file within @INC
    do 'stat.pl';
    do 'foo/stat.pl';
 
C<do './stat.pl'> is largely like
 
    eval `cat stat.pl`;
 
except that it's more concise, runs no external processes, and keeps
track of the current filename for error messages. It also differs in that
code evaluated with C<do FILE> cannot see lexicals in the enclosing
scope; C<eval STRING> does.  It's the same, however, in that it does
reparse the file every time you call it, so you probably don't want
to do this inside a loop.
 
Using C<do> with a relative path (except for F<./> and F<../>), like
 
    do 'foo/stat.pl';
 
will search the L<C<@INC>|perlvar/@INC> directories, and update
L<C<%INC>|perlvar/%INC> if the file is found.  See L<perlvar/@INC>
and L<perlvar/%INC> for these variables. In particular, note that
whilst historically L<C<@INC>|perlvar/@INC> contained '.' (the
current directory) making these two cases equivalent, that is no
longer necessarily the case, as '.' is not included in C<@INC> by default
in perl versions 5.26.0 onwards. Instead, perl will now warn:
 
    do "stat.pl" failed, '.' is no longer in @INC;
    did you mean do "./stat.pl"?
 
If L<C<do>|/do EXPR> can read the file but cannot compile it, it
returns L<C<undef>|/undef EXPR> and sets an error message in
L<C<$@>|perlvar/$@>.  If L<C<do>|/do EXPR> cannot read the file, it
returns undef and sets L<C<$!>|perlvar/$!> to the error.  Always check
L<C<$@>|perlvar/$@> first, as compilation could fail in a way that also
sets L<C<$!>|perlvar/$!>.  If the file is successfully compiled,
L<C<do>|/do EXPR> returns the value of the last expression evaluated.
 
Inclusion of library modules is better done with the
L<C<use>|/use Module VERSION LIST> and L<C<require>|/require VERSION>
operators, which also do automatic error checking and raise an exception
if there's a problem.
 
You might like to use L<C<do>|/do EXPR> to read in a program
configuration file.  Manual error checking can be done this way:
 
    # Read in config files: system first, then user.
    # Beware of using relative pathnames here.
    for $file ("/share/prog/defaults.rc",
               "$ENV{HOME}/.someprogrc")
    {
        unless ($return = do $file) {
            warn "couldn't parse $file: $@" if $@;
            warn "couldn't do $file: $!"    unless defined $return;
            warn "couldn't run $file"       unless $return;
        }
    }
 
=item dump LABEL
X<dump> X<core> X<undump>
 
=item dump EXPR
 
=item dump
 
=for Pod::Functions create an immediate core dump
 
This function causes an immediate core dump.  See also the B<-u>
command-line switch in L<perlrun|perlrun/-u>, which does the same thing.
Primarily this is so that you can use the B<undump> program (not
supplied) to turn your core dump into an executable binary after
having initialized all your variables at the beginning of the
program.  When the new binary is executed it will begin by executing
a C<goto LABEL> (with all the restrictions that L<C<goto>|/goto LABEL>
suffers).
Think of it as a goto with an intervening core dump and reincarnation.
If C<LABEL> is omitted, restarts the program from the top.  The
C<dump EXPR> form, available starting in Perl 5.18.0, allows a name to be
computed at run time, being otherwise identical to C<dump LABEL>.
 
B<WARNING>: Any files opened at the time of the dump will I<not>
be open any more when the program is reincarnated, with possible
resulting confusion by Perl.
 
This function is now largely obsolete, mostly because it's very hard to
convert a core file into an executable.  As of Perl 5.30, it must be invoked
as C<CORE::dump()>.
 
Unlike most named operators, this has the same precedence as assignment.
It is also exempt from the looks-like-a-function rule, so
C<dump ("foo")."bar"> will cause "bar" to be part of the argument to
L<C<dump>|/dump LABEL>.
 
Portability issues: L<perlport/dump>.
 
=item each HASH
X<each> X<hash, iterator>
 
=item each ARRAY
X<array, iterator>
 
=for Pod::Functions retrieve the next key/value pair from a hash
 
When called on a hash in list context, returns a 2-element list
consisting of the key and value for the next element of a hash.  In Perl
5.12 and later only, it will also return the index and value for the next
element of an array so that you can iterate over it; older Perls consider
this a syntax error.  When called in scalar context, returns only the key
(not the value) in a hash, or the index in an array.
 
Hash entries are returned in an apparently random order.  The actual random
order is specific to a given hash; the exact same series of operations
on two hashes may result in a different order for each hash.  Any insertion
into the hash may change the order, as will any deletion, with the exception
that the most recent key returned by L<C<each>|/each HASH> or
L<C<keys>|/keys HASH> may be deleted without changing the order.  So
long as a given hash is unmodified you may rely on
L<C<keys>|/keys HASH>, L<C<values>|/values HASH> and
L<C<each>|/each HASH> to repeatedly return the same order
as each other.  See L<perlsec/"Algorithmic Complexity Attacks"> for
details on why hash order is randomized.  Aside from the guarantees
provided here the exact details of Perl's hash algorithm and the hash
traversal order are subject to change in any release of Perl.
 
After L<C<each>|/each HASH> has returned all entries from the hash or
array, the next call to L<C<each>|/each HASH> returns the empty list in
list context and L<C<undef>|/undef EXPR> in scalar context; the next
call following I<that> one restarts iteration.  Each hash or array has
its own internal iterator, accessed by L<C<each>|/each HASH>,
L<C<keys>|/keys HASH>, and L<C<values>|/values HASH>.  The iterator is
implicitly reset when L<C<each>|/each HASH> has reached the end as just
described; it can be explicitly reset by calling L<C<keys>|/keys HASH>
or L<C<values>|/values HASH> on the hash or array, or by referencing
the hash (but not array) in list context.  If you add or delete
a hash's elements while iterating over it, the effect on the iterator is
unspecified; for example, entries may be skipped or duplicated--so don't
do that.  Exception: It is always safe to delete the item most recently
returned by L<C<each>|/each HASH>, so the following code works properly:
 
    while (my ($key, $value) = each %hash) {
        print $key, "\n";
        delete $hash{$key};   # This is safe
    }
 
Tied hashes may have a different ordering behaviour to perl's hash
implementation.
 
The iterator used by C<each> is attached to the hash or array, and is
shared between all iteration operations applied to the same hash or array.
Thus all uses of C<each> on a single hash or array advance the same
iterator location.  All uses of C<each> are also subject to having the
iterator reset by any use of C<keys> or C<values> on the same hash or
array, or by the hash (but not array) being referenced in list context.
This makes C<each>-based loops quite fragile: it is easy to arrive at
such a loop with the iterator already part way through the object, or to
accidentally clobber the iterator state during execution of the loop body.
It's easy enough to explicitly reset the iterator before starting a loop,
but there is no way to insulate the iterator state used by a loop from
the iterator state used by anything else that might execute during the
loop body.  To avoid these problems, use a C<foreach> loop rather than
C<while>-C<each>.
 
This prints out your environment like the L<printenv(1)> program,
but in a different order:
 
    while (my ($key,$value) = each %ENV) {
        print "$key=$value\n";
    }
 
Starting with Perl 5.14, an experimental feature allowed
L<C<each>|/each HASH> to take a scalar expression. This experiment has
been deemed unsuccessful, and was removed as of Perl 5.24.
 
As of Perl 5.18 you can use a bare L<C<each>|/each HASH> in a C<while>
loop, which will set L<C<$_>|perlvar/$_> on every iteration.
If either an C<each> expression or an explicit assignment of an C<each>
expression to a scalar is used as a C<while>/C<for> condition, then
the condition actually tests for definedness of the expression's value,
not for its regular truth value.
 
    while (each %ENV) {
        print "$_=$ENV{$_}\n";
    }
 
To avoid confusing would-be users of your code who are running earlier
versions of Perl with mysterious syntax errors, put this sort of thing at
the top of your file to signal that your code will work I<only> on Perls of
a recent vintage:
 
    use 5.012;  # so keys/values/each work on arrays
    use 5.018;  # so each assigns to $_ in a lone while test
 
See also L<C<keys>|/keys HASH>, L<C<values>|/values HASH>, and
L<C<sort>|/sort SUBNAME LIST>.
 
=item eof FILEHANDLE
X<eof>
X<end of file>
X<end-of-file>
 
=item eof ()
 
=item eof
 
=for Pod::Functions test a filehandle for its end
 
Returns 1 if the next read on FILEHANDLE will return end of file I<or> if
FILEHANDLE is not open.  FILEHANDLE may be an expression whose value
gives the real filehandle.  (Note that this function actually
reads a character and then C<ungetc>s it, so isn't useful in an
interactive context.)  Do not read from a terminal file (or call
C<eof(FILEHANDLE)> on it) after end-of-file is reached.  File types such
as terminals may lose the end-of-file condition if you do.
 
An L<C<eof>|/eof FILEHANDLE> without an argument uses the last file
read.  Using L<C<eof()>|/eof FILEHANDLE> with empty parentheses is
different.  It refers to the pseudo file formed from the files listed on
the command line and accessed via the C<< <> >> operator.  Since
C<< <> >> isn't explicitly opened, as a normal filehandle is, an
L<C<eof()>|/eof FILEHANDLE> before C<< <> >> has been used will cause
L<C<@ARGV>|perlvar/@ARGV> to be examined to determine if input is
available.   Similarly, an L<C<eof()>|/eof FILEHANDLE> after C<< <> >>
has returned end-of-file will assume you are processing another
L<C<@ARGV>|perlvar/@ARGV> list, and if you haven't set
L<C<@ARGV>|perlvar/@ARGV>, will read input from C<STDIN>; see
L<perlop/"I/O Operators">.
 
In a C<< while (<>) >> loop, L<C<eof>|/eof FILEHANDLE> or C<eof(ARGV)>
can be used to detect the end of each file, whereas
L<C<eof()>|/eof FILEHANDLE> will detect the end of the very last file
only.  Examples:
 
    # reset line numbering on each input file
    while (<>) {
        next if /^\s*#/;  # skip comments
        print "$.\t$_";
    } continue {
        close ARGV if eof;  # Not eof()!
    }
 
    # insert dashes just before last line of last file
    while (<>) {
        if (eof()) {  # check for end of last file
            print "--------------\n";
        }
        print;
        last if eof();     # needed if we're reading from a terminal
    }
 
Practical hint: you almost never need to use L<C<eof>|/eof FILEHANDLE>
in Perl, because the input operators typically return L<C<undef>|/undef
EXPR> when they run out of data or encounter an error.
 
=item eval EXPR
X<eval> X<try> X<catch> X<evaluate> X<parse> X<execute>
X<error, handling> X<exception, handling>
 
=item eval BLOCK
 
=item eval
 
=for Pod::Functions catch exceptions or compile and run code
 
C<eval> in all its forms is used to execute a little Perl program,
trapping any errors encountered so they don't crash the calling program.
 
Plain C<eval> with no argument is just C<eval EXPR>, where the
expression is understood to be contained in L<C<$_>|perlvar/$_>.  Thus
there are only two real C<eval> forms; the one with an EXPR is often
called "string eval".  In a string eval, the value of the expression
(which is itself determined within scalar context) is first parsed, and
if there were no errors, executed as a block within the lexical context
of the current Perl program.  This form is typically used to delay
parsing and subsequent execution of the text of EXPR until run time.
Note that the value is parsed every time the C<eval> executes.
 
The other form is called "block eval".  It is less general than string
eval, but the code within the BLOCK is parsed only once (at the same
time the code surrounding the C<eval> itself was parsed) and executed
within the context of the current Perl program.  This form is typically
used to trap exceptions more efficiently than the first, while also
providing the benefit of checking the code within BLOCK at compile time.
BLOCK is parsed and compiled just once.  Since errors are trapped, it
often is used to check if a given feature is available.
 
In both forms, the value returned is the value of the last expression
evaluated inside the mini-program; a return statement may also be used, just
as with subroutines.  The expression providing the return value is evaluated
in void, scalar, or list context, depending on the context of the
C<eval> itself.  See L<C<wantarray>|/wantarray> for more
on how the evaluation context can be determined.
 
If there is a syntax error or runtime error, or a L<C<die>|/die LIST>
statement is executed, C<eval> returns
L<C<undef>|/undef EXPR> in scalar context, or an empty list in list
context, and L<C<$@>|perlvar/$@> is set to the error message.  (Prior to
5.16, a bug caused L<C<undef>|/undef EXPR> to be returned in list
context for syntax errors, but not for runtime errors.) If there was no
error, L<C<$@>|perlvar/$@> is set to the empty string.  A control flow
operator like L<C<last>|/last LABEL> or L<C<goto>|/goto LABEL> can
bypass the setting of L<C<$@>|perlvar/$@>.  Beware that using
C<eval> neither silences Perl from printing warnings to
STDERR, nor does it stuff the text of warning messages into
L<C<$@>|perlvar/$@>.  To do either of those, you have to use the
L<C<$SIG{__WARN__}>|perlvar/%SIG> facility, or turn off warnings inside
the BLOCK or EXPR using S<C<no warnings 'all'>>.  See
L<C<warn>|/warn LIST>, L<perlvar>, and L<warnings>.
 
Note that, because C<eval> traps otherwise-fatal errors,
it is useful for determining whether a particular feature (such as
L<C<socket>|/socket SOCKET,DOMAIN,TYPE,PROTOCOL> or
L<C<symlink>|/symlink OLDFILE,NEWFILE>) is implemented.  It is also
Perl's exception-trapping mechanism, where the L<C<die>|/die LIST>
operator is used to raise exceptions.
 
Before Perl 5.14, the assignment to L<C<$@>|perlvar/$@> occurred before
restoration
of localized variables, which means that for your code to run on older
versions, a temporary is required if you want to mask some, but not all
errors:
 
 # alter $@ on nefarious repugnancy only
 {
    my $e;
    {
      local $@; # protect existing $@
      eval { test_repugnancy() };
      # $@ =~ /nefarious/ and die $@; # Perl 5.14 and higher only
      $@ =~ /nefarious/ and $e = $@;
    }
    die $e if defined $e
 }
 
There are some different considerations for each form:
 
=over 4
 
=item String eval
 
Since the return value of EXPR is executed as a block within the lexical
context of the current Perl program, any outer lexical variables are
visible to it, and any package variable settings or subroutine and
format definitions remain afterwards.
 
=over 4
 
=item Under the L<C<"unicode_eval"> feature|feature/The 'unicode_eval' and 'evalbytes' features>
 
If this feature is enabled (which is the default under a C<use 5.16> or
higher declaration), EXPR is considered to be
in the same encoding as the surrounding program.  Thus if
S<L<C<use utf8>|utf8>> is in effect, the string will be treated as being
UTF-8 encoded.  Otherwise, the string is considered to be a sequence of
independent bytes.  Bytes that correspond to ASCII-range code points
will have their normal meanings for operators in the string.  The
treatment of the other bytes depends on if the
L<C<'unicode_strings"> feature|feature/The 'unicode_strings' feature> is
in effect.
 
In a plain C<eval> without an EXPR argument, being in S<C<use utf8>> or
not is irrelevant; the UTF-8ness of C<$_> itself determines the
behavior.
 
Any S<C<use utf8>> or S<C<no utf8>> declarations within the string have
no effect, and source filters are forbidden.  (C<unicode_strings>,
however, can appear within the string.)  See also the
L<C<evalbytes>|/evalbytes EXPR> operator, which works properly with
source filters.
 
Variables defined outside the C<eval> and used inside it retain their
original UTF-8ness.  Everything inside the string follows the normal
rules for a Perl program with the given state of S<C<use utf8>>.
 
=item Outside the C<"unicode_eval"> feature
 
In this case, the behavior is problematic and is not so easily
described.  Here are two bugs that cannot easily be fixed without
breaking existing programs:
 
=over 4
 
=item *
 
It can lose track of whether something should be encoded as UTF-8 or
not.
 
=item *
 
Source filters activated within C<eval> leak out into whichever file
scope is currently being compiled.  To give an example with the CPAN module
L<Semi::Semicolons>:
 
 BEGIN { eval "use Semi::Semicolons; # not filtered" }
 # filtered here!
 
L<C<evalbytes>|/evalbytes EXPR> fixes that to work the way one would
expect:
 
 use feature "evalbytes";
 BEGIN { evalbytes "use Semi::Semicolons; # filtered" }
 # not filtered
 
=back
 
=back
 
Problems can arise if the string expands a scalar containing a floating
point number.  That scalar can expand to letters, such as C<"NaN"> or
C<"Infinity">; or, within the scope of a L<C<use locale>|locale>, the
decimal point character may be something other than a dot (such as a
comma).  None of these are likely to parse as you are likely expecting.
 
You should be especially careful to remember what's being looked at
when:
 
    eval $x;        # CASE 1
    eval "$x";      # CASE 2
 
    eval '$x';      # CASE 3
    eval { $x };    # CASE 4
 
    eval "\$$x++";  # CASE 5
    $$x++;          # CASE 6
 
Cases 1 and 2 above behave identically: they run the code contained in
the variable $x.  (Although case 2 has misleading double quotes making
the reader wonder what else might be happening (nothing is).)  Cases 3
and 4 likewise behave in the same way: they run the code C<'$x'>, which
does nothing but return the value of $x.  (Case 4 is preferred for
purely visual reasons, but it also has the advantage of compiling at
compile-time instead of at run-time.)  Case 5 is a place where
normally you I<would> like to use double quotes, except that in this
particular situation, you can just use symbolic references instead, as
in case 6.
 
An C<eval ''> executed within a subroutine defined
in the C<DB> package doesn't see the usual
surrounding lexical scope, but rather the scope of the first non-DB piece
of code that called it.  You don't normally need to worry about this unless
you are writing a Perl debugger.
 
The final semicolon, if any, may be omitted from the value of EXPR.
 
=item Block eval
 
If the code to be executed doesn't vary, you may use the eval-BLOCK
form to trap run-time errors without incurring the penalty of
recompiling each time.  The error, if any, is still returned in
L<C<$@>|perlvar/$@>.
Examples:
 
    # make divide-by-zero nonfatal
    eval { $answer = $a / $b; }; warn $@ if $@;
 
    # same thing, but less efficient
    eval '$answer = $a / $b'; warn $@ if $@;
 
    # a compile-time error
    eval { $answer = }; # WRONG
 
    # a run-time error
    eval '$answer =';   # sets $@
 
If you want to trap errors when loading an XS module, some problems with
the binary interface (such as Perl version skew) may be fatal even with
C<eval> unless C<$ENV{PERL_DL_NONLAZY}> is set.  See
L<perlrun|perlrun/PERL_DL_NONLAZY>.
 
Using the C<eval {}> form as an exception trap in libraries does have some
issues.  Due to the current arguably broken state of C<__DIE__> hooks, you
may wish not to trigger any C<__DIE__> hooks that user code may have installed.
You can use the C<local $SIG{__DIE__}> construct for this purpose,
as this example shows:
 
    # a private exception trap for divide-by-zero
    eval { local $SIG{'__DIE__'}; $answer = $a / $b; };
    warn $@ if $@;
 
This is especially significant, given that C<__DIE__> hooks can call
L<C<die>|/die LIST> again, which has the effect of changing their error
messages:
 
    # __DIE__ hooks may modify error messages
    {
       local $SIG{'__DIE__'} =
              sub { (my $x = $_[0]) =~ s/foo/bar/g; die $x };
       eval { die "foo lives here" };
       print $@ if $@;                # prints "bar lives here"
    }
 
Because this promotes action at a distance, this counterintuitive behavior
may be fixed in a future release.
 
C<eval BLOCK> does I<not> count as a loop, so the loop control statements
L<C<next>|/next LABEL>, L<C<last>|/last LABEL>, or
L<C<redo>|/redo LABEL> cannot be used to leave or restart the block.
 
The final semicolon, if any, may be omitted from within the BLOCK.
 
=back
 
=item evalbytes EXPR
X<evalbytes>
 
=item evalbytes
 
=for Pod::Functions +evalbytes similar to string eval, but intend to parse a bytestream
 
This function is similar to a L<string eval|/eval EXPR>, except it
always parses its argument (or L<C<$_>|perlvar/$_> if EXPR is omitted)
as a string of independent bytes.
 
If called when S<C<use utf8>> is in effect, the string will be assumed
to be encoded in UTF-8, and C<evalbytes> will make a temporary copy to
work from, downgraded to non-UTF-8.  If this is not possible
(because one or more characters in it require UTF-8), the C<evalbytes>
will fail with the error stored in C<$@>.
 
Bytes that correspond to ASCII-range code points will have their normal
meanings for operators in the string.  The treatment of the other bytes
depends on if the L<C<'unicode_strings"> feature|feature/The
'unicode_strings' feature> is in effect.
 
Of course, variables that are UTF-8 and are referred to in the string
retain that:
 
 my $a = "\x{100}";
 evalbytes 'print ord $a, "\n"';
 
prints
 
 256
 
and C<$@> is empty.
 
Source filters activated within the evaluated code apply to the code
itself.
 
L<C<evalbytes>|/evalbytes EXPR> is available starting in Perl v5.16.  To
access it, you must say C<CORE::evalbytes>, but you can omit the
C<CORE::> if the
L<C<"evalbytes"> feature|feature/The 'unicode_eval' and 'evalbytes' features>
is enabled.  This is enabled automatically with a C<use v5.16> (or
higher) declaration in the current scope.
 
=item exec LIST
X<exec> X<execute>
 
=item exec PROGRAM LIST
 
=for Pod::Functions abandon this program to run another
 
The L<C<exec>|/exec LIST> function executes a system command I<and never
returns>; use L<C<system>|/system LIST> instead of L<C<exec>|/exec LIST>
if you want it to return.  It fails and
returns false only if the command does not exist I<and> it is executed
directly instead of via your system's command shell (see below).
 
Since it's a common mistake to use L<C<exec>|/exec LIST> instead of
L<C<system>|/system LIST>, Perl warns you if L<C<exec>|/exec LIST> is
called in void context and if there is a following statement that isn't
L<C<die>|/die LIST>, L<C<warn>|/warn LIST>, or L<C<exit>|/exit EXPR> (if
L<warnings> are enabled--but you always do that, right?).  If you
I<really> want to follow an L<C<exec>|/exec LIST> with some other
statement, you can use one of these styles to avoid the warning:
 
    exec ('foo')   or print STDERR "couldn't exec foo: $!";
    { exec ('foo') }; print STDERR "couldn't exec foo: $!";
 
If there is more than one argument in LIST, this calls L<execvp(3)> with the
arguments in LIST.  If there is only one element in LIST, the argument is
checked for shell metacharacters, and if there are any, the entire
argument is passed to the system's command shell for parsing (this is
C</bin/sh -c> on Unix platforms, but varies on other platforms).  If
there are no shell metacharacters in the argument, it is split into words
and passed directly to C<execvp>, which is more efficient.  Examples:
 
    exec '/bin/echo', 'Your arguments are: ', @ARGV;
    exec "sort $outfile | uniq";
 
If you don't really want to execute the first argument, but want to lie
to the program you are executing about its own name, you can specify
the program you actually want to run as an "indirect object" (without a
comma) in front of the LIST, as in C<exec PROGRAM LIST>.  (This always
forces interpretation of the LIST as a multivalued list, even if there
is only a single scalar in the list.)  Example:
 
    my $shell = '/bin/csh';
    exec $shell '-sh';    # pretend it's a login shell
 
or, more directly,
 
    exec {'/bin/csh'} '-sh';  # pretend it's a login shell
 
When the arguments get executed via the system shell, results are
subject to its quirks and capabilities.  See L<perlop/"`STRING`">
for details.
 
Using an indirect object with L<C<exec>|/exec LIST> or
L<C<system>|/system LIST> is also more secure.  This usage (which also
works fine with L<C<system>|/system LIST>) forces
interpretation of the arguments as a multivalued list, even if the
list had just one argument.  That way you're safe from the shell
expanding wildcards or splitting up words with whitespace in them.
 
    my @args = ( "echo surprise" );
 
    exec @args;               # subject to shell escapes
                                # if @args == 1
    exec { $args[0] } @args;  # safe even with one-arg list
 
The first version, the one without the indirect object, ran the I<echo>
program, passing it C<"surprise"> an argument.  The second version didn't;
it tried to run a program named I<"echo surprise">, didn't find it, and set
L<C<$?>|perlvar/$?> to a non-zero value indicating failure.
 
On Windows, only the C<exec PROGRAM LIST> indirect object syntax will
reliably avoid using the shell; C<exec LIST>, even with more than one
element, will fall back to the shell if the first spawn fails.
 
Perl attempts to flush all files opened for output before the exec,
but this may not be supported on some platforms (see L<perlport>).
To be safe, you may need to set L<C<$E<verbar>>|perlvar/$E<verbar>>
(C<$AUTOFLUSH> in L<English>) or call the C<autoflush> method of
L<C<IO::Handle>|IO::Handle/METHODS> on any open handles to avoid lost
output.
 
Note that L<C<exec>|/exec LIST> will not call your C<END> blocks, nor
will it invoke C<DESTROY> methods on your objects.
 
Portability issues: L<perlport/exec>.
 
=item exists EXPR
X<exists> X<autovivification>
 
=for Pod::Functions test whether a hash key is present
 
Given an expression that specifies an element of a hash, returns true if the
specified element in the hash has ever been initialized, even if the
corresponding value is undefined.
 
    print "Exists\n"    if exists $hash{$key};
    print "Defined\n"   if defined $hash{$key};
    print "True\n"      if $hash{$key};
 
exists may also be called on array elements, but its behavior is much less
obvious and is strongly tied to the use of L<C<delete>|/delete EXPR> on
arrays.
 
B<WARNING:> Calling L<C<exists>|/exists EXPR> on array values is
strongly discouraged.  The
notion of deleting or checking the existence of Perl array elements is not
conceptually coherent, and can lead to surprising behavior.
 
    print "Exists\n"    if exists $array[$index];
    print "Defined\n"   if defined $array[$index];
    print "True\n"      if $array[$index];
 
A hash or array element can be true only if it's defined and defined only if
it exists, but the reverse doesn't necessarily hold true.
 
Given an expression that specifies the name of a subroutine,
returns true if the specified subroutine has ever been declared, even
if it is undefined.  Mentioning a subroutine name for exists or defined
does not count as declaring it.  Note that a subroutine that does not
exist may still be callable: its package may have an C<AUTOLOAD>
method that makes it spring into existence the first time that it is
called; see L<perlsub>.
 
    print "Exists\n"  if exists &subroutine;
    print "Defined\n" if defined &subroutine;
 
Note that the EXPR can be arbitrarily complicated as long as the final
operation is a hash or array key lookup or subroutine name:
 
    if (exists $ref->{A}->{B}->{$key})  { }
    if (exists $hash{A}{B}{$key})       { }
 
    if (exists $ref->{A}->{B}->[$ix])   { }
    if (exists $hash{A}{B}[$ix])        { }
 
    if (exists &{$ref->{A}{B}{$key}})   { }
 
Although the most deeply nested array or hash element will not spring into
existence just because its existence was tested, any intervening ones will.
Thus C<< $ref->{"A"} >> and C<< $ref->{"A"}->{"B"} >> will spring
into existence due to the existence test for the C<$key> element above.
This happens anywhere the arrow operator is used, including even here:
 
    undef $ref;
    if (exists $ref->{"Some key"})    { }
    print $ref;  # prints HASH(0x80d3d5c)
 
Use of a subroutine call, rather than a subroutine name, as an argument
to L<C<exists>|/exists EXPR> is an error.
 
    exists &sub;    # OK
    exists &sub();  # Error
 
=item exit EXPR
X<exit> X<terminate> X<abort>
 
=item exit
 
=for Pod::Functions terminate this program
 
Evaluates EXPR and exits immediately with that value.    Example:
 
    my $ans = <STDIN>;
    exit 0 if $ans =~ /^[Xx]/;
 
See also L<C<die>|/die LIST>.  If EXPR is omitted, exits with C<0>
status.  The only
universally recognized values for EXPR are C<0> for success and C<1>
for error; other values are subject to interpretation depending on the
environment in which the Perl program is running.  For example, exiting
69 (EX_UNAVAILABLE) from a I<sendmail> incoming-mail filter will cause
the mailer to return the item undelivered, but that's not true everywhere.
 
Don't use L<C<exit>|/exit EXPR> to abort a subroutine if there's any
chance that someone might want to trap whatever error happened.  Use
L<C<die>|/die LIST> instead, which can be trapped by an
L<C<eval>|/eval EXPR>.
 
The L<C<exit>|/exit EXPR> function does not always exit immediately.  It
calls any defined C<END> routines first, but these C<END> routines may
not themselves abort the exit.  Likewise any object destructors that
need to be called are called before the real exit.  C<END> routines and
destructors can change the exit status by modifying L<C<$?>|perlvar/$?>.
If this is a problem, you can call
L<C<POSIX::_exit($status)>|POSIX/C<_exit>> to avoid C<END> and destructor
processing.  See L<perlmod> for details.
 
Portability issues: L<perlport/exit>.
 
=item exp EXPR
X<exp> X<exponential> X<antilog> X<antilogarithm> X<e>
 
=item exp
 
=for Pod::Functions raise I<e> to a power
 
Returns I<e> (the natural logarithm base) to the power of EXPR.
If EXPR is omitted, gives C<exp($_)>.
 
=item fc EXPR
X<fc> X<foldcase> X<casefold> X<fold-case> X<case-fold>
 
=item fc
 
=for Pod::Functions +fc return casefolded version of a string
 
Returns the casefolded version of EXPR.  This is the internal function
implementing the C<\F> escape in double-quoted strings.
 
Casefolding is the process of mapping strings to a form where case
differences are erased; comparing two strings in their casefolded
form is effectively a way of asking if two strings are equal,
regardless of case.
 
Roughly, if you ever found yourself writing this
 
    lc($this) eq lc($that)    # Wrong!
        # or
    uc($this) eq uc($that)    # Also wrong!
        # or
    $this =~ /^\Q$that\E\z/i  # Right!
 
Now you can write
 
    fc($this) eq fc($that)
 
And get the correct results.
 
Perl only implements the full form of casefolding, but you can access
the simple folds using L<Unicode::UCD/B<casefold()>> and
L<Unicode::UCD/B<prop_invmap()>>.
For further information on casefolding, refer to
the Unicode Standard, specifically sections 3.13 C<Default Case Operations>,
4.2 C<Case-Normative>, and 5.18 C<Case Mappings>,
available at L<https://www.unicode.org/versions/latest/>, as well as the
Case Charts available at L<https://www.unicode.org/charts/case/>.
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
This function behaves the same way under various pragmas, such as within
L<S<C<"use feature 'unicode_strings">>|feature/The 'unicode_strings' feature>,
as L<C<lc>|/lc EXPR> does, with the single exception of
L<C<fc>|/fc EXPR> of I<LATIN CAPITAL LETTER SHARP S> (U+1E9E) within the
scope of L<S<C<use locale>>|locale>.  The foldcase of this character
would normally be C<"ss">, but as explained in the L<C<lc>|/lc EXPR>
section, case
changes that cross the 255/256 boundary are problematic under locales,
and are hence prohibited.  Therefore, this function under locale returns
instead the string C<"\x{17F}\x{17F}">, which is the I<LATIN SMALL LETTER
LONG S>.  Since that character itself folds to C<"s">, the string of two
of them together should be equivalent to a single U+1E9E when foldcased.
 
While the Unicode Standard defines two additional forms of casefolding,
one for Turkic languages and one that never maps one character into multiple
characters, these are not provided by the Perl core.  However, the CPAN module
L<C<Unicode::Casing>|Unicode::Casing> may be used to provide an implementation.
 
L<C<fc>|/fc EXPR> is available only if the
L<C<"fc"> feature|feature/The 'fc' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"fc"> feature|feature/The 'fc' feature> is enabled automatically
with a C<use v5.16> (or higher) declaration in the current scope.
 
=item fcntl FILEHANDLE,FUNCTION,SCALAR
X<fcntl>
 
=for Pod::Functions file control system call
 
Implements the L<fcntl(2)> function.  You'll probably have to say
 
    use Fcntl;
 
first to get the correct constant definitions.  Argument processing and
value returned work just like L<C<ioctl>|/ioctl
FILEHANDLE,FUNCTION,SCALAR> below.  For example:
 
    use Fcntl;
    my $flags = fcntl($filehandle, F_GETFL, 0)
        or die "Can't fcntl F_GETFL: $!";
 
You don't have to check for L<C<defined>|/defined EXPR> on the return
from L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR>.  Like
L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>, it maps a C<0> return
from the system call into C<"0 but true"> in Perl.  This string is true
in boolean context and C<0> in numeric context.  It is also exempt from
the normal
L<C<Argument "..." isn't numeric>|perldiag/Argument "%s" isn't numeric%s>
L<warnings> on improper numeric conversions.
 
Note that L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR> raises an
exception if used on a machine that doesn't implement L<fcntl(2)>.  See
the L<Fcntl> module or your L<fcntl(2)> manpage to learn what functions
are available on your system.
 
Here's an example of setting a filehandle named C<$REMOTE> to be
non-blocking at the system level.  You'll have to negotiate
L<C<$E<verbar>>|perlvar/$E<verbar>> on your own, though.
 
    use Fcntl qw(F_GETFL F_SETFL O_NONBLOCK);
 
    my $flags = fcntl($REMOTE, F_GETFL, 0)
        or die "Can't get flags for the socket: $!\n";
 
    fcntl($REMOTE, F_SETFL, $flags | O_NONBLOCK)
        or die "Can't set flags for the socket: $!\n";
 
Portability issues: L<perlport/fcntl>.
 
=item __FILE__
X<__FILE__>
 
=for Pod::Functions the name of the current source file
 
A special token that returns the name of the file in which it occurs.
It can be altered by the mechanism described at
L<perlsyn/"Plain Old Comments (Not!)">.
 
=item fileno FILEHANDLE
X<fileno>
 
=item fileno DIRHANDLE
 
=for Pod::Functions return file descriptor from filehandle
 
Returns the file descriptor for a filehandle or directory handle,
or undefined if the
filehandle is not open.  If there is no real file descriptor at the OS
level, as can happen with filehandles connected to memory objects via
L<C<open>|/open FILEHANDLE,MODE,EXPR> with a reference for the third
argument, -1 is returned.
 
This is mainly useful for constructing bitmaps for
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> and low-level POSIX
tty-handling operations.
If FILEHANDLE is an expression, the value is taken as an indirect
filehandle, generally its name.
 
You can use this to find out whether two handles refer to the
same underlying descriptor:
 
    if (fileno($this) != -1 && fileno($this) == fileno($that)) {
        print "\$this and \$that are dups\n";
    } elsif (fileno($this) != -1 && fileno($that) != -1) {
        print "\$this and \$that have different " .
            "underlying file descriptors\n";
    } else {
        print "At least one of \$this and \$that does " .
            "not have a real file descriptor\n";
    }
 
The behavior of L<C<fileno>|/fileno FILEHANDLE> on a directory handle
depends on the operating system.  On a system with L<dirfd(3)> or
similar, L<C<fileno>|/fileno FILEHANDLE> on a directory
handle returns the underlying file descriptor associated with the
handle; on systems with no such support, it returns the undefined value,
and sets L<C<$!>|perlvar/$!> (errno).
 
=item flock FILEHANDLE,OPERATION
X<flock> X<lock> X<locking>
 
=for Pod::Functions lock an entire file with an advisory lock
 
Calls L<flock(2)>, or an emulation of it, on FILEHANDLE.  Returns true
for success, false on failure.  Produces a fatal error if used on a
machine that doesn't implement L<flock(2)>, L<fcntl(2)> locking, or
L<lockf(3)>.  L<C<flock>|/flock FILEHANDLE,OPERATION> is Perl's portable
file-locking interface, although it locks entire files only, not
records.
 
Two potentially non-obvious but traditional L<C<flock>|/flock
FILEHANDLE,OPERATION> semantics are
that it waits indefinitely until the lock is granted, and that its locks
are B<merely advisory>.  Such discretionary locks are more flexible, but
offer fewer guarantees.  This means that programs that do not also use
L<C<flock>|/flock FILEHANDLE,OPERATION> may modify files locked with
L<C<flock>|/flock FILEHANDLE,OPERATION>.  See L<perlport>,
your port's specific documentation, and your system-specific local manpages
for details.  It's best to assume traditional behavior if you're writing
portable programs.  (But if you're not, you should as always feel perfectly
free to write for your own system's idiosyncrasies (sometimes called
"features").  Slavish adherence to portability concerns shouldn't get
in the way of your getting your job done.)
 
OPERATION is one of LOCK_SH, LOCK_EX, or LOCK_UN, possibly combined with
LOCK_NB.  These constants are traditionally valued 1, 2, 8 and 4, but
you can use the symbolic names if you import them from the L<Fcntl> module,
either individually, or as a group using the C<:flock> tag.  LOCK_SH
requests a shared lock, LOCK_EX requests an exclusive lock, and LOCK_UN
releases a previously requested lock.  If LOCK_NB is bitwise-or'ed with
LOCK_SH or LOCK_EX, then L<C<flock>|/flock FILEHANDLE,OPERATION> returns
immediately rather than blocking waiting for the lock; check the return
status to see if you got it.
 
To avoid the possibility of miscoordination, Perl now flushes FILEHANDLE
before locking or unlocking it.
 
Note that the emulation built with L<lockf(3)> doesn't provide shared
locks, and it requires that FILEHANDLE be open with write intent.  These
are the semantics that L<lockf(3)> implements.  Most if not all systems
implement L<lockf(3)> in terms of L<fcntl(2)> locking, though, so the
differing semantics shouldn't bite too many people.
 
Note that the L<fcntl(2)> emulation of L<flock(3)> requires that FILEHANDLE
be open with read intent to use LOCK_SH and requires that it be open
with write intent to use LOCK_EX.
 
Note also that some versions of L<C<flock>|/flock FILEHANDLE,OPERATION>
cannot lock things over the network; you would need to use the more
system-specific L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR> for
that.  If you like you can force Perl to ignore your system's L<flock(2)>
function, and so provide its own L<fcntl(2)>-based emulation, by passing
the switch C<-Ud_flock> to the F<Configure> program when you configure
and build a new Perl.
 
Here's a mailbox appender for BSD systems.
 
    # import LOCK_* and SEEK_END constants
    use Fcntl qw(:flock SEEK_END);
 
    sub lock {
        my ($fh) = @_;
        flock($fh, LOCK_EX) or die "Cannot lock mailbox - $!\n";
        # and, in case we're running on a very old UNIX
        # variant without the modern O_APPEND semantics...
        seek($fh, 0, SEEK_END) or die "Cannot seek - $!\n";
    }
 
    sub unlock {
        my ($fh) = @_;
        flock($fh, LOCK_UN) or die "Cannot unlock mailbox - $!\n";
    }
 
    open(my $mbox, ">>", "/usr/spool/mail/$ENV{'USER'}")
        or die "Can't open mailbox: $!";
 
    lock($mbox);
    print $mbox $msg,"\n\n";
    unlock($mbox);
 
On systems that support a real L<flock(2)>, locks are inherited across
L<C<fork>|/fork> calls, whereas those that must resort to the more
capricious L<fcntl(2)> function lose their locks, making it seriously
harder to write servers.
 
See also L<DB_File> for other L<C<flock>|/flock FILEHANDLE,OPERATION>
examples.
 
Portability issues: L<perlport/flock>.
 
=item fork
X<fork> X<child> X<parent>
 
=for Pod::Functions create a new process just like this one
 
Does a L<fork(2)> system call to create a new process running the
same program at the same point.  It returns the child pid to the
parent process, C<0> to the child process, or L<C<undef>|/undef EXPR> if
the fork is
unsuccessful.  File descriptors (and sometimes locks on those descriptors)
are shared, while everything else is copied.  On most systems supporting
L<fork(2)>, great care has gone into making it extremely efficient (for
example, using copy-on-write technology on data pages), making it the
dominant paradigm for multitasking over the last few decades.
 
Perl attempts to flush all files opened for output before forking the
child process, but this may not be supported on some platforms (see
L<perlport>).  To be safe, you may need to set
L<C<$E<verbar>>|perlvar/$E<verbar>> (C<$AUTOFLUSH> in L<English>) or
call the C<autoflush> method of L<C<IO::Handle>|IO::Handle/METHODS> on
any open handles to avoid duplicate output.
 
If you L<C<fork>|/fork> without ever waiting on your children, you will
accumulate zombies.  On some systems, you can avoid this by setting
L<C<$SIG{CHLD}>|perlvar/%SIG> to C<"IGNORE">.  See also L<perlipc> for
more examples of forking and reaping moribund children.
 
Note that if your forked child inherits system file descriptors like
STDIN and STDOUT that are actually connected by a pipe or socket, even
if you exit, then the remote server (such as, say, a CGI script or a
backgrounded job launched from a remote shell) won't think you're done.
You should reopen those to F</dev/null> if it's any issue.
 
On some platforms such as Windows, where the L<fork(2)> system call is
not available, Perl can be built to emulate L<C<fork>|/fork> in the Perl
interpreter.  The emulation is designed, at the level of the Perl
program, to be as compatible as possible with the "Unix" L<fork(2)>.
However it has limitations that have to be considered in code intended
to be portable.  See L<perlfork> for more details.
 
Portability issues: L<perlport/fork>.
 
=item format
X<format>
 
=for Pod::Functions declare a picture format with use by the write() function
 
Declare a picture format for use by the L<C<write>|/write FILEHANDLE>
function.  For example:
 
    format Something =
        Test: @<<<<<<<< @||||| @>>>>>
              $str,     $%,    '$' . int($num)
    .
 
    $str = "widget";
    $num = $cost/$quantity;
    $~ = 'Something';
    write;
 
See L<perlform> for many details and examples.
 
=item formline PICTURE,LIST
X<formline>
 
=for Pod::Functions internal function used for formats
 
This is an internal function used by L<C<format>|/format>s, though you
may call it, too.  It formats (see L<perlform>) a list of values
according to the contents of PICTURE, placing the output into the format
output accumulator, L<C<$^A>|perlvar/$^A> (or C<$ACCUMULATOR> in
L<English>).  Eventually, when a L<C<write>|/write FILEHANDLE> is done,
the contents of L<C<$^A>|perlvar/$^A> are written to some filehandle.
You could also read L<C<$^A>|perlvar/$^A> and then set
L<C<$^A>|perlvar/$^A> back to C<"">.  Note that a format typically does
one L<C<formline>|/formline PICTURE,LIST> per line of form, but the
L<C<formline>|/formline PICTURE,LIST> function itself doesn't care how
many newlines are embedded in the PICTURE.  This means that the C<~> and
C<~~> tokens treat the entire PICTURE as a single line.  You may
therefore need to use multiple formlines to implement a single record
format, just like the L<C<format>|/format> compiler.
 
Be careful if you put double quotes around the picture, because an C<@>
character may be taken to mean the beginning of an array name.
L<C<formline>|/formline PICTURE,LIST> always returns true.  See
L<perlform> for other examples.
 
If you are trying to use this instead of L<C<write>|/write FILEHANDLE>
to capture the output, you may find it easier to open a filehandle to a
scalar (C<< open my $fh, ">", \$output >>) and write to that instead.
 
=item getc FILEHANDLE
X<getc> X<getchar> X<character> X<file, read>
 
=item getc
 
=for Pod::Functions get the next character from the filehandle
 
Returns the next character from the input file attached to FILEHANDLE,
or the undefined value at end of file or if there was an error (in
the latter case L<C<$!>|perlvar/$!> is set).  If FILEHANDLE is omitted,
reads from
STDIN.  This is not particularly efficient.  However, it cannot be
used by itself to fetch single characters without waiting for the user
to hit enter.  For that, try something more like:
 
    if ($BSD_STYLE) {
        system "stty cbreak </dev/tty >/dev/tty 2>&1";
    }
    else {
        system "stty", '-icanon', 'eol', "\001";
    }
 
    my $key = getc(STDIN);
 
    if ($BSD_STYLE) {
        system "stty -cbreak </dev/tty >/dev/tty 2>&1";
    }
    else {
        system 'stty', 'icanon', 'eol', '^@'; # ASCII NUL
    }
    print "\n";
 
Determination of whether C<$BSD_STYLE> should be set is left as an
exercise to the reader.
 
The L<C<POSIX::getattr>|POSIX/C<getattr>> function can do this more
portably on systems purporting POSIX compliance.  See also the
L<C<Term::ReadKey>|Term::ReadKey> module on CPAN.
 
=item getlogin
X<getlogin> X<login>
 
=for Pod::Functions return who logged in at this tty
 
This implements the C library function of the same name, which on most
systems returns the current login from F</etc/utmp>, if any.  If it
returns the empty string, use L<C<getpwuid>|/getpwuid UID>.
 
    my $login = getlogin || getpwuid($<) || "Kilroy";
 
Do not consider L<C<getlogin>|/getlogin> for authentication: it is not
as secure as L<C<getpwuid>|/getpwuid UID>.
 
Portability issues: L<perlport/getlogin>.
 
=item getpeername SOCKET
X<getpeername> X<peer>
 
=for Pod::Functions find the other end of a socket connection
 
Returns the packed sockaddr address of the other end of the SOCKET
connection.
 
    use Socket;
    my $hersockaddr    = getpeername($sock);
    my ($port, $iaddr) = sockaddr_in($hersockaddr);
    my $herhostname    = gethostbyaddr($iaddr, AF_INET);
    my $herstraddr     = inet_ntoa($iaddr);
 
=item getpgrp PID
X<getpgrp> X<group>
 
=for Pod::Functions get process group
 
Returns the current process group for the specified PID.  Use
a PID of C<0> to get the current process group for the
current process.  Will raise an exception if used on a machine that
doesn't implement L<getpgrp(2)>.  If PID is omitted, returns the process
group of the current process.  Note that the POSIX version of
L<C<getpgrp>|/getpgrp PID> does not accept a PID argument, so only
C<PID==0> is truly portable.
 
Portability issues: L<perlport/getpgrp>.
 
=item getppid
X<getppid> X<parent> X<pid>
 
=for Pod::Functions get parent process ID
 
Returns the process id of the parent process.
 
Note for Linux users: Between v5.8.1 and v5.16.0 Perl would work
around non-POSIX thread semantics the minority of Linux systems (and
Debian GNU/kFreeBSD systems) that used LinuxThreads, this emulation
has since been removed.  See the documentation for L<$$|perlvar/$$> for
details.
 
Portability issues: L<perlport/getppid>.
 
=item getpriority WHICH,WHO
X<getpriority> X<priority> X<nice>
 
=for Pod::Functions get current nice value
 
Returns the current priority for a process, a process group, or a user.
(See L<getpriority(2)>.)  Will raise a fatal exception if used on a
machine that doesn't implement L<getpriority(2)>.
 
C<WHICH> can be any of C<PRIO_PROCESS>, C<PRIO_PGRP> or C<PRIO_USER>
imported from L<POSIX/RESOURCE CONSTANTS>.
 
Portability issues: L<perlport/getpriority>.
 
=item getpwnam NAME
X<getpwnam> X<getgrnam> X<gethostbyname> X<getnetbyname> X<getprotobyname>
X<getpwuid> X<getgrgid> X<getservbyname> X<gethostbyaddr> X<getnetbyaddr>
X<getprotobynumber> X<getservbyport> X<getpwent> X<getgrent> X<gethostent>
X<getnetent> X<getprotoent> X<getservent> X<setpwent> X<setgrent> X<sethostent>
X<setnetent> X<setprotoent> X<setservent> X<endpwent> X<endgrent> X<endhostent>
X<endnetent> X<endprotoent> X<endservent>
 
=for Pod::Functions get passwd record given user login name
 
=item getgrnam NAME
 
=for Pod::Functions get group record given group name
 
=item gethostbyname NAME
 
=for Pod::Functions get host record given name
 
=item getnetbyname NAME
 
=for Pod::Functions get networks record given name
 
=item getprotobyname NAME
 
=for Pod::Functions get protocol record given name
 
=item getpwuid UID
 
=for Pod::Functions get passwd record given user ID
 
=item getgrgid GID
 
=for Pod::Functions get group record given group user ID
 
=item getservbyname NAME,PROTO
 
=for Pod::Functions get services record given its name
 
=item gethostbyaddr ADDR,ADDRTYPE
 
=for Pod::Functions get host record given its address
 
=item getnetbyaddr ADDR,ADDRTYPE
 
=for Pod::Functions get network record given its address
 
=item getprotobynumber NUMBER
 
=for Pod::Functions get protocol record numeric protocol
 
=item getservbyport PORT,PROTO
 
=for Pod::Functions get services record given numeric port
 
=item getpwent
 
=for Pod::Functions get next passwd record
 
=item getgrent
 
=for Pod::Functions get next group record
 
=item gethostent
 
=for Pod::Functions get next hosts record
 
=item getnetent
 
=for Pod::Functions get next networks record
 
=item getprotoent
 
=for Pod::Functions get next protocols record
 
=item getservent
 
=for Pod::Functions get next services record
 
=item setpwent
 
=for Pod::Functions prepare passwd file for use
 
=item setgrent
 
=for Pod::Functions prepare group file for use
 
=item sethostent STAYOPEN
 
=for Pod::Functions prepare hosts file for use
 
=item setnetent STAYOPEN
 
=for Pod::Functions prepare networks file for use
 
=item setprotoent STAYOPEN
 
=for Pod::Functions prepare protocols file for use
 
=item setservent STAYOPEN
 
=for Pod::Functions prepare services file for use
 
=item endpwent
 
=for Pod::Functions be done using passwd file
 
=item endgrent
 
=for Pod::Functions be done using group file
 
=item endhostent
 
=for Pod::Functions be done using hosts file
 
=item endnetent
 
=for Pod::Functions be done using networks file
 
=item endprotoent
 
=for Pod::Functions be done using protocols file
 
=item endservent
 
=for Pod::Functions be done using services file
 
These routines are the same as their counterparts in the
system C library.  In list context, the return values from the
various get routines are as follows:
 
 #    0        1          2           3         4
 my ( $name,   $passwd,   $gid,       $members  ) = getgr*
 my ( $name,   $aliases,  $addrtype,  $net      ) = getnet*
 my ( $name,   $aliases,  $port,      $proto    ) = getserv*
 my ( $name,   $aliases,  $proto                ) = getproto*
 my ( $name,   $aliases,  $addrtype,  $length,  @addrs ) = gethost*
 my ( $name,   $passwd,   $uid,       $gid,     $quota,
    $comment,  $gcos,     $dir,       $shell,   $expire ) = getpw*
 #    5        6          7           8         9
 
(If the entry doesn't exist, the return value is a single meaningless true
value.)
 
The exact meaning of the $gcos field varies but it usually contains
the real name of the user (as opposed to the login name) and other
information pertaining to the user.  Beware, however, that in many
system users are able to change this information and therefore it
cannot be trusted and therefore the $gcos is tainted (see
L<perlsec>).  The $passwd and $shell, user's encrypted password and
login shell, are also tainted, for the same reason.
 
In scalar context, you get the name, unless the function was a
lookup by name, in which case you get the other thing, whatever it is.
(If the entry doesn't exist you get the undefined value.)  For example:
 
    my $uid   = getpwnam($name);
    my $name  = getpwuid($num);
    my $name  = getpwent();
    my $gid   = getgrnam($name);
    my $name  = getgrgid($num);
    my $name  = getgrent();
    # etc.
 
In I<getpw*()> the fields $quota, $comment, and $expire are special
in that they are unsupported on many systems.  If the
$quota is unsupported, it is an empty scalar.  If it is supported, it
usually encodes the disk quota.  If the $comment field is unsupported,
it is an empty scalar.  If it is supported it usually encodes some
administrative comment about the user.  In some systems the $quota
field may be $change or $age, fields that have to do with password
aging.  In some systems the $comment field may be $class.  The $expire
field, if present, encodes the expiration period of the account or the
password.  For the availability and the exact meaning of these fields
in your system, please consult L<getpwnam(3)> and your system's
F<pwd.h> file.  You can also find out from within Perl what your
$quota and $comment fields mean and whether you have the $expire field
by using the L<C<Config>|Config> module and the values C<d_pwquota>, C<d_pwage>,
C<d_pwchange>, C<d_pwcomment>, and C<d_pwexpire>.  Shadow password
files are supported only if your vendor has implemented them in the
intuitive fashion that calling the regular C library routines gets the
shadow versions if you're running under privilege or if there exists
the L<shadow(3)> functions as found in System V (this includes Solaris
and Linux).  Those systems that implement a proprietary shadow password
facility are unlikely to be supported.
 
The $members value returned by I<getgr*()> is a space-separated list of
the login names of the members of the group.
 
For the I<gethost*()> functions, if the C<h_errno> variable is supported in
C, it will be returned to you via L<C<$?>|perlvar/$?> if the function
call fails.  The
C<@addrs> value returned by a successful call is a list of raw
addresses returned by the corresponding library call.  In the
Internet domain, each address is four bytes long; you can unpack it
by saying something like:
 
    my ($w,$x,$y,$z) = unpack('W4',$addr[0]);
 
The Socket library makes this slightly easier:
 
    use Socket;
    my $iaddr = inet_aton("127.1"); # or whatever address
    my $name  = gethostbyaddr($iaddr, AF_INET);
 
    # or going the other way
    my $straddr = inet_ntoa($iaddr);
 
In the opposite way, to resolve a hostname to the IP address
you can write this:
 
    use Socket;
    my $packed_ip = gethostbyname("www.perl.org");
    my $ip_address;
    if (defined $packed_ip) {
        $ip_address = inet_ntoa($packed_ip);
    }
 
Make sure L<C<gethostbyname>|/gethostbyname NAME> is called in SCALAR
context and that its return value is checked for definedness.
 
The L<C<getprotobynumber>|/getprotobynumber NUMBER> function, even
though it only takes one argument, has the precedence of a list
operator, so beware:
 
    getprotobynumber $number eq 'icmp'   # WRONG
    getprotobynumber($number eq 'icmp')  # actually means this
    getprotobynumber($number) eq 'icmp'  # better this way
 
If you get tired of remembering which element of the return list
contains which return value, by-name interfaces are provided in standard
modules: L<C<File::stat>|File::stat>, L<C<Net::hostent>|Net::hostent>,
L<C<Net::netent>|Net::netent>, L<C<Net::protoent>|Net::protoent>,
L<C<Net::servent>|Net::servent>, L<C<Time::gmtime>|Time::gmtime>,
L<C<Time::localtime>|Time::localtime>, and
L<C<User::grent>|User::grent>.  These override the normal built-ins,
supplying versions that return objects with the appropriate names for
each field.  For example:
 
   use File::stat;
   use User::pwent;
   my $is_his = (stat($filename)->uid == pwent($whoever)->uid);
 
Even though it looks as though they're the same method calls (uid),
they aren't, because a C<File::stat> object is different from
a C<User::pwent> object.
 
Many of these functions are not safe in a multi-threaded environment
where more than one thread can be using them.  In particular, functions
like C<getpwent()> iterate per-process and not per-thread, so if two
threads are simultaneously iterating, neither will get all the records.
 
Some systems have thread-safe versions of some of the functions, such as
C<getpwnam_r()> instead of C<getpwnam()>.  There, Perl automatically and
invisibly substitutes the thread-safe version, without notice.  This
means that code that safely runs on some systems can fail on others that
lack the thread-safe versions.
 
Portability issues: L<perlport/getpwnam> to L<perlport/endservent>.
 
=item getsockname SOCKET
X<getsockname>
 
=for Pod::Functions retrieve the sockaddr for a given socket
 
Returns the packed sockaddr address of this end of the SOCKET connection,
in case you don't know the address because you have several different
IPs that the connection might have come in on.
 
    use Socket;
    my $mysockaddr = getsockname($sock);
    my ($port, $myaddr) = sockaddr_in($mysockaddr);
    printf "Connect to %s [%s]\n",
       scalar gethostbyaddr($myaddr, AF_INET),
       inet_ntoa($myaddr);
 
=item getsockopt SOCKET,LEVEL,OPTNAME
X<getsockopt>
 
=for Pod::Functions get socket options on a given socket
 
Queries the option named OPTNAME associated with SOCKET at a given LEVEL.
Options may exist at multiple protocol levels depending on the socket
type, but at least the uppermost socket level SOL_SOCKET (defined in the
L<C<Socket>|Socket> module) will exist.  To query options at another
level the protocol number of the appropriate protocol controlling the
option should be supplied.  For example, to indicate that an option is
to be interpreted by the TCP protocol, LEVEL should be set to the
protocol number of TCP, which you can get using
L<C<getprotobyname>|/getprotobyname NAME>.
 
The function returns a packed string representing the requested socket
option, or L<C<undef>|/undef EXPR> on error, with the reason for the
error placed in L<C<$!>|perlvar/$!>.  Just what is in the packed string
depends on LEVEL and OPTNAME; consult L<getsockopt(2)> for details.  A
common case is that the option is an integer, in which case the result
is a packed integer, which you can decode using
L<C<unpack>|/unpack TEMPLATE,EXPR> with the C<i> (or C<I>) format.
 
Here's an example to test whether Nagle's algorithm is enabled on a socket:
 
    use Socket qw(:all);
 
    defined(my $tcp = getprotobyname("tcp"))
        or die "Could not determine the protocol number for tcp";
    # my $tcp = IPPROTO_TCP; # Alternative
    my $packed = getsockopt($socket, $tcp, TCP_NODELAY)
        or die "getsockopt TCP_NODELAY: $!";
    my $nodelay = unpack("I", $packed);
    print "Nagle's algorithm is turned ",
           $nodelay ? "off\n" : "on\n";
 
Portability issues: L<perlport/getsockopt>.
 
=item glob EXPR
X<glob> X<wildcard> X<filename, expansion> X<expand>
 
=item glob
 
=for Pod::Functions expand filenames using wildcards
 
In list context, returns a (possibly empty) list of filename expansions on
the value of EXPR such as the standard Unix shell F</bin/csh> would do.  In
scalar context, glob iterates through such filename expansions, returning
undef when the list is exhausted.  This is the internal function
implementing the C<< <*.c> >> operator, but you can use it directly.  If
EXPR is omitted, L<C<$_>|perlvar/$_> is used.  The C<< <*.c> >> operator
is discussed in more detail in L<perlop/"I/O Operators">.
 
Note that L<C<glob>|/glob EXPR> splits its arguments on whitespace and
treats
each segment as separate pattern.  As such, C<glob("*.c *.h")>
matches all files with a F<.c> or F<.h> extension.  The expression
C<glob(".* *")> matches all files in the current working directory.
If you want to glob filenames that might contain whitespace, you'll
have to use extra quotes around the spacey filename to protect it.
For example, to glob filenames that have an C<e> followed by a space
followed by an C<f>, use one of:
 
    my @spacies = <"*e f*">;
    my @spacies = glob '"*e f*"';
    my @spacies = glob q("*e f*");
 
If you had to get a variable through, you could do this:
 
    my @spacies = glob "'*${var}e f*'";
    my @spacies = glob qq("*${var}e f*");
 
If non-empty braces are the only wildcard characters used in the
L<C<glob>|/glob EXPR>, no filenames are matched, but potentially many
strings are returned.  For example, this produces nine strings, one for
each pairing of fruits and colors:
 
    my @many = glob "{apple,tomato,cherry}={green,yellow,red}";
 
This operator is implemented using the standard C<File::Glob> extension.
See L<File::Glob> for details, including
L<C<bsd_glob>|File::Glob/C<bsd_glob>>, which does not treat whitespace
as a pattern separator.
 
If a C<glob> expression is used as the condition of a C<while> or C<for>
loop, then it will be implicitly assigned to C<$_>.  If either a C<glob>
expression or an explicit assignment of a C<glob> expression to a scalar
is used as a C<while>/C<for> condition, then the condition actually
tests for definedness of the expression's value, not for its regular
truth value.
 
Portability issues: L<perlport/glob>.
 
=item gmtime EXPR
X<gmtime> X<UTC> X<Greenwich>
 
=item gmtime
 
=for Pod::Functions convert UNIX time into record or string using Greenwich time
 
Works just like L<C<localtime>|/localtime EXPR> but the returned values
are localized for the standard Greenwich time zone.
 
Note: When called in list context, $isdst, the last value
returned by gmtime, is always C<0>.  There is no
Daylight Saving Time in GMT.
 
Portability issues: L<perlport/gmtime>.
 
=item goto LABEL
X<goto> X<jump> X<jmp>
 
=item goto EXPR
 
=item goto &NAME
 
=for Pod::Functions create spaghetti code
 
The C<goto LABEL> form finds the statement labeled with LABEL and
resumes execution there.  It can't be used to get out of a block or
subroutine given to L<C<sort>|/sort SUBNAME LIST>.  It can be used to go
almost anywhere else within the dynamic scope, including out of
subroutines, but it's usually better to use some other construct such as
L<C<last>|/last LABEL> or L<C<die>|/die LIST>.  The author of Perl has
never felt the need to use this form of L<C<goto>|/goto LABEL> (in Perl,
that is; C is another matter).  (The difference is that C does not offer
named loops combined with loop control.  Perl does, and this replaces
most structured uses of L<C<goto>|/goto LABEL> in other languages.)
 
The C<goto EXPR> form expects to evaluate C<EXPR> to a code reference or
a label name.  If it evaluates to a code reference, it will be handled
like C<goto &NAME>, below.  This is especially useful for implementing
tail recursion via C<goto __SUB__>.
 
If the expression evaluates to a label name, its scope will be resolved
dynamically.  This allows for computed L<C<goto>|/goto LABEL>s per
FORTRAN, but isn't necessarily recommended if you're optimizing for
maintainability:
 
    goto ("FOO", "BAR", "GLARCH")[$i];
 
As shown in this example, C<goto EXPR> is exempt from the "looks like a
function" rule.  A pair of parentheses following it does not (necessarily)
delimit its argument.  C<goto("NE")."XT"> is equivalent to C<goto NEXT>.
Also, unlike most named operators, this has the same precedence as
assignment.
 
Use of C<goto LABEL> or C<goto EXPR> to jump into a construct is
deprecated and will issue a warning.  Even then, it may not be used to
go into any construct that requires initialization, such as a
subroutine, a C<foreach> loop, or a C<given>
block.  In general, it may not be used to jump into the parameter
of a binary or list operator, but it may be used to jump into the
I<first> parameter of a binary operator.  (The C<=>
assignment operator's "first" operand is its right-hand
operand.)  It also can't be used to go into a
construct that is optimized away.
 
The C<goto &NAME> form is quite different from the other forms of
L<C<goto>|/goto LABEL>.  In fact, it isn't a goto in the normal sense at
all, and doesn't have the stigma associated with other gotos.  Instead,
it exits the current subroutine (losing any changes set by
L<C<local>|/local EXPR>) and immediately calls in its place the named
subroutine using the current value of L<C<@_>|perlvar/@_>.  This is used
by C<AUTOLOAD> subroutines that wish to load another subroutine and then
pretend that the other subroutine had been called in the first place
(except that any modifications to L<C<@_>|perlvar/@_> in the current
subroutine are propagated to the other subroutine.) After the
L<C<goto>|/goto LABEL>, not even L<C<caller>|/caller EXPR> will be able
to tell that this routine was called first.
 
NAME needn't be the name of a subroutine; it can be a scalar variable
containing a code reference or a block that evaluates to a code
reference.
 
=item grep BLOCK LIST
X<grep>
 
=item grep EXPR,LIST
 
=for Pod::Functions locate elements in a list test true against a given criterion
 
This is similar in spirit to, but not the same as, L<grep(1)> and its
relatives.  In particular, it is not limited to using regular expressions.
 
Evaluates the BLOCK or EXPR for each element of LIST (locally setting
L<C<$_>|perlvar/$_> to each element) and returns the list value
consisting of those
elements for which the expression evaluated to true.  In scalar
context, returns the number of times the expression was true.
 
    my @foo = grep(!/^#/, @bar);    # weed out comments
 
or equivalently,
 
    my @foo = grep {!/^#/} @bar;    # weed out comments
 
Note that L<C<$_>|perlvar/$_> is an alias to the list value, so it can
be used to
modify the elements of the LIST.  While this is useful and supported,
it can cause bizarre results if the elements of LIST are not variables.
Similarly, grep returns aliases into the original list, much as a for
loop's index variable aliases the list elements.  That is, modifying an
element of a list returned by grep (for example, in a C<foreach>,
L<C<map>|/map BLOCK LIST> or another L<C<grep>|/grep BLOCK LIST>)
actually modifies the element in the original list.
This is usually something to be avoided when writing clear code.
 
See also L<C<map>|/map BLOCK LIST> for a list composed of the results of
the BLOCK or EXPR.
 
=item hex EXPR
X<hex> X<hexadecimal>
 
=item hex
 
=for Pod::Functions convert a hexadecimal string to a number
 
Interprets EXPR as a hex string and returns the corresponding numeric value.
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
    print hex '0xAf'; # prints '175'
    print hex 'aF';   # same
    $valid_input =~ /\A(?:0?[xX])?(?:_?[0-9a-fA-F])*\z/
 
A hex string consists of hex digits and an optional C<0x> or C<x> prefix.
Each hex digit may be preceded by a single underscore, which will be ignored.
Any other character triggers a warning and causes the rest of the string
to be ignored (even leading whitespace, unlike L<C<oct>|/oct EXPR>).
Only integers can be represented, and integer overflow triggers a warning.
 
To convert strings that might start with any of C<0>, C<0x>, or C<0b>,
see L<C<oct>|/oct EXPR>.  To present something as hex, look into
L<C<printf>|/printf FILEHANDLE FORMAT, LIST>,
L<C<sprintf>|/sprintf FORMAT, LIST>, and
L<C<unpack>|/unpack TEMPLATE,EXPR>.
 
=item import LIST
X<import>
 
=for Pod::Functions patch a module's namespace into your own
 
There is no builtin L<C<import>|/import LIST> function.  It is just an
ordinary method (subroutine) defined (or inherited) by modules that wish
to export names to another module.  The
L<C<use>|/use Module VERSION LIST> function calls the
L<C<import>|/import LIST> method for the package used.  See also
L<C<use>|/use Module VERSION LIST>, L<perlmod>, and L<Exporter>.
 
=item index STR,SUBSTR,POSITION
X<index> X<indexOf> X<InStr>
 
=item index STR,SUBSTR
 
=for Pod::Functions find a substring within a string
 
The index function searches for one string within another, but without
the wildcard-like behavior of a full regular-expression pattern match.
It returns the position of the first occurrence of SUBSTR in STR at
or after POSITION.  If POSITION is omitted, starts searching from the
beginning of the string.  POSITION before the beginning of the string
or after its end is treated as if it were the beginning or the end,
respectively.  POSITION and the return value are based at zero.
If the substring is not found, L<C<index>|/index STR,SUBSTR,POSITION>
returns -1.
 
=item int EXPR
X<int> X<integer> X<truncate> X<trunc> X<floor>
 
=item int
 
=for Pod::Functions get the integer portion of a number
 
Returns the integer portion of EXPR.  If EXPR is omitted, uses
L<C<$_>|perlvar/$_>.
You should not use this function for rounding: one because it truncates
towards C<0>, and two because machine representations of floating-point
numbers can sometimes produce counterintuitive results.  For example,
C<int(-6.725/0.025)> produces -268 rather than the correct -269; that's
because it's really more like -268.99999999999994315658 instead.  Usually,
the L<C<sprintf>|/sprintf FORMAT, LIST>,
L<C<printf>|/printf FILEHANDLE FORMAT, LIST>, or the
L<C<POSIX::floor>|POSIX/C<floor>> and L<C<POSIX::ceil>|POSIX/C<ceil>>
functions will serve you better than will L<C<int>|/int EXPR>.
 
=item ioctl FILEHANDLE,FUNCTION,SCALAR
X<ioctl>
 
=for Pod::Functions system-dependent device control system call
 
Implements the L<ioctl(2)> function.  You'll probably first have to say
 
    require "sys/ioctl.ph";  # probably in
                             # $Config{archlib}/sys/ioctl.ph
 
to get the correct function definitions.  If F<sys/ioctl.ph> doesn't
exist or doesn't have the correct definitions you'll have to roll your
own, based on your C header files such as F<< <sys/ioctl.h> >>.
(There is a Perl script called B<h2ph> that comes with the Perl kit that
may help you in this, but it's nontrivial.)  SCALAR will be read and/or
written depending on the FUNCTION; a C pointer to the string value of SCALAR
will be passed as the third argument of the actual
L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR> call.  (If SCALAR
has no string value but does have a numeric value, that value will be
passed rather than a pointer to the string value.  To guarantee this to be
true, add a C<0> to the scalar before using it.)  The
L<C<pack>|/pack TEMPLATE,LIST> and L<C<unpack>|/unpack TEMPLATE,EXPR>
functions may be needed to manipulate the values of structures used by
L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>.
 
The return value of L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR> (and
L<C<fcntl>|/fcntl FILEHANDLE,FUNCTION,SCALAR>) is as follows:
 
    if OS returns:      then Perl returns:
        -1               undefined value
         0              string "0 but true"
    anything else           that number
 
Thus Perl returns true on success and false on failure, yet you can
still easily determine the actual value returned by the operating
system:
 
    my $retval = ioctl(...) || -1;
    printf "System returned %d\n", $retval;
 
The special string C<"0 but true"> is exempt from
L<C<Argument "..." isn't numeric>|perldiag/Argument "%s" isn't numeric%s>
L<warnings> on improper numeric conversions.
 
Portability issues: L<perlport/ioctl>.
 
=item join EXPR,LIST
X<join>
 
=for Pod::Functions join a list into a string using a separator
 
Joins the separate strings of LIST into a single string with fields
separated by the value of EXPR, and returns that new string.  Example:
 
   my $rec = join(':', $login,$passwd,$uid,$gid,$gcos,$home,$shell);
 
Beware that unlike L<C<split>|/split E<sol>PATTERNE<sol>,EXPR,LIMIT>,
L<C<join>|/join EXPR,LIST> doesn't take a pattern as its first argument.
Compare L<C<split>|/split E<sol>PATTERNE<sol>,EXPR,LIMIT>.
 
=item keys HASH
X<keys> X<key>
 
=item keys ARRAY
 
=for Pod::Functions retrieve list of indices from a hash
 
Called in list context, returns a list consisting of all the keys of the
named hash, or in Perl 5.12 or later only, the indices of an array.  Perl
releases prior to 5.12 will produce a syntax error if you try to use an
array argument.  In scalar context, returns the number of keys or indices.
 
Hash entries are returned in an apparently random order.  The actual random
order is specific to a given hash; the exact same series of operations
on two hashes may result in a different order for each hash.  Any insertion
into the hash may change the order, as will any deletion, with the exception
that the most recent key returned by L<C<each>|/each HASH> or
L<C<keys>|/keys HASH> may be deleted without changing the order.  So
long as a given hash is unmodified you may rely on
L<C<keys>|/keys HASH>, L<C<values>|/values HASH> and L<C<each>|/each
HASH> to repeatedly return the same order
as each other.  See L<perlsec/"Algorithmic Complexity Attacks"> for
details on why hash order is randomized.  Aside from the guarantees
provided here the exact details of Perl's hash algorithm and the hash
traversal order are subject to change in any release of Perl.  Tied hashes
may behave differently to Perl's hashes with respect to changes in order on
insertion and deletion of items.
 
As a side effect, calling L<C<keys>|/keys HASH> resets the internal
iterator of the HASH or ARRAY (see L<C<each>|/each HASH>) before
yielding the keys.  In
particular, calling L<C<keys>|/keys HASH> in void context resets the
iterator with no other overhead.
 
Here is yet another way to print your environment:
 
    my @keys = keys %ENV;
    my @values = values %ENV;
    while (@keys) {
        print pop(@keys), '=', pop(@values), "\n";
    }
 
or how about sorted by key:
 
    foreach my $key (sort(keys %ENV)) {
        print $key, '=', $ENV{$key}, "\n";
    }
 
The returned values are copies of the original keys in the hash, so
modifying them will not affect the original hash.  Compare
L<C<values>|/values HASH>.
 
To sort a hash by value, you'll need to use a
L<C<sort>|/sort SUBNAME LIST> function.  Here's a descending numeric
sort of a hash by its values:
 
    foreach my $key (sort { $hash{$b} <=> $hash{$a} } keys %hash) {
        printf "%4d %s\n", $hash{$key}, $key;
    }
 
Used as an lvalue, L<C<keys>|/keys HASH> allows you to increase the
number of hash buckets
allocated for the given hash.  This can gain you a measure of efficiency if
you know the hash is going to get big.  (This is similar to pre-extending
an array by assigning a larger number to $#array.)  If you say
 
    keys %hash = 200;
 
then C<%hash> will have at least 200 buckets allocated for it--256 of them,
in fact, since it rounds up to the next power of two.  These
buckets will be retained even if you do C<%hash = ()>, use C<undef
%hash> if you want to free the storage while C<%hash> is still in scope.
You can't shrink the number of buckets allocated for the hash using
L<C<keys>|/keys HASH> in this way (but you needn't worry about doing
this by accident, as trying has no effect).  C<keys @array> in an lvalue
context is a syntax error.
 
Starting with Perl 5.14, an experimental feature allowed
L<C<keys>|/keys HASH> to take a scalar expression. This experiment has
been deemed unsuccessful, and was removed as of Perl 5.24.
 
To avoid confusing would-be users of your code who are running earlier
versions of Perl with mysterious syntax errors, put this sort of thing at
the top of your file to signal that your code will work I<only> on Perls of
a recent vintage:
 
    use 5.012;  # so keys/values/each work on arrays
 
See also L<C<each>|/each HASH>, L<C<values>|/values HASH>, and
L<C<sort>|/sort SUBNAME LIST>.
 
=item kill SIGNAL, LIST
 
=item kill SIGNAL
X<kill> X<signal>
 
=for Pod::Functions send a signal to a process or process group
 
Sends a signal to a list of processes.  Returns the number of arguments
that were successfully used to signal (which is not necessarily the same
as the number of processes actually killed, e.g. where a process group is
killed).
 
    my $cnt = kill 'HUP', $child1, $child2;
    kill 'KILL', @goners;
 
SIGNAL may be either a signal name (a string) or a signal number.  A signal
name may start with a C<SIG> prefix, thus C<FOO> and C<SIGFOO> refer to the
same signal.  The string form of SIGNAL is recommended for portability because
the same signal may have different numbers in different operating systems.
 
A list of signal names supported by the current platform can be found in
C<$Config{sig_name}>, which is provided by the L<C<Config>|Config>
module.  See L<Config> for more details.
 
A negative signal name is the same as a negative signal number, killing process
groups instead of processes.  For example, C<kill '-KILL', $pgrp> and
C<kill -9, $pgrp> will send C<SIGKILL> to
the entire process group specified.  That
means you usually want to use positive not negative signals.
 
If SIGNAL is either the number 0 or the string C<ZERO> (or C<SIGZERO>),
no signal is sent to the process, but L<C<kill>|/kill SIGNAL, LIST>
checks whether it's I<possible> to send a signal to it
(that means, to be brief, that the process is owned by the same user, or we are
the super-user).  This is useful to check that a child process is still
alive (even if only as a zombie) and hasn't changed its UID.  See
L<perlport> for notes on the portability of this construct.
 
The behavior of kill when a I<PROCESS> number is zero or negative depends on
the operating system.  For example, on POSIX-conforming systems, zero will
signal the current process group, -1 will signal all processes, and any
other negative PROCESS number will act as a negative signal number and
kill the entire process group specified.
 
If both the SIGNAL and the PROCESS are negative, the results are undefined.
A warning may be produced in a future version.
 
See L<perlipc/"Signals"> for more details.
 
On some platforms such as Windows where the L<fork(2)> system call is not
available, Perl can be built to emulate L<C<fork>|/fork> at the
interpreter level.
This emulation has limitations related to kill that have to be considered,
for code running on Windows and in code intended to be portable.
 
See L<perlfork> for more details.
 
If there is no I<LIST> of processes, no signal is sent, and the return
value is 0.  This form is sometimes used, however, because it causes
tainting checks to be run.  But see
L<perlsec/Laundering and Detecting Tainted Data>.
 
Portability issues: L<perlport/kill>.
 
=item last LABEL
X<last> X<break>
 
=item last EXPR
 
=item last
 
=for Pod::Functions exit a block prematurely
 
The L<C<last>|/last LABEL> command is like the C<break> statement in C
(as used in
loops); it immediately exits the loop in question.  If the LABEL is
omitted, the command refers to the innermost enclosing
loop.  The C<last EXPR> form, available starting in Perl
5.18.0, allows a label name to be computed at run time,
and is otherwise identical to C<last LABEL>.  The
L<C<continue>|/continue BLOCK> block, if any, is not executed:
 
    LINE: while (<STDIN>) {
        last LINE if /^$/;  # exit when done with header
        #...
    }
 
L<C<last>|/last LABEL> cannot return a value from a block that typically
returns a value, such as C<eval {}>, C<sub {}>, or C<do {}>. It will perform
its flow control behavior, which precludes any return value. It should not be
used to exit a L<C<grep>|/grep BLOCK LIST> or L<C<map>|/map BLOCK LIST>
operation.
 
Note that a block by itself is semantically identical to a loop
that executes once.  Thus L<C<last>|/last LABEL> can be used to effect
an early exit out of such a block.
 
See also L<C<continue>|/continue BLOCK> for an illustration of how
L<C<last>|/last LABEL>, L<C<next>|/next LABEL>, and
L<C<redo>|/redo LABEL> work.
 
Unlike most named operators, this has the same precedence as assignment.
It is also exempt from the looks-like-a-function rule, so
C<last ("foo")."bar"> will cause "bar" to be part of the argument to
L<C<last>|/last LABEL>.
 
=item lc EXPR
X<lc> X<lowercase>
 
=item lc
 
=for Pod::Functions return lower-case version of a string
 
Returns a lowercased version of EXPR.  This is the internal function
implementing the C<\L> escape in double-quoted strings.
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
What gets returned depends on several factors:
 
=over
 
=item If C<use bytes> is in effect:
 
The results follow ASCII rules.  Only the characters C<A-Z> change,
to C<a-z> respectively.
 
=item Otherwise, if C<use locale> for C<LC_CTYPE> is in effect:
 
Respects current C<LC_CTYPE> locale for code points < 256; and uses Unicode
rules for the remaining code points (this last can only happen if
the UTF8 flag is also set).  See L<perllocale>.
 
Starting in v5.20, Perl uses full Unicode rules if the locale is
UTF-8.  Otherwise, there is a deficiency in this scheme, which is that
case changes that cross the 255/256
boundary are not well-defined.  For example, the lower case of LATIN CAPITAL
LETTER SHARP S (U+1E9E) in Unicode rules is U+00DF (on ASCII
platforms).   But under C<use locale> (prior to v5.20 or not a UTF-8
locale), the lower case of U+1E9E is
itself, because 0xDF may not be LATIN SMALL LETTER SHARP S in the
current locale, and Perl has no way of knowing if that character even
exists in the locale, much less what code point it is.  Perl returns
a result that is above 255 (almost always the input character unchanged),
for all instances (and there aren't many) where the 255/256 boundary
would otherwise be crossed; and starting in v5.22, it raises a
L<locale|perldiag/Can't do %s("%s") on non-UTF-8 locale; resolved to "%s".> warning.
 
=item Otherwise, If EXPR has the UTF8 flag set:
 
Unicode rules are used for the case change.
 
=item Otherwise, if C<use feature 'unicode_strings'> or C<use locale ':not_characters'> is in effect:
 
Unicode rules are used for the case change.
 
=item Otherwise:
 
ASCII rules are used for the case change.  The lowercase of any character
outside the ASCII range is the character itself.
 
=back
 
=item lcfirst EXPR
X<lcfirst> X<lowercase>
 
=item lcfirst
 
=for Pod::Functions return a string with just the next letter in lower case
 
Returns the value of EXPR with the first character lowercased.  This
is the internal function implementing the C<\l> escape in
double-quoted strings.
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
This function behaves the same way under various pragmas, such as in a locale,
as L<C<lc>|/lc EXPR> does.
 
=item length EXPR
X<length> X<size>
 
=item length
 
=for Pod::Functions return the number of characters in a string
 
Returns the length in I<characters> of the value of EXPR.  If EXPR is
omitted, returns the length of L<C<$_>|perlvar/$_>.  If EXPR is
undefined, returns L<C<undef>|/undef EXPR>.
 
This function cannot be used on an entire array or hash to find out how
many elements these have.  For that, use C<scalar @array> and C<scalar keys
%hash>, respectively.
 
Like all Perl character operations, L<C<length>|/length EXPR> normally
deals in logical
characters, not physical bytes.  For how many bytes a string encoded as
UTF-8 would take up, use C<length(Encode::encode('UTF-8', EXPR))>
(you'll have to C<use Encode> first).  See L<Encode> and L<perlunicode>.
 
=item __LINE__
X<__LINE__>
 
=for Pod::Functions the current source line number
 
A special token that compiles to the current line number.
It can be altered by the mechanism described at
L<perlsyn/"Plain Old Comments (Not!)">.
 
=item link OLDFILE,NEWFILE
X<link>
 
=for Pod::Functions create a hard link in the filesystem
 
Creates a new filename linked to the old filename.  Returns true for
success, false otherwise.
 
Portability issues: L<perlport/link>.
 
=item listen SOCKET,QUEUESIZE
X<listen>
 
=for Pod::Functions register your socket as a server
 
Does the same thing that the L<listen(2)> system call does.  Returns true if
it succeeded, false otherwise.  See the example in
L<perlipc/"Sockets: Client/Server Communication">.
 
=item local EXPR
X<local>
 
=for Pod::Functions create a temporary value for a global variable (dynamic scoping)
 
You really probably want to be using L<C<my>|/my VARLIST> instead,
because L<C<local>|/local EXPR> isn't what most people think of as
"local".  See L<perlsub/"Private Variables via my()"> for details.
 
A local modifies the listed variables to be local to the enclosing
block, file, or eval.  If more than one value is listed, the list must
be placed in parentheses.  See L<perlsub/"Temporary Values via local()">
for details, including issues with tied arrays and hashes.
 
The C<delete local EXPR> construct can also be used to localize the deletion
of array/hash elements to the current block.
See L<perlsub/"Localized deletion of elements of composite types">.
 
=item localtime EXPR
X<localtime> X<ctime>
 
=item localtime
 
=for Pod::Functions convert UNIX time into record or string using local time
 
Converts a time as returned by the time function to a 9-element list
with the time analyzed for the local time zone.  Typically used as
follows:
 
    #     0    1    2     3     4    5     6     7     8
    my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) =
                                                localtime(time);
 
All list elements are numeric and come straight out of the C `struct
tm'.  C<$sec>, C<$min>, and C<$hour> are the seconds, minutes, and hours
of the specified time.
 
C<$mday> is the day of the month and C<$mon> the month in
the range C<0..11>, with 0 indicating January and 11 indicating December.
This makes it easy to get a month name from a list:
 
    my @abbr = qw(Jan Feb Mar Apr May Jun Jul Aug Sep Oct Nov Dec);
    print "$abbr[$mon] $mday";
    # $mon=9, $mday=18 gives "Oct 18"
 
C<$year> contains the number of years since 1900.  To get a 4-digit
year write:
 
    $year += 1900;
 
To get the last two digits of the year (e.g., "01" in 2001) do:
 
    $year = sprintf("%02d", $year % 100);
 
C<$wday> is the day of the week, with 0 indicating Sunday and 3 indicating
Wednesday.  C<$yday> is the day of the year, in the range C<0..364>
(or C<0..365> in leap years.)
 
C<$isdst> is true if the specified time occurs during Daylight Saving
Time, false otherwise.
 
If EXPR is omitted, L<C<localtime>|/localtime EXPR> uses the current
time (as returned by L<C<time>|/time>).
 
In scalar context, L<C<localtime>|/localtime EXPR> returns the
L<ctime(3)> value:
 
    my $now_string = localtime;  # e.g., "Thu Oct 13 04:54:34 1994"
 
The format of this scalar value is B<not> locale-dependent but built
into Perl.  For GMT instead of local time use the
L<C<gmtime>|/gmtime EXPR> builtin.  See also the
L<C<Time::Local>|Time::Local> module (for converting seconds, minutes,
hours, and such back to the integer value returned by L<C<time>|/time>),
and the L<POSIX> module's L<C<strftime>|POSIX/C<strftime>> and
L<C<mktime>|POSIX/C<mktime>> functions.
 
To get somewhat similar but locale-dependent date strings, set up your
locale environment variables appropriately (please see L<perllocale>) and
try for example:
 
    use POSIX qw(strftime);
    my $now_string = strftime "%a %b %e %H:%M:%S %Y", localtime;
    # or for GMT formatted appropriately for your locale:
    my $now_string = strftime "%a %b %e %H:%M:%S %Y", gmtime;
 
Note that C<%a> and C<%b>, the short forms of the day of the week
and the month of the year, may not necessarily be three characters wide.
 
The L<Time::gmtime> and L<Time::localtime> modules provide a convenient,
by-name access mechanism to the L<C<gmtime>|/gmtime EXPR> and
L<C<localtime>|/localtime EXPR> functions, respectively.
 
For a comprehensive date and time representation look at the
L<DateTime> module on CPAN.
 
Portability issues: L<perlport/localtime>.
 
=item lock THING
X<lock>
 
=for Pod::Functions +5.005 get a thread lock on a variable, subroutine, or method
 
This function places an advisory lock on a shared variable or referenced
object contained in I<THING> until the lock goes out of scope.
 
The value returned is the scalar itself, if the argument is a scalar, or a
reference, if the argument is a hash, array or subroutine.
 
L<C<lock>|/lock THING> is a "weak keyword"; this means that if you've
defined a function
by this name (before any calls to it), that function will be called
instead.  If you are not under C<use threads::shared> this does nothing.
See L<threads::shared>.
 
=item log EXPR
X<log> X<logarithm> X<e> X<ln> X<base>
 
=item log
 
=for Pod::Functions retrieve the natural logarithm for a number
 
Returns the natural logarithm (base I<e>) of EXPR.  If EXPR is omitted,
returns the log of L<C<$_>|perlvar/$_>.  To get the
log of another base, use basic algebra:
The base-N log of a number is equal to the natural log of that number
divided by the natural log of N.  For example:
 
    sub log10 {
        my $n = shift;
        return log($n)/log(10);
    }
 
See also L<C<exp>|/exp EXPR> for the inverse operation.
 
=item lstat FILEHANDLE
X<lstat>
 
=item lstat EXPR
 
=item lstat DIRHANDLE
 
=item lstat
 
=for Pod::Functions stat a symbolic link
 
Does the same thing as the L<C<stat>|/stat FILEHANDLE> function
(including setting the special C<_> filehandle) but stats a symbolic
link instead of the file the symbolic link points to.  If symbolic links
are unimplemented on your system, a normal L<C<stat>|/stat FILEHANDLE>
is done.  For much more detailed information, please see the
documentation for L<C<stat>|/stat FILEHANDLE>.
 
If EXPR is omitted, stats L<C<$_>|perlvar/$_>.
 
Portability issues: L<perlport/lstat>.
 
=item m//
 
=for Pod::Functions match a string with a regular expression pattern
 
The match operator.  See L<perlop/"Regexp Quote-Like Operators">.
 
=item map BLOCK LIST
X<map>
 
=item map EXPR,LIST
 
=for Pod::Functions apply a change to a list to get back a new list with the changes
 
Evaluates the BLOCK or EXPR for each element of LIST (locally setting
L<C<$_>|perlvar/$_> to each element) and composes a list of the results of
each such evaluation.  Each element of LIST may produce zero, one, or more
elements in the generated list, so the number of elements in the generated
list may differ from that in LIST.  In scalar context, returns the total
number of elements so generated.  In list context, returns the generated list.
 
    my @chars = map(chr, @numbers);
 
translates a list of numbers to the corresponding characters.
 
    my @squares = map { $_ * $_ } @numbers;
 
translates a list of numbers to their squared values.
 
    my @squares = map { $_ > 5 ? ($_ * $_) : () } @numbers;
 
shows that number of returned elements can differ from the number of
input elements.  To omit an element, return an empty list ().
This could also be achieved by writing
 
    my @squares = map { $_ * $_ } grep { $_ > 5 } @numbers;
 
which makes the intention more clear.
 
Map always returns a list, which can be
assigned to a hash such that the elements
become key/value pairs.  See L<perldata> for more details.
 
    my %hash = map { get_a_key_for($_) => $_ } @array;
 
is just a funny way to write
 
    my %hash;
    foreach (@array) {
        $hash{get_a_key_for($_)} = $_;
    }
 
Note that L<C<$_>|perlvar/$_> is an alias to the list value, so it can
be used to modify the elements of the LIST.  While this is useful and
supported, it can cause bizarre results if the elements of LIST are not
variables.  Using a regular C<foreach> loop for this purpose would be
clearer in most cases.  See also L<C<grep>|/grep BLOCK LIST> for a
list composed of those items of the original list for which the BLOCK
or EXPR evaluates to true.
 
C<{> starts both hash references and blocks, so C<map { ...> could be either
the start of map BLOCK LIST or map EXPR, LIST.  Because Perl doesn't look
ahead for the closing C<}> it has to take a guess at which it's dealing with
based on what it finds just after the
C<{>.  Usually it gets it right, but if it
doesn't it won't realize something is wrong until it gets to the C<}> and
encounters the missing (or unexpected) comma.  The syntax error will be
reported close to the C<}>, but you'll need to change something near the C<{>
such as using a unary C<+> or semicolon to give Perl some help:
 
 my %hash = map {  "\L$_" => 1  } @array # perl guesses EXPR. wrong
 my %hash = map { +"\L$_" => 1  } @array # perl guesses BLOCK. right
 my %hash = map {; "\L$_" => 1  } @array # this also works
 my %hash = map { ("\L$_" => 1) } @array # as does this
 my %hash = map {  lc($_) => 1  } @array # and this.
 my %hash = map +( lc($_) => 1 ), @array # this is EXPR and works!
 
 my %hash = map  ( lc($_), 1 ),   @array # evaluates to (1, @array)
 
or to force an anon hash constructor use C<+{>:
 
    my @hashes = map +{ lc($_) => 1 }, @array # EXPR, so needs
                                              # comma at end
 
to get a list of anonymous hashes each with only one entry apiece.
 
=item mkdir FILENAME,MODE
X<mkdir> X<md> X<directory, create>
 
=item mkdir FILENAME
 
=item mkdir
 
=for Pod::Functions create a directory
 
Creates the directory specified by FILENAME, with permissions
specified by MODE (as modified by L<C<umask>|/umask EXPR>).  If it
succeeds it returns true; otherwise it returns false and sets
L<C<$!>|perlvar/$!> (errno).
MODE defaults to 0777 if omitted, and FILENAME defaults
to L<C<$_>|perlvar/$_> if omitted.
 
In general, it is better to create directories with a permissive MODE
and let the user modify that with their L<C<umask>|/umask EXPR> than it
is to supply
a restrictive MODE and give the user no way to be more permissive.
The exceptions to this rule are when the file or directory should be
kept private (mail files, for instance).  The documentation for
L<C<umask>|/umask EXPR> discusses the choice of MODE in more detail.
 
Note that according to the POSIX 1003.1-1996 the FILENAME may have any
number of trailing slashes.  Some operating and filesystems do not get
this right, so Perl automatically removes all trailing slashes to keep
everyone happy.
 
To recursively create a directory structure, look at
the L<C<make_path>|File::Path/make_path( $dir1, $dir2, .... )> function
of the L<File::Path> module.
 
=item msgctl ID,CMD,ARG
X<msgctl>
 
=for Pod::Functions SysV IPC message control operations
 
Calls the System V IPC function L<msgctl(2)>.  You'll probably have to say
 
    use IPC::SysV;
 
first to get the correct constant definitions.  If CMD is C<IPC_STAT>,
then ARG must be a variable that will hold the returned C<msqid_ds>
structure.  Returns like L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>:
the undefined value for error, C<"0 but true"> for zero, or the actual
return value otherwise.  See also L<perlipc/"SysV IPC"> and the
documentation for L<C<IPC::SysV>|IPC::SysV> and
L<C<IPC::Semaphore>|IPC::Semaphore>.
 
Portability issues: L<perlport/msgctl>.
 
=item msgget KEY,FLAGS
X<msgget>
 
=for Pod::Functions get SysV IPC message queue
 
Calls the System V IPC function L<msgget(2)>.  Returns the message queue
id, or L<C<undef>|/undef EXPR> on error.  See also L<perlipc/"SysV IPC">
and the documentation for L<C<IPC::SysV>|IPC::SysV> and
L<C<IPC::Msg>|IPC::Msg>.
 
Portability issues: L<perlport/msgget>.
 
=item msgrcv ID,VAR,SIZE,TYPE,FLAGS
X<msgrcv>
 
=for Pod::Functions receive a SysV IPC message from a message queue
 
Calls the System V IPC function msgrcv to receive a message from
message queue ID into variable VAR with a maximum message size of
SIZE.  Note that when a message is received, the message type as a
native long integer will be the first thing in VAR, followed by the
actual message.  This packing may be opened with C<unpack("l! a*")>.
Taints the variable.  Returns true if successful, false
on error.  See also L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV> and L<C<IPC::Msg>|IPC::Msg>.
 
Portability issues: L<perlport/msgrcv>.
 
=item msgsnd ID,MSG,FLAGS
X<msgsnd>
 
=for Pod::Functions send a SysV IPC message to a message queue
 
Calls the System V IPC function msgsnd to send the message MSG to the
message queue ID.  MSG must begin with the native long integer message
type, be followed by the length of the actual message, and then finally
the message itself.  This kind of packing can be achieved with
C<pack("l! a*", $type, $message)>.  Returns true if successful,
false on error.  See also L<perlipc/"SysV IPC"> and the documentation
for L<C<IPC::SysV>|IPC::SysV> and L<C<IPC::Msg>|IPC::Msg>.
 
Portability issues: L<perlport/msgsnd>.
 
=item my VARLIST
X<my>
 
=item my TYPE VARLIST
 
=item my VARLIST : ATTRS
 
=item my TYPE VARLIST : ATTRS
 
=for Pod::Functions declare and assign a local variable (lexical scoping)
 
A L<C<my>|/my VARLIST> declares the listed variables to be local
(lexically) to the enclosing block, file, or L<C<eval>|/eval EXPR>.  If
more than one variable is listed, the list must be placed in
parentheses.
 
The exact semantics and interface of TYPE and ATTRS are still
evolving.  TYPE may be a bareword, a constant declared
with L<C<use constant>|constant>, or L<C<__PACKAGE__>|/__PACKAGE__>.  It
is
currently bound to the use of the L<fields> pragma,
and attributes are handled using the L<attributes> pragma, or starting
from Perl 5.8.0 also via the L<Attribute::Handlers> module.  See
L<perlsub/"Private Variables via my()"> for details.
 
Note that with a parenthesised list, L<C<undef>|/undef EXPR> can be used
as a dummy placeholder, for example to skip assignment of initial
values:
 
    my ( undef, $min, $hour ) = localtime;
 
=item next LABEL
X<next> X<continue>
 
=item next EXPR
 
=item next
 
=for Pod::Functions iterate a block prematurely
 
The L<C<next>|/next LABEL> command is like the C<continue> statement in
C; it starts the next iteration of the loop:
 
    LINE: while (<STDIN>) {
        next LINE if /^#/;  # discard comments
        #...
    }
 
Note that if there were a L<C<continue>|/continue BLOCK> block on the
above, it would get
executed even on discarded lines.  If LABEL is omitted, the command
refers to the innermost enclosing loop.  The C<next EXPR> form, available
as of Perl 5.18.0, allows a label name to be computed at run time, being
otherwise identical to C<next LABEL>.
 
L<C<next>|/next LABEL> cannot return a value from a block that typically
returns a value, such as C<eval {}>, C<sub {}>, or C<do {}>. It will perform
its flow control behavior, which precludes any return value. It should not be
used to exit a L<C<grep>|/grep BLOCK LIST> or L<C<map>|/map BLOCK LIST>
operation.
 
Note that a block by itself is semantically identical to a loop
that executes once.  Thus L<C<next>|/next LABEL> will exit such a block
early.
 
See also L<C<continue>|/continue BLOCK> for an illustration of how
L<C<last>|/last LABEL>, L<C<next>|/next LABEL>, and
L<C<redo>|/redo LABEL> work.
 
Unlike most named operators, this has the same precedence as assignment.
It is also exempt from the looks-like-a-function rule, so
C<next ("foo")."bar"> will cause "bar" to be part of the argument to
L<C<next>|/next LABEL>.
 
=item no MODULE VERSION LIST
X<no declarations>
X<unimporting>
 
=item no MODULE VERSION
 
=item no MODULE LIST
 
=item no MODULE
 
=item no VERSION
 
=for Pod::Functions unimport some module symbols or semantics at compile time
 
See the L<C<use>|/use Module VERSION LIST> function, of which
L<C<no>|/no MODULE VERSION LIST> is the opposite.
 
=item oct EXPR
X<oct> X<octal> X<hex> X<hexadecimal> X<binary> X<bin>
 
=item oct
 
=for Pod::Functions convert a string to an octal number
 
Interprets EXPR as an octal string and returns the corresponding
value.  (If EXPR happens to start off with C<0x>, interprets it as a
hex string.  If EXPR starts off with C<0b>, it is interpreted as a
binary string.  Leading whitespace is ignored in all three cases.)
The following will handle decimal, binary, octal, and hex in standard
Perl notation:
 
    $val = oct($val) if $val =~ /^0/;
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.   To go the other way
(produce a number in octal), use L<C<sprintf>|/sprintf FORMAT, LIST> or
L<C<printf>|/printf FILEHANDLE FORMAT, LIST>:
 
    my $dec_perms = (stat("filename"))[2] & 07777;
    my $oct_perm_str = sprintf "%o", $perms;
 
The L<C<oct>|/oct EXPR> function is commonly used when a string such as
C<644> needs
to be converted into a file mode, for example.  Although Perl
automatically converts strings into numbers as needed, this automatic
conversion assumes base 10.
 
Leading white space is ignored without warning, as too are any trailing
non-digits, such as a decimal point (L<C<oct>|/oct EXPR> only handles
non-negative integers, not negative integers or floating point).
 
=item open FILEHANDLE,MODE,EXPR
X<open> X<pipe> X<file, open> X<fopen>
 
=item open FILEHANDLE,MODE,EXPR,LIST
 
=item open FILEHANDLE,MODE,REFERENCE
 
=item open FILEHANDLE,EXPR
 
=item open FILEHANDLE
 
=for Pod::Functions open a file, pipe, or descriptor
 
Associates an internal FILEHANDLE with the external file specified by
EXPR. That filehandle will subsequently allow you to perform
I/O operations on that file, such as reading from it or writing to it.
 
Instead of a filename, you may specify an external command
(plus an optional argument list) or a scalar reference, in order to open
filehandles on commands or in-memory scalars, respectively.
 
A thorough reference to C<open> follows. For a gentler introduction to
the basics of C<open>, see also the L<perlopentut> manual page.
 
=over
 
=item Working with files
 
Most often, C<open> gets invoked with three arguments: the required
FILEHANDLE (usually an empty scalar variable), followed by MODE (usually
a literal describing the I/O mode the filehandle will use), and then the
filename  that the new filehandle will refer to.
 
=over
 
=item Simple examples
 
Reading from a file:
 
    open(my $fh, "<", "input.txt")
        or die "Can't open < input.txt: $!";
 
    # Process every line in input.txt
    while (my $line = <$fh>) {
        #
        # ... do something interesting with $line here ...
        #
    }
 
or writing to one:
 
    open(my $fh, ">", "output.txt")
        or die "Can't open > output.txt: $!";
 
    print $fh "This line gets printed into output.txt.\n";
 
For a summary of common filehandle operations such as these, see
L<perlintro/Files and I/O>.
 
=item About filehandles
 
The first argument to C<open>, labeled FILEHANDLE in this reference, is
usually a scalar variable. (Exceptions exist, described in "Other
considerations", below.) If the call to C<open> succeeds, then the
expression provided as FILEHANDLE will get assigned an open
I<filehandle>. That filehandle provides an internal reference to the
specified external file, conveniently stored in a Perl variable, and
ready for I/O operations such as reading and writing.
 
=item About modes
 
When calling C<open> with three or more arguments, the second argument
-- labeled MODE here -- defines the I<open mode>. MODE is usually a
literal string comprising special characters that define the intended
I/O role of the filehandle being created: whether it's read-only, or
read-and-write, and so on.
 
If MODE is C<< < >>, the file is opened for input (read-only).
If MODE is C<< > >>, the file is opened for output, with existing files
first being truncated ("clobbered") and nonexisting files newly created.
If MODE is C<<< >> >>>, the file is opened for appending, again being
created if necessary.
 
You can put a C<+> in front of the C<< > >> or C<< < >> to
indicate that you want both read and write access to the file; thus
C<< +< >> is almost always preferred for read/write updates--the
C<< +> >> mode would clobber the file first.  You can't usually use
either read-write mode for updating textfiles, since they have
variable-length records.  See the B<-i> switch in
L<perlrun|perlrun/-i[extension]> for a better approach.  The file is
created with permissions of C<0666> modified by the process's
L<C<umask>|/umask EXPR> value.
 
These various prefixes correspond to the L<fopen(3)> modes of C<r>,
C<r+>, C<w>, C<w+>, C<a>, and C<a+>.
 
More examples of different modes in action:
 
 # Open a file for concatenation
 open(my $log, ">>", "/usr/spool/news/twitlog")
     or warn "Couldn't open log file; discarding input";
 
 # Open a file for reading and writing
 open(my $dbase, "+<", "dbase.mine")
     or die "Can't open 'dbase.mine' for update: $!";
 
=item Checking the return value
 
Open returns nonzero on success, the undefined value otherwise.  If the
C<open> involved a pipe, the return value happens to be the pid of the
subprocess.
 
When opening a file, it's seldom a good idea to continue if the request
failed, so C<open> is frequently used with L<C<die>|/die LIST>. Even if
you want your code to do something other than C<die> on a failed open,
you should still always check the return value from opening a file.
 
=back
 
=item Specifying I/O layers in MODE
 
You can use the three-argument form of open to specify
I/O layers (sometimes referred to as "disciplines") to apply to the new
filehandle. These affect how the input and output are processed (see
L<open> and
L<PerlIO> for more details).  For example:
 
    open(my $fh, "<:encoding(UTF-8)", $filename)
        || die "Can't open UTF-8 encoded $filename: $!";
 
This opens the UTF8-encoded file containing Unicode characters;
see L<perluniintro>.  Note that if layers are specified in the
three-argument form, then default layers stored in
L<C<${^OPEN}>|perlvar/${^OPEN}>
(usually set by the L<open> pragma or the switch C<-CioD>) are ignored.
Those layers will also be ignored if you specify a colon with no name
following it.  In that case the default layer for the operating system
(:raw on Unix, :crlf on Windows) is used.
 
On some systems (in general, DOS- and Windows-based systems)
L<C<binmode>|/binmode FILEHANDLE, LAYER> is necessary when you're not
working with a text file.  For the sake of portability it is a good idea
always to use it when appropriate, and never to use it when it isn't
appropriate.  Also, people can set their I/O to be by default
UTF8-encoded Unicode, not bytes.
 
=item Using C<undef> for temporary files
 
As a special case the three-argument form with a read/write mode and the third
argument being L<C<undef>|/undef EXPR>:
 
    open(my $tmp, "+>", undef) or die ...
 
opens a filehandle to a newly created empty anonymous temporary file.
(This happens under any mode, which makes C<< +> >> the only useful and
sensible mode to use.)  You will need to
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE> to do the reading.
 
 
=item Opening a filehandle into an in-memory scalar
 
You can open filehandles directly to Perl scalars instead of a file or
other resource external to the program. To do so, provide a reference to
that scalar as the third argument to C<open>, like so:
 
 open(my $memory, ">", \$var)
     or die "Can't open memory file: $!";
 print $memory "foo!\n";    # output will appear in $var
 
To (re)open C<STDOUT> or C<STDERR> as an in-memory file, close it first:
 
    close STDOUT;
    open(STDOUT, ">", \$variable)
        or die "Can't open STDOUT: $!";
 
The scalars for in-memory files are treated as octet strings: unless
the file is being opened with truncation the scalar may not contain
any code points over 0xFF.
 
Opening in-memory files I<can> fail for a variety of reasons.  As with
any other C<open>, check the return value for success.
 
I<Technical note>: This feature works only when Perl is built with
PerlIO -- the default, except with older (pre-5.16) Perl installations
that were configured to not include it (e.g. via C<Configure
-Uuseperlio>). You can see whether your Perl was built with PerlIO by
running C<perl -V:useperlio>.  If it says C<'define'>, you have PerlIO;
otherwise you don't.
 
See L<perliol> for detailed info on PerlIO.
 
=item Opening a filehandle into a command
 
If MODE is C<|->, then the filename is
interpreted as a command to which output is to be piped, and if MODE
is C<-|>, the filename is interpreted as a command that pipes
output to us.  In the two-argument (and one-argument) form, one should
replace dash (C<->) with the command.
See L<perlipc/"Using open() for IPC"> for more examples of this.
(You are not allowed to L<C<open>|/open FILEHANDLE,MODE,EXPR> to a command
that pipes both in I<and> out, but see L<IPC::Open2>, L<IPC::Open3>, and
L<perlipc/"Bidirectional Communication with Another Process"> for
alternatives.)
 
 
 open(my $article_fh, "-|", "caesar <$article")  # decrypt
                                                 # article
     or die "Can't start caesar: $!";
 
 open(my $article_fh, "caesar <$article |")      # ditto
     or die "Can't start caesar: $!";
 
 open(my $out_fh, "|-", "sort >Tmp$$")    # $$ is our process id
     or die "Can't start sort: $!";
 
 
In the form of pipe opens taking three or more arguments, if LIST is specified
(extra arguments after the command name) then LIST becomes arguments
to the command invoked if the platform supports it.  The meaning of
L<C<open>|/open FILEHANDLE,MODE,EXPR> with more than three arguments for
non-pipe modes is not yet defined, but experimental "layers" may give
extra LIST arguments meaning.
 
If you open a pipe on the command C<-> (that is, specify either C<|-> or C<-|>
with the one- or two-argument forms of
L<C<open>|/open FILEHANDLE,MODE,EXPR>), an implicit L<C<fork>|/fork> is done,
so L<C<open>|/open FILEHANDLE,MODE,EXPR> returns twice: in the parent process
it returns the pid
of the child process, and in the child process it returns (a defined) C<0>.
Use C<defined($pid)> or C<//> to determine whether the open was successful.
 
For example, use either
 
   my $child_pid = open(my $from_kid, "-|")
        // die "Can't fork: $!";
 
or
 
   my $child_pid = open(my $to_kid,   "|-")
        // die "Can't fork: $!";
 
followed by
 
    if ($child_pid) {
        # am the parent:
        # either write $to_kid or else read $from_kid
        ...
       waitpid $child_pid, 0;
    } else {
        # am the child; use STDIN/STDOUT normally
        ...
        exit;
    }
 
The filehandle behaves normally for the parent, but I/O to that
filehandle is piped from/to the STDOUT/STDIN of the child process.
In the child process, the filehandle isn't opened--I/O happens from/to
the new STDOUT/STDIN.  Typically this is used like the normal
piped open when you want to exercise more control over just how the
pipe command gets executed, such as when running setuid and
you don't want to have to scan shell commands for metacharacters.
 
The following blocks are more or less equivalent:
 
    open(my $fh, "|tr '[a-z]' '[A-Z]'");
    open(my $fh, "|-", "tr '[a-z]' '[A-Z]'");
    open(my $fh, "|-") || exec 'tr', '[a-z]', '[A-Z]';
    open(my $fh, "|-", "tr", '[a-z]', '[A-Z]');
 
    open(my $fh, "cat -n '$file'|");
    open(my $fh, "-|", "cat -n '$file'");
    open(my $fh, "-|") || exec "cat", "-n", $file;
    open(my $fh, "-|", "cat", "-n", $file);
 
The last two examples in each block show the pipe as "list form", which
is not yet supported on all platforms. (If your platform has a real
L<C<fork>|/fork>, such as Linux and macOS, you can use the list form; it
also works on Windows with Perl 5.22 or later.) You would want to use
the list form of the pipe so you can pass literal arguments to the
command without risk of the shell interpreting any shell metacharacters
in them. However, this also bars you from opening pipes to commands that
intentionally contain shell metacharacters, such as:
 
    open(my $fh, "|cat -n | expand -4 | lpr")
        || die "Can't open pipeline to lpr: $!";
 
See L<perlipc/"Safe Pipe Opens"> for more examples of this.
 
=item Duping filehandles
 
You may also, in the Bourne shell tradition, specify an EXPR beginning
with C<< >& >>, in which case the rest of the string is interpreted
as the name of a filehandle (or file descriptor, if numeric) to be
duped (as in L<dup(2)>) and opened.  You may use C<&> after C<< > >>,
C<<< >> >>>, C<< < >>, C<< +> >>, C<<< +>> >>>, and C<< +< >>.
The mode you specify should match the mode of the original filehandle.
(Duping a filehandle does not take into account any existing contents
of IO buffers.)  If you use the three-argument
form, then you can pass either a
number, the name of a filehandle, or the normal "reference to a glob".
 
Here is a script that saves, redirects, and restores C<STDOUT> and
C<STDERR> using various methods:
 
    #!/usr/bin/perl
    open(my $oldout, ">&STDOUT")
        or die "Can't dup STDOUT: $!";
    open(OLDERR,     ">&", \*STDERR)
        or die "Can't dup STDERR: $!";
 
    open(STDOUT, '>', "foo.out")
        or die "Can't redirect STDOUT: $!";
    open(STDERR, ">&STDOUT")
        or die "Can't dup STDOUT: $!";
 
    select STDERR; $| = 1;  # make unbuffered
    select STDOUT; $| = 1;  # make unbuffered
 
    print STDOUT "stdout 1\n";  # this works for
    print STDERR "stderr 1\n";  # subprocesses too
 
    open(STDOUT, ">&", $oldout)
        or die "Can't dup \$oldout: $!";
    open(STDERR, ">&OLDERR")
        or die "Can't dup OLDERR: $!";
 
    print STDOUT "stdout 2\n";
    print STDERR "stderr 2\n";
 
If you specify C<< '<&=X' >>, where C<X> is a file descriptor number
or a filehandle, then Perl will do an equivalent of C's L<fdopen(3)> of
that file descriptor (and not call L<dup(2)>); this is more
parsimonious of file descriptors.  For example:
 
    # open for input, reusing the fileno of $fd
    open(my $fh, "<&=", $fd)
 
or
 
    open(my $fh, "<&=$fd")
 
or
 
    # open for append, using the fileno of $oldfh
    open(my $fh, ">>&=", $oldfh)
 
Being parsimonious on filehandles is also useful (besides being
parsimonious) for example when something is dependent on file
descriptors, like for example locking using
L<C<flock>|/flock FILEHANDLE,OPERATION>.  If you do just
C<< open(my $A, ">>&", $B) >>, the filehandle C<$A> will not have the
same file descriptor as C<$B>, and therefore C<flock($A)> will not
C<flock($B)> nor vice versa.  But with C<< open(my $A, ">>&=", $B) >>,
the filehandles will share the same underlying system file descriptor.
 
Note that under Perls older than 5.8.0, Perl uses the standard C library's'
L<fdopen(3)> to implement the C<=> functionality.  On many Unix systems,
L<fdopen(3)> fails when file descriptors exceed a certain value, typically 255.
For Perls 5.8.0 and later, PerlIO is (most often) the default.
 
=item Legacy usage
 
This section describes ways to call C<open> outside of best practices;
you may encounter these uses in older code. Perl does not consider their
use deprecated, exactly, but neither is it recommended in new code, for
the sake of clarity and readability.
 
=over
 
=item Specifying mode and filename as a single argument
 
In the one- and two-argument forms of the call, the mode and filename
should be concatenated (in that order), preferably separated by white
space.  You can--but shouldn't--omit the mode in these forms when that mode
is C<< < >>.  It is safe to use the two-argument form of
L<C<open>|/open FILEHANDLE,MODE,EXPR> if the filename argument is a known literal.
 
 open(my $dbase, "+<dbase.mine")          # ditto
     or die "Can't open 'dbase.mine' for update: $!";
 
In the two-argument (and one-argument) form, opening C<< <- >>
or C<-> opens STDIN and opening C<< >- >> opens STDOUT.
 
New code should favor the three-argument form of C<open> over this older
form. Declaring the mode and the filename as two distinct arguments
avoids any confusion between the two.
 
=item Calling C<open> with one argument via global variables
 
As a shortcut, a one-argument call takes the filename from the global
scalar variable of the same name as the filehandle:
 
    $ARTICLE = 100;
    open(ARTICLE)
        or die "Can't find article $ARTICLE: $!\n";
 
Here C<$ARTICLE> must be a global (package) scalar variable - not one
declared with L<C<my>|/my VARLIST> or L<C<state>|/state VARLIST>.
 
=item Assigning a filehandle to a bareword
 
An older style is to use a bareword as the filehandle, as
 
    open(FH, "<", "input.txt")
       or die "Can't open < input.txt: $!";
 
Then you can use C<FH> as the filehandle, in C<< close FH >> and C<<
<FH> >> and so on.  Note that it's a global variable, so this form is
not recommended when dealing with filehandles other than Perl's built-in ones (e.g. STDOUT and STDIN).
 
=back
 
=item Other considerations
 
=over
 
=item Automatic filehandle closure
 
The filehandle will be closed when its reference count reaches zero. If
it is a lexically scoped variable declared with L<C<my>|/my VARLIST>,
that usually means the end of the enclosing scope.  However, this
automatic close does not check for errors, so it is better to explicitly
close filehandles, especially those used for writing:
 
    close($handle)
       || warn "close failed: $!";
 
=item Automatic pipe flushing
 
Perl will attempt to flush all files opened for
output before any operation that may do a fork, but this may not be
supported on some platforms (see L<perlport>).  To be safe, you may need
to set L<C<$E<verbar>>|perlvar/$E<verbar>> (C<$AUTOFLUSH> in L<English>)
or call the C<autoflush> method of L<C<IO::Handle>|IO::Handle/METHODS>
on any open handles.
 
On systems that support a close-on-exec flag on files, the flag will
be set for the newly opened file descriptor as determined by the value
of L<C<$^F>|perlvar/$^F>.  See L<perlvar/$^F>.
 
Closing any piped filehandle causes the parent process to wait for the
child to finish, then returns the status value in L<C<$?>|perlvar/$?> and
L<C<${^CHILD_ERROR_NATIVE}>|perlvar/${^CHILD_ERROR_NATIVE}>.
 
=item Direct versus by-reference assignment of filehandles
 
If FILEHANDLE -- the first argument in a call to C<open> -- is an
undefined scalar variable (or array or hash element), a new filehandle
is autovivified, meaning that the variable is assigned a reference to a
newly allocated anonymous filehandle.  Otherwise if FILEHANDLE is an
expression, its value is the real filehandle.  (This is considered a
symbolic reference, so C<use strict "refs"> should I<not> be in effect.)
 
=item Whitespace and special characters in the filename argument
 
The filename passed to the one- and two-argument forms of
L<C<open>|/open FILEHANDLE,MODE,EXPR> will
have leading and trailing whitespace deleted and normal
redirection characters honored.  This property, known as "magic open",
can often be used to good effect.  A user could specify a filename of
F<"rsh cat file |">, or you could change certain filenames as needed:
 
    $filename =~ s/(.*\.gz)\s*$/gzip -dc < $1|/;
    open(my $fh, $filename)
        or die "Can't open $filename: $!";
 
Use the three-argument form to open a file with arbitrary weird characters in it,
 
    open(my $fh, "<", $file)
        || die "Can't open $file: $!";
 
otherwise it's necessary to protect any leading and trailing whitespace:
 
    $file =~ s#^(\s)#./$1#;
    open(my $fh, "< $file\0")
        || die "Can't open $file: $!";
 
(this may not work on some bizarre filesystems).  One should
conscientiously choose between the I<magic> and I<three-argument> form
of L<C<open>|/open FILEHANDLE,MODE,EXPR>:
 
    open(my $in, $ARGV[0]) || die "Can't open $ARGV[0]: $!";
 
will allow the user to specify an argument of the form C<"rsh cat file |">,
but will not work on a filename that happens to have a trailing space, while
 
    open(my $in, "<", $ARGV[0])
        || die "Can't open $ARGV[0]: $!";
 
will have exactly the opposite restrictions. (However, some shells
support the syntax C<< perl your_program.pl <( rsh cat file ) >>, which
produces a filename that can be opened normally.)
 
=item Invoking C-style C<open>
 
If you want a "real" C L<open(2)>, then you should use the
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> function, which involves
no such magic (but uses different filemodes than Perl
L<C<open>|/open FILEHANDLE,MODE,EXPR>, which corresponds to C L<fopen(3)>).
This is another way to protect your filenames from interpretation.  For
example:
 
    use IO::Handle;
    sysopen(my $fh, $path, O_RDWR|O_CREAT|O_EXCL)
        or die "Can't open $path: $!";
    $fh->autoflush(1);
    print $fh "stuff $$\n";
    seek($fh, 0, 0);
    print "File contains: ", readline($fh);
 
See L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE> for some details about
mixing reading and writing.
 
=item Portability issues
 
See L<perlport/open>.
 
=back
 
=back
 
 
=item opendir DIRHANDLE,EXPR
X<opendir>
 
=for Pod::Functions open a directory
 
Opens a directory named EXPR for processing by
L<C<readdir>|/readdir DIRHANDLE>, L<C<telldir>|/telldir DIRHANDLE>,
L<C<seekdir>|/seekdir DIRHANDLE,POS>,
L<C<rewinddir>|/rewinddir DIRHANDLE>, and
L<C<closedir>|/closedir DIRHANDLE>.  Returns true if successful.
DIRHANDLE may be an expression whose value can be used as an indirect
dirhandle, usually the real dirhandle name.  If DIRHANDLE is an undefined
scalar variable (or array or hash element), the variable is assigned a
reference to a new anonymous dirhandle; that is, it's autovivified.
Dirhandles are the same objects as filehandles; an I/O object can only
be open as one of these handle types at once.
 
See the example at L<C<readdir>|/readdir DIRHANDLE>.
 
=item ord EXPR
X<ord> X<encoding>
 
=item ord
 
=for Pod::Functions find a character's numeric representation
 
Returns the numeric value of the first character of EXPR.
If EXPR is an empty string, returns 0.  If EXPR is omitted, uses
L<C<$_>|perlvar/$_>.
(Note I<character>, not byte.)
 
For the reverse, see L<C<chr>|/chr NUMBER>.
See L<perlunicode> for more about Unicode.
 
=item our VARLIST
X<our> X<global>
 
=item our TYPE VARLIST
 
=item our VARLIST : ATTRS
 
=item our TYPE VARLIST : ATTRS
 
=for Pod::Functions +5.6.0 declare and assign a package variable (lexical scoping)
 
L<C<our>|/our VARLIST> makes a lexical alias to a package (i.e. global)
variable of the same name in the current package for use within the
current lexical scope.
 
L<C<our>|/our VARLIST> has the same scoping rules as
L<C<my>|/my VARLIST> or L<C<state>|/state VARLIST>, meaning that it is
only valid within a lexical scope.  Unlike L<C<my>|/my VARLIST> and
L<C<state>|/state VARLIST>, which both declare new (lexical) variables,
L<C<our>|/our VARLIST> only creates an alias to an existing variable: a
package variable of the same name.
 
This means that when C<use strict 'vars'> is in effect, L<C<our>|/our
VARLIST> lets you use a package variable without qualifying it with the
package name, but only within the lexical scope of the
L<C<our>|/our VARLIST> declaration.  This applies immediately--even
within the same statement.
 
    package Foo;
    use strict;
 
    $Foo::foo = 23;
 
    {
        our $foo;   # alias to $Foo::foo
        print $foo; # prints 23
    }
 
    print $Foo::foo; # prints 23
 
    print $foo; # ERROR: requires explicit package name
 
This works even if the package variable has not been used before, as
package variables spring into existence when first used.
 
    package Foo;
    use strict;
 
    our $foo = 23;   # just like $Foo::foo = 23
 
    print $Foo::foo; # prints 23
 
Because the variable becomes legal immediately under C<use strict 'vars'>, so
long as there is no variable with that name is already in scope, you can then
reference the package variable again even within the same statement.
 
    package Foo;
    use strict;
 
    my  $foo = $foo; # error, undeclared $foo on right-hand side
    our $foo = $foo; # no errors
 
If more than one variable is listed, the list must be placed
in parentheses.
 
    our($bar, $baz);
 
An L<C<our>|/our VARLIST> declaration declares an alias for a package
variable that will be visible
across its entire lexical scope, even across package boundaries.  The
package in which the variable is entered is determined at the point
of the declaration, not at the point of use.  This means the following
behavior holds:
 
    package Foo;
    our $bar;      # declares $Foo::bar for rest of lexical scope
    $bar = 20;
 
    package Bar;
    print $bar;    # prints 20, as it refers to $Foo::bar
 
Multiple L<C<our>|/our VARLIST> declarations with the same name in the
same lexical
scope are allowed if they are in different packages.  If they happen
to be in the same package, Perl will emit warnings if you have asked
for them, just like multiple L<C<my>|/my VARLIST> declarations.  Unlike
a second L<C<my>|/my VARLIST> declaration, which will bind the name to a
fresh variable, a second L<C<our>|/our VARLIST> declaration in the same
package, in the same scope, is merely redundant.
 
    use warnings;
    package Foo;
    our $bar;      # declares $Foo::bar for rest of lexical scope
    $bar = 20;
 
    package Bar;
    our $bar = 30; # declares $Bar::bar for rest of lexical scope
    print $bar;    # prints 30
 
    our $bar;      # emits warning but has no other effect
    print $bar;    # still prints 30
 
An L<C<our>|/our VARLIST> declaration may also have a list of attributes
associated with it.
 
The exact semantics and interface of TYPE and ATTRS are still
evolving.  TYPE is currently bound to the use of the L<fields> pragma,
and attributes are handled using the L<attributes> pragma, or, starting
from Perl 5.8.0, also via the L<Attribute::Handlers> module.  See
L<perlsub/"Private Variables via my()"> for details.
 
Note that with a parenthesised list, L<C<undef>|/undef EXPR> can be used
as a dummy placeholder, for example to skip assignment of initial
values:
 
    our ( undef, $min, $hour ) = localtime;
 
L<C<our>|/our VARLIST> differs from L<C<use vars>|vars>, which allows
use of an unqualified name I<only> within the affected package, but
across scopes.
 
=item pack TEMPLATE,LIST
X<pack>
 
=for Pod::Functions convert a list into a binary representation
 
Takes a LIST of values and converts it into a string using the rules
given by the TEMPLATE.  The resulting string is the concatenation of
the converted values.  Typically, each converted value looks
like its machine-level representation.  For example, on 32-bit machines
an integer may be represented by a sequence of 4 bytes, which  will in
Perl be presented as a string that's 4 characters long.
 
See L<perlpacktut> for an introduction to this function.
 
The TEMPLATE is a sequence of characters that give the order and type
of values, as follows:
 
    a  A string with arbitrary binary data, will be null padded.
    A  A text (ASCII) string, will be space padded.
    Z  A null-terminated (ASCIZ) string, will be null padded.
 
    b  A bit string (ascending bit order inside each byte,
       like vec()).
    B  A bit string (descending bit order inside each byte).
    h  A hex string (low nybble first).
    H  A hex string (high nybble first).
 
    c  A signed char (8-bit) value.
    C  An unsigned char (octet) value.
    W  An unsigned char value (can be greater than 255).
 
    s  A signed short (16-bit) value.
    S  An unsigned short value.
 
    l  A signed long (32-bit) value.
    L  An unsigned long value.
 
    q  A signed quad (64-bit) value.
    Q  An unsigned quad value.
         (Quads are available only if your system supports 64-bit
          integer values _and_ if Perl has been compiled to support
          those.  Raises an exception otherwise.)
 
    i  A signed integer value.
    I  An unsigned integer value.
         (This 'integer' is _at_least_ 32 bits wide.  Its exact
          size depends on what a local C compiler calls 'int'.)
 
    n  An unsigned short (16-bit) in "network" (big-endian) order.
    N  An unsigned long (32-bit) in "network" (big-endian) order.
    v  An unsigned short (16-bit) in "VAX" (little-endian) order.
    V  An unsigned long (32-bit) in "VAX" (little-endian) order.
 
    j  A Perl internal signed integer value (IV).
    J  A Perl internal unsigned integer value (UV).
 
    f  A single-precision float in native format.
    d  A double-precision float in native format.
 
    F  A Perl internal floating-point value (NV) in native format
    D  A float of long-double precision in native format.
         (Long doubles are available only if your system supports
          long double values _and_ if Perl has been compiled to
          support those.  Raises an exception otherwise.
          Note that there are different long double formats.)
 
    p  A pointer to a null-terminated string.
    P  A pointer to a structure (fixed-length string).
 
    u  A uuencoded string.
    U  A Unicode character number.  Encodes to a character in char-
       acter mode and UTF-8 (or UTF-EBCDIC in EBCDIC platforms) in
       byte mode.
 
    w  A BER compressed integer (not an ASN.1 BER, see perlpacktut
       for details).  Its bytes represent an unsigned integer in
       base 128, most significant digit first, with as few digits
       as possible.  Bit eight (the high bit) is set on each byte
       except the last.
 
    x  A null byte (a.k.a ASCII NUL, "\000", chr(0))
    X  Back up a byte.
    @  Null-fill or truncate to absolute position, counted from the
       start of the innermost ()-group.
    .  Null-fill or truncate to absolute position specified by
       the value.
    (  Start of a ()-group.
 
One or more modifiers below may optionally follow certain letters in the
TEMPLATE (the second column lists letters for which the modifier is valid):
 
    !   sSlLiI     Forces native (short, long, int) sizes instead
                   of fixed (16-/32-bit) sizes.
 
    !   xX         Make x and X act as alignment commands.
 
    !   nNvV       Treat integers as signed instead of unsigned.
 
    !   @.         Specify position as byte offset in the internal
                   representation of the packed string.  Efficient
                   but dangerous.
 
    >   sSiIlLqQ   Force big-endian byte-order on the type.
        jJfFdDpP   (The "big end" touches the construct.)
 
    <   sSiIlLqQ   Force little-endian byte-order on the type.
        jJfFdDpP   (The "little end" touches the construct.)
 
The C<< > >> and C<< < >> modifiers can also be used on C<()> groups
to force a particular byte-order on all components in that group,
including all its subgroups.
 
=begin comment
 
Larry recalls that the hex and bit string formats (H, h, B, b) were added to
pack for processing data from NASA's Magellan probe.  Magellan was in an
elliptical orbit, using the antenna for the radar mapping when close to
Venus and for communicating data back to Earth for the rest of the orbit.
There were two transmission units, but one of these failed, and then the
other developed a fault whereby it would randomly flip the sense of all the
bits. It was easy to automatically detect complete records with the correct
sense, and complete records with all the bits flipped. However, this didn't
recover the records where the sense flipped midway. A colleague of Larry's
was able to pretty much eyeball where the records flipped, so they wrote an
editor named kybble (a pun on the dog food Kibbles 'n Bits) to enable him to
manually correct the records and recover the data. For this purpose pack
gained the hex and bit string format specifiers.
 
git shows that they were added to perl 3.0 in patch #44 (Jan 1991, commit
27e2fb84680b9cc1), but the patch description makes no mention of their
addition, let alone the story behind them.
 
=end comment
 
The following rules apply:
 
=over
 
=item *
 
Each letter may optionally be followed by a number indicating the repeat
count.  A numeric repeat count may optionally be enclosed in brackets, as
in C<pack("C[80]", @arr)>.  The repeat count gobbles that many values from
the LIST when used with all format types other than C<a>, C<A>, C<Z>, C<b>,
C<B>, C<h>, C<H>, C<@>, C<.>, C<x>, C<X>, and C<P>, where it means
something else, described below.  Supplying a C<*> for the repeat count
instead of a number means to use however many items are left, except for:
 
=over
 
=item *
 
C<@>, C<x>, and C<X>, where it is equivalent to C<0>.
 
=item *
 
<.>, where it means relative to the start of the string.
 
=item *
 
C<u>, where it is equivalent to 1 (or 45, which here is equivalent).
 
=back
 
One can replace a numeric repeat count with a template letter enclosed in
brackets to use the packed byte length of the bracketed template for the
repeat count.
 
For example, the template C<x[L]> skips as many bytes as in a packed long,
and the template C<"$t X[$t] $t"> unpacks twice whatever $t (when
variable-expanded) unpacks.  If the template in brackets contains alignment
commands (such as C<x![d]>), its packed length is calculated as if the
start of the template had the maximal possible alignment.
 
When used with C<Z>, a C<*> as the repeat count is guaranteed to add a
trailing null byte, so the resulting string is always one byte longer than
the byte length of the item itself.
 
When used with C<@>, the repeat count represents an offset from the start
of the innermost C<()> group.
 
When used with C<.>, the repeat count determines the starting position to
calculate the value offset as follows:
 
=over
 
=item *
 
If the repeat count is C<0>, it's relative to the current position.
 
=item *
 
If the repeat count is C<*>, the offset is relative to the start of the
packed string.
 
=item *
 
And if it's an integer I<n>, the offset is relative to the start of the
I<n>th innermost C<( )> group, or to the start of the string if I<n> is
bigger then the group level.
 
=back
 
The repeat count for C<u> is interpreted as the maximal number of bytes
to encode per line of output, with 0, 1 and 2 replaced by 45.  The repeat
count should not be more than 65.
 
=item *
 
The C<a>, C<A>, and C<Z> types gobble just one value, but pack it as a
string of length count, padding with nulls or spaces as needed.  When
unpacking, C<A> strips trailing whitespace and nulls, C<Z> strips everything
after the first null, and C<a> returns data with no stripping at all.
 
If the value to pack is too long, the result is truncated.  If it's too
long and an explicit count is provided, C<Z> packs only C<$count-1> bytes,
followed by a null byte.  Thus C<Z> always packs a trailing null, except
when the count is 0.
 
=item *
 
Likewise, the C<b> and C<B> formats pack a string that's that many bits long.
Each such format generates 1 bit of the result.  These are typically followed
by a repeat count like C<B8> or C<B64>.
 
Each result bit is based on the least-significant bit of the corresponding
input character, i.e., on C<ord($char)%2>.  In particular, characters C<"0">
and C<"1"> generate bits 0 and 1, as do characters C<"\000"> and C<"\001">.
 
Starting from the beginning of the input string, each 8-tuple
of characters is converted to 1 character of output.  With format C<b>,
the first character of the 8-tuple determines the least-significant bit of a
character; with format C<B>, it determines the most-significant bit of
a character.
 
If the length of the input string is not evenly divisible by 8, the
remainder is packed as if the input string were padded by null characters
at the end.  Similarly during unpacking, "extra" bits are ignored.
 
If the input string is longer than needed, remaining characters are ignored.
 
A C<*> for the repeat count uses all characters of the input field.
On unpacking, bits are converted to a string of C<0>s and C<1>s.
 
=item *
 
The C<h> and C<H> formats pack a string that many nybbles (4-bit groups,
representable as hexadecimal digits, C<"0".."9"> C<"a".."f">) long.
 
For each such format, L<C<pack>|/pack TEMPLATE,LIST> generates 4 bits of result.
With non-alphabetical characters, the result is based on the 4 least-significant
bits of the input character, i.e., on C<ord($char)%16>.  In particular,
characters C<"0"> and C<"1"> generate nybbles 0 and 1, as do bytes
C<"\000"> and C<"\001">.  For characters C<"a".."f"> and C<"A".."F">, the result
is compatible with the usual hexadecimal digits, so that C<"a"> and
C<"A"> both generate the nybble C<0xA==10>.  Use only these specific hex
characters with this format.
 
Starting from the beginning of the template to
L<C<pack>|/pack TEMPLATE,LIST>, each pair
of characters is converted to 1 character of output.  With format C<h>, the
first character of the pair determines the least-significant nybble of the
output character; with format C<H>, it determines the most-significant
nybble.
 
If the length of the input string is not even, it behaves as if padded by
a null character at the end.  Similarly, "extra" nybbles are ignored during
unpacking.
 
If the input string is longer than needed, extra characters are ignored.
 
A C<*> for the repeat count uses all characters of the input field.  For
L<C<unpack>|/unpack TEMPLATE,EXPR>, nybbles are converted to a string of
hexadecimal digits.
 
=item *
 
The C<p> format packs a pointer to a null-terminated string.  You are
responsible for ensuring that the string is not a temporary value, as that
could potentially get deallocated before you got around to using the packed
result.  The C<P> format packs a pointer to a structure of the size indicated
by the length.  A null pointer is created if the corresponding value for
C<p> or C<P> is L<C<undef>|/undef EXPR>; similarly with
L<C<unpack>|/unpack TEMPLATE,EXPR>, where a null pointer unpacks into
L<C<undef>|/undef EXPR>.
 
If your system has a strange pointer size--meaning a pointer is neither as
big as an int nor as big as a long--it may not be possible to pack or
unpack pointers in big- or little-endian byte order.  Attempting to do
so raises an exception.
 
=item *
 
The C</> template character allows packing and unpacking of a sequence of
items where the packed structure contains a packed item count followed by
the packed items themselves.  This is useful when the structure you're
unpacking has encoded the sizes or repeat counts for some of its fields
within the structure itself as separate fields.
 
For L<C<pack>|/pack TEMPLATE,LIST>, you write
I<length-item>C</>I<sequence-item>, and the
I<length-item> describes how the length value is packed.  Formats likely
to be of most use are integer-packing ones like C<n> for Java strings,
C<w> for ASN.1 or SNMP, and C<N> for Sun XDR.
 
For L<C<pack>|/pack TEMPLATE,LIST>, I<sequence-item> may have a repeat
count, in which case
the minimum of that and the number of available items is used as the argument
for I<length-item>.  If it has no repeat count or uses a '*', the number
of available items is used.
 
For L<C<unpack>|/unpack TEMPLATE,EXPR>, an internal stack of integer
arguments unpacked so far is
used.  You write C</>I<sequence-item> and the repeat count is obtained by
popping off the last element from the stack.  The I<sequence-item> must not
have a repeat count.
 
If I<sequence-item> refers to a string type (C<"A">, C<"a">, or C<"Z">),
the I<length-item> is the string length, not the number of strings.  With
an explicit repeat count for pack, the packed string is adjusted to that
length.  For example:
 
 This code:                             gives this result:
 
 unpack("W/a", "\004Gurusamy")          ("Guru")
 unpack("a3/A A*", "007 Bond  J ")      (" Bond", "J")
 unpack("a3 x2 /A A*", "007: Bond, J.") ("Bond, J", ".")
 
 pack("n/a* w/a","hello,","world")     "\000\006hello,\005world"
 pack("a/W2", ord("a") .. ord("z"))    "2ab"
 
The I<length-item> is not returned explicitly from
L<C<unpack>|/unpack TEMPLATE,EXPR>.
 
Supplying a count to the I<length-item> format letter is only useful with
C<A>, C<a>, or C<Z>.  Packing with a I<length-item> of C<a> or C<Z> may
introduce C<"\000"> characters, which Perl does not regard as legal in
numeric strings.
 
=item *
 
The integer types C<s>, C<S>, C<l>, and C<L> may be
followed by a C<!> modifier to specify native shorts or
longs.  As shown in the example above, a bare C<l> means
exactly 32 bits, although the native C<long> as seen by the local C compiler
may be larger.  This is mainly an issue on 64-bit platforms.  You can
see whether using C<!> makes any difference this way:
 
    printf "format s is %d, s! is %d\n",
        length pack("s"), length pack("s!");
 
    printf "format l is %d, l! is %d\n",
        length pack("l"), length pack("l!");
 
 
C<i!> and C<I!> are also allowed, but only for completeness' sake:
they are identical to C<i> and C<I>.
 
The actual sizes (in bytes) of native shorts, ints, longs, and long
longs on the platform where Perl was built are also available from
the command line:
 
    $ perl -V:{short,int,long{,long}}size
    shortsize='2';
    intsize='4';
    longsize='4';
    longlongsize='8';
 
or programmatically via the L<C<Config>|Config> module:
 
       use Config;
       print $Config{shortsize},    "\n";
       print $Config{intsize},      "\n";
       print $Config{longsize},     "\n";
       print $Config{longlongsize}, "\n";
 
C<$Config{longlongsize}> is undefined on systems without
long long support.
 
=item *
 
The integer formats C<s>, C<S>, C<i>, C<I>, C<l>, C<L>, C<j>, and C<J> are
inherently non-portable between processors and operating systems because
they obey native byteorder and endianness.  For example, a 4-byte integer
0x12345678 (305419896 decimal) would be ordered natively (arranged in and
handled by the CPU registers) into bytes as
 
    0x12 0x34 0x56 0x78  # big-endian
    0x78 0x56 0x34 0x12  # little-endian
 
Basically, Intel and VAX CPUs are little-endian, while everybody else,
including Motorola m68k/88k, PPC, Sparc, HP PA, Power, and Cray, are
big-endian.  Alpha and MIPS can be either: Digital/Compaq uses (well, used)
them in little-endian mode, but SGI/Cray uses them in big-endian mode.
 
The names I<big-endian> and I<little-endian> are comic references to the
egg-eating habits of the little-endian Lilliputians and the big-endian
Blefuscudians from the classic Jonathan Swift satire, I<Gulliver's Travels>.
This entered computer lingo via the paper "On Holy Wars and a Plea for
Peace" by Danny Cohen, USC/ISI IEN 137, April 1, 1980.
 
Some systems may have even weirder byte orders such as
 
   0x56 0x78 0x12 0x34
   0x34 0x12 0x78 0x56
 
These are called mid-endian, middle-endian, mixed-endian, or just weird.
 
You can determine your system endianness with this incantation:
 
   printf("%#02x ", $_) for unpack("W*", pack L=>0x12345678);
 
The byteorder on the platform where Perl was built is also available
via L<Config>:
 
    use Config;
    print "$Config{byteorder}\n";
 
or from the command line:
 
    $ perl -V:byteorder
 
Byteorders C<"1234"> and C<"12345678"> are little-endian; C<"4321">
and C<"87654321"> are big-endian.  Systems with multiarchitecture binaries
will have C<"ffff">, signifying that static information doesn't work,
one must use runtime probing.
 
For portably packed integers, either use the formats C<n>, C<N>, C<v>,
and C<V> or else use the C<< > >> and C<< < >> modifiers described
immediately below.  See also L<perlport>.
 
=item *
 
Also floating point numbers have endianness.  Usually (but not always)
this agrees with the integer endianness.  Even though most platforms
these days use the IEEE 754 binary format, there are differences,
especially if the long doubles are involved.  You can see the
C<Config> variables C<doublekind> and C<longdblkind> (also C<doublesize>,
C<longdblsize>): the "kind" values are enums, unlike C<byteorder>.
 
Portability-wise the best option is probably to keep to the IEEE 754
64-bit doubles, and of agreed-upon endianness.  Another possibility
is the C<"%a">) format of L<C<printf>|/printf FILEHANDLE FORMAT, LIST>.
 
=item *
 
Starting with Perl 5.10.0, integer and floating-point formats, along with
the C<p> and C<P> formats and C<()> groups, may all be followed by the
C<< > >> or C<< < >> endianness modifiers to respectively enforce big-
or little-endian byte-order.  These modifiers are especially useful
given how C<n>, C<N>, C<v>, and C<V> don't cover signed integers,
64-bit integers, or floating-point values.
 
Here are some concerns to keep in mind when using an endianness modifier:
 
=over
 
=item *
 
Exchanging signed integers between different platforms works only
when all platforms store them in the same format.  Most platforms store
signed integers in two's-complement notation, so usually this is not an issue.
 
=item *
 
The C<< > >> or C<< < >> modifiers can only be used on floating-point
formats on big- or little-endian machines.  Otherwise, attempting to
use them raises an exception.
 
=item *
 
Forcing big- or little-endian byte-order on floating-point values for
data exchange can work only if all platforms use the same
binary representation such as IEEE floating-point.  Even if all
platforms are using IEEE, there may still be subtle differences.  Being able
to use C<< > >> or C<< < >> on floating-point values can be useful,
but also dangerous if you don't know exactly what you're doing.
It is not a general way to portably store floating-point values.
 
=item *
 
When using C<< > >> or C<< < >> on a C<()> group, this affects
all types inside the group that accept byte-order modifiers,
including all subgroups.  It is silently ignored for all other
types.  You are not allowed to override the byte-order within a group
that already has a byte-order modifier suffix.
 
=back
 
=item *
 
Real numbers (floats and doubles) are in native machine format only.
Due to the multiplicity of floating-point formats and the lack of a
standard "network" representation for them, no facility for interchange has been
made.  This means that packed floating-point data written on one machine
may not be readable on another, even if both use IEEE floating-point
arithmetic (because the endianness of the memory representation is not part
of the IEEE spec).  See also L<perlport>.
 
If you know I<exactly> what you're doing, you can use the C<< > >> or C<< < >>
modifiers to force big- or little-endian byte-order on floating-point values.
 
Because Perl uses doubles (or long doubles, if configured) internally for
all numeric calculation, converting from double into float and thence
to double again loses precision, so C<unpack("f", pack("f", $foo)>)
will not in general equal $foo.
 
=item *
 
Pack and unpack can operate in two modes: character mode (C<C0> mode) where
the packed string is processed per character, and UTF-8 byte mode (C<U0> mode)
where the packed string is processed in its UTF-8-encoded Unicode form on
a byte-by-byte basis.  Character mode is the default
unless the format string starts with C<U>.  You
can always switch mode mid-format with an explicit
C<C0> or C<U0> in the format.  This mode remains in effect until the next
mode change, or until the end of the C<()> group it (directly) applies to.
 
Using C<C0> to get Unicode characters while using C<U0> to get I<non>-Unicode
bytes is not necessarily obvious.   Probably only the first of these
is what you want:
 
    $ perl -CS -E 'say "\x{3B1}\x{3C9}"' |
      perl -CS -ne 'printf "%v04X\n", $_ for unpack("C0A*", $_)'
    03B1.03C9
    $ perl -CS -E 'say "\x{3B1}\x{3C9}"' |
      perl -CS -ne 'printf "%v02X\n", $_ for unpack("U0A*", $_)'
    CE.B1.CF.89
    $ perl -CS -E 'say "\x{3B1}\x{3C9}"' |
      perl -C0 -ne 'printf "%v02X\n", $_ for unpack("C0A*", $_)'
    CE.B1.CF.89
    $ perl -CS -E 'say "\x{3B1}\x{3C9}"' |
      perl -C0 -ne 'printf "%v02X\n", $_ for unpack("U0A*", $_)'
    C3.8E.C2.B1.C3.8F.C2.89
 
Those examples also illustrate that you should not try to use
L<C<pack>|/pack TEMPLATE,LIST>/L<C<unpack>|/unpack TEMPLATE,EXPR> as a
substitute for the L<Encode> module.
 
=item *
 
You must yourself do any alignment or padding by inserting, for example,
enough C<"x">es while packing.  There is no way for
L<C<pack>|/pack TEMPLATE,LIST> and L<C<unpack>|/unpack TEMPLATE,EXPR>
to know where characters are going to or coming from, so they
handle their output and input as flat sequences of characters.
 
=item *
 
A C<()> group is a sub-TEMPLATE enclosed in parentheses.  A group may
take a repeat count either as postfix, or for
L<C<unpack>|/unpack TEMPLATE,EXPR>, also via the C</>
template character.  Within each repetition of a group, positioning with
C<@> starts over at 0.  Therefore, the result of
 
    pack("@1A((@2A)@3A)", qw[X Y Z])
 
is the string C<"\0X\0\0YZ">.
 
=item *
 
C<x> and C<X> accept the C<!> modifier to act as alignment commands: they
jump forward or back to the closest position aligned at a multiple of C<count>
characters.  For example, to L<C<pack>|/pack TEMPLATE,LIST> or
L<C<unpack>|/unpack TEMPLATE,EXPR> a C structure like
 
    struct {
        char   c;    /* one signed, 8-bit character */
        double d;
        char   cc[2];
    }
 
one may need to use the template C<c x![d] d c[2]>.  This assumes that
doubles must be aligned to the size of double.
 
For alignment commands, a C<count> of 0 is equivalent to a C<count> of 1;
both are no-ops.
 
=item *
 
C<n>, C<N>, C<v> and C<V> accept the C<!> modifier to
represent signed 16-/32-bit integers in big-/little-endian order.
This is portable only when all platforms sharing packed data use the
same binary representation for signed integers; for example, when all
platforms use two's-complement representation.
 
=item *
 
Comments can be embedded in a TEMPLATE using C<#> through the end of line.
White space can separate pack codes from each other, but modifiers and
repeat counts must follow immediately.  Breaking complex templates into
individual line-by-line components, suitably annotated, can do as much to
improve legibility and maintainability of pack/unpack formats as C</x> can
for complicated pattern matches.
 
=item *
 
If TEMPLATE requires more arguments than L<C<pack>|/pack TEMPLATE,LIST>
is given, L<C<pack>|/pack TEMPLATE,LIST>
assumes additional C<""> arguments.  If TEMPLATE requires fewer arguments
than given, extra arguments are ignored.
 
=item *
 
Attempting to pack the special floating point values C<Inf> and C<NaN>
(infinity, also in negative, and not-a-number) into packed integer values
(like C<"L">) is a fatal error.  The reason for this is that there simply
isn't any sensible mapping for these special values into integers.
 
=back
 
Examples:
 
    $foo = pack("WWWW",65,66,67,68);
    # foo eq "ABCD"
    $foo = pack("W4",65,66,67,68);
    # same thing
    $foo = pack("W4",0x24b6,0x24b7,0x24b8,0x24b9);
    # same thing with Unicode circled letters.
    $foo = pack("U4",0x24b6,0x24b7,0x24b8,0x24b9);
    # same thing with Unicode circled letters.  You don't get the
    # UTF-8 bytes because the U at the start of the format caused
    # a switch to U0-mode, so the UTF-8 bytes get joined into
    # characters
    $foo = pack("C0U4",0x24b6,0x24b7,0x24b8,0x24b9);
    # foo eq "\xe2\x92\xb6\xe2\x92\xb7\xe2\x92\xb8\xe2\x92\xb9"
    # This is the UTF-8 encoding of the string in the
    # previous example
 
    $foo = pack("ccxxcc",65,66,67,68);
    # foo eq "AB\0\0CD"
 
    # NOTE: The examples above featuring "W" and "c" are true
    # only on ASCII and ASCII-derived systems such as ISO Latin 1
    # and UTF-8.  On EBCDIC systems, the first example would be
    #      $foo = pack("WWWW",193,194,195,196);
 
    $foo = pack("s2",1,2);
    # "\001\000\002\000" on little-endian
    # "\000\001\000\002" on big-endian
 
    $foo = pack("a4","abcd","x","y","z");
    # "abcd"
 
    $foo = pack("aaaa","abcd","x","y","z");
    # "axyz"
 
    $foo = pack("a14","abcdefg");
    # "abcdefg\0\0\0\0\0\0\0"
 
    $foo = pack("i9pl", gmtime);
    # a real struct tm (on my system anyway)
 
    $utmp_template = "Z8 Z8 Z16 L";
    $utmp = pack($utmp_template, @utmp1);
    # a struct utmp (BSDish)
 
    @utmp2 = unpack($utmp_template, $utmp);
    # "@utmp1" eq "@utmp2"
 
    sub bintodec {
        unpack("N", pack("B32", substr("0" x 32 . shift, -32)));
    }
 
    $foo = pack('sx2l', 12, 34);
    # short 12, two zero bytes padding, long 34
    $bar = pack('s@4l', 12, 34);
    # short 12, zero fill to position 4, long 34
    # $foo eq $bar
    $baz = pack('s.l', 12, 4, 34);
    # short 12, zero fill to position 4, long 34
 
    $foo = pack('nN', 42, 4711);
    # pack big-endian 16- and 32-bit unsigned integers
    $foo = pack('S>L>', 42, 4711);
    # exactly the same
    $foo = pack('s<l<', -42, 4711);
    # pack little-endian 16- and 32-bit signed integers
    $foo = pack('(sl)<', -42, 4711);
    # exactly the same
 
The same template may generally also be used in
L<C<unpack>|/unpack TEMPLATE,EXPR>.
 
=item package NAMESPACE
 
=item package NAMESPACE VERSION
X<package> X<module> X<namespace> X<version>
 
=item package NAMESPACE BLOCK
 
=item package NAMESPACE VERSION BLOCK
X<package> X<module> X<namespace> X<version>
 
=for Pod::Functions declare a separate global namespace
 
Declares the BLOCK or the rest of the compilation unit as being in the
given namespace.  The scope of the package declaration is either the
supplied code BLOCK or, in the absence of a BLOCK, from the declaration
itself through the end of current scope (the enclosing block, file, or
L<C<eval>|/eval EXPR>).  That is, the forms without a BLOCK are
operative through the end of the current scope, just like the
L<C<my>|/my VARLIST>, L<C<state>|/state VARLIST>, and
L<C<our>|/our VARLIST> operators.  All unqualified dynamic identifiers
in this scope will be in the given namespace, except where overridden by
another L<C<package>|/package NAMESPACE> declaration or
when they're one of the special identifiers that qualify into C<main::>,
like C<STDOUT>, C<ARGV>, C<ENV>, and the punctuation variables.
 
A package statement affects dynamic variables only, including those
you've used L<C<local>|/local EXPR> on, but I<not> lexically-scoped
variables, which are created with L<C<my>|/my VARLIST>,
L<C<state>|/state VARLIST>, or L<C<our>|/our VARLIST>.  Typically it
would be the first declaration in a file included by
L<C<require>|/require VERSION> or L<C<use>|/use Module VERSION LIST>.
You can switch into a
package in more than one place, since this only determines which default
symbol table the compiler uses for the rest of that block.  You can refer to
identifiers in other packages than the current one by prefixing the identifier
with the package name and a double colon, as in C<$SomePack::var>
or C<ThatPack::INPUT_HANDLE>.  If package name is omitted, the C<main>
package as assumed.  That is, C<$::sail> is equivalent to
C<$main::sail> (as well as to C<$main'sail>, still seen in ancient
code, mostly from Perl 4).
 
If VERSION is provided, L<C<package>|/package NAMESPACE> sets the
C<$VERSION> variable in the given
namespace to a L<version> object with the VERSION provided.  VERSION must be a
"strict" style version number as defined by the L<version> module: a positive
decimal number (integer or decimal-fraction) without exponentiation or else a
dotted-decimal v-string with a leading 'v' character and at least three
components.  You should set C<$VERSION> only once per package.
 
See L<perlmod/"Packages"> for more information about packages, modules,
and classes.  See L<perlsub> for other scoping issues.
 
=item __PACKAGE__
X<__PACKAGE__>
 
=for Pod::Functions +5.004 the current package
 
A special token that returns the name of the package in which it occurs.
 
=item pipe READHANDLE,WRITEHANDLE
X<pipe>
 
=for Pod::Functions open a pair of connected filehandles
 
Opens a pair of connected pipes like the corresponding system call.
Note that if you set up a loop of piped processes, deadlock can occur
unless you are very careful.  In addition, note that Perl's pipes use
IO buffering, so you may need to set L<C<$E<verbar>>|perlvar/$E<verbar>>
to flush your WRITEHANDLE after each command, depending on the
application.
 
Returns true on success.
 
See L<IPC::Open2>, L<IPC::Open3>, and
L<perlipc/"Bidirectional Communication with Another Process">
for examples of such things.
 
On systems that support a close-on-exec flag on files, that flag is set
on all newly opened file descriptors whose
L<C<fileno>|/fileno FILEHANDLE>s are I<higher> than the current value of
L<C<$^F>|perlvar/$^F> (by default 2 for C<STDERR>).  See L<perlvar/$^F>.
 
=item pop ARRAY
X<pop> X<stack>
 
=item pop
 
=for Pod::Functions remove the last element from an array and return it
 
Pops and returns the last value of the array, shortening the array by
one element.
 
Returns the undefined value if the array is empty, although this may
also happen at other times.  If ARRAY is omitted, pops the
L<C<@ARGV>|perlvar/@ARGV> array in the main program, but the
L<C<@_>|perlvar/@_> array in subroutines, just like
L<C<shift>|/shift ARRAY>.
 
Starting with Perl 5.14, an experimental feature allowed
L<C<pop>|/pop ARRAY> to take a
scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
=item pos SCALAR
X<pos> X<match, position>
 
=item pos
 
=for Pod::Functions find or set the offset for the last/next m//g search
 
Returns the offset of where the last C<m//g> search left off for the
variable in question (L<C<$_>|perlvar/$_> is used when the variable is not
specified).  This offset is in characters unless the
(no-longer-recommended) L<C<use bytes>|bytes> pragma is in effect, in
which case the offset is in bytes.  Note that 0 is a valid match offset.
L<C<undef>|/undef EXPR> indicates
that the search position is reset (usually due to match failure, but
can also be because no match has yet been run on the scalar).
 
L<C<pos>|/pos SCALAR> directly accesses the location used by the regexp
engine to store the offset, so assigning to L<C<pos>|/pos SCALAR> will
change that offset, and so will also influence the C<\G> zero-width
assertion in regular expressions.  Both of these effects take place for
the next match, so you can't affect the position with
L<C<pos>|/pos SCALAR> during the current match, such as in
C<(?{pos() = 5})> or C<s//pos() = 5/e>.
 
Setting L<C<pos>|/pos SCALAR> also resets the I<matched with
zero-length> flag, described
under L<perlre/"Repeated Patterns Matching a Zero-length Substring">.
 
Because a failed C<m//gc> match doesn't reset the offset, the return
from L<C<pos>|/pos SCALAR> won't change either in this case.  See
L<perlre> and L<perlop>.
 
=item print FILEHANDLE LIST
X<print>
 
=item print FILEHANDLE
 
=item print LIST
 
=item print
 
=for Pod::Functions output a list to a filehandle
 
Prints a string or a list of strings.  Returns true if successful.
FILEHANDLE may be a scalar variable containing the name of or a reference
to the filehandle, thus introducing one level of indirection.  (NOTE: If
FILEHANDLE is a variable and the next token is a term, it may be
misinterpreted as an operator unless you interpose a C<+> or put
parentheses around the arguments.)  If FILEHANDLE is omitted, prints to the
last selected (see L<C<select>|/select FILEHANDLE>) output handle.  If
LIST is omitted, prints L<C<$_>|perlvar/$_> to the currently selected
output handle.  To use FILEHANDLE alone to print the content of
L<C<$_>|perlvar/$_> to it, you must use a bareword filehandle like
C<FH>, not an indirect one like C<$fh>.  To set the default output handle
to something other than STDOUT, use the select operation.
 
The current value of L<C<$,>|perlvar/$,> (if any) is printed between
each LIST item.  The current value of L<C<$\>|perlvar/$\> (if any) is
printed after the entire LIST has been printed.  Because print takes a
LIST, anything in the LIST is evaluated in list context, including any
subroutines whose return lists you pass to
L<C<print>|/print FILEHANDLE LIST>.  Be careful not to follow the print
keyword with a left
parenthesis unless you want the corresponding right parenthesis to
terminate the arguments to the print; put parentheses around all arguments
(or interpose a C<+>, but that doesn't look as good).
 
If you're storing handles in an array or hash, or in general whenever
you're using any expression more complex than a bareword handle or a plain,
unsubscripted scalar variable to retrieve it, you will have to use a block
returning the filehandle value instead, in which case the LIST may not be
omitted:
 
    print { $files[$i] } "stuff\n";
    print { $OK ? *STDOUT : *STDERR } "stuff\n";
 
Printing to a closed pipe or socket will generate a SIGPIPE signal.  See
L<perlipc> for more on signal handling.
 
=item printf FILEHANDLE FORMAT, LIST
X<printf>
 
=item printf FILEHANDLE
 
=item printf FORMAT, LIST
 
=item printf
 
=for Pod::Functions output a formatted list to a filehandle
 
Equivalent to C<print FILEHANDLE sprintf(FORMAT, LIST)>, except that
L<C<$\>|perlvar/$\> (the output record separator) is not appended.  The
FORMAT and the LIST are actually parsed as a single list.  The first
argument of the list will be interpreted as the
L<C<printf>|/printf FILEHANDLE FORMAT, LIST> format.  This means that
C<printf(@_)> will use C<$_[0]> as the format.  See
L<sprintf|/sprintf FORMAT, LIST> for an explanation of the format
argument.  If C<use locale> (including C<use locale ':not_characters'>)
is in effect and L<C<POSIX::setlocale>|POSIX/C<setlocale>> has been
called, the character used for the decimal separator in formatted
floating-point numbers is affected by the C<LC_NUMERIC> locale setting.
See L<perllocale> and L<POSIX>.
 
For historical reasons, if you omit the list, L<C<$_>|perlvar/$_> is
used as the format;
to use FILEHANDLE without a list, you must use a bareword filehandle like
C<FH>, not an indirect one like C<$fh>.  However, this will rarely do what
you want; if L<C<$_>|perlvar/$_> contains formatting codes, they will be
replaced with the empty string and a warning will be emitted if
L<warnings> are enabled.  Just use L<C<print>|/print FILEHANDLE LIST> if
you want to print the contents of L<C<$_>|perlvar/$_>.
 
Don't fall into the trap of using a
L<C<printf>|/printf FILEHANDLE FORMAT, LIST> when a simple
L<C<print>|/print FILEHANDLE LIST> would do.  The
L<C<print>|/print FILEHANDLE LIST> is more efficient and less error
prone.
 
=item prototype FUNCTION
X<prototype>
 
=item prototype
 
=for Pod::Functions +5.002 get the prototype (if any) of a subroutine
 
Returns the prototype of a function as a string (or
L<C<undef>|/undef EXPR> if the
function has no prototype).  FUNCTION is a reference to, or the name of,
the function whose prototype you want to retrieve.  If FUNCTION is omitted,
L<C<$_>|perlvar/$_> is used.
 
If FUNCTION is a string starting with C<CORE::>, the rest is taken as a
name for a Perl builtin.  If the builtin's arguments
cannot be adequately expressed by a prototype
(such as L<C<system>|/system LIST>), L<C<prototype>|/prototype FUNCTION>
returns L<C<undef>|/undef EXPR>, because the builtin
does not really behave like a Perl function.  Otherwise, the string
describing the equivalent prototype is returned.
 
=item push ARRAY,LIST
X<push> X<stack>
 
=for Pod::Functions append one or more elements to an array
 
Treats ARRAY as a stack by appending the values of LIST to the end of
ARRAY.  The length of ARRAY increases by the length of LIST.  Has the same
effect as
 
    for my $value (LIST) {
        $ARRAY[++$#ARRAY] = $value;
    }
 
but is more efficient.  Returns the number of elements in the array following
the completed L<C<push>|/push ARRAY,LIST>.
 
Starting with Perl 5.14, an experimental feature allowed
L<C<push>|/push ARRAY,LIST> to take a
scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
=item q/STRING/
 
=for Pod::Functions singly quote a string
 
=item qq/STRING/
 
=for Pod::Functions doubly quote a string
 
=item qw/STRING/
 
=for Pod::Functions quote a list of words
 
=item qx/STRING/
 
=for Pod::Functions backquote quote a string
 
Generalized quotes.  See L<perlop/"Quote-Like Operators">.
 
=item qr/STRING/
 
=for Pod::Functions +5.005 compile pattern
 
Regexp-like quote.  See L<perlop/"Regexp Quote-Like Operators">.
 
=item quotemeta EXPR
X<quotemeta> X<metacharacter>
 
=item quotemeta
 
=for Pod::Functions quote regular expression magic characters
 
Returns the value of EXPR with all the ASCII non-"word"
characters backslashed.  (That is, all ASCII characters not matching
C</[A-Za-z_0-9]/> will be preceded by a backslash in the
returned string, regardless of any locale settings.)
This is the internal function implementing
the C<\Q> escape in double-quoted strings.
(See below for the behavior on non-ASCII code points.)
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
quotemeta (and C<\Q> ... C<\E>) are useful when interpolating strings into
regular expressions, because by default an interpolated variable will be
considered a mini-regular expression.  For example:
 
    my $sentence = 'The quick brown fox jumped over the lazy dog';
    my $substring = 'quick.*?fox';
    $sentence =~ s{$substring}{big bad wolf};
 
Will cause C<$sentence> to become C<'The big bad wolf jumped over...'>.
 
On the other hand:
 
    my $sentence = 'The quick brown fox jumped over the lazy dog';
    my $substring = 'quick.*?fox';
    $sentence =~ s{\Q$substring\E}{big bad wolf};
 
Or:
 
    my $sentence = 'The quick brown fox jumped over the lazy dog';
    my $substring = 'quick.*?fox';
    my $quoted_substring = quotemeta($substring);
    $sentence =~ s{$quoted_substring}{big bad wolf};
 
Will both leave the sentence as is.
Normally, when accepting literal string input from the user,
L<C<quotemeta>|/quotemeta EXPR> or C<\Q> must be used.
 
In Perl v5.14, all non-ASCII characters are quoted in non-UTF-8-encoded
strings, but not quoted in UTF-8 strings.
 
Starting in Perl v5.16, Perl adopted a Unicode-defined strategy for
quoting non-ASCII characters; the quoting of ASCII characters is
unchanged.
 
Also unchanged is the quoting of non-UTF-8 strings when outside the
scope of a
L<C<use feature 'unicode_strings'>|feature/The 'unicode_strings' feature>,
which is to quote all
characters in the upper Latin1 range.  This provides complete backwards
compatibility for old programs which do not use Unicode.  (Note that
C<unicode_strings> is automatically enabled within the scope of a
S<C<use v5.12>> or greater.)
 
Within the scope of L<C<use locale>|locale>, all non-ASCII Latin1 code
points
are quoted whether the string is encoded as UTF-8 or not.  As mentioned
above, locale does not affect the quoting of ASCII-range characters.
This protects against those locales where characters such as C<"|"> are
considered to be word characters.
 
Otherwise, Perl quotes non-ASCII characters using an adaptation from
Unicode (see L<https://www.unicode.org/reports/tr31/>).
The only code points that are quoted are those that have any of the
Unicode properties:  Pattern_Syntax, Pattern_White_Space, White_Space,
Default_Ignorable_Code_Point, or General_Category=Control.
 
Of these properties, the two important ones are Pattern_Syntax and
Pattern_White_Space.  They have been set up by Unicode for exactly this
purpose of deciding which characters in a regular expression pattern
should be quoted.  No character that can be in an identifier has these
properties.
 
Perl promises, that if we ever add regular expression pattern
metacharacters to the dozen already defined
(C<\ E<verbar> ( ) [ { ^ $ * + ? .>), that we will only use ones that have the
Pattern_Syntax property.  Perl also promises, that if we ever add
characters that are considered to be white space in regular expressions
(currently mostly affected by C</x>), they will all have the
Pattern_White_Space property.
 
Unicode promises that the set of code points that have these two
properties will never change, so something that is not quoted in v5.16
will never need to be quoted in any future Perl release.  (Not all the
code points that match Pattern_Syntax have actually had characters
assigned to them; so there is room to grow, but they are quoted
whether assigned or not.  Perl, of course, would never use an
unassigned code point as an actual metacharacter.)
 
Quoting characters that have the other 3 properties is done to enhance
the readability of the regular expression and not because they actually
need to be quoted for regular expression purposes (characters with the
White_Space property are likely to be indistinguishable on the page or
screen from those with the Pattern_White_Space property; and the other
two properties contain non-printing characters).
 
=item rand EXPR
X<rand> X<random>
 
=item rand
 
=for Pod::Functions retrieve the next pseudorandom number
 
Returns a random fractional number greater than or equal to C<0> and less
than the value of EXPR.  (EXPR should be positive.)  If EXPR is
omitted, the value C<1> is used.  Currently EXPR with the value C<0> is
also special-cased as C<1> (this was undocumented before Perl 5.8.0
and is subject to change in future versions of Perl).  Automatically calls
L<C<srand>|/srand EXPR> unless L<C<srand>|/srand EXPR> has already been
called.  See also L<C<srand>|/srand EXPR>.
 
Apply L<C<int>|/int EXPR> to the value returned by L<C<rand>|/rand EXPR>
if you want random integers instead of random fractional numbers.  For
example,
 
    int(rand(10))
 
returns a random integer between C<0> and C<9>, inclusive.
 
(Note: If your rand function consistently returns numbers that are too
large or too small, then your version of Perl was probably compiled
with the wrong number of RANDBITS.)
 
B<L<C<rand>|/rand EXPR> is not cryptographically secure.  You should not rely
on it in security-sensitive situations.>  As of this writing, a
number of third-party CPAN modules offer random number generators
intended by their authors to be cryptographically secure,
including: L<Data::Entropy>, L<Crypt::Random>, L<Math::Random::Secure>,
and L<Math::TrulyRandom>.
 
=item read FILEHANDLE,SCALAR,LENGTH,OFFSET
X<read> X<file, read>
 
=item read FILEHANDLE,SCALAR,LENGTH
 
=for Pod::Functions fixed-length buffered input from a filehandle
 
Attempts to read LENGTH I<characters> of data into variable SCALAR
from the specified FILEHANDLE.  Returns the number of characters
actually read, C<0> at end of file, or undef if there was an error (in
the latter case L<C<$!>|perlvar/$!> is also set).  SCALAR will be grown
or shrunk
so that the last character actually read is the last character of the
scalar after the read.
 
An OFFSET may be specified to place the read data at some place in the
string other than the beginning.  A negative OFFSET specifies
placement at that many characters counting backwards from the end of
the string.  A positive OFFSET greater than the length of SCALAR
results in the string being padded to the required size with C<"\0">
bytes before the result of the read is appended.
 
The call is implemented in terms of either Perl's or your system's native
L<fread(3)> library function, via the L<PerlIO> layers applied to the
handle.  To get a true L<read(2)> system call, see
L<sysread|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>.
 
Note the I<characters>: depending on the status of the filehandle,
either (8-bit) bytes or characters are read.  By default, all
filehandles operate on bytes, but for example if the filehandle has
been opened with the C<:utf8> I/O layer (see
L<C<open>|/open FILEHANDLE,MODE,EXPR>, and the L<open>
pragma), the I/O will operate on UTF8-encoded Unicode
characters, not bytes.  Similarly for the C<:encoding> layer:
in that case pretty much any characters can be read.
 
=item readdir DIRHANDLE
X<readdir>
 
=for Pod::Functions get a directory from a directory handle
 
Returns the next directory entry for a directory opened by
L<C<opendir>|/opendir DIRHANDLE,EXPR>.
If used in list context, returns all the rest of the entries in the
directory.  If there are no more entries, returns the undefined value in
scalar context and the empty list in list context.
 
If you're planning to filetest the return values out of a
L<C<readdir>|/readdir DIRHANDLE>, you'd better prepend the directory in
question.  Otherwise, because we didn't L<C<chdir>|/chdir EXPR> there,
it would have been testing the wrong file.
 
    opendir(my $dh, $some_dir) || die "Can't opendir $some_dir: $!";
    my @dots = grep { /^\./ && -f "$some_dir/$_" } readdir($dh);
    closedir $dh;
 
As of Perl 5.12 you can use a bare L<C<readdir>|/readdir DIRHANDLE> in a
C<while> loop, which will set L<C<$_>|perlvar/$_> on every iteration.
If either a C<readdir> expression or an explicit assignment of a
C<readdir> expression to a scalar is used as a C<while>/C<for> condition,
then the condition actually tests for definedness of the expression's
value, not for its regular truth value.
 
    opendir(my $dh, $some_dir) || die "Can't open $some_dir: $!";
    while (readdir $dh) {
        print "$some_dir/$_\n";
    }
    closedir $dh;
 
To avoid confusing would-be users of your code who are running earlier
versions of Perl with mysterious failures, put this sort of thing at the
top of your file to signal that your code will work I<only> on Perls of a
recent vintage:
 
    use 5.012; # so readdir assigns to $_ in a lone while test
 
=item readline EXPR
 
=item readline
X<readline> X<gets> X<fgets>
 
=for Pod::Functions fetch a record from a file
 
Reads from the filehandle whose typeglob is contained in EXPR (or from
C<*ARGV> if EXPR is not provided).  In scalar context, each call reads and
returns the next line until end-of-file is reached, whereupon the
subsequent call returns L<C<undef>|/undef EXPR>.  In list context, reads
until end-of-file is reached and returns a list of lines.  Note that the
notion of "line" used here is whatever you may have defined with
L<C<$E<sol>>|perlvar/$E<sol>> (or C<$INPUT_RECORD_SEPARATOR> in
L<English>).  See L<perlvar/"$/">.
 
When L<C<$E<sol>>|perlvar/$E<sol>> is set to L<C<undef>|/undef EXPR>,
when L<C<readline>|/readline EXPR> is in scalar context (i.e., file
slurp mode), and when an empty file is read, it returns C<''> the first
time, followed by L<C<undef>|/undef EXPR> subsequently.
 
This is the internal function implementing the C<< <EXPR> >>
operator, but you can use it directly.  The C<< <EXPR> >>
operator is discussed in more detail in L<perlop/"I/O Operators">.
 
    my $line = <STDIN>;
    my $line = readline(STDIN);    # same thing
 
If L<C<readline>|/readline EXPR> encounters an operating system error,
L<C<$!>|perlvar/$!> will be set with the corresponding error message.
It can be helpful to check L<C<$!>|perlvar/$!> when you are reading from
filehandles you don't trust, such as a tty or a socket.  The following
example uses the operator form of L<C<readline>|/readline EXPR> and dies
if the result is not defined.
 
    while ( ! eof($fh) ) {
        defined( $_ = readline $fh ) or die "readline failed: $!";
        ...
    }
 
Note that you have can't handle L<C<readline>|/readline EXPR> errors
that way with the C<ARGV> filehandle.  In that case, you have to open
each element of L<C<@ARGV>|perlvar/@ARGV> yourself since
L<C<eof>|/eof FILEHANDLE> handles C<ARGV> differently.
 
    foreach my $arg (@ARGV) {
        open(my $fh, $arg) or warn "Can't open $arg: $!";
 
        while ( ! eof($fh) ) {
            defined( $_ = readline $fh )
                or die "readline failed for $arg: $!";
            ...
        }
    }
 
Like the C<< <EXPR> >> operator, if a C<readline> expression is
used as the condition of a C<while> or C<for> loop, then it will be
implicitly assigned to C<$_>.  If either a C<readline> expression or
an explicit assignment of a C<readline> expression to a scalar is used
as a C<while>/C<for> condition, then the condition actually tests for
definedness of the expression's value, not for its regular truth value.
 
=item readlink EXPR
X<readlink>
 
=item readlink
 
=for Pod::Functions determine where a symbolic link is pointing
 
Returns the value of a symbolic link, if symbolic links are
implemented.  If not, raises an exception.  If there is a system
error, returns the undefined value and sets L<C<$!>|perlvar/$!> (errno).
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
Portability issues: L<perlport/readlink>.
 
=item readpipe EXPR
 
=item readpipe
X<readpipe>
 
=for Pod::Functions execute a system command and collect standard output
 
EXPR is executed as a system command.
The collected standard output of the command is returned.
In scalar context, it comes back as a single (potentially
multi-line) string.  In list context, returns a list of lines
(however you've defined lines with L<C<$E<sol>>|perlvar/$E<sol>> (or
C<$INPUT_RECORD_SEPARATOR> in L<English>)).
This is the internal function implementing the C<qx/EXPR/>
operator, but you can use it directly.  The C<qx/EXPR/>
operator is discussed in more detail in L<perlop/"C<qx/I<STRING>/>">.
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
=item recv SOCKET,SCALAR,LENGTH,FLAGS
X<recv>
 
=for Pod::Functions receive a message over a Socket
 
Receives a message on a socket.  Attempts to receive LENGTH characters
of data into variable SCALAR from the specified SOCKET filehandle.
SCALAR will be grown or shrunk to the length actually read.  Takes the
same flags as the system call of the same name.  Returns the address
of the sender if SOCKET's protocol supports this; returns an empty
string otherwise.  If there's an error, returns the undefined value.
This call is actually implemented in terms of the L<recvfrom(2)> system call.
See L<perlipc/"UDP: Message Passing"> for examples.
 
Note that if the socket has been marked as C<:utf8>, C<recv> will
throw an exception.  The C<:encoding(...)> layer implicitly introduces
the C<:utf8> layer.  See L<C<binmode>|/binmode FILEHANDLE, LAYER>.
 
=item redo LABEL
X<redo>
 
=item redo EXPR
 
=item redo
 
=for Pod::Functions start this loop iteration over again
 
The L<C<redo>|/redo LABEL> command restarts the loop block without
evaluating the conditional again.  The L<C<continue>|/continue BLOCK>
block, if any, is not executed.  If
the LABEL is omitted, the command refers to the innermost enclosing
loop.  The C<redo EXPR> form, available starting in Perl 5.18.0, allows a
label name to be computed at run time, and is otherwise identical to C<redo
LABEL>.  Programs that want to lie to themselves about what was just input
normally use this command:
 
    # a simpleminded Pascal comment stripper
    # (warning: assumes no { or } in strings)
    LINE: while (<STDIN>) {
        while (s|({.*}.*){.*}|$1 |) {}
        s|{.*}| |;
        if (s|{.*| |) {
            my $front = $_;
            while (<STDIN>) {
                if (/}/) {  # end of comment?
                    s|^|$front\{|;
                    redo LINE;
                }
            }
        }
        print;
    }
 
L<C<redo>|/redo LABEL> cannot return a value from a block that typically
returns a value, such as C<eval {}>, C<sub {}>, or C<do {}>. It will perform
its flow control behavior, which precludes any return value. It should not be
used to exit a L<C<grep>|/grep BLOCK LIST> or L<C<map>|/map BLOCK LIST>
operation.
 
Note that a block by itself is semantically identical to a loop
that executes once.  Thus L<C<redo>|/redo LABEL> inside such a block
will effectively turn it into a looping construct.
 
See also L<C<continue>|/continue BLOCK> for an illustration of how
L<C<last>|/last LABEL>, L<C<next>|/next LABEL>, and
L<C<redo>|/redo LABEL> work.
 
Unlike most named operators, this has the same precedence as assignment.
It is also exempt from the looks-like-a-function rule, so
C<redo ("foo")."bar"> will cause "bar" to be part of the argument to
L<C<redo>|/redo LABEL>.
 
=item ref EXPR
X<ref> X<reference>
 
=item ref
 
=for Pod::Functions find out the type of thing being referenced
 
Examines the value of EXPR, expecting it to be a reference, and returns
a string giving information about the reference and the type of referent.
If EXPR is not specified, L<C<$_>|perlvar/$_> will be used.
 
If the operand is not a reference, then the empty string will be returned.
An empty string will only be returned in this situation.  C<ref> is often
useful to just test whether a value is a reference, which can be done
by comparing the result to the empty string.  It is a common mistake
to use the result of C<ref> directly as a truth value: this goes wrong
because C<0> (which is false) can be returned for a reference.
 
If the operand is a reference to a blessed object, then the name of
the class into which the referent is blessed will be returned.  C<ref>
doesn't care what the physical type of the referent is; blessing takes
precedence over such concerns.  Beware that exact comparison of C<ref>
results against a class name doesn't perform a class membership test:
a class's members also include objects blessed into subclasses, for
which C<ref> will return the name of the subclass.  Also beware that
class names can clash with the built-in type names (described below).
 
If the operand is a reference to an unblessed object, then the return
value indicates the type of object.  If the unblessed referent is not
a scalar, then the return value will be one of the strings C<ARRAY>,
C<HASH>, C<CODE>, C<FORMAT>, or C<IO>, indicating only which kind of
object it is.  If the unblessed referent is a scalar, then the return
value will be one of the strings C<SCALAR>, C<VSTRING>, C<REF>, C<GLOB>,
C<LVALUE>, or C<REGEXP>, depending on the kind of value the scalar
currently has.   But note that C<qr//> scalars are created already
blessed, so C<ref qr/.../> will likely return C<Regexp>.  Beware that
these built-in type names can also be used as
class names, so C<ref> returning one of these names doesn't unambiguously
indicate that the referent is of the kind to which the name refers.
 
The ambiguity between built-in type names and class names significantly
limits the utility of C<ref>.  For unambiguous information, use
L<C<Scalar::Util::blessed()>|Scalar::Util/blessed> for information about
blessing, and L<C<Scalar::Util::reftype()>|Scalar::Util/reftype> for
information about physical types.  Use L<the C<isa> method|UNIVERSAL/C<<
$obj->isa( TYPE ) >>> for class membership tests, though one must be
sure of blessedness before attempting a method call.
 
See also L<perlref> and L<perlobj>.
 
=item rename OLDNAME,NEWNAME
X<rename> X<move> X<mv> X<ren>
 
=for Pod::Functions change a filename
 
Changes the name of a file; an existing file NEWNAME will be
clobbered.  Returns true for success, false otherwise.
 
Behavior of this function varies wildly depending on your system
implementation.  For example, it will usually not work across file system
boundaries, even though the system I<mv> command sometimes compensates
for this.  Other restrictions include whether it works on directories,
open files, or pre-existing files.  Check L<perlport> and either the
L<rename(2)> manpage or equivalent system documentation for details.
 
For a platform independent L<C<move>|File::Copy/move> function look at
the L<File::Copy> module.
 
Portability issues: L<perlport/rename>.
 
=item require VERSION
X<require>
 
=item require EXPR
 
=item require
 
=for Pod::Functions load in external functions from a library at runtime
 
Demands a version of Perl specified by VERSION, or demands some semantics
specified by EXPR or by L<C<$_>|perlvar/$_> if EXPR is not supplied.
 
VERSION may be either a literal such as v5.24.1, which will be
compared to L<C<$^V>|perlvar/$^V> (or C<$PERL_VERSION> in L<English>),
or a numeric argument of the form 5.024001, which will be compared to
L<C<$]>|perlvar/$]>. An exception is raised if VERSION is greater than
the version of the current Perl interpreter.  Compare with
L<C<use>|/use Module VERSION LIST>, which can do a similar check at
compile time.
 
Specifying VERSION as a numeric argument of the form 5.024001 should
generally be avoided as older less readable syntax compared to
v5.24.1. Before perl 5.8.0 (released in 2002), the more verbose numeric
form was the only supported syntax, which is why you might see it in
older code.
 
    require v5.24.1;    # run time version check
    require 5.24.1;     # ditto
    require 5.024_001;  # ditto; older syntax compatible
                          with perl 5.6
 
Otherwise, L<C<require>|/require VERSION> demands that a library file be
included if it hasn't already been included.  The file is included via
the do-FILE mechanism, which is essentially just a variety of
L<C<eval>|/eval EXPR> with the
caveat that lexical variables in the invoking script will be invisible
to the included code.  If it were implemented in pure Perl, it
would have semantics similar to the following:
 
    use Carp 'croak';
    use version;
 
    sub require {
        my ($filename) = @_;
        if ( my $version = eval { version->parse($filename) } ) {
            if ( $version > $^V ) {
               my $vn = $version->normal;
               croak "Perl $vn required--this is only $^V, stopped";
            }
            return 1;
        }
 
        if (exists $INC{$filename}) {
            return 1 if $INC{$filename};
            croak "Compilation failed in require";
        }
 
        foreach $prefix (@INC) {
            if (ref($prefix)) {
                #... do other stuff - see text below ....
            }
            # (see text below about possible appending of .pmc
            # suffix to $filename)
            my $realfilename = "$prefix/$filename";
            next if ! -e $realfilename || -d _ || -b _;
            $INC{$filename} = $realfilename;
            my $result = do($realfilename);
                         # but run in caller's namespace
 
            if (!defined $result) {
                $INC{$filename} = undef;
                croak $@ ? "$@Compilation failed in require"
                         : "Can't locate $filename: $!\n";
            }
            if (!$result) {
                delete $INC{$filename};
                croak "$filename did not return true value";
            }
            $! = 0;
            return $result;
        }
        croak "Can't locate $filename in \@INC ...";
    }
 
Note that the file will not be included twice under the same specified
name.
 
The file must return true as the last statement to indicate
successful execution of any initialization code, so it's customary to
end such a file with C<1;> unless you're sure it'll return true
otherwise.  But it's better just to put the C<1;>, in case you add more
statements.
 
If EXPR is a bareword, L<C<require>|/require VERSION> assumes a F<.pm>
extension and replaces C<::> with C</> in the filename for you,
to make it easy to load standard modules.  This form of loading of
modules does not risk altering your namespace, however it will autovivify
the stash for the required module.
 
In other words, if you try this:
 
        require Foo::Bar;     # a splendid bareword
 
The require function will actually look for the F<Foo/Bar.pm> file in the
directories specified in the L<C<@INC>|perlvar/@INC> array, and it will
autovivify the C<Foo::Bar::> stash at compile time.
 
But if you try this:
 
        my $class = 'Foo::Bar';
        require $class;       # $class is not a bareword
    #or
        require "Foo::Bar";   # not a bareword because of the ""
 
The require function will look for the F<Foo::Bar> file in the
L<C<@INC>|perlvar/@INC>  array and
will complain about not finding F<Foo::Bar> there.  In this case you can do:
 
        eval "require $class";
 
or you could do
 
        require "Foo/Bar.pm";
 
Neither of these forms will autovivify any stashes at compile time and
only have run time effects.
 
Now that you understand how L<C<require>|/require VERSION> looks for
files with a bareword argument, there is a little extra functionality
going on behind the scenes.  Before L<C<require>|/require VERSION> looks
for a F<.pm> extension, it will first look for a similar filename with a
F<.pmc> extension.  If this file is found, it will be loaded in place of
any file ending in a F<.pm> extension. This applies to both the explicit
C<require "Foo/Bar.pm";> form and the C<require Foo::Bar;> form.
 
You can also insert hooks into the import facility by putting Perl code
directly into the L<C<@INC>|perlvar/@INC> array.  There are three forms
of hooks: subroutine references, array references, and blessed objects.
 
Subroutine references are the simplest case.  When the inclusion system
walks through L<C<@INC>|perlvar/@INC> and encounters a subroutine, this
subroutine gets called with two parameters, the first a reference to
itself, and the second the name of the file to be included (e.g.,
F<Foo/Bar.pm>).  The subroutine should return either nothing or else a
list of up to four values in the following order:
 
=over
 
=item 1
 
A reference to a scalar, containing any initial source code to prepend to
the file or generator output.
 
=item 2
 
A filehandle, from which the file will be read.
 
=item 3
 
A reference to a subroutine.  If there is no filehandle (previous item),
then this subroutine is expected to generate one line of source code per
call, writing the line into L<C<$_>|perlvar/$_> and returning 1, then
finally at end of file returning 0.  If there is a filehandle, then the
subroutine will be called to act as a simple source filter, with the
line as read in L<C<$_>|perlvar/$_>.
Again, return 1 for each valid line, and 0 after all lines have been
returned.
For historical reasons the subroutine will receive a meaningless argument
(in fact always the numeric value zero) as C<$_[0]>.
 
=item 4
 
Optional state for the subroutine.  The state is passed in as C<$_[1]>.
 
=back
 
If an empty list, L<C<undef>|/undef EXPR>, or nothing that matches the
first 3 values above is returned, then L<C<require>|/require VERSION>
looks at the remaining elements of L<C<@INC>|perlvar/@INC>.
Note that this filehandle must be a real filehandle (strictly a typeglob
or reference to a typeglob, whether blessed or unblessed); tied filehandles
will be ignored and processing will stop there.
 
If the hook is an array reference, its first element must be a subroutine
reference.  This subroutine is called as above, but the first parameter is
the array reference.  This lets you indirectly pass arguments to
the subroutine.
 
In other words, you can write:
 
    push @INC, \&my_sub;
    sub my_sub {
        my ($coderef, $filename) = @_;  # $coderef is \&my_sub
        ...
    }
 
or:
 
    push @INC, [ \&my_sub, $x, $y, ... ];
    sub my_sub {
        my ($arrayref, $filename) = @_;
        # Retrieve $x, $y, ...
        my (undef, @parameters) = @$arrayref;
        ...
    }
 
If the hook is an object, it must provide an C<INC> method that will be
called as above, the first parameter being the object itself.  (Note that
you must fully qualify the sub's name, as unqualified C<INC> is always forced
into package C<main>.)  Here is a typical code layout:
 
    # In Foo.pm
    package Foo;
    sub new { ... }
    sub Foo::INC {
        my ($self, $filename) = @_;
        ...
    }
 
    # In the main program
    push @INC, Foo->new(...);
 
These hooks are also permitted to set the L<C<%INC>|perlvar/%INC> entry
corresponding to the files they have loaded.  See L<perlvar/%INC>.
 
For a yet-more-powerful import facility, see
L<C<use>|/use Module VERSION LIST> and L<perlmod>.
 
=item reset EXPR
X<reset>
 
=item reset
 
=for Pod::Functions clear all variables of a given name
 
Generally used in a L<C<continue>|/continue BLOCK> block at the end of a
loop to clear variables and reset C<m?pattern?> searches so that they
work again.  The
expression is interpreted as a list of single characters (hyphens
allowed for ranges).  All variables (scalars, arrays, and hashes)
in the current package beginning with one of
those letters are reset to their pristine state.  If the expression is
omitted, one-match searches (C<m?pattern?>) are reset to match again.
Only resets variables or searches in the current package.  Always returns
1.  Examples:
 
    reset 'X';      # reset all X variables
    reset 'a-z';    # reset lower case variables
    reset;          # just reset m?one-time? searches
 
Resetting C<"A-Z"> is not recommended because you'll wipe out your
L<C<@ARGV>|perlvar/@ARGV> and L<C<@INC>|perlvar/@INC> arrays and your
L<C<%ENV>|perlvar/%ENV> hash.
 
Resets only package variables; lexical variables are unaffected, but
they clean themselves up on scope exit anyway, so you'll probably want
to use them instead.  See L<C<my>|/my VARLIST>.
 
=item return EXPR
X<return>
 
=item return
 
=for Pod::Functions get out of a function early
 
Returns from a subroutine, L<C<eval>|/eval EXPR>,
L<C<do FILE>|/do EXPR>, L<C<sort>|/sort SUBNAME LIST> block or regex
eval block (but not a L<C<grep>|/grep BLOCK LIST>,
L<C<map>|/map BLOCK LIST>, or L<C<do BLOCK>|/do BLOCK> block) with the value
given in EXPR.  Evaluation of EXPR may be in list, scalar, or void
context, depending on how the return value will be used, and the context
may vary from one execution to the next (see
L<C<wantarray>|/wantarray>).  If no EXPR
is given, returns an empty list in list context, the undefined value in
scalar context, and (of course) nothing at all in void context.
 
(In the absence of an explicit L<C<return>|/return EXPR>, a subroutine,
L<C<eval>|/eval EXPR>,
or L<C<do FILE>|/do EXPR> automatically returns the value of the last expression
evaluated.)
 
Unlike most named operators, this is also exempt from the
looks-like-a-function rule, so C<return ("foo")."bar"> will
cause C<"bar"> to be part of the argument to L<C<return>|/return EXPR>.
 
=item reverse LIST
X<reverse> X<rev> X<invert>
 
=for Pod::Functions flip a string or a list
 
In list context, returns a list value consisting of the elements
of LIST in the opposite order.  In scalar context, concatenates the
elements of LIST and returns a string value with all characters
in the opposite order.
 
    print join(", ", reverse "world", "Hello"); # Hello, world
 
    print scalar reverse "dlrow ,", "olleH";    # Hello, world
 
Used without arguments in scalar context, L<C<reverse>|/reverse LIST>
reverses L<C<$_>|perlvar/$_>.
 
    $_ = "dlrow ,olleH";
    print reverse;                         # No output, list context
    print scalar reverse;                  # Hello, world
 
Note that reversing an array to itself (as in C<@a = reverse @a>) will
preserve non-existent elements whenever possible; i.e., for non-magical
arrays or for tied arrays with C<EXISTS> and C<DELETE> methods.
 
This operator is also handy for inverting a hash, although there are some
caveats.  If a value is duplicated in the original hash, only one of those
can be represented as a key in the inverted hash.  Also, this has to
unwind one hash and build a whole new one, which may take some time
on a large hash, such as from a DBM file.
 
    my %by_name = reverse %by_address;  # Invert the hash
 
=item rewinddir DIRHANDLE
X<rewinddir>
 
=for Pod::Functions reset directory handle
 
Sets the current position to the beginning of the directory for the
L<C<readdir>|/readdir DIRHANDLE> routine on DIRHANDLE.
 
Portability issues: L<perlport/rewinddir>.
 
=item rindex STR,SUBSTR,POSITION
X<rindex>
 
=item rindex STR,SUBSTR
 
=for Pod::Functions right-to-left substring search
 
Works just like L<C<index>|/index STR,SUBSTR,POSITION> except that it
returns the position of the I<last>
occurrence of SUBSTR in STR.  If POSITION is specified, returns the
last occurrence beginning at or before that position.
 
=item rmdir FILENAME
X<rmdir> X<rd> X<directory, remove>
 
=item rmdir
 
=for Pod::Functions remove a directory
 
Deletes the directory specified by FILENAME if that directory is
empty.  If it succeeds it returns true; otherwise it returns false and
sets L<C<$!>|perlvar/$!> (errno).  If FILENAME is omitted, uses
L<C<$_>|perlvar/$_>.
 
To remove a directory tree recursively (C<rm -rf> on Unix) look at
the L<C<rmtree>|File::Path/rmtree( $dir )> function of the L<File::Path>
module.
 
=item s///
 
=for Pod::Functions replace a pattern with a string
 
The substitution operator.  See L<perlop/"Regexp Quote-Like Operators">.
 
=item say FILEHANDLE LIST
X<say>
 
=item say FILEHANDLE
 
=item say LIST
 
=item say
 
=for Pod::Functions +say output a list to a filehandle, appending a newline
 
Just like L<C<print>|/print FILEHANDLE LIST>, but implicitly appends a
newline at the end of the LIST instead of any value L<C<$\>|perlvar/$\>
might have.  To use FILEHANDLE without a LIST to
print the contents of L<C<$_>|perlvar/$_> to it, you must use a bareword
filehandle like C<FH>, not an indirect one like C<$fh>.
 
L<C<say>|/say FILEHANDLE LIST> is available only if the
L<C<"say"> feature|feature/The 'say' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"say"> feature|feature/The 'say' feature> is enabled automatically
with a C<use v5.10> (or higher) declaration in the current scope.
 
=item scalar EXPR
X<scalar> X<context>
 
=for Pod::Functions force a scalar context
 
Forces EXPR to be interpreted in scalar context and returns the value
of EXPR.
 
    my @counts = ( scalar @a, scalar @b, scalar @c );
 
There is no equivalent operator to force an expression to
be interpolated in list context because in practice, this is never
needed.  If you really wanted to do so, however, you could use
the construction C<@{[ (some expression) ]}>, but usually a simple
C<(some expression)> suffices.
 
Because L<C<scalar>|/scalar EXPR> is a unary operator, if you
accidentally use a
parenthesized list for the EXPR, this behaves as a scalar comma expression,
evaluating all but the last element in void context and returning the final
element evaluated in scalar context.  This is seldom what you want.
 
The following single statement:
 
    print uc(scalar(foo(), $bar)), $baz;
 
is the moral equivalent of these two:
 
    foo();
    print(uc($bar), $baz);
 
See L<perlop> for more details on unary operators and the comma operator,
and L<perldata> for details on evaluating a hash in scalar contex.
 
=item seek FILEHANDLE,POSITION,WHENCE
X<seek> X<fseek> X<filehandle, position>
 
=for Pod::Functions reposition file pointer for random-access I/O
 
Sets FILEHANDLE's position, just like the L<fseek(3)> call of C C<stdio>.
FILEHANDLE may be an expression whose value gives the name of the
filehandle.  The values for WHENCE are C<0> to set the new position
I<in bytes> to POSITION; C<1> to set it to the current position plus
POSITION; and C<2> to set it to EOF plus POSITION, typically
negative.  For WHENCE you may use the constants C<SEEK_SET>,
C<SEEK_CUR>, and C<SEEK_END> (start of the file, current position, end
of the file) from the L<Fcntl> module.  Returns C<1> on success, false
otherwise.
 
Note the emphasis on bytes: even if the filehandle has been set to operate
on characters (for example using the C<:encoding(UTF-8)> I/O layer), the
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, and
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>
family of functions use byte offsets, not character offsets,
because seeking to a character offset would be very slow in a UTF-8 file.
 
If you want to position the file for
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET> or
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET>, don't use
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>, because buffering makes its
effect on the file's read-write position unpredictable and non-portable.
Use L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE> instead.
 
Due to the rules and rigors of ANSI C, on some systems you have to do a
seek whenever you switch between reading and writing.  Amongst other
things, this may have the effect of calling stdio's L<clearerr(3)>.
A WHENCE of C<1> (C<SEEK_CUR>) is useful for not moving the file position:
 
    seek($fh, 0, 1);
 
This is also useful for applications emulating C<tail -f>.  Once you hit
EOF on your read and then sleep for a while, you (probably) have to stick in a
dummy L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE> to reset things.  The
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE> doesn't change the position,
but it I<does> clear the end-of-file condition on the handle, so that the
next C<readline FILE> makes Perl try again to read something.  (We hope.)
 
If that doesn't work (some I/O implementations are particularly
cantankerous), you might need something like this:
 
    for (;;) {
        for ($curpos = tell($fh); $_ = readline($fh);
             $curpos = tell($fh)) {
            # search for some stuff and put it into files
        }
        sleep($for_a_while);
        seek($fh, $curpos, 0);
    }
 
=item seekdir DIRHANDLE,POS
X<seekdir>
 
=for Pod::Functions reposition directory pointer
 
Sets the current position for the L<C<readdir>|/readdir DIRHANDLE>
routine on DIRHANDLE.  POS must be a value returned by
L<C<telldir>|/telldir DIRHANDLE>.  L<C<seekdir>|/seekdir DIRHANDLE,POS>
also has the same caveats about possible directory compaction as the
corresponding system library routine.
 
=item select FILEHANDLE
X<select> X<filehandle, default>
 
=item select
 
=for Pod::Functions reset default output or do I/O multiplexing
 
Returns the currently selected filehandle.  If FILEHANDLE is supplied,
sets the new current default filehandle for output.  This has two
effects: first, a L<C<write>|/write FILEHANDLE> or a L<C<print>|/print
FILEHANDLE LIST> without a filehandle
default to this FILEHANDLE.  Second, references to variables related to
output will refer to this output channel.
 
For example, to set the top-of-form format for more than one
output channel, you might do the following:
 
    select(REPORT1);
    $^ = 'report1_top';
    select(REPORT2);
    $^ = 'report2_top';
 
FILEHANDLE may be an expression whose value gives the name of the
actual filehandle.  Thus:
 
    my $oldfh = select(STDERR); $| = 1; select($oldfh);
 
Some programmers may prefer to think of filehandles as objects with
methods, preferring to write the last example as:
 
    STDERR->autoflush(1);
 
(Prior to Perl version 5.14, you have to C<use IO::Handle;> explicitly
first.)
 
Portability issues: L<perlport/select>.
 
=item select RBITS,WBITS,EBITS,TIMEOUT
X<select>
 
This calls the L<select(2)> syscall with the bit masks specified, which
can be constructed using L<C<fileno>|/fileno FILEHANDLE> and
L<C<vec>|/vec EXPR,OFFSET,BITS>, along these lines:
 
    my $rin = my $win = my $ein = '';
    vec($rin, fileno(STDIN),  1) = 1;
    vec($win, fileno(STDOUT), 1) = 1;
    $ein = $rin | $win;
 
If you want to select on many filehandles, you may wish to write a
subroutine like this:
 
    sub fhbits {
        my @fhlist = @_;
        my $bits = "";
        for my $fh (@fhlist) {
            vec($bits, fileno($fh), 1) = 1;
        }
        return $bits;
    }
    my $rin = fhbits(\*STDIN, $tty, $mysock);
 
The usual idiom is:
 
 my ($nfound, $timeleft) =
   select(my $rout = $rin, my $wout = $win, my $eout = $ein,
                                                          $timeout);
 
or to block until something becomes ready just do this
 
 my $nfound =
   select(my $rout = $rin, my $wout = $win, my $eout = $ein, undef);
 
Most systems do not bother to return anything useful in C<$timeleft>, so
calling L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> in scalar context
just returns C<$nfound>.
 
Any of the bit masks can also be L<C<undef>|/undef EXPR>.  The timeout,
if specified, is
in seconds, which may be fractional.  Note: not all implementations are
capable of returning the C<$timeleft>.  If not, they always return
C<$timeleft> equal to the supplied C<$timeout>.
 
You can effect a sleep of 250 milliseconds this way:
 
    select(undef, undef, undef, 0.25);
 
Note that whether L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> gets
restarted after signals (say, SIGALRM) is implementation-dependent.  See
also L<perlport> for notes on the portability of
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT>.
 
On error, L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> behaves just
like L<select(2)>: it returns C<-1> and sets L<C<$!>|perlvar/$!>.
 
On some Unixes, L<select(2)> may report a socket file descriptor as
"ready for reading" even when no data is available, and thus any
subsequent L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET> would block.
This can be avoided if you always use C<O_NONBLOCK> on the socket.  See
L<select(2)> and L<fcntl(2)> for further details.
 
The standard L<C<IO::Select>|IO::Select> module provides a
user-friendlier interface to
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT>, mostly because it does
all the bit-mask work for you.
 
B<WARNING>: One should not attempt to mix buffered I/O (like
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET> or
L<C<readline>|/readline EXPR>) with
L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT>, except as permitted by
POSIX, and even then only on POSIX systems.  You have to use
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET> instead.
 
Portability issues: L<perlport/select>.
 
=item semctl ID,SEMNUM,CMD,ARG
X<semctl>
 
=for Pod::Functions SysV semaphore control operations
 
Calls the System V IPC function L<semctl(2)>.  You'll probably have to say
 
    use IPC::SysV;
 
first to get the correct constant definitions.  If CMD is IPC_STAT or
GETALL, then ARG must be a variable that will hold the returned
semid_ds structure or semaphore value array.  Returns like
L<C<ioctl>|/ioctl FILEHANDLE,FUNCTION,SCALAR>:
the undefined value for error, "C<0 but true>" for zero, or the actual
return value otherwise.  The ARG must consist of a vector of native
short integers, which may be created with C<pack("s!",(0)x$nsem)>.
See also L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV> and L<C<IPC::Semaphore>|IPC::Semaphore>.
 
Portability issues: L<perlport/semctl>.
 
=item semget KEY,NSEMS,FLAGS
X<semget>
 
=for Pod::Functions get set of SysV semaphores
 
Calls the System V IPC function L<semget(2)>.  Returns the semaphore id, or
the undefined value on error.  See also
L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV> and L<C<IPC::Semaphore>|IPC::Semaphore>.
 
Portability issues: L<perlport/semget>.
 
=item semop KEY,OPSTRING
X<semop>
 
=for Pod::Functions SysV semaphore operations
 
Calls the System V IPC function L<semop(2)> for semaphore operations
such as signalling and waiting.  OPSTRING must be a packed array of
semop structures.  Each semop structure can be generated with
C<pack("s!3", $semnum, $semop, $semflag)>.  The length of OPSTRING
implies the number of semaphore operations.  Returns true if
successful, false on error.  As an example, the
following code waits on semaphore $semnum of semaphore id $semid:
 
    my $semop = pack("s!3", $semnum, -1, 0);
    die "Semaphore trouble: $!\n" unless semop($semid, $semop);
 
To signal the semaphore, replace C<-1> with C<1>.  See also
L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV> and L<C<IPC::Semaphore>|IPC::Semaphore>.
 
Portability issues: L<perlport/semop>.
 
=item send SOCKET,MSG,FLAGS,TO
X<send>
 
=item send SOCKET,MSG,FLAGS
 
=for Pod::Functions send a message over a socket
 
Sends a message on a socket.  Attempts to send the scalar MSG to the SOCKET
filehandle.  Takes the same flags as the system call of the same name.  On
unconnected sockets, you must specify a destination to I<send to>, in which
case it does a L<sendto(2)> syscall.  Returns the number of characters sent,
or the undefined value on error.  The L<sendmsg(2)> syscall is currently
unimplemented.  See L<perlipc/"UDP: Message Passing"> for examples.
 
Note that if the socket has been marked as C<:utf8>, C<send> will
throw an exception.  The C<:encoding(...)> layer implicitly introduces
the C<:utf8> layer.  See L<C<binmode>|/binmode FILEHANDLE, LAYER>.
 
=item setpgrp PID,PGRP
X<setpgrp> X<group>
 
=for Pod::Functions set the process group of a process
 
Sets the current process group for the specified PID, C<0> for the current
process.  Raises an exception when used on a machine that doesn't
implement POSIX L<setpgid(2)> or BSD L<setpgrp(2)>.  If the arguments
are omitted, it defaults to C<0,0>.  Note that the BSD 4.2 version of
L<C<setpgrp>|/setpgrp PID,PGRP> does not accept any arguments, so only
C<setpgrp(0,0)> is portable.  See also
L<C<POSIX::setsid()>|POSIX/C<setsid>>.
 
Portability issues: L<perlport/setpgrp>.
 
=item setpriority WHICH,WHO,PRIORITY
X<setpriority> X<priority> X<nice> X<renice>
 
=for Pod::Functions set a process's nice value
 
Sets the current priority for a process, a process group, or a user.
(See L<setpriority(2)>.)  Raises an exception when used on a machine
that doesn't implement L<setpriority(2)>.
 
C<WHICH> can be any of C<PRIO_PROCESS>, C<PRIO_PGRP> or C<PRIO_USER>
imported from L<POSIX/RESOURCE CONSTANTS>.
 
Portability issues: L<perlport/setpriority>.
 
=item setsockopt SOCKET,LEVEL,OPTNAME,OPTVAL
X<setsockopt>
 
=for Pod::Functions set some socket options
 
Sets the socket option requested.  Returns L<C<undef>|/undef EXPR> on
error.  Use integer constants provided by the L<C<Socket>|Socket> module
for
LEVEL and OPNAME.  Values for LEVEL can also be obtained from
getprotobyname.  OPTVAL might either be a packed string or an integer.
An integer OPTVAL is shorthand for pack("i", OPTVAL).
 
An example disabling Nagle's algorithm on a socket:
 
    use Socket qw(IPPROTO_TCP TCP_NODELAY);
    setsockopt($socket, IPPROTO_TCP, TCP_NODELAY, 1);
 
Portability issues: L<perlport/setsockopt>.
 
=item shift ARRAY
X<shift>
 
=item shift
 
=for Pod::Functions remove the first element of an array, and return it
 
Shifts the first value of the array off and returns it, shortening the
array by 1 and moving everything down.  If there are no elements in the
array, returns the undefined value.  If ARRAY is omitted, shifts the
L<C<@_>|perlvar/@_> array within the lexical scope of subroutines and
formats, and the L<C<@ARGV>|perlvar/@ARGV> array outside a subroutine
and also within the lexical scopes
established by the C<eval STRING>, C<BEGIN {}>, C<INIT {}>, C<CHECK {}>,
C<UNITCHECK {}>, and C<END {}> constructs.
 
Starting with Perl 5.14, an experimental feature allowed
L<C<shift>|/shift ARRAY> to take a
scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
See also L<C<unshift>|/unshift ARRAY,LIST>, L<C<push>|/push ARRAY,LIST>,
and L<C<pop>|/pop ARRAY>.  L<C<shift>|/shift ARRAY> and
L<C<unshift>|/unshift ARRAY,LIST> do the same thing to the left end of
an array that L<C<pop>|/pop ARRAY> and L<C<push>|/push ARRAY,LIST> do to
the right end.
 
=item shmctl ID,CMD,ARG
X<shmctl>
 
=for Pod::Functions SysV shared memory operations
 
Calls the System V IPC function shmctl.  You'll probably have to say
 
    use IPC::SysV;
 
first to get the correct constant definitions.  If CMD is C<IPC_STAT>,
then ARG must be a variable that will hold the returned C<shmid_ds>
structure.  Returns like ioctl: L<C<undef>|/undef EXPR> for error; "C<0>
but true" for zero; and the actual return value otherwise.
See also L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV>.
 
Portability issues: L<perlport/shmctl>.
 
=item shmget KEY,SIZE,FLAGS
X<shmget>
 
=for Pod::Functions get SysV shared memory segment identifier
 
Calls the System V IPC function shmget.  Returns the shared memory
segment id, or L<C<undef>|/undef EXPR> on error.
See also L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV>.
 
Portability issues: L<perlport/shmget>.
 
=item shmread ID,VAR,POS,SIZE
X<shmread>
X<shmwrite>
 
=for Pod::Functions read SysV shared memory
 
=item shmwrite ID,STRING,POS,SIZE
 
=for Pod::Functions write SysV shared memory
 
Reads or writes the System V shared memory segment ID starting at
position POS for size SIZE by attaching to it, copying in/out, and
detaching from it.  When reading, VAR must be a variable that will
hold the data read.  When writing, if STRING is too long, only SIZE
bytes are used; if STRING is too short, nulls are written to fill out
SIZE bytes.  Return true if successful, false on error.
L<C<shmread>|/shmread ID,VAR,POS,SIZE> taints the variable.  See also
L<perlipc/"SysV IPC"> and the documentation for
L<C<IPC::SysV>|IPC::SysV> and the L<C<IPC::Shareable>|IPC::Shareable>
module from CPAN.
 
Portability issues: L<perlport/shmread> and L<perlport/shmwrite>.
 
=item shutdown SOCKET,HOW
X<shutdown>
 
=for Pod::Functions close down just half of a socket connection
 
Shuts down a socket connection in the manner indicated by HOW, which
has the same interpretation as in the syscall of the same name.
 
    shutdown($socket, 0);    # I/we have stopped reading data
    shutdown($socket, 1);    # I/we have stopped writing data
    shutdown($socket, 2);    # I/we have stopped using this socket
 
This is useful with sockets when you want to tell the other
side you're done writing but not done reading, or vice versa.
It's also a more insistent form of close because it also
disables the file descriptor in any forked copies in other
processes.
 
Returns C<1> for success; on error, returns L<C<undef>|/undef EXPR> if
the first argument is not a valid filehandle, or returns C<0> and sets
L<C<$!>|perlvar/$!> for any other failure.
 
=item sin EXPR
X<sin> X<sine> X<asin> X<arcsine>
 
=item sin
 
=for Pod::Functions return the sine of a number
 
Returns the sine of EXPR (expressed in radians).  If EXPR is omitted,
returns sine of L<C<$_>|perlvar/$_>.
 
For the inverse sine operation, you may use the C<Math::Trig::asin>
function, or use this relation:
 
    sub asin { atan2($_[0], sqrt(1 - $_[0] * $_[0])) }
 
=item sleep EXPR
X<sleep> X<pause>
 
=item sleep
 
=for Pod::Functions block for some number of seconds
 
Causes the script to sleep for (integer) EXPR seconds, or forever if no
argument is given.  Returns the integer number of seconds actually slept.
 
May be interrupted if the process receives a signal such as C<SIGALRM>.
 
    eval {
        local $SIG{ALRM} = sub { die "Alarm!\n" };
        sleep;
    };
    die $@ unless $@ eq "Alarm!\n";
 
You probably cannot mix L<C<alarm>|/alarm SECONDS> and
L<C<sleep>|/sleep EXPR> calls, because L<C<sleep>|/sleep EXPR> is often
implemented using L<C<alarm>|/alarm SECONDS>.
 
On some older systems, it may sleep up to a full second less than what
you requested, depending on how it counts seconds.  Most modern systems
always sleep the full amount.  They may appear to sleep longer than that,
however, because your process might not be scheduled right away in a
busy multitasking system.
 
For delays of finer granularity than one second, the L<Time::HiRes>
module (from CPAN, and starting from Perl 5.8 part of the standard
distribution) provides L<C<usleep>|Time::HiRes/usleep ( $useconds )>.
You may also use Perl's four-argument
version of L<C<select>|/select RBITS,WBITS,EBITS,TIMEOUT> leaving the
first three arguments undefined, or you might be able to use the
L<C<syscall>|/syscall NUMBER, LIST> interface to access L<setitimer(2)>
if your system supports it.  See L<perlfaq8> for details.
 
See also the L<POSIX> module's L<C<pause>|POSIX/C<pause>> function.
 
=item socket SOCKET,DOMAIN,TYPE,PROTOCOL
X<socket>
 
=for Pod::Functions create a socket
 
Opens a socket of the specified kind and attaches it to filehandle
SOCKET.  DOMAIN, TYPE, and PROTOCOL are specified the same as for
the syscall of the same name.  You should C<use Socket> first
to get the proper definitions imported.  See the examples in
L<perlipc/"Sockets: Client/Server Communication">.
 
On systems that support a close-on-exec flag on files, the flag will
be set for the newly opened file descriptor, as determined by the
value of L<C<$^F>|perlvar/$^F>.  See L<perlvar/$^F>.
 
=item socketpair SOCKET1,SOCKET2,DOMAIN,TYPE,PROTOCOL
X<socketpair>
 
=for Pod::Functions create a pair of sockets
 
Creates an unnamed pair of sockets in the specified domain, of the
specified type.  DOMAIN, TYPE, and PROTOCOL are specified the same as
for the syscall of the same name.  If unimplemented, raises an exception.
Returns true if successful.
 
On systems that support a close-on-exec flag on files, the flag will
be set for the newly opened file descriptors, as determined by the value
of L<C<$^F>|perlvar/$^F>.  See L<perlvar/$^F>.
 
Some systems define L<C<pipe>|/pipe READHANDLE,WRITEHANDLE> in terms of
L<C<socketpair>|/socketpair SOCKET1,SOCKET2,DOMAIN,TYPE,PROTOCOL>, in
which a call to C<pipe($rdr, $wtr)> is essentially:
 
    use Socket;
    socketpair(my $rdr, my $wtr, AF_UNIX, SOCK_STREAM, PF_UNSPEC);
    shutdown($rdr, 1);        # no more writing for reader
    shutdown($wtr, 0);        # no more reading for writer
 
See L<perlipc> for an example of socketpair use.  Perl 5.8 and later will
emulate socketpair using IP sockets to localhost if your system implements
sockets but not socketpair.
 
Portability issues: L<perlport/socketpair>.
 
=item sort SUBNAME LIST
X<sort>
 
=item sort BLOCK LIST
 
=item sort LIST
 
=for Pod::Functions sort a list of values
 
In list context, this sorts the LIST and returns the sorted list value.
In scalar context, the behaviour of L<C<sort>|/sort SUBNAME LIST> is
undefined.
 
If SUBNAME or BLOCK is omitted, L<C<sort>|/sort SUBNAME LIST>s in
standard string comparison
order.  If SUBNAME is specified, it gives the name of a subroutine
that returns an integer less than, equal to, or greater than C<0>,
depending on how the elements of the list are to be ordered.  (The
C<< <=> >> and C<cmp> operators are extremely useful in such routines.)
SUBNAME may be a scalar variable name (unsubscripted), in which case
the value provides the name of (or a reference to) the actual
subroutine to use.  In place of a SUBNAME, you can provide a BLOCK as
an anonymous, in-line sort subroutine.
 
If the subroutine's prototype is C<($$)>, the elements to be compared are
passed by reference in L<C<@_>|perlvar/@_>, as for a normal subroutine.
This is slower than unprototyped subroutines, where the elements to be
compared are passed into the subroutine as the package global variables
C<$a> and C<$b> (see example below).
 
If the subroutine is an XSUB, the elements to be compared are pushed on
to the stack, the way arguments are usually passed to XSUBs.  C<$a> and
C<$b> are not set.
 
The values to be compared are always passed by reference and should not
be modified.
 
You also cannot exit out of the sort block or subroutine using any of the
loop control operators described in L<perlsyn> or with
L<C<goto>|/goto LABEL>.
 
When L<C<use locale>|locale> (but not C<use locale ':not_characters'>)
is in effect, C<sort LIST> sorts LIST according to the
current collation locale.  See L<perllocale>.
 
L<C<sort>|/sort SUBNAME LIST> returns aliases into the original list,
much as a for loop's index variable aliases the list elements.  That is,
modifying an element of a list returned by L<C<sort>|/sort SUBNAME LIST>
(for example, in a C<foreach>, L<C<map>|/map BLOCK LIST> or
L<C<grep>|/grep BLOCK LIST>)
actually modifies the element in the original list.  This is usually
something to be avoided when writing clear code.
 
Historically Perl has varied in whether sorting is stable by default.
If stability matters, it can be controlled explicitly by using the
L<sort> pragma.
 
Examples:
 
    # sort lexically
    my @articles = sort @files;
 
    # same thing, but with explicit sort routine
    my @articles = sort {$a cmp $b} @files;
 
    # now case-insensitively
    my @articles = sort {fc($a) cmp fc($b)} @files;
 
    # same thing in reversed order
    my @articles = sort {$b cmp $a} @files;
 
    # sort numerically ascending
    my @articles = sort {$a <=> $b} @files;
 
    # sort numerically descending
    my @articles = sort {$b <=> $a} @files;
 
    # this sorts the %age hash by value instead of key
    # using an in-line function
    my @eldest = sort { $age{$b} <=> $age{$a} } keys %age;
 
    # sort using explicit subroutine name
    sub byage {
        $age{$a} <=> $age{$b};  # presuming numeric
    }
    my @sortedclass = sort byage @class;
 
    sub backwards { $b cmp $a }
    my @harry  = qw(dog cat x Cain Abel);
    my @george = qw(gone chased yz Punished Axed);
    print sort @harry;
        # prints AbelCaincatdogx
    print sort backwards @harry;
        # prints xdogcatCainAbel
    print sort @george, 'to', @harry;
        # prints AbelAxedCainPunishedcatchaseddoggonetoxyz
 
    # inefficiently sort by descending numeric compare using
    # the first integer after the first = sign, or the
    # whole record case-insensitively otherwise
 
    my @new = sort {
        ($b =~ /=(\d+)/)[0] <=> ($a =~ /=(\d+)/)[0]
                            ||
                    fc($a)  cmp  fc($b)
    } @old;
 
    # same thing, but much more efficiently;
    # we'll build auxiliary indices instead
    # for speed
    my (@nums, @caps);
    for (@old) {
        push @nums, ( /=(\d+)/ ? $1 : undef );
        push @caps, fc($_);
    }
 
    my @new = @old[ sort {
                           $nums[$b] <=> $nums[$a]
                                    ||
                           $caps[$a] cmp $caps[$b]
                         } 0..$#old
                  ];
 
    # same thing, but without any temps
    my @new = map { $_->[0] }
           sort { $b->[1] <=> $a->[1]
                           ||
                  $a->[2] cmp $b->[2]
           } map { [$_, /=(\d+)/, fc($_)] } @old;
 
    # using a prototype allows you to use any comparison subroutine
    # as a sort subroutine (including other package's subroutines)
    package Other;
    sub backwards ($$) { $_[1] cmp $_[0]; }  # $a and $b are
                                             # not set here
    package main;
    my @new = sort Other::backwards @old;
 
    # guarantee stability
    use sort 'stable';
    my @new = sort { substr($a, 3, 5) cmp substr($b, 3, 5) } @old;
 
Warning: syntactical care is required when sorting the list returned from
a function.  If you want to sort the list returned by the function call
C<find_records(@key)>, you can use:
 
    my @contact = sort { $a cmp $b } find_records @key;
    my @contact = sort +find_records(@key);
    my @contact = sort &find_records(@key);
    my @contact = sort(find_records(@key));
 
If instead you want to sort the array C<@key> with the comparison routine
C<find_records()> then you can use:
 
    my @contact = sort { find_records() } @key;
    my @contact = sort find_records(@key);
    my @contact = sort(find_records @key);
    my @contact = sort(find_records (@key));
 
C<$a> and C<$b> are set as package globals in the package the sort() is
called from.  That means C<$main::a> and C<$main::b> (or C<$::a> and
C<$::b>) in the C<main> package, C<$FooPack::a> and C<$FooPack::b> in the
C<FooPack> package, etc.  If the sort block is in scope of a C<my> or
C<state> declaration of C<$a> and/or C<$b>, you I<must> spell out the full
name of the variables in the sort block :
 
   package main;
   my $a = "C"; # DANGER, Will Robinson, DANGER !!!
 
   print sort { $a cmp $b }               qw(A C E G B D F H);
                                          # WRONG
   sub badlexi { $a cmp $b }
   print sort badlexi                     qw(A C E G B D F H);
                                          # WRONG
   # the above prints BACFEDGH or some other incorrect ordering
 
   print sort { $::a cmp $::b }           qw(A C E G B D F H);
                                          # OK
   print sort { our $a cmp our $b }       qw(A C E G B D F H);
                                          # also OK
   print sort { our ($a, $b); $a cmp $b } qw(A C E G B D F H);
                                          # also OK
   sub lexi { our $a cmp our $b }
   print sort lexi                        qw(A C E G B D F H);
                                          # also OK
   # the above print ABCDEFGH
 
With proper care you may mix package and my (or state) C<$a> and/or C<$b>:
 
   my $a = {
      tiny   => -2,
      small  => -1,
      normal => 0,
      big    => 1,
      huge   => 2
   };
 
   say sort { $a->{our $a} <=> $a->{our $b} }
       qw{ huge normal tiny small big};
 
   # prints tinysmallnormalbighuge
 
C<$a> and C<$b> are implicitly local to the sort() execution and regain their
former values upon completing the sort.
 
Sort subroutines written using C<$a> and C<$b> are bound to their calling
package. It is possible, but of limited interest, to define them in a
different package, since the subroutine must still refer to the calling
package's C<$a> and C<$b> :
 
   package Foo;
   sub lexi { $Bar::a cmp $Bar::b }
   package Bar;
   ... sort Foo::lexi ...
 
Use the prototyped versions (see above) for a more generic alternative.
 
The comparison function is required to behave.  If it returns
inconsistent results (sometimes saying C<$x[1]> is less than C<$x[2]> and
sometimes saying the opposite, for example) the results are not
well-defined.
 
Because C<< <=> >> returns L<C<undef>|/undef EXPR> when either operand
is C<NaN> (not-a-number), be careful when sorting with a
comparison function like C<< $a <=> $b >> any lists that might contain a
C<NaN>.  The following example takes advantage that C<NaN != NaN> to
eliminate any C<NaN>s from the input list.
 
    my @result = sort { $a <=> $b } grep { $_ == $_ } @input;
 
=item splice ARRAY,OFFSET,LENGTH,LIST
X<splice>
 
=item splice ARRAY,OFFSET,LENGTH
 
=item splice ARRAY,OFFSET
 
=item splice ARRAY
 
=for Pod::Functions add or remove elements anywhere in an array
 
Removes the elements designated by OFFSET and LENGTH from an array, and
replaces them with the elements of LIST, if any.  In list context,
returns the elements removed from the array.  In scalar context,
returns the last element removed, or L<C<undef>|/undef EXPR> if no
elements are
removed.  The array grows or shrinks as necessary.
If OFFSET is negative then it starts that far from the end of the array.
If LENGTH is omitted, removes everything from OFFSET onward.
If LENGTH is negative, removes the elements from OFFSET onward
except for -LENGTH elements at the end of the array.
If both OFFSET and LENGTH are omitted, removes everything.  If OFFSET is
past the end of the array and a LENGTH was provided, Perl issues a warning,
and splices at the end of the array.
 
The following equivalences hold (assuming C<< $#a >= $i >> )
 
    push(@a,$x,$y)      splice(@a,@a,0,$x,$y)
    pop(@a)             splice(@a,-1)
    shift(@a)           splice(@a,0,1)
    unshift(@a,$x,$y)   splice(@a,0,0,$x,$y)
    $a[$i] = $y         splice(@a,$i,1,$y)
 
L<C<splice>|/splice ARRAY,OFFSET,LENGTH,LIST> can be used, for example,
to implement n-ary queue processing:
 
    sub nary_print {
      my $n = shift;
      while (my @next_n = splice @_, 0, $n) {
        say join q{ -- }, @next_n;
      }
    }
 
    nary_print(3, qw(a b c d e f g h));
    # prints:
    #   a -- b -- c
    #   d -- e -- f
    #   g -- h
 
Starting with Perl 5.14, an experimental feature allowed
L<C<splice>|/splice ARRAY,OFFSET,LENGTH,LIST> to take a
scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
=item split /PATTERN/,EXPR,LIMIT
X<split>
 
=item split /PATTERN/,EXPR
 
=item split /PATTERN/
 
=item split
 
=for Pod::Functions split up a string using a regexp delimiter
 
Splits the string EXPR into a list of strings and returns the
list in list context, or the size of the list in scalar context.
(Prior to Perl 5.11, it also overwrote C<@_> with the list in
void and scalar context. If you target old perls, beware.)
 
If only PATTERN is given, EXPR defaults to L<C<$_>|perlvar/$_>.
 
Anything in EXPR that matches PATTERN is taken to be a separator
that separates the EXPR into substrings (called "I<fields>") that
do B<not> include the separator.  Note that a separator may be
longer than one character or even have no characters at all (the
empty string, which is a zero-width match).
 
The PATTERN need not be constant; an expression may be used
to specify a pattern that varies at runtime.
 
If PATTERN matches the empty string, the EXPR is split at the match
position (between characters).  As an example, the following:
 
    print join(':', split(/b/, 'abc')), "\n";
 
uses the C<b> in C<'abc'> as a separator to produce the output C<a:c>.
However, this:
 
    print join(':', split(//, 'abc')), "\n";
 
uses empty string matches as separators to produce the output
C<a:b:c>; thus, the empty string may be used to split EXPR into a
list of its component characters.
 
As a special case for L<C<split>|/split E<sol>PATTERNE<sol>,EXPR,LIMIT>,
the empty pattern given in
L<match operator|perlop/"m/PATTERN/msixpodualngc"> syntax (C<//>)
specifically matches the empty string, which is contrary to its usual
interpretation as the last successful match.
 
If PATTERN is C</^/>, then it is treated as if it used the
L<multiline modifier|perlreref/OPERATORS> (C</^/m>), since it
isn't much use otherwise.
 
C<E<sol>m> and any of the other pattern modifiers valid for C<qr>
(summarized in L<perlop/qrE<sol>STRINGE<sol>msixpodualn>) may be
specified explicitly.
 
As another special case,
L<C<split>|/split E<sol>PATTERNE<sol>,EXPR,LIMIT> emulates the default
behavior of the
command line tool B<awk> when the PATTERN is either omitted or a
string composed of a single space character (such as S<C<' '>> or
S<C<"\x20">>, but not e.g. S<C</ />>).  In this case, any leading
whitespace in EXPR is removed before splitting occurs, and the PATTERN is
instead treated as if it were C</\s+/>; in particular, this means that
I<any> contiguous whitespace (not just a single space character) is used as
a separator.  However, this special treatment can be avoided by specifying
the pattern S<C</ />> instead of the string S<C<" ">>, thereby allowing
only a single space character to be a separator.  In earlier Perls this
special case was restricted to the use of a plain S<C<" ">> as the
pattern argument to split; in Perl 5.18.0 and later this special case is
triggered by any expression which evaluates to the simple string S<C<" ">>.
 
As of Perl 5.28, this special-cased whitespace splitting works as expected in
the scope of L<< S<C<"use feature 'unicode_strings">>|feature/The
'unicode_strings' feature >>. In previous versions, and outside the scope of
that feature, it exhibits L<perlunicode/The "Unicode Bug">: characters that are
whitespace according to Unicode rules but not according to ASCII rules can be
treated as part of fields rather than as field separators, depending on the
string's internal encoding.
 
If omitted, PATTERN defaults to a single space, S<C<" ">>, triggering
the previously described I<awk> emulation.
 
If LIMIT is specified and positive, it represents the maximum number
of fields into which the EXPR may be split; in other words, LIMIT is
one greater than the maximum number of times EXPR may be split.  Thus,
the LIMIT value C<1> means that EXPR may be split a maximum of zero
times, producing a maximum of one field (namely, the entire value of
EXPR).  For instance:
 
    print join(':', split(//, 'abc', 1)), "\n";
 
produces the output C<abc>, and this:
 
    print join(':', split(//, 'abc', 2)), "\n";
 
produces the output C<a:bc>, and each of these:
 
    print join(':', split(//, 'abc', 3)), "\n";
    print join(':', split(//, 'abc', 4)), "\n";
 
produces the output C<a:b:c>.
 
If LIMIT is negative, it is treated as if it were instead arbitrarily
large; as many fields as possible are produced.
 
If LIMIT is omitted (or, equivalently, zero), then it is usually
treated as if it were instead negative but with the exception that
trailing empty fields are stripped (empty leading fields are always
preserved); if all fields are empty, then all fields are considered to
be trailing (and are thus stripped in this case).  Thus, the following:
 
    print join(':', split(/,/, 'a,b,c,,,')), "\n";
 
produces the output C<a:b:c>, but the following:
 
    print join(':', split(/,/, 'a,b,c,,,', -1)), "\n";
 
produces the output C<a:b:c:::>.
 
In time-critical applications, it is worthwhile to avoid splitting
into more fields than necessary.  Thus, when assigning to a list,
if LIMIT is omitted (or zero), then LIMIT is treated as though it
were one larger than the number of variables in the list; for the
following, LIMIT is implicitly 3:
 
    my ($login, $passwd) = split(/:/);
 
Note that splitting an EXPR that evaluates to the empty string always
produces zero fields, regardless of the LIMIT specified.
 
An empty leading field is produced when there is a positive-width
match at the beginning of EXPR.  For instance:
 
    print join(':', split(/ /, ' abc')), "\n";
 
produces the output C<:abc>.  However, a zero-width match at the
beginning of EXPR never produces an empty field, so that:
 
    print join(':', split(//, ' abc'));
 
produces the output S<C< :a:b:c>> (rather than S<C<: :a:b:c>>).
 
An empty trailing field, on the other hand, is produced when there is a
match at the end of EXPR, regardless of the length of the match
(of course, unless a non-zero LIMIT is given explicitly, such fields are
removed, as in the last example).  Thus:
 
    print join(':', split(//, ' abc', -1)), "\n";
 
produces the output S<C< :a:b:c:>>.
 
If the PATTERN contains
L<capturing groups|perlretut/Grouping things and hierarchical matching>,
then for each separator, an additional field is produced for each substring
captured by a group (in the order in which the groups are specified,
as per L<backreferences|perlretut/Backreferences>); if any group does not
match, then it captures the L<C<undef>|/undef EXPR> value instead of a
substring.  Also,
note that any such additional field is produced whenever there is a
separator (that is, whenever a split occurs), and such an additional field
does B<not> count towards the LIMIT.  Consider the following expressions
evaluated in list context (each returned list is provided in the associated
comment):
 
    split(/-|,/, "1-10,20", 3)
    # ('1', '10', '20')
 
    split(/(-|,)/, "1-10,20", 3)
    # ('1', '-', '10', ',', '20')
 
    split(/-|(,)/, "1-10,20", 3)
    # ('1', undef, '10', ',', '20')
 
    split(/(-)|,/, "1-10,20", 3)
    # ('1', '-', '10', undef, '20')
 
    split(/(-)|(,)/, "1-10,20", 3)
    # ('1', '-', undef, '10', undef, ',', '20')
 
=item sprintf FORMAT, LIST
X<sprintf>
 
=for Pod::Functions formatted print into a string
 
Returns a string formatted by the usual
L<C<printf>|/printf FILEHANDLE FORMAT, LIST> conventions of the C
library function L<C<sprintf>|/sprintf FORMAT, LIST>.  See below for
more details and see L<sprintf(3)> or L<printf(3)> on your system for an
explanation of the general principles.
 
For example:
 
        # Format number with up to 8 leading zeroes
        my $result = sprintf("%08d", $number);
 
        # Round number to 3 digits after decimal point
        my $rounded = sprintf("%.3f", $number);
 
Perl does its own L<C<sprintf>|/sprintf FORMAT, LIST> formatting: it
emulates the C
function L<sprintf(3)>, but doesn't use it except for floating-point
numbers, and even then only standard modifiers are allowed.
Non-standard extensions in your local L<sprintf(3)> are
therefore unavailable from Perl.
 
Unlike L<C<printf>|/printf FILEHANDLE FORMAT, LIST>,
L<C<sprintf>|/sprintf FORMAT, LIST> does not do what you probably mean
when you pass it an array as your first argument.
The array is given scalar context,
and instead of using the 0th element of the array as the format, Perl will
use the count of elements in the array as the format, which is almost never
useful.
 
Perl's L<C<sprintf>|/sprintf FORMAT, LIST> permits the following
universally-known conversions:
 
   %%    a percent sign
   %c    a character with the given number
   %s    a string
   %d    a signed integer, in decimal
   %u    an unsigned integer, in decimal
   %o    an unsigned integer, in octal
   %x    an unsigned integer, in hexadecimal
   %e    a floating-point number, in scientific notation
   %f    a floating-point number, in fixed decimal notation
   %g    a floating-point number, in %e or %f notation
 
In addition, Perl permits the following widely-supported conversions:
 
   %X    like %x, but using upper-case letters
   %E    like %e, but using an upper-case "E"
   %G    like %g, but with an upper-case "E" (if applicable)
   %b    an unsigned integer, in binary
   %B    like %b, but using an upper-case "B" with the # flag
   %p    a pointer (outputs the Perl value's address in hexadecimal)
   %n    special: *stores* the number of characters output so far
         into the next argument in the parameter list
   %a    hexadecimal floating point
   %A    like %a, but using upper-case letters
 
Finally, for backward (and we do mean "backward") compatibility, Perl
permits these unnecessary but widely-supported conversions:
 
   %i    a synonym for %d
   %D    a synonym for %ld
   %U    a synonym for %lu
   %O    a synonym for %lo
   %F    a synonym for %f
 
Note that the number of exponent digits in the scientific notation produced
by C<%e>, C<%E>, C<%g> and C<%G> for numbers with the modulus of the
exponent less than 100 is system-dependent: it may be three or less
(zero-padded as necessary).  In other words, 1.23 times ten to the
99th may be either "1.23e99" or "1.23e099".  Similarly for C<%a> and C<%A>:
the exponent or the hexadecimal digits may float: especially the
"long doubles" Perl configuration option may cause surprises.
 
Between the C<%> and the format letter, you may specify several
additional attributes controlling the interpretation of the format.
In order, these are:
 
=over 4
 
=item format parameter index
 
An explicit format parameter index, such as C<2$>.  By default sprintf
will format the next unused argument in the list, but this allows you
to take the arguments out of order:
 
  printf '%2$d %1$d', 12, 34;      # prints "34 12"
  printf '%3$d %d %1$d', 1, 2, 3;  # prints "3 1 1"
 
=item flags
 
one or more of:
 
   space   prefix non-negative number with a space
   +       prefix non-negative number with a plus sign
   -       left-justify within the field
   0       use zeros, not spaces, to right-justify
   #       ensure the leading "0" for any octal,
           prefix non-zero hexadecimal with "0x" or "0X",
           prefix non-zero binary with "0b" or "0B"
 
For example:
 
  printf '<% d>',  12;   # prints "< 12>"
  printf '<% d>',   0;   # prints "< 0>"
  printf '<% d>', -12;   # prints "<-12>"
  printf '<%+d>',  12;   # prints "<+12>"
  printf '<%+d>',   0;   # prints "<+0>"
  printf '<%+d>', -12;   # prints "<-12>"
  printf '<%6s>',  12;   # prints "<    12>"
  printf '<%-6s>', 12;   # prints "<12    >"
  printf '<%06s>', 12;   # prints "<000012>"
  printf '<%#o>',  12;   # prints "<014>"
  printf '<%#x>',  12;   # prints "<0xc>"
  printf '<%#X>',  12;   # prints "<0XC>"
  printf '<%#b>',  12;   # prints "<0b1100>"
  printf '<%#B>',  12;   # prints "<0B1100>"
 
When a space and a plus sign are given as the flags at once,
the space is ignored.
 
  printf '<%+ d>', 12;   # prints "<+12>"
  printf '<% +d>', 12;   # prints "<+12>"
 
When the # flag and a precision are given in the %o conversion,
the precision is incremented if it's necessary for the leading "0".
 
  printf '<%#.5o>', 012;      # prints "<00012>"
  printf '<%#.5o>', 012345;   # prints "<012345>"
  printf '<%#.0o>', 0;        # prints "<0>"
 
=item vector flag
 
This flag tells Perl to interpret the supplied string as a vector of
integers, one for each character in the string.  Perl applies the format to
each integer in turn, then joins the resulting strings with a separator (a
dot C<.> by default).  This can be useful for displaying ordinal values of
characters in arbitrary strings:
 
  printf "%vd", "AB\x{100}";           # prints "65.66.256"
  printf "version is v%vd\n", $^V;     # Perl's version
 
Put an asterisk C<*> before the C<v> to override the string to
use to separate the numbers:
 
  printf "address is %*vX\n", ":", $addr;   # IPv6 address
  printf "bits are %0*v8b\n", " ", $bits;   # random bitstring
 
You can also explicitly specify the argument number to use for
the join string using something like C<*2$v>; for example:
 
  printf '%*4$vX %*4$vX %*4$vX',       # 3 IPv6 addresses
          @addr[1..3], ":";
 
=item (minimum) width
 
Arguments are usually formatted to be only as wide as required to
display the given value.  You can override the width by putting
a number here, or get the width from the next argument (with C<*>)
or from a specified argument (e.g., with C<*2$>):
 
 printf "<%s>", "a";       # prints "<a>"
 printf "<%6s>", "a";      # prints "<     a>"
 printf "<%*s>", 6, "a";   # prints "<     a>"
 printf '<%*2$s>', "a", 6; # prints "<     a>"
 printf "<%2s>", "long";   # prints "<long>" (does not truncate)
 
If a field width obtained through C<*> is negative, it has the same
effect as the C<-> flag: left-justification.
 
=item precision, or maximum width
X<precision>
 
You can specify a precision (for numeric conversions) or a maximum
width (for string conversions) by specifying a C<.> followed by a number.
For floating-point formats except C<g> and C<G>, this specifies
how many places right of the decimal point to show (the default being 6).
For example:
 
  # these examples are subject to system-specific variation
  printf '<%f>', 1;    # prints "<1.000000>"
  printf '<%.1f>', 1;  # prints "<1.0>"
  printf '<%.0f>', 1;  # prints "<1>"
  printf '<%e>', 10;   # prints "<1.000000e+01>"
  printf '<%.1e>', 10; # prints "<1.0e+01>"
 
For "g" and "G", this specifies the maximum number of significant digits to
show; for example:
 
  # These examples are subject to system-specific variation.
  printf '<%g>', 1;        # prints "<1>"
  printf '<%.10g>', 1;     # prints "<1>"
  printf '<%g>', 100;      # prints "<100>"
  printf '<%.1g>', 100;    # prints "<1e+02>"
  printf '<%.2g>', 100.01; # prints "<1e+02>"
  printf '<%.5g>', 100.01; # prints "<100.01>"
  printf '<%.4g>', 100.01; # prints "<100>"
  printf '<%.1g>', 0.0111; # prints "<0.01>"
  printf '<%.2g>', 0.0111; # prints "<0.011>"
  printf '<%.3g>', 0.0111; # prints "<0.0111>"
 
For integer conversions, specifying a precision implies that the
output of the number itself should be zero-padded to this width,
where the 0 flag is ignored:
 
  printf '<%.6d>', 1;      # prints "<000001>"
  printf '<%+.6d>', 1;     # prints "<+000001>"
  printf '<%-10.6d>', 1;   # prints "<000001    >"
  printf '<%10.6d>', 1;    # prints "<    000001>"
  printf '<%010.6d>', 1;   # prints "<    000001>"
  printf '<%+10.6d>', 1;   # prints "<   +000001>"
 
  printf '<%.6x>', 1;      # prints "<000001>"
  printf '<%#.6x>', 1;     # prints "<0x000001>"
  printf '<%-10.6x>', 1;   # prints "<000001    >"
  printf '<%10.6x>', 1;    # prints "<    000001>"
  printf '<%010.6x>', 1;   # prints "<    000001>"
  printf '<%#10.6x>', 1;   # prints "<  0x000001>"
 
For string conversions, specifying a precision truncates the string
to fit the specified width:
 
  printf '<%.5s>', "truncated";   # prints "<trunc>"
  printf '<%10.5s>', "truncated"; # prints "<     trunc>"
 
You can also get the precision from the next argument using C<.*>, or from a
specified argument (e.g., with C<.*2$>):
 
  printf '<%.6x>', 1;       # prints "<000001>"
  printf '<%.*x>', 6, 1;    # prints "<000001>"
 
  printf '<%.*2$x>', 1, 6;  # prints "<000001>"
 
  printf '<%6.*2$x>', 1, 4; # prints "<  0001>"
 
If a precision obtained through C<*> is negative, it counts
as having no precision at all.
 
  printf '<%.*s>',  7, "string";   # prints "<string>"
  printf '<%.*s>',  3, "string";   # prints "<str>"
  printf '<%.*s>',  0, "string";   # prints "<>"
  printf '<%.*s>', -1, "string";   # prints "<string>"
 
  printf '<%.*d>',  1, 0;   # prints "<0>"
  printf '<%.*d>',  0, 0;   # prints "<>"
  printf '<%.*d>', -1, 0;   # prints "<0>"
 
=item size
 
For numeric conversions, you can specify the size to interpret the
number as using C<l>, C<h>, C<V>, C<q>, C<L>, or C<ll>.  For integer
conversions (C<d u o x X b i D U O>), numbers are usually assumed to be
whatever the default integer size is on your platform (usually 32 or 64
bits), but you can override this to use instead one of the standard C types,
as supported by the compiler used to build Perl:
 
   hh          interpret integer as C type "char" or "unsigned
               char" on Perl 5.14 or later
   h           interpret integer as C type "short" or
               "unsigned short"
   j           interpret integer as C type "intmax_t" on Perl
               5.14 or later; and prior to Perl 5.30, only with
               a C99 compiler (unportable)
   l           interpret integer as C type "long" or
               "unsigned long"
   q, L, or ll interpret integer as C type "long long",
               "unsigned long long", or "quad" (typically
               64-bit integers)
   t           interpret integer as C type "ptrdiff_t" on Perl
               5.14 or later
   z           interpret integer as C types "size_t" or
               "ssize_t" on Perl 5.14 or later
 
As of 5.14, none of these raises an exception if they are not supported on
your platform.  However, if warnings are enabled, a warning of the
L<C<printf>|warnings> warning class is issued on an unsupported
conversion flag.  Should you instead prefer an exception, do this:
 
    use warnings FATAL => "printf";
 
If you would like to know about a version dependency before you
start running the program, put something like this at its top:
 
    use 5.014;  # for hh/j/t/z/ printf modifiers
 
You can find out whether your Perl supports quads via L<Config>:
 
    use Config;
    if ($Config{use64bitint} eq "define"
        || $Config{longsize} >= 8) {
        print "Nice quads!\n";
    }
 
For floating-point conversions (C<e f g E F G>), numbers are usually assumed
to be the default floating-point size on your platform (double or long double),
but you can force "long double" with C<q>, C<L>, or C<ll> if your
platform supports them.  You can find out whether your Perl supports long
doubles via L<Config>:
 
    use Config;
    print "long doubles\n" if $Config{d_longdbl} eq "define";
 
You can find out whether Perl considers "long double" to be the default
floating-point size to use on your platform via L<Config>:
 
    use Config;
    if ($Config{uselongdouble} eq "define") {
        print "long doubles by default\n";
    }
 
It can also be that long doubles and doubles are the same thing:
 
        use Config;
        ($Config{doublesize} == $Config{longdblsize}) &&
                print "doubles are long doubles\n";
 
The size specifier C<V> has no effect for Perl code, but is supported for
compatibility with XS code.  It means "use the standard size for a Perl
integer or floating-point number", which is the default.
 
=item order of arguments
 
Normally, L<C<sprintf>|/sprintf FORMAT, LIST> takes the next unused
argument as the value to
format for each format specification.  If the format specification
uses C<*> to require additional arguments, these are consumed from
the argument list in the order they appear in the format
specification I<before> the value to format.  Where an argument is
specified by an explicit index, this does not affect the normal
order for the arguments, even when the explicitly specified index
would have been the next argument.
 
So:
 
    printf "<%*.*s>", $a, $b, $c;
 
uses C<$a> for the width, C<$b> for the precision, and C<$c>
as the value to format; while:
 
  printf '<%*1$.*s>', $a, $b;
 
would use C<$a> for the width and precision, and C<$b> as the
value to format.
 
Here are some more examples; be aware that when using an explicit
index, the C<$> may need escaping:
 
 printf "%2\$d %d\n",      12, 34;     # will print "34 12\n"
 printf "%2\$d %d %d\n",   12, 34;     # will print "34 12 34\n"
 printf "%3\$d %d %d\n",   12, 34, 56; # will print "56 12 34\n"
 printf "%2\$*3\$d %d\n",  12, 34,  3; # will print " 34 12\n"
 printf "%*1\$.*f\n",       4,  5, 10; # will print "5.0000\n"
 
=back
 
If L<C<use locale>|locale> (including C<use locale ':not_characters'>)
is in effect and L<C<POSIX::setlocale>|POSIX/C<setlocale>> has been
called,
the character used for the decimal separator in formatted floating-point
numbers is affected by the C<LC_NUMERIC> locale.  See L<perllocale>
and L<POSIX>.
 
=item sqrt EXPR
X<sqrt> X<root> X<square root>
 
=item sqrt
 
=for Pod::Functions square root function
 
Return the positive square root of EXPR.  If EXPR is omitted, uses
L<C<$_>|perlvar/$_>.  Works only for non-negative operands unless you've
loaded the L<C<Math::Complex>|Math::Complex> module.
 
    use Math::Complex;
    print sqrt(-4);    # prints 2i
 
=item srand EXPR
X<srand> X<seed> X<randseed>
 
=item srand
 
=for Pod::Functions seed the random number generator
 
Sets and returns the random number seed for the L<C<rand>|/rand EXPR>
operator.
 
The point of the function is to "seed" the L<C<rand>|/rand EXPR>
function so that L<C<rand>|/rand EXPR> can produce a different sequence
each time you run your program.  When called with a parameter,
L<C<srand>|/srand EXPR> uses that for the seed; otherwise it
(semi-)randomly chooses a seed.  In either case, starting with Perl 5.14,
it returns the seed.  To signal that your code will work I<only> on Perls
of a recent vintage:
 
    use 5.014;  # so srand returns the seed
 
If L<C<srand>|/srand EXPR> is not called explicitly, it is called
implicitly without a parameter at the first use of the
L<C<rand>|/rand EXPR> operator.  However, there are a few situations
where programs are likely to want to call L<C<srand>|/srand EXPR>.  One
is for generating predictable results, generally for testing or
debugging.  There, you use C<srand($seed)>, with the same C<$seed> each
time.  Another case is that you may want to call L<C<srand>|/srand EXPR>
after a L<C<fork>|/fork> to avoid child processes sharing the same seed
value as the parent (and consequently each other).
 
Do B<not> call C<srand()> (i.e., without an argument) more than once per
process.  The internal state of the random number generator should
contain more entropy than can be provided by any seed, so calling
L<C<srand>|/srand EXPR> again actually I<loses> randomness.
 
Most implementations of L<C<srand>|/srand EXPR> take an integer and will
silently
truncate decimal numbers.  This means C<srand(42)> will usually
produce the same results as C<srand(42.1)>.  To be safe, always pass
L<C<srand>|/srand EXPR> an integer.
 
A typical use of the returned seed is for a test program which has too many
combinations to test comprehensively in the time available to it each run.  It
can test a random subset each time, and should there be a failure, log the seed
used for that run so that it can later be used to reproduce the same results.
 
B<L<C<rand>|/rand EXPR> is not cryptographically secure.  You should not rely
on it in security-sensitive situations.>  As of this writing, a
number of third-party CPAN modules offer random number generators
intended by their authors to be cryptographically secure,
including: L<Data::Entropy>, L<Crypt::Random>, L<Math::Random::Secure>,
and L<Math::TrulyRandom>.
 
=item stat FILEHANDLE
X<stat> X<file, status> X<ctime>
 
=item stat EXPR
 
=item stat DIRHANDLE
 
=item stat
 
=for Pod::Functions get a file's status information
 
Returns a 13-element list giving the status info for a file, either
the file opened via FILEHANDLE or DIRHANDLE, or named by EXPR.  If EXPR is
omitted, it stats L<C<$_>|perlvar/$_> (not C<_>!).  Returns the empty
list if L<C<stat>|/stat FILEHANDLE> fails.  Typically
used as follows:
 
    my ($dev,$ino,$mode,$nlink,$uid,$gid,$rdev,$size,
        $atime,$mtime,$ctime,$blksize,$blocks)
           = stat($filename);
 
Not all fields are supported on all filesystem types.  Here are the
meanings of the fields:
 
  0 dev      device number of filesystem
  1 ino      inode number
  2 mode     file mode  (type and permissions)
  3 nlink    number of (hard) links to the file
  4 uid      numeric user ID of file's owner
  5 gid      numeric group ID of file's owner
  6 rdev     the device identifier (special files only)
  7 size     total size of file, in bytes
  8 atime    last access time in seconds since the epoch
  9 mtime    last modify time in seconds since the epoch
 10 ctime    inode change time in seconds since the epoch (*)
 11 blksize  preferred I/O size in bytes for interacting with the
             file (may vary from file to file)
 12 blocks   actual number of system-specific blocks allocated
             on disk (often, but not always, 512 bytes each)
 
(The epoch was at 00:00 January 1, 1970 GMT.)
 
(*) Not all fields are supported on all filesystem types.  Notably, the
ctime field is non-portable.  In particular, you cannot expect it to be a
"creation time"; see L<perlport/"Files and Filesystems"> for details.
 
If L<C<stat>|/stat FILEHANDLE> is passed the special filehandle
consisting of an underline, no stat is done, but the current contents of
the stat structure from the last L<C<stat>|/stat FILEHANDLE>,
L<C<lstat>|/lstat FILEHANDLE>, or filetest are returned.  Example:
 
    if (-x $file && (($d) = stat(_)) && $d < 0) {
        print "$file is executable NFS file\n";
    }
 
(This works on machines only for which the device number is negative
under NFS.)
 
On some platforms inode numbers are of a type larger than perl knows how
to handle as integer numerical values.  If necessary, an inode number will
be returned as a decimal string in order to preserve the entire value.
If used in a numeric context, this will be converted to a floating-point
numerical value, with rounding, a fate that is best avoided.  Therefore,
you should prefer to compare inode numbers using C<eq> rather than C<==>.
C<eq> will work fine on inode numbers that are represented numerically,
as well as those represented as strings.
 
Because the mode contains both the file type and its permissions, you
should mask off the file type portion and (s)printf using a C<"%o">
if you want to see the real permissions.
 
    my $mode = (stat($filename))[2];
    printf "Permissions are %04o\n", $mode & 07777;
 
In scalar context, L<C<stat>|/stat FILEHANDLE> returns a boolean value
indicating success
or failure, and, if successful, sets the information associated with
the special filehandle C<_>.
 
The L<File::stat> module provides a convenient, by-name access mechanism:
 
    use File::stat;
    my $sb = stat($filename);
    printf "File is %s, size is %s, perm %04o, mtime %s\n",
           $filename, $sb->size, $sb->mode & 07777,
           scalar localtime $sb->mtime;
 
You can import symbolic mode constants (C<S_IF*>) and functions
(C<S_IS*>) from the L<Fcntl> module:
 
    use Fcntl ':mode';
 
    my $mode = (stat($filename))[2];
 
    my $user_rwx      = ($mode & S_IRWXU) >> 6;
    my $group_read    = ($mode & S_IRGRP) >> 3;
    my $other_execute =  $mode & S_IXOTH;
 
    printf "Permissions are %04o\n", S_IMODE($mode), "\n";
 
    my $is_setuid     =  $mode & S_ISUID;
    my $is_directory  =  S_ISDIR($mode);
 
You could write the last two using the C<-u> and C<-d> operators.
Commonly available C<S_IF*> constants are:
 
    # Permissions: read, write, execute, for user, group, others.
 
    S_IRWXU S_IRUSR S_IWUSR S_IXUSR
    S_IRWXG S_IRGRP S_IWGRP S_IXGRP
    S_IRWXO S_IROTH S_IWOTH S_IXOTH
 
    # Setuid/Setgid/Stickiness/SaveText.
    # Note that the exact meaning of these is system-dependent.
 
    S_ISUID S_ISGID S_ISVTX S_ISTXT
 
    # File types.  Not all are necessarily available on
    # your system.
 
    S_IFREG S_IFDIR S_IFLNK S_IFBLK S_IFCHR
    S_IFIFO S_IFSOCK S_IFWHT S_ENFMT
 
    # The following are compatibility aliases for S_IRUSR,
    # S_IWUSR, and S_IXUSR.
 
    S_IREAD S_IWRITE S_IEXEC
 
and the C<S_IF*> functions are
 
    S_IMODE($mode)    the part of $mode containing the permission
                      bits and the setuid/setgid/sticky bits
 
    S_IFMT($mode)     the part of $mode containing the file type
                      which can be bit-anded with (for example)
                      S_IFREG or with the following functions
 
    # The operators -f, -d, -l, -b, -c, -p, and -S.
 
    S_ISREG($mode) S_ISDIR($mode) S_ISLNK($mode)
    S_ISBLK($mode) S_ISCHR($mode) S_ISFIFO($mode) S_ISSOCK($mode)
 
    # No direct -X operator counterpart, but for the first one
    # the -g operator is often equivalent.  The ENFMT stands for
    # record flocking enforcement, a platform-dependent feature.
 
    S_ISENFMT($mode) S_ISWHT($mode)
 
See your native L<chmod(2)> and L<stat(2)> documentation for more details
about the C<S_*> constants.  To get status info for a symbolic link
instead of the target file behind the link, use the
L<C<lstat>|/lstat FILEHANDLE> function.
 
Portability issues: L<perlport/stat>.
 
=item state VARLIST
X<state>
 
=item state TYPE VARLIST
 
=item state VARLIST : ATTRS
 
=item state TYPE VARLIST : ATTRS
 
=for Pod::Functions +state declare and assign a persistent lexical variable
 
L<C<state>|/state VARLIST> declares a lexically scoped variable, just
like L<C<my>|/my VARLIST>.
However, those variables will never be reinitialized, contrary to
lexical variables that are reinitialized each time their enclosing block
is entered.
See L<perlsub/"Persistent Private Variables"> for details.
 
If more than one variable is listed, the list must be placed in
parentheses.  With a parenthesised list, L<C<undef>|/undef EXPR> can be
used as a
dummy placeholder.  However, since initialization of state variables in
such lists is currently not possible this would serve no purpose.
 
L<C<state>|/state VARLIST> is available only if the
L<C<"state"> feature|feature/The 'state' feature> is enabled or if it is
prefixed with C<CORE::>.  The
L<C<"state"> feature|feature/The 'state' feature> is enabled
automatically with a C<use v5.10> (or higher) declaration in the current
scope.
 
 
=item study SCALAR
X<study>
 
=item study
 
=for Pod::Functions no-op, formerly optimized input data for repeated searches
 
At this time, C<study> does nothing. This may change in the future.
 
Prior to Perl version 5.16, it would create an inverted index of all characters
that occurred in the given SCALAR (or L<C<$_>|perlvar/$_> if unspecified). When
matching a pattern, the rarest character from the pattern would be looked up in
this index. Rarity was based on some static frequency tables constructed from
some C programs and English text.
 
 
=item sub NAME BLOCK
X<sub>
 
=item sub NAME (PROTO) BLOCK
 
=item sub NAME : ATTRS BLOCK
 
=item sub NAME (PROTO) : ATTRS BLOCK
 
=for Pod::Functions declare a subroutine, possibly anonymously
 
This is subroutine definition, not a real function I<per se>.  Without a
BLOCK it's just a forward declaration.  Without a NAME, it's an anonymous
function declaration, so does return a value: the CODE ref of the closure
just created.
 
See L<perlsub> and L<perlref> for details about subroutines and
references; see L<attributes> and L<Attribute::Handlers> for more
information about attributes.
 
=item __SUB__
X<__SUB__>
 
=for Pod::Functions +current_sub the current subroutine, or C<undef> if not in a subroutine
 
A special token that returns a reference to the current subroutine, or
L<C<undef>|/undef EXPR> outside of a subroutine.
 
The behaviour of L<C<__SUB__>|/__SUB__> within a regex code block (such
as C</(?{...})/>) is subject to change.
 
This token is only available under C<use v5.16> or the
L<C<"current_sub"> feature|feature/The 'current_sub' feature>.
See L<feature>.
 
=item substr EXPR,OFFSET,LENGTH,REPLACEMENT
X<substr> X<substring> X<mid> X<left> X<right>
 
=item substr EXPR,OFFSET,LENGTH
 
=item substr EXPR,OFFSET
 
=for Pod::Functions get or alter a portion of a string
 
Extracts a substring out of EXPR and returns it.  First character is at
offset zero.  If OFFSET is negative, starts
that far back from the end of the string.  If LENGTH is omitted, returns
everything through the end of the string.  If LENGTH is negative, leaves that
many characters off the end of the string.
 
    my $s = "The black cat climbed the green tree";
    my $color  = substr $s, 4, 5;      # black
    my $middle = substr $s, 4, -11;    # black cat climbed the
    my $end    = substr $s, 14;        # climbed the green tree
    my $tail   = substr $s, -4;        # tree
    my $z      = substr $s, -4, 2;     # tr
 
You can use the L<C<substr>|/substr EXPR,OFFSET,LENGTH,REPLACEMENT>
function as an lvalue, in which case EXPR
must itself be an lvalue.  If you assign something shorter than LENGTH,
the string will shrink, and if you assign something longer than LENGTH,
the string will grow to accommodate it.  To keep the string the same
length, you may need to pad or chop your value using
L<C<sprintf>|/sprintf FORMAT, LIST>.
 
If OFFSET and LENGTH specify a substring that is partly outside the
string, only the part within the string is returned.  If the substring
is beyond either end of the string,
L<C<substr>|/substr EXPR,OFFSET,LENGTH,REPLACEMENT> returns the undefined
value and produces a warning.  When used as an lvalue, specifying a
substring that is entirely outside the string raises an exception.
Here's an example showing the behavior for boundary cases:
 
    my $name = 'fred';
    substr($name, 4) = 'dy';         # $name is now 'freddy'
    my $null = substr $name, 6, 2;   # returns "" (no warning)
    my $oops = substr $name, 7;      # returns undef, with warning
    substr($name, 7) = 'gap';        # raises an exception
 
An alternative to using
L<C<substr>|/substr EXPR,OFFSET,LENGTH,REPLACEMENT> as an lvalue is to
specify the
replacement string as the 4th argument.  This allows you to replace
parts of the EXPR and return what was there before in one operation,
just as you can with
L<C<splice>|/splice ARRAY,OFFSET,LENGTH,LIST>.
 
    my $s = "The black cat climbed the green tree";
    my $z = substr $s, 14, 7, "jumped from";    # climbed
    # $s is now "The black cat jumped from the green tree"
 
Note that the lvalue returned by the three-argument version of
L<C<substr>|/substr EXPR,OFFSET,LENGTH,REPLACEMENT> acts as
a 'magic bullet'; each time it is assigned to, it remembers which part
of the original string is being modified; for example:
 
    my $x = '1234';
    for (substr($x,1,2)) {
        $_ = 'a';   print $x,"\n";    # prints 1a4
        $_ = 'xyz'; print $x,"\n";    # prints 1xyz4
        $x = '56789';
        $_ = 'pq';  print $x,"\n";    # prints 5pq9
    }
 
With negative offsets, it remembers its position from the end of the string
when the target string is modified:
 
    my $x = '1234';
    for (substr($x, -3, 2)) {
        $_ = 'a';   print $x,"\n";    # prints 1a4, as above
        $x = 'abcdefg';
        print $_,"\n";                # prints f
    }
 
Prior to Perl version 5.10, the result of using an lvalue multiple times was
unspecified.  Prior to 5.16, the result with negative offsets was
unspecified.
 
=item symlink OLDFILE,NEWFILE
X<symlink> X<link> X<symbolic link> X<link, symbolic>
 
=for Pod::Functions create a symbolic link to a file
 
Creates a new filename symbolically linked to the old filename.
Returns C<1> for success, C<0> otherwise.  On systems that don't support
symbolic links, raises an exception.  To check for that,
use eval:
 
    my $symlink_exists = eval { symlink("",""); 1 };
 
Portability issues: L<perlport/symlink>.
 
=item syscall NUMBER, LIST
X<syscall> X<system call>
 
=for Pod::Functions execute an arbitrary system call
 
Calls the system call specified as the first element of the list,
passing the remaining elements as arguments to the system call.  If
unimplemented, raises an exception.  The arguments are interpreted
as follows: if a given argument is numeric, the argument is passed as
an int.  If not, the pointer to the string value is passed.  You are
responsible to make sure a string is pre-extended long enough to
receive any result that might be written into a string.  You can't use a
string literal (or other read-only string) as an argument to
L<C<syscall>|/syscall NUMBER, LIST> because Perl has to assume that any
string pointer might be written through.  If your
integer arguments are not literals and have never been interpreted in a
numeric context, you may need to add C<0> to them to force them to look
like numbers.  This emulates the
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET> function (or
vice versa):
 
    require 'syscall.ph';        # may need to run h2ph
    my $s = "hi there\n";
    syscall(SYS_write(), fileno(STDOUT), $s, length $s);
 
Note that Perl supports passing of up to only 14 arguments to your syscall,
which in practice should (usually) suffice.
 
Syscall returns whatever value returned by the system call it calls.
If the system call fails, L<C<syscall>|/syscall NUMBER, LIST> returns
C<-1> and sets L<C<$!>|perlvar/$!> (errno).
Note that some system calls I<can> legitimately return C<-1>.  The proper
way to handle such calls is to assign C<$! = 0> before the call, then
check the value of L<C<$!>|perlvar/$!> if
L<C<syscall>|/syscall NUMBER, LIST> returns C<-1>.
 
There's a problem with C<syscall(SYS_pipe())>: it returns the file
number of the read end of the pipe it creates, but there is no way
to retrieve the file number of the other end.  You can avoid this
problem by using L<C<pipe>|/pipe READHANDLE,WRITEHANDLE> instead.
 
Portability issues: L<perlport/syscall>.
 
=item sysopen FILEHANDLE,FILENAME,MODE
X<sysopen>
 
=item sysopen FILEHANDLE,FILENAME,MODE,PERMS
 
=for Pod::Functions +5.002 open a file, pipe, or descriptor
 
Opens the file whose filename is given by FILENAME, and associates it with
FILEHANDLE.  If FILEHANDLE is an expression, its value is used as the real
filehandle wanted; an undefined scalar will be suitably autovivified.  This
function calls the underlying operating system's L<open(2)> function with the
parameters FILENAME, MODE, and PERMS.
 
Returns true on success and L<C<undef>|/undef EXPR> otherwise.
 
L<PerlIO> layers will be applied to the handle the same way they would in an
L<C<open>|/open FILEHANDLE,MODE,EXPR> call that does not specify layers. That is,
the current value of L<C<${^OPEN}>|perlvar/${^OPEN}> as set by the L<open>
pragma in a lexical scope, or the C<-C> commandline option or C<PERL_UNICODE>
environment variable in the main program scope, falling back to the platform
defaults as described in L<PerlIO/Defaults and how to override them>. If you
want to remove any layers that may transform the byte stream, use
L<C<binmode>|/binmode FILEHANDLE, LAYER> after opening it.
 
The possible values and flag bits of the MODE parameter are
system-dependent; they are available via the standard module
L<C<Fcntl>|Fcntl>.  See the documentation of your operating system's
L<open(2)> syscall to see
which values and flag bits are available.  You may combine several flags
using the C<|>-operator.
 
Some of the most common values are C<O_RDONLY> for opening the file in
read-only mode, C<O_WRONLY> for opening the file in write-only mode,
and C<O_RDWR> for opening the file in read-write mode.
X<O_RDONLY> X<O_RDWR> X<O_WRONLY>
 
For historical reasons, some values work on almost every system
supported by Perl: 0 means read-only, 1 means write-only, and 2
means read/write.  We know that these values do I<not> work under
OS/390 and on the Macintosh; you probably don't want to
use them in new code.
 
If the file named by FILENAME does not exist and the
L<C<open>|/open FILEHANDLE,MODE,EXPR> call creates
it (typically because MODE includes the C<O_CREAT> flag), then the value of
PERMS specifies the permissions of the newly created file.  If you omit
the PERMS argument to L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE>,
Perl uses the octal value C<0666>.
These permission values need to be in octal, and are modified by your
process's current L<C<umask>|/umask EXPR>.
X<O_CREAT>
 
In many systems the C<O_EXCL> flag is available for opening files in
exclusive mode.  This is B<not> locking: exclusiveness means here that
if the file already exists,
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> fails.  C<O_EXCL> may
not work
on network filesystems, and has no effect unless the C<O_CREAT> flag
is set as well.  Setting C<O_CREAT|O_EXCL> prevents the file from
being opened if it is a symbolic link.  It does not protect against
symbolic links in the file's path.
X<O_EXCL>
 
Sometimes you may want to truncate an already-existing file.  This
can be done using the C<O_TRUNC> flag.  The behavior of
C<O_TRUNC> with C<O_RDONLY> is undefined.
X<O_TRUNC>
 
You should seldom if ever use C<0644> as argument to
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE>, because
that takes away the user's option to have a more permissive umask.
Better to omit it.  See L<C<umask>|/umask EXPR> for more on this.
 
This function has no direct relation to the usage of
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET>,
or L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>.  A handle opened with
this function can be used with buffered IO just as one opened with
L<C<open>|/open FILEHANDLE,MODE,EXPR> can be used with unbuffered IO.
 
Note that under Perls older than 5.8.0,
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> depends on the
L<fdopen(3)> C library function.  On many Unix systems, L<fdopen(3)> is known
to fail when file descriptors exceed a certain value, typically 255.  If
you need more file descriptors than that, consider using the
L<C<POSIX::open>|POSIX/C<open>> function.  For Perls 5.8.0 and later,
PerlIO is (most often) the default.
 
See L<perlopentut> for a kinder, gentler explanation of opening files.
 
Portability issues: L<perlport/sysopen>.
 
=item sysread FILEHANDLE,SCALAR,LENGTH,OFFSET
X<sysread>
 
=item sysread FILEHANDLE,SCALAR,LENGTH
 
=for Pod::Functions fixed-length unbuffered input from a filehandle
 
Attempts to read LENGTH bytes of data into variable SCALAR from the
specified FILEHANDLE, using L<read(2)>.  It bypasses any L<PerlIO> layers
including buffered IO (but is affected by the presence of the C<:utf8>
layer as described later), so mixing this with other kinds of reads,
L<C<print>|/print FILEHANDLE LIST>, L<C<write>|/write FILEHANDLE>,
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, or L<C<eof>|/eof FILEHANDLE> can cause
confusion because the
C<:perlio> or C<:crlf> layers usually buffer data.  Returns the number of
bytes actually read, C<0> at end of file, or undef if there was an
error (in the latter case L<C<$!>|perlvar/$!> is also set).  SCALAR will
be grown or
shrunk so that the last byte actually read is the last byte of the
scalar after the read.
 
An OFFSET may be specified to place the read data at some place in the
string other than the beginning.  A negative OFFSET specifies
placement at that many characters counting backwards from the end of
the string.  A positive OFFSET greater than the length of SCALAR
results in the string being padded to the required size with C<"\0">
bytes before the result of the read is appended.
 
There is no syseof() function, which is ok, since
L<C<eof>|/eof FILEHANDLE> doesn't work well on device files (like ttys)
anyway.  Use L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET> and
check for a return value of 0 to decide whether you're done.
 
Note that if the filehandle has been marked as C<:utf8>, C<sysread> will
throw an exception.  The C<:encoding(...)> layer implicitly
introduces the C<:utf8> layer.  See
L<C<binmode>|/binmode FILEHANDLE, LAYER>,
L<C<open>|/open FILEHANDLE,MODE,EXPR>, and the L<open> pragma.
 
=item sysseek FILEHANDLE,POSITION,WHENCE
X<sysseek> X<lseek>
 
=for Pod::Functions +5.004 position I/O pointer on handle used with sysread and syswrite
 
Sets FILEHANDLE's system position I<in bytes> using L<lseek(2)>.  FILEHANDLE may
be an expression whose value gives the name of the filehandle.  The values
for WHENCE are C<0> to set the new position to POSITION; C<1> to set it
to the current position plus POSITION; and C<2> to set it to EOF plus
POSITION, typically negative.
 
Note the emphasis on bytes: even if the filehandle has been set to operate
on characters (for example using the C<:encoding(UTF-8)> I/O layer), the
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, and
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>
family of functions use byte offsets, not character offsets,
because seeking to a character offset would be very slow in a UTF-8 file.
 
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE> bypasses normal
buffered IO, so mixing it with reads other than
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET> (for example
L<C<readline>|/readline EXPR> or
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET>),
L<C<print>|/print FILEHANDLE LIST>, L<C<write>|/write FILEHANDLE>,
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, or L<C<eof>|/eof FILEHANDLE> may cause
confusion.
 
For WHENCE, you may also use the constants C<SEEK_SET>, C<SEEK_CUR>,
and C<SEEK_END> (start of the file, current position, end of the file)
from the L<Fcntl> module.  Use of the constants is also more portable
than relying on 0, 1, and 2.  For example to define a "systell" function:
 
    use Fcntl 'SEEK_CUR';
    sub systell { sysseek($_[0], 0, SEEK_CUR) }
 
Returns the new position, or the undefined value on failure.  A position
of zero is returned as the string C<"0 but true">; thus
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE> returns
true on success and false on failure, yet you can still easily determine
the new position.
 
=item system LIST
X<system> X<shell>
 
=item system PROGRAM LIST
 
=for Pod::Functions run a separate program
 
Does exactly the same thing as L<C<exec>|/exec LIST>, except that a fork is
done first and the parent process waits for the child process to
exit.  Note that argument processing varies depending on the
number of arguments.  If there is more than one argument in LIST,
or if LIST is an array with more than one value, starts the program
given by the first element of the list with arguments given by the
rest of the list.  If there is only one scalar argument, the argument
is checked for shell metacharacters, and if there are any, the
entire argument is passed to the system's command shell for parsing
(this is C</bin/sh -c> on Unix platforms, but varies on other
platforms).  If there are no shell metacharacters in the argument,
it is split into words and passed directly to C<execvp>, which is
more efficient.  On Windows, only the C<system PROGRAM LIST> syntax will
reliably avoid using the shell; C<system LIST>, even with more than one
element, will fall back to the shell if the first spawn fails.
 
Perl will attempt to flush all files opened for
output before any operation that may do a fork, but this may not be
supported on some platforms (see L<perlport>).  To be safe, you may need
to set L<C<$E<verbar>>|perlvar/$E<verbar>> (C<$AUTOFLUSH> in L<English>)
or call the C<autoflush> method of L<C<IO::Handle>|IO::Handle/METHODS>
on any open handles.
 
The return value is the exit status of the program as returned by the
L<C<wait>|/wait> call.  To get the actual exit value, shift right by
eight (see below).  See also L<C<exec>|/exec LIST>.  This is I<not> what
you want to use to capture the output from a command; for that you
should use merely backticks or
L<C<qxE<sol>E<sol>>|/qxE<sol>STRINGE<sol>>, as described in
L<perlop/"`STRING`">.  Return value of -1 indicates a failure to start
the program or an error of the L<wait(2)> system call (inspect
L<C<$!>|perlvar/$!> for the reason).
 
If you'd like to make L<C<system>|/system LIST> (and many other bits of
Perl) die on error, have a look at the L<autodie> pragma.
 
Like L<C<exec>|/exec LIST>, L<C<system>|/system LIST> allows you to lie
to a program about its name if you use the C<system PROGRAM LIST>
syntax.  Again, see L<C<exec>|/exec LIST>.
 
Since C<SIGINT> and C<SIGQUIT> are ignored during the execution of
L<C<system>|/system LIST>, if you expect your program to terminate on
receipt of these signals you will need to arrange to do so yourself
based on the return value.
 
    my @args = ("command", "arg1", "arg2");
    system(@args) == 0
        or die "system @args failed: $?";
 
If you'd like to manually inspect L<C<system>|/system LIST>'s failure,
you can check all possible failure modes by inspecting
L<C<$?>|perlvar/$?> like this:
 
    if ($? == -1) {
        print "failed to execute: $!\n";
    }
    elsif ($? & 127) {
        printf "child died with signal %d, %s coredump\n",
            ($? & 127),  ($? & 128) ? 'with' : 'without';
    }
    else {
        printf "child exited with value %d\n", $? >> 8;
    }
 
Alternatively, you may inspect the value of
L<C<${^CHILD_ERROR_NATIVE}>|perlvar/${^CHILD_ERROR_NATIVE}> with the
L<C<W*()>|POSIX/C<WIFEXITED>> calls from the L<POSIX> module.
 
When L<C<system>|/system LIST>'s arguments are executed indirectly by
the shell, results and return codes are subject to its quirks.
See L<perlop/"`STRING`"> and L<C<exec>|/exec LIST> for details.
 
Since L<C<system>|/system LIST> does a L<C<fork>|/fork> and
L<C<wait>|/wait> it may affect a C<SIGCHLD> handler.  See L<perlipc> for
details.
 
Portability issues: L<perlport/system>.
 
=item syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET
X<syswrite>
 
=item syswrite FILEHANDLE,SCALAR,LENGTH
 
=item syswrite FILEHANDLE,SCALAR
 
=for Pod::Functions fixed-length unbuffered output to a filehandle
 
Attempts to write LENGTH bytes of data from variable SCALAR to the
specified FILEHANDLE, using L<write(2)>.  If LENGTH is
not specified, writes whole SCALAR.  It bypasses any L<PerlIO> layers
including buffered IO (but is affected by the presence of the C<:utf8>
layer as described later), so
mixing this with reads (other than C<sysread)>),
L<C<print>|/print FILEHANDLE LIST>, L<C<write>|/write FILEHANDLE>,
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, or L<C<eof>|/eof FILEHANDLE> may cause
confusion because the C<:perlio> and C<:crlf> layers usually buffer data.
Returns the number of bytes actually written, or L<C<undef>|/undef EXPR>
if there was an error (in this case the errno variable
L<C<$!>|perlvar/$!> is also set).  If the LENGTH is greater than the
data available in the SCALAR after the OFFSET, only as much data as is
available will be written.
 
An OFFSET may be specified to write the data from some part of the
string other than the beginning.  A negative OFFSET specifies writing
that many characters counting backwards from the end of the string.
If SCALAR is of length zero, you can only use an OFFSET of 0.
 
B<WARNING>: If the filehandle is marked C<:utf8>, C<syswrite> will raise an exception.
The C<:encoding(...)> layer implicitly introduces the C<:utf8> layer.
Alternately, if the handle is not marked with an encoding but you
attempt to write characters with code points over 255, raises an exception.
See L<C<binmode>|/binmode FILEHANDLE, LAYER>,
L<C<open>|/open FILEHANDLE,MODE,EXPR>, and the L<open> pragma.
 
=item tell FILEHANDLE
X<tell>
 
=item tell
 
=for Pod::Functions get current seekpointer on a filehandle
 
Returns the current position I<in bytes> for FILEHANDLE, or -1 on
error.  FILEHANDLE may be an expression whose value gives the name of
the actual filehandle.  If FILEHANDLE is omitted, assumes the file
last read.
 
Note the emphasis on bytes: even if the filehandle has been set to operate
on characters (for example using the C<:encoding(UTF-8)> I/O layer), the
L<C<seek>|/seek FILEHANDLE,POSITION,WHENCE>,
L<C<tell>|/tell FILEHANDLE>, and
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>
family of functions use byte offsets, not character offsets,
because seeking to a character offset would be very slow in a UTF-8 file.
 
The return value of L<C<tell>|/tell FILEHANDLE> for the standard streams
like the STDIN depends on the operating system: it may return -1 or
something else.  L<C<tell>|/tell FILEHANDLE> on pipes, fifos, and
sockets usually returns -1.
 
There is no C<systell> function.  Use
L<C<sysseek($fh, 0, 1)>|/sysseek FILEHANDLE,POSITION,WHENCE> for that.
 
Do not use L<C<tell>|/tell FILEHANDLE> (or other buffered I/O
operations) on a filehandle that has been manipulated by
L<C<sysread>|/sysread FILEHANDLE,SCALAR,LENGTH,OFFSET>,
L<C<syswrite>|/syswrite FILEHANDLE,SCALAR,LENGTH,OFFSET>, or
L<C<sysseek>|/sysseek FILEHANDLE,POSITION,WHENCE>.  Those functions
ignore the buffering, while L<C<tell>|/tell FILEHANDLE> does not.
 
=item telldir DIRHANDLE
X<telldir>
 
=for Pod::Functions get current seekpointer on a directory handle
 
Returns the current position of the L<C<readdir>|/readdir DIRHANDLE>
routines on DIRHANDLE.  Value may be given to
L<C<seekdir>|/seekdir DIRHANDLE,POS> to access a particular location in
a directory.  L<C<telldir>|/telldir DIRHANDLE> has the same caveats
about possible directory compaction as the corresponding system library
routine.
 
=item tie VARIABLE,CLASSNAME,LIST
X<tie>
 
=for Pod::Functions +5.002 bind a variable to an object class
 
This function binds a variable to a package class that will provide the
implementation for the variable.  VARIABLE is the name of the variable
to be enchanted.  CLASSNAME is the name of a class implementing objects
of correct type.  Any additional arguments are passed to the
appropriate constructor
method of the class (meaning C<TIESCALAR>, C<TIEHANDLE>, C<TIEARRAY>,
or C<TIEHASH>).  Typically these are arguments such as might be passed
to the L<dbm_open(3)> function of C.  The object returned by the
constructor is also returned by the
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST> function, which would be useful
if you want to access other methods in CLASSNAME.
 
Note that functions such as L<C<keys>|/keys HASH> and
L<C<values>|/values HASH> may return huge lists when used on large
objects, like DBM files.  You may prefer to use the L<C<each>|/each
HASH> function to iterate over such.  Example:
 
    # print out history file offsets
    use NDBM_File;
    tie(my %HIST, 'NDBM_File', '/usr/lib/news/history', 1, 0);
    while (my ($key,$val) = each %HIST) {
        print $key, ' = ', unpack('L', $val), "\n";
    }
 
A class implementing a hash should have the following methods:
 
    TIEHASH classname, LIST
    FETCH this, key
    STORE this, key, value
    DELETE this, key
    CLEAR this
    EXISTS this, key
    FIRSTKEY this
    NEXTKEY this, lastkey
    SCALAR this
    DESTROY this
    UNTIE this
 
A class implementing an ordinary array should have the following methods:
 
    TIEARRAY classname, LIST
    FETCH this, key
    STORE this, key, value
    FETCHSIZE this
    STORESIZE this, count
    CLEAR this
    PUSH this, LIST
    POP this
    SHIFT this
    UNSHIFT this, LIST
    SPLICE this, offset, length, LIST
    EXTEND this, count
    DELETE this, key
    EXISTS this, key
    DESTROY this
    UNTIE this
 
A class implementing a filehandle should have the following methods:
 
    TIEHANDLE classname, LIST
    READ this, scalar, length, offset
    READLINE this
    GETC this
    WRITE this, scalar, length, offset
    PRINT this, LIST
    PRINTF this, format, LIST
    BINMODE this
    EOF this
    FILENO this
    SEEK this, position, whence
    TELL this
    OPEN this, mode, LIST
    CLOSE this
    DESTROY this
    UNTIE this
 
A class implementing a scalar should have the following methods:
 
    TIESCALAR classname, LIST
    FETCH this,
    STORE this, value
    DESTROY this
    UNTIE this
 
Not all methods indicated above need be implemented.  See L<perltie>,
L<Tie::Hash>, L<Tie::Array>, L<Tie::Scalar>, and L<Tie::Handle>.
 
Unlike L<C<dbmopen>|/dbmopen HASH,DBNAME,MASK>, the
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST> function will not
L<C<use>|/use Module VERSION LIST> or L<C<require>|/require VERSION> a
module for you; you need to do that explicitly yourself.  See L<DB_File>
or the L<Config> module for interesting
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST> implementations.
 
For further details see L<perltie>, L<C<tied>|/tied VARIABLE>.
 
=item tied VARIABLE
X<tied>
 
=for Pod::Functions get a reference to the object underlying a tied variable
 
Returns a reference to the object underlying VARIABLE (the same value
that was originally returned by the
L<C<tie>|/tie VARIABLE,CLASSNAME,LIST> call that bound the variable
to a package.)  Returns the undefined value if VARIABLE isn't tied to a
package.
 
=item time
X<time> X<epoch>
 
=for Pod::Functions return number of seconds since 1970
 
Returns the number of non-leap seconds since whatever time the system
considers to be the epoch, suitable for feeding to
L<C<gmtime>|/gmtime EXPR> and L<C<localtime>|/localtime EXPR>.  On most
systems the epoch is 00:00:00 UTC, January 1, 1970;
a prominent exception being Mac OS Classic which uses 00:00:00, January 1,
1904 in the current local time zone for its epoch.
 
For measuring time in better granularity than one second, use the
L<Time::HiRes> module from Perl 5.8 onwards (or from CPAN before then), or,
if you have L<gettimeofday(2)>, you may be able to use the
L<C<syscall>|/syscall NUMBER, LIST> interface of Perl.  See L<perlfaq8>
for details.
 
For date and time processing look at the many related modules on CPAN.
For a comprehensive date and time representation look at the
L<DateTime> module.
 
=item times
X<times>
 
=for Pod::Functions return elapsed time for self and child processes
 
Returns a four-element list giving the user and system times in
seconds for this process and any exited children of this process.
 
    my ($user,$system,$cuser,$csystem) = times;
 
In scalar context, L<C<times>|/times> returns C<$user>.
 
Children's times are only included for terminated children.
 
Portability issues: L<perlport/times>.
 
=item tr///
 
=for Pod::Functions transliterate a string
 
The transliteration operator.  Same as
L<C<yE<sol>E<sol>E<sol>>|/yE<sol>E<sol>E<sol>>.  See
L<perlop/"Quote-Like Operators">.
 
=item truncate FILEHANDLE,LENGTH
X<truncate>
 
=item truncate EXPR,LENGTH
 
=for Pod::Functions shorten a file
 
Truncates the file opened on FILEHANDLE, or named by EXPR, to the
specified length.  Raises an exception if truncate isn't implemented
on your system.  Returns true if successful, L<C<undef>|/undef EXPR> on
error.
 
The behavior is undefined if LENGTH is greater than the length of the
file.
 
The position in the file of FILEHANDLE is left unchanged.  You may want to
call L<seek|/"seek FILEHANDLE,POSITION,WHENCE"> before writing to the
file.
 
Portability issues: L<perlport/truncate>.
 
=item uc EXPR
X<uc> X<uppercase> X<toupper>
 
=item uc
 
=for Pod::Functions return upper-case version of a string
 
Returns an uppercased version of EXPR.  This is the internal function
implementing the C<\U> escape in double-quoted strings.
It does not attempt to do titlecase mapping on initial letters.  See
L<C<ucfirst>|/ucfirst EXPR> for that.
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
This function behaves the same way under various pragmas, such as in a locale,
as L<C<lc>|/lc EXPR> does.
 
=item ucfirst EXPR
X<ucfirst> X<uppercase>
 
=item ucfirst
 
=for Pod::Functions return a string with just the next letter in upper case
 
Returns the value of EXPR with the first character in uppercase
(titlecase in Unicode).  This is the internal function implementing
the C<\u> escape in double-quoted strings.
 
If EXPR is omitted, uses L<C<$_>|perlvar/$_>.
 
This function behaves the same way under various pragmas, such as in a locale,
as L<C<lc>|/lc EXPR> does.
 
=item umask EXPR
X<umask>
 
=item umask
 
=for Pod::Functions set file creation mode mask
 
Sets the umask for the process to EXPR and returns the previous value.
If EXPR is omitted, merely returns the current umask.
 
The Unix permission C<rwxr-x---> is represented as three sets of three
bits, or three octal digits: C<0750> (the leading 0 indicates octal
and isn't one of the digits).  The L<C<umask>|/umask EXPR> value is such
a number representing disabled permissions bits.  The permission (or
"mode") values you pass L<C<mkdir>|/mkdir FILENAME,MODE> or
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> are modified by your
umask, so even if you tell
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> to create a file with
permissions C<0777>, if your umask is C<0022>, then the file will
actually be created with permissions C<0755>.  If your
L<C<umask>|/umask EXPR> were C<0027> (group can't write; others can't
read, write, or execute), then passing
L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE> C<0666> would create a
file with mode C<0640> (because C<0666 &~ 027> is C<0640>).
 
Here's some advice: supply a creation mode of C<0666> for regular
files (in L<C<sysopen>|/sysopen FILEHANDLE,FILENAME,MODE>) and one of
C<0777> for directories (in L<C<mkdir>|/mkdir FILENAME,MODE>) and
executable files.  This gives users the freedom of
choice: if they want protected files, they might choose process umasks
of C<022>, C<027>, or even the particularly antisocial mask of C<077>.
Programs should rarely if ever make policy decisions better left to
the user.  The exception to this is when writing files that should be
kept private: mail files, web browser cookies, F<.rhosts> files, and
so on.
 
If L<umask(2)> is not implemented on your system and you are trying to
restrict access for I<yourself> (i.e., C<< (EXPR & 0700) > 0 >>),
raises an exception.  If L<umask(2)> is not implemented and you are
not trying to restrict access for yourself, returns
L<C<undef>|/undef EXPR>.
 
Remember that a umask is a number, usually given in octal; it is I<not> a
string of octal digits.  See also L<C<oct>|/oct EXPR>, if all you have
is a string.
 
Portability issues: L<perlport/umask>.
 
=item undef EXPR
X<undef> X<undefine>
 
=item undef
 
=for Pod::Functions remove a variable or function definition
 
Undefines the value of EXPR, which must be an lvalue.  Use only on a
scalar value, an array (using C<@>), a hash (using C<%>), a subroutine
(using C<&>), or a typeglob (using C<*>).  Saying C<undef $hash{$key}>
will probably not do what you expect on most predefined variables or
DBM list values, so don't do that; see L<C<delete>|/delete EXPR>.
Always returns the undefined value.
You can omit the EXPR, in which case nothing is
undefined, but you still get an undefined value that you could, for
instance, return from a subroutine, assign to a variable, or pass as a
parameter.  Examples:
 
    undef $foo;
    undef $bar{'blurfl'};      # Compare to: delete $bar{'blurfl'};
    undef @ary;
    undef %hash;
    undef &mysub;
    undef *xyz;       # destroys $xyz, @xyz, %xyz, &xyz, etc.
    return (wantarray ? (undef, $errmsg) : undef) if $they_blew_it;
    select undef, undef, undef, 0.25;
    my ($x, $y, undef, $z) = foo();    # Ignore third value returned
 
Note that this is a unary operator, not a list operator.
 
=item unlink LIST
X<unlink> X<delete> X<remove> X<rm> X<del>
 
=item unlink
 
=for Pod::Functions remove one link to a file
 
Deletes a list of files.  On success, it returns the number of files
it successfully deleted.  On failure, it returns false and sets
L<C<$!>|perlvar/$!> (errno):
 
    my $unlinked = unlink 'a', 'b', 'c';
    unlink @goners;
    unlink glob "*.bak";
 
On error, L<C<unlink>|/unlink LIST> will not tell you which files it
could not remove.
If you want to know which files you could not remove, try them one
at a time:
 
     foreach my $file ( @goners ) {
         unlink $file or warn "Could not unlink $file: $!";
     }
 
Note: L<C<unlink>|/unlink LIST> will not attempt to delete directories
unless you are
superuser and the B<-U> flag is supplied to Perl.  Even if these
conditions are met, be warned that unlinking a directory can inflict
damage on your filesystem.  Finally, using L<C<unlink>|/unlink LIST> on
directories is not supported on many operating systems.  Use
L<C<rmdir>|/rmdir FILENAME> instead.
 
If LIST is omitted, L<C<unlink>|/unlink LIST> uses L<C<$_>|perlvar/$_>.
 
=item unpack TEMPLATE,EXPR
X<unpack>
 
=item unpack TEMPLATE
 
=for Pod::Functions convert binary structure into normal perl variables
 
L<C<unpack>|/unpack TEMPLATE,EXPR> does the reverse of
L<C<pack>|/pack TEMPLATE,LIST>: it takes a string
and expands it out into a list of values.
(In scalar context, it returns merely the first value produced.)
 
If EXPR is omitted, unpacks the L<C<$_>|perlvar/$_> string.
See L<perlpacktut> for an introduction to this function.
 
The string is broken into chunks described by the TEMPLATE.  Each chunk
is converted separately to a value.  Typically, either the string is a result
of L<C<pack>|/pack TEMPLATE,LIST>, or the characters of the string
represent a C structure of some kind.
 
The TEMPLATE has the same format as in the
L<C<pack>|/pack TEMPLATE,LIST> function.
Here's a subroutine that does substring:
 
    sub substr {
        my ($what, $where, $howmuch) = @_;
        unpack("x$where a$howmuch", $what);
    }
 
and then there's
 
    sub ordinal { unpack("W",$_[0]); } # same as ord()
 
In addition to fields allowed in L<C<pack>|/pack TEMPLATE,LIST>, you may
prefix a field with a %<number> to indicate that
you want a <number>-bit checksum of the items instead of the items
themselves.  Default is a 16-bit checksum.  The checksum is calculated by
summing numeric values of expanded values (for string fields the sum of
C<ord($char)> is taken; for bit fields the sum of zeroes and ones).
 
For example, the following
computes the same number as the System V sum program:
 
    my $checksum = do {
        local $/;  # slurp!
        unpack("%32W*", readline) % 65535;
    };
 
The following efficiently counts the number of set bits in a bit vector:
 
    my $setbits = unpack("%32b*", $selectmask);
 
The C<p> and C<P> formats should be used with care.  Since Perl
has no way of checking whether the value passed to
L<C<unpack>|/unpack TEMPLATE,EXPR>
corresponds to a valid memory location, passing a pointer value that's
not known to be valid is likely to have disastrous consequences.
 
If there are more pack codes or if the repeat count of a field or a group
is larger than what the remainder of the input string allows, the result
is not well defined: the repeat count may be decreased, or
L<C<unpack>|/unpack TEMPLATE,EXPR> may produce empty strings or zeros,
or it may raise an exception.
If the input string is longer than one described by the TEMPLATE,
the remainder of that input string is ignored.
 
See L<C<pack>|/pack TEMPLATE,LIST> for more examples and notes.
 
=item unshift ARRAY,LIST
X<unshift>
 
=for Pod::Functions prepend more elements to the beginning of a list
 
Does the opposite of a L<C<shift>|/shift ARRAY>.  Or the opposite of a
L<C<push>|/push ARRAY,LIST>,
depending on how you look at it.  Prepends list to the front of the
array and returns the new number of elements in the array.
 
    unshift(@ARGV, '-e') unless $ARGV[0] =~ /^-/;
 
Note the LIST is prepended whole, not one element at a time, so the
prepended elements stay in the same order.  Use
L<C<reverse>|/reverse LIST> to do the reverse.
 
Starting with Perl 5.14, an experimental feature allowed
L<C<unshift>|/unshift ARRAY,LIST> to take
a scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
=item untie VARIABLE
X<untie>
 
=for Pod::Functions break a tie binding to a variable
 
Breaks the binding between a variable and a package.
(See L<tie|/tie VARIABLE,CLASSNAME,LIST>.)
Has no effect if the variable is not tied.
 
=item use Module VERSION LIST
X<use> X<module> X<import>
 
=item use Module VERSION
 
=item use Module LIST
 
=item use Module
 
=item use VERSION
 
=for Pod::Functions load in a module at compile time and import its namespace
 
Imports some semantics into the current package from the named module,
generally by aliasing certain subroutine or variable names into your
package.  It is exactly equivalent to
 
    BEGIN { require Module; Module->import( LIST ); }
 
except that Module I<must> be a bareword.
The importation can be made conditional by using the L<if> module.
 
In the C<use VERSION> form, VERSION may be either a v-string such as
v5.24.1, which will be compared to L<C<$^V>|perlvar/$^V> (aka
$PERL_VERSION), or a numeric argument of the form 5.024001, which will
be compared to L<C<$]>|perlvar/$]>.  An exception is raised if VERSION
is greater than the version of the current Perl interpreter; Perl will
not attempt to parse the rest of the file.  Compare with
L<C<require>|/require VERSION>, which can do a similar check at run
time.  Symmetrically, C<no VERSION> allows you to specify that you
want a version of Perl older than the specified one.
 
Specifying VERSION as a numeric argument of the form 5.024001 should
generally be avoided as older less readable syntax compared to
v5.24.1. Before perl 5.8.0 released in 2002 the more verbose numeric
form was the only supported syntax, which is why you might see it in
 
    use v5.24.1;    # compile time version check
    use 5.24.1;     # ditto
    use 5.024_001;  # ditto; older syntax compatible with perl 5.6
 
This is often useful if you need to check the current Perl version before
L<C<use>|/use Module VERSION LIST>ing library modules that won't work
with older versions of Perl.
(We try not to do this more than we have to.)
 
C<use VERSION> also lexically enables all features available in the requested
version as defined by the L<feature> pragma, disabling any features
not in the requested version's feature bundle.  See L<feature>.
Similarly, if the specified Perl version is greater than or equal to
5.12.0, strictures are enabled lexically as
with L<C<use strict>|strict>.  Any explicit use of
C<use strict> or C<no strict> overrides C<use VERSION>, even if it comes
before it.  Later use of C<use VERSION>
will override all behavior of a previous
C<use VERSION>, possibly removing the C<strict> and C<feature> added by
C<use VERSION>.  C<use VERSION> does not
load the F<feature.pm> or F<strict.pm>
files.
 
The C<BEGIN> forces the L<C<require>|/require VERSION> and
L<C<import>|/import LIST> to happen at compile time.  The
L<C<require>|/require VERSION> makes sure the module is loaded into
memory if it hasn't been yet.  The L<C<import>|/import LIST> is not a
builtin; it's just an ordinary static method
call into the C<Module> package to tell the module to import the list of
features back into the current package.  The module can implement its
L<C<import>|/import LIST> method any way it likes, though most modules
just choose to derive their L<C<import>|/import LIST> method via
inheritance from the C<Exporter> class that is defined in the
L<C<Exporter>|Exporter> module.  See L<Exporter>.  If no
L<C<import>|/import LIST> method can be found, then the call is skipped,
even if there is an AUTOLOAD method.
 
If you do not want to call the package's L<C<import>|/import LIST>
method (for instance,
to stop your namespace from being altered), explicitly supply the empty list:
 
    use Module ();
 
That is exactly equivalent to
 
    BEGIN { require Module }
 
If the VERSION argument is present between Module and LIST, then the
L<C<use>|/use Module VERSION LIST> will call the C<VERSION> method in
class Module with the given version as an argument:
 
    use Module 12.34;
 
is equivalent to:
 
    BEGIN { require Module; Module->VERSION(12.34) }
 
The L<default C<VERSION> method|UNIVERSAL/C<VERSION ( [ REQUIRE ] )>>,
inherited from the L<C<UNIVERSAL>|UNIVERSAL> class, croaks if the given
version is larger than the value of the variable C<$Module::VERSION>.
 
The VERSION argument cannot be an arbitrary expression.  It only counts
as a VERSION argument if it is a version number literal, starting with
either a digit or C<v> followed by a digit.  Anything that doesn't
look like a version literal will be parsed as the start of the LIST.
Nevertheless, many attempts to use an arbitrary expression as a VERSION
argument will appear to work, because L<Exporter>'s C<import> method
handles numeric arguments specially, performing version checks rather
than treating them as things to export.
 
Again, there is a distinction between omitting LIST (L<C<import>|/import
LIST> called with no arguments) and an explicit empty LIST C<()>
(L<C<import>|/import LIST> not called).  Note that there is no comma
after VERSION!
 
Because this is a wide-open interface, pragmas (compiler directives)
are also implemented this way.  Some of the currently implemented
pragmas are:
 
    use constant;
    use diagnostics;
    use integer;
    use sigtrap  qw(SEGV BUS);
    use strict   qw(subs vars refs);
    use subs     qw(afunc blurfl);
    use warnings qw(all);
    use sort     qw(stable);
 
Some of these pseudo-modules import semantics into the current
block scope (like L<C<strict>|strict> or L<C<integer>|integer>, unlike
ordinary modules, which import symbols into the current package (which
are effective through the end of the file).
 
Because L<C<use>|/use Module VERSION LIST> takes effect at compile time,
it doesn't respect the ordinary flow control of the code being compiled.
In particular, putting a L<C<use>|/use Module VERSION LIST> inside the
false branch of a conditional doesn't prevent it
from being processed.  If a module or pragma only needs to be loaded
conditionally, this can be done using the L<if> pragma:
 
    use if $] < 5.008, "utf8";
    use if WANT_WARNINGS, warnings => qw(all);
 
There's a corresponding L<C<no>|/no MODULE VERSION LIST> declaration
that unimports meanings imported by L<C<use>|/use Module VERSION LIST>,
i.e., it calls C<< Module->unimport(LIST) >> instead of
L<C<import>|/import LIST>.  It behaves just as L<C<import>|/import LIST>
does with VERSION, an omitted or empty LIST,
or no unimport method being found.
 
    no integer;
    no strict 'refs';
    no warnings;
 
Care should be taken when using the C<no VERSION> form of L<C<no>|/no
MODULE VERSION LIST>.  It is
I<only> meant to be used to assert that the running Perl is of a earlier
version than its argument and I<not> to undo the feature-enabling side effects
of C<use VERSION>.
 
See L<perlmodlib> for a list of standard modules and pragmas.  See
L<perlrun|perlrun/-m[-]module> for the C<-M> and C<-m> command-line
options to Perl that give L<C<use>|/use Module VERSION LIST>
functionality from the command-line.
 
=item utime LIST
X<utime>
 
=for Pod::Functions set a file's last access and modify times
 
Changes the access and modification times on each file of a list of
files.  The first two elements of the list must be the NUMERIC access
and modification times, in that order.  Returns the number of files
successfully changed.  The inode change time of each file is set
to the current time.  For example, this code has the same effect as the
Unix L<touch(1)> command when the files I<already exist> and belong to
the user running the program:
 
    #!/usr/bin/perl
    my $atime = my $mtime = time;
    utime $atime, $mtime, @ARGV;
 
Since Perl 5.8.0, if the first two elements of the list are
L<C<undef>|/undef EXPR>,
the L<utime(2)> syscall from your C library is called with a null second
argument.  On most systems, this will set the file's access and
modification times to the current time (i.e., equivalent to the example
above) and will work even on files you don't own provided you have write
permission:
 
    for my $file (@ARGV) {
        utime(undef, undef, $file)
            || warn "Couldn't touch $file: $!";
    }
 
Under NFS this will use the time of the NFS server, not the time of
the local machine.  If there is a time synchronization problem, the
NFS server and local machine will have different times.  The Unix
L<touch(1)> command will in fact normally use this form instead of the
one shown in the first example.
 
Passing only one of the first two elements as L<C<undef>|/undef EXPR> is
equivalent to passing a 0 and will not have the effect described when
both are L<C<undef>|/undef EXPR>.  This also triggers an
uninitialized warning.
 
On systems that support L<futimes(2)>, you may pass filehandles among the
files.  On systems that don't support L<futimes(2)>, passing filehandles raises
an exception.  Filehandles must be passed as globs or glob references to be
recognized; barewords are considered filenames.
 
Portability issues: L<perlport/utime>.
 
=item values HASH
X<values>
 
=item values ARRAY
 
=for Pod::Functions return a list of the values in a hash
 
In list context, returns a list consisting of all the values of the named
hash.  In Perl 5.12 or later only, will also return a list of the values of
an array; prior to that release, attempting to use an array argument will
produce a syntax error.  In scalar context, returns the number of values.
 
Hash entries are returned in an apparently random order.  The actual random
order is specific to a given hash; the exact same series of operations
on two hashes may result in a different order for each hash.  Any insertion
into the hash may change the order, as will any deletion, with the exception
that the most recent key returned by L<C<each>|/each HASH> or
L<C<keys>|/keys HASH> may be deleted without changing the order.  So
long as a given hash is unmodified you may rely on
L<C<keys>|/keys HASH>, L<C<values>|/values HASH> and
L<C<each>|/each HASH> to repeatedly return the same order
as each other.  See L<perlsec/"Algorithmic Complexity Attacks"> for
details on why hash order is randomized.  Aside from the guarantees
provided here the exact details of Perl's hash algorithm and the hash
traversal order are subject to change in any release of Perl.  Tied hashes
may behave differently to Perl's hashes with respect to changes in order on
insertion and deletion of items.
 
As a side effect, calling L<C<values>|/values HASH> resets the HASH or
ARRAY's internal iterator (see L<C<each>|/each HASH>) before yielding the
values.  In particular,
calling L<C<values>|/values HASH> in void context resets the iterator
with no other overhead.
 
Apart from resetting the iterator,
C<values @array> in list context is the same as plain C<@array>.
(We recommend that you use void context C<keys @array> for this, but
reasoned that taking C<values @array> out would require more
documentation than leaving it in.)
 
Note that the values are not copied, which means modifying them will
modify the contents of the hash:
 
    for (values %hash)      { s/foo/bar/g }  # modifies %hash values
    for (@hash{keys %hash}) { s/foo/bar/g }  # same
 
Starting with Perl 5.14, an experimental feature allowed
L<C<values>|/values HASH> to take a
scalar expression. This experiment has been deemed unsuccessful, and was
removed as of Perl 5.24.
 
To avoid confusing would-be users of your code who are running earlier
versions of Perl with mysterious syntax errors, put this sort of thing at
the top of your file to signal that your code will work I<only> on Perls of
a recent vintage:
 
    use 5.012;  # so keys/values/each work on arrays
 
See also L<C<keys>|/keys HASH>, L<C<each>|/each HASH>, and
L<C<sort>|/sort SUBNAME LIST>.
 
=item vec EXPR,OFFSET,BITS
X<vec> X<bit> X<bit vector>
 
=for Pod::Functions test or set particular bits in a string
 
Treats the string in EXPR as a bit vector made up of elements of
width BITS and returns the value of the element specified by OFFSET
as an unsigned integer.  BITS therefore specifies the number of bits
that are reserved for each element in the bit vector.  This must
be a power of two from 1 to 32 (or 64, if your platform supports
that).
 
If BITS is 8, "elements" coincide with bytes of the input string.
 
If BITS is 16 or more, bytes of the input string are grouped into chunks
of size BITS/8, and each group is converted to a number as with
L<C<pack>|/pack TEMPLATE,LIST>/L<C<unpack>|/unpack TEMPLATE,EXPR> with
big-endian formats C<n>/C<N> (and analogously for BITS==64).  See
L<C<pack>|/pack TEMPLATE,LIST> for details.
 
If bits is 4 or less, the string is broken into bytes, then the bits
of each byte are broken into 8/BITS groups.  Bits of a byte are
numbered in a little-endian-ish way, as in C<0x01>, C<0x02>,
C<0x04>, C<0x08>, C<0x10>, C<0x20>, C<0x40>, C<0x80>.  For example,
breaking the single input byte C<chr(0x36)> into two groups gives a list
C<(0x6, 0x3)>; breaking it into 4 groups gives C<(0x2, 0x1, 0x3, 0x0)>.
 
L<C<vec>|/vec EXPR,OFFSET,BITS> may also be assigned to, in which case
parentheses are needed
to give the expression the correct precedence as in
 
    vec($image, $max_x * $x + $y, 8) = 3;
 
If the selected element is outside the string, the value 0 is returned.
If an element off the end of the string is written to, Perl will first
extend the string with sufficiently many zero bytes.   It is an error
to try to write off the beginning of the string (i.e., negative OFFSET).
 
If the string happens to be encoded as UTF-8 internally (and thus has
the UTF8 flag set), L<C<vec>|/vec EXPR,OFFSET,BITS> tries to convert it
to use a one-byte-per-character internal representation. However, if the
string contains characters with values of 256 or higher, a fatal error
will occur.
 
Strings created with L<C<vec>|/vec EXPR,OFFSET,BITS> can also be
manipulated with the logical
operators C<|>, C<&>, C<^>, and C<~>.  These operators will assume a bit
vector operation is desired when both operands are strings.
See L<perlop/"Bitwise String Operators">.
 
The following code will build up an ASCII string saying C<'PerlPerlPerl'>.
The comments show the string after each step.  Note that this code works
in the same way on big-endian or little-endian machines.
 
    my $foo = '';
    vec($foo,  0, 32) = 0x5065726C; # 'Perl'
 
    # $foo eq "Perl" eq "\x50\x65\x72\x6C", 32 bits
    print vec($foo, 0, 8);  # prints 80 == 0x50 == ord('P')
 
    vec($foo,  2, 16) = 0x5065; # 'PerlPe'
    vec($foo,  3, 16) = 0x726C; # 'PerlPerl'
    vec($foo,  8,  8) = 0x50;   # 'PerlPerlP'
    vec($foo,  9,  8) = 0x65;   # 'PerlPerlPe'
    vec($foo, 20,  4) = 2;      # 'PerlPerlPe'   . "\x02"
    vec($foo, 21,  4) = 7;      # 'PerlPerlPer'
                                   # 'r' is "\x72"
    vec($foo, 45,  2) = 3;      # 'PerlPerlPer'  . "\x0c"
    vec($foo, 93,  1) = 1;      # 'PerlPerlPer'  . "\x2c"
    vec($foo, 94,  1) = 1;      # 'PerlPerlPerl'
                                   # 'l' is "\x6c"
 
To transform a bit vector into a string or list of 0's and 1's, use these:
 
    my $bits = unpack("b*", $vector);
    my @bits = split(//, unpack("b*", $vector));
 
If you know the exact length in bits, it can be used in place of the C<*>.
 
Here is an example to illustrate how the bits actually fall in place:
 
  #!/usr/bin/perl -wl
 
  print <<'EOT';
                                    0         1         2         3
                     unpack("V",$_) 01234567890123456789012345678901
  ------------------------------------------------------------------
  EOT
 
  for $w (0..3) {
      $width = 2**$w;
      for ($shift=0; $shift < $width; ++$shift) {
          for ($off=0; $off < 32/$width; ++$off) {
              $str = pack("B*", "0"x32);
              $bits = (1<<$shift);
              vec($str, $off, $width) = $bits;
              $res = unpack("b*",$str);
              $val = unpack("V", $str);
              write;
          }
      }
  }
 
  format STDOUT =
  vec($_,@#,@#) = @<< == @######### @>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
  $off, $width, $bits, $val, $res
  .
  __END__
 
Regardless of the machine architecture on which it runs, the
example above should print the following table:
 
                                    0         1         2         3
                     unpack("V",$_) 01234567890123456789012345678901
  ------------------------------------------------------------------
  vec($_, 0, 1) = 1   ==          1 10000000000000000000000000000000
  vec($_, 1, 1) = 1   ==          2 01000000000000000000000000000000
  vec($_, 2, 1) = 1   ==          4 00100000000000000000000000000000
  vec($_, 3, 1) = 1   ==          8 00010000000000000000000000000000
  vec($_, 4, 1) = 1   ==         16 00001000000000000000000000000000
  vec($_, 5, 1) = 1   ==         32 00000100000000000000000000000000
  vec($_, 6, 1) = 1   ==         64 00000010000000000000000000000000
  vec($_, 7, 1) = 1   ==        128 00000001000000000000000000000000
  vec($_, 8, 1) = 1   ==        256 00000000100000000000000000000000
  vec($_, 9, 1) = 1   ==        512 00000000010000000000000000000000
  vec($_,10, 1) = 1   ==       1024 00000000001000000000000000000000
  vec($_,11, 1) = 1   ==       2048 00000000000100000000000000000000
  vec($_,12, 1) = 1   ==       4096 00000000000010000000000000000000
  vec($_,13, 1) = 1   ==       8192 00000000000001000000000000000000
  vec($_,14, 1) = 1   ==      16384 00000000000000100000000000000000
  vec($_,15, 1) = 1   ==      32768 00000000000000010000000000000000
  vec($_,16, 1) = 1   ==      65536 00000000000000001000000000000000
  vec($_,17, 1) = 1   ==     131072 00000000000000000100000000000000
  vec($_,18, 1) = 1   ==     262144 00000000000000000010000000000000
  vec($_,19, 1) = 1   ==     524288 00000000000000000001000000000000
  vec($_,20, 1) = 1   ==    1048576 00000000000000000000100000000000
  vec($_,21, 1) = 1   ==    2097152 00000000000000000000010000000000
  vec($_,22, 1) = 1   ==    4194304 00000000000000000000001000000000
  vec($_,23, 1) = 1   ==    8388608 00000000000000000000000100000000
  vec($_,24, 1) = 1   ==   16777216 00000000000000000000000010000000
  vec($_,25, 1) = 1   ==   33554432 00000000000000000000000001000000
  vec($_,26, 1) = 1   ==   67108864 00000000000000000000000000100000
  vec($_,27, 1) = 1   ==  134217728 00000000000000000000000000010000
  vec($_,28, 1) = 1   ==  268435456 00000000000000000000000000001000
  vec($_,29, 1) = 1   ==  536870912 00000000000000000000000000000100
  vec($_,30, 1) = 1   == 1073741824 00000000000000000000000000000010
  vec($_,31, 1) = 1   == 2147483648 00000000000000000000000000000001
  vec($_, 0, 2) = 1   ==          1 10000000000000000000000000000000
  vec($_, 1, 2) = 1   ==          4 00100000000000000000000000000000
  vec($_, 2, 2) = 1   ==         16 00001000000000000000000000000000
  vec($_, 3, 2) = 1   ==         64 00000010000000000000000000000000
  vec($_, 4, 2) = 1   ==        256 00000000100000000000000000000000
  vec($_, 5, 2) = 1   ==       1024 00000000001000000000000000000000
  vec($_, 6, 2) = 1   ==       4096 00000000000010000000000000000000
  vec($_, 7, 2) = 1   ==      16384 00000000000000100000000000000000
  vec($_, 8, 2) = 1   ==      65536 00000000000000001000000000000000
  vec($_, 9, 2) = 1   ==     262144 00000000000000000010000000000000
  vec($_,10, 2) = 1   ==    1048576 00000000000000000000100000000000
  vec($_,11, 2) = 1   ==    4194304 00000000000000000000001000000000
  vec($_,12, 2) = 1   ==   16777216 00000000000000000000000010000000
  vec($_,13, 2) = 1   ==   67108864 00000000000000000000000000100000
  vec($_,14, 2) = 1   ==  268435456 00000000000000000000000000001000
  vec($_,15, 2) = 1   == 1073741824 00000000000000000000000000000010
  vec($_, 0, 2) = 2   ==          2 01000000000000000000000000000000
  vec($_, 1, 2) = 2   ==          8 00010000000000000000000000000000
  vec($_, 2, 2) = 2   ==         32 00000100000000000000000000000000
  vec($_, 3, 2) = 2   ==        128 00000001000000000000000000000000
  vec($_, 4, 2) = 2   ==        512 00000000010000000000000000000000
  vec($_, 5, 2) = 2   ==       2048 00000000000100000000000000000000
  vec($_, 6, 2) = 2   ==       8192 00000000000001000000000000000000
  vec($_, 7, 2) = 2   ==      32768 00000000000000010000000000000000
  vec($_, 8, 2) = 2   ==     131072 00000000000000000100000000000000
  vec($_, 9, 2) = 2   ==     524288 00000000000000000001000000000000
  vec($_,10, 2) = 2   ==    2097152 00000000000000000000010000000000
  vec($_,11, 2) = 2   ==    8388608 00000000000000000000000100000000
  vec($_,12, 2) = 2   ==   33554432 00000000000000000000000001000000
  vec($_,13, 2) = 2   ==  134217728 00000000000000000000000000010000
  vec($_,14, 2) = 2   ==  536870912 00000000000000000000000000000100
  vec($_,15, 2) = 2   == 2147483648 00000000000000000000000000000001
  vec($_, 0, 4) = 1   ==          1 10000000000000000000000000000000
  vec($_, 1, 4) = 1   ==         16 00001000000000000000000000000000
  vec($_, 2, 4) = 1   ==        256 00000000100000000000000000000000
  vec($_, 3, 4) = 1   ==       4096 00000000000010000000000000000000
  vec($_, 4, 4) = 1   ==      65536 00000000000000001000000000000000
  vec($_, 5, 4) = 1   ==    1048576 00000000000000000000100000000000
  vec($_, 6, 4) = 1   ==   16777216 00000000000000000000000010000000
  vec($_, 7, 4) = 1   ==  268435456 00000000000000000000000000001000
  vec($_, 0, 4) = 2   ==          2 01000000000000000000000000000000
  vec($_, 1, 4) = 2   ==         32 00000100000000000000000000000000
  vec($_, 2, 4) = 2   ==        512 00000000010000000000000000000000
  vec($_, 3, 4) = 2   ==       8192 00000000000001000000000000000000
  vec($_, 4, 4) = 2   ==     131072 00000000000000000100000000000000
  vec($_, 5, 4) = 2   ==    2097152 00000000000000000000010000000000
  vec($_, 6, 4) = 2   ==   33554432 00000000000000000000000001000000
  vec($_, 7, 4) = 2   ==  536870912 00000000000000000000000000000100
  vec($_, 0, 4) = 4   ==          4 00100000000000000000000000000000
  vec($_, 1, 4) = 4   ==         64 00000010000000000000000000000000
  vec($_, 2, 4) = 4   ==       1024 00000000001000000000000000000000
  vec($_, 3, 4) = 4   ==      16384 00000000000000100000000000000000
  vec($_, 4, 4) = 4   ==     262144 00000000000000000010000000000000
  vec($_, 5, 4) = 4   ==    4194304 00000000000000000000001000000000
  vec($_, 6, 4) = 4   ==   67108864 00000000000000000000000000100000
  vec($_, 7, 4) = 4   == 1073741824 00000000000000000000000000000010
  vec($_, 0, 4) = 8   ==          8 00010000000000000000000000000000
  vec($_, 1, 4) = 8   ==        128 00000001000000000000000000000000
  vec($_, 2, 4) = 8   ==       2048 00000000000100000000000000000000
  vec($_, 3, 4) = 8   ==      32768 00000000000000010000000000000000
  vec($_, 4, 4) = 8   ==     524288 00000000000000000001000000000000
  vec($_, 5, 4) = 8   ==    8388608 00000000000000000000000100000000
  vec($_, 6, 4) = 8   ==  134217728 00000000000000000000000000010000
  vec($_, 7, 4) = 8   == 2147483648 00000000000000000000000000000001
  vec($_, 0, 8) = 1   ==          1 10000000000000000000000000000000
  vec($_, 1, 8) = 1   ==        256 00000000100000000000000000000000
  vec($_, 2, 8) = 1   ==      65536 00000000000000001000000000000000
  vec($_, 3, 8) = 1   ==   16777216 00000000000000000000000010000000
  vec($_, 0, 8) = 2   ==          2 01000000000000000000000000000000
  vec($_, 1, 8) = 2   ==        512 00000000010000000000000000000000
  vec($_, 2, 8) = 2   ==     131072 00000000000000000100000000000000
  vec($_, 3, 8) = 2   ==   33554432 00000000000000000000000001000000
  vec($_, 0, 8) = 4   ==          4 00100000000000000000000000000000
  vec($_, 1, 8) = 4   ==       1024 00000000001000000000000000000000
  vec($_, 2, 8) = 4   ==     262144 00000000000000000010000000000000
  vec($_, 3, 8) = 4   ==   67108864 00000000000000000000000000100000
  vec($_, 0, 8) = 8   ==          8 00010000000000000000000000000000
  vec($_, 1, 8) = 8   ==       2048 00000000000100000000000000000000
  vec($_, 2, 8) = 8   ==     524288 00000000000000000001000000000000
  vec($_, 3, 8) = 8   ==  134217728 00000000000000000000000000010000
  vec($_, 0, 8) = 16  ==         16 00001000000000000000000000000000
  vec($_, 1, 8) = 16  ==       4096 00000000000010000000000000000000
  vec($_, 2, 8) = 16  ==    1048576 00000000000000000000100000000000
  vec($_, 3, 8) = 16  ==  268435456 00000000000000000000000000001000
  vec($_, 0, 8) = 32  ==         32 00000100000000000000000000000000
  vec($_, 1, 8) = 32  ==       8192 00000000000001000000000000000000
  vec($_, 2, 8) = 32  ==    2097152 00000000000000000000010000000000
  vec($_, 3, 8) = 32  ==  536870912 00000000000000000000000000000100
  vec($_, 0, 8) = 64  ==         64 00000010000000000000000000000000
  vec($_, 1, 8) = 64  ==      16384 00000000000000100000000000000000
  vec($_, 2, 8) = 64  ==    4194304 00000000000000000000001000000000
  vec($_, 3, 8) = 64  == 1073741824 00000000000000000000000000000010
  vec($_, 0, 8) = 128 ==        128 00000001000000000000000000000000
  vec($_, 1, 8) = 128 ==      32768 00000000000000010000000000000000
  vec($_, 2, 8) = 128 ==    8388608 00000000000000000000000100000000
  vec($_, 3, 8) = 128 == 2147483648 00000000000000000000000000000001
 
=item wait
X<wait>
 
=for Pod::Functions wait for any child process to die
 
Behaves like L<wait(2)> on your system: it waits for a child
process to terminate and returns the pid of the deceased process, or
C<-1> if there are no child processes.  The status is returned in
L<C<$?>|perlvar/$?> and
L<C<${^CHILD_ERROR_NATIVE}>|perlvar/${^CHILD_ERROR_NATIVE}>.
Note that a return value of C<-1> could mean that child processes are
being automatically reaped, as described in L<perlipc>.
 
If you use L<C<wait>|/wait> in your handler for
L<C<$SIG{CHLD}>|perlvar/%SIG>, it may accidentally wait for the child
created by L<C<qx>|/qxE<sol>STRINGE<sol>> or L<C<system>|/system LIST>.
See L<perlipc> for details.
 
Portability issues: L<perlport/wait>.
 
=item waitpid PID,FLAGS
X<waitpid>
 
=for Pod::Functions wait for a particular child process to die
 
Waits for a particular child process to terminate and returns the pid of
the deceased process, or C<-1> if there is no such child process.  A
non-blocking wait (with L<WNOHANG|POSIX/C<WNOHANG>> in FLAGS) can return 0 if
there are child processes matching PID but none have terminated yet.
The status is returned in L<C<$?>|perlvar/$?> and
L<C<${^CHILD_ERROR_NATIVE}>|perlvar/${^CHILD_ERROR_NATIVE}>.
 
A PID of C<0> indicates to wait for any child process whose process group ID is
equal to that of the current process.  A PID of less than C<-1> indicates to
wait for any child process whose process group ID is equal to -PID.  A PID of
C<-1> indicates to wait for any child process.
 
If you say
 
    use POSIX ":sys_wait_h";
 
    my $kid;
    do {
        $kid = waitpid(-1, WNOHANG);
    } while $kid > 0;
 
or
 
    1 while waitpid(-1, WNOHANG) > 0;
 
then you can do a non-blocking wait for all pending zombie processes (see
L<POSIX/WAIT>).
Non-blocking wait is available on machines supporting either the
L<waitpid(2)> or L<wait4(2)> syscalls.  However, waiting for a particular
pid with FLAGS of C<0> is implemented everywhere.  (Perl emulates the
system call by remembering the status values of processes that have
exited but have not been harvested by the Perl script yet.)
 
Note that on some systems, a return value of C<-1> could mean that child
processes are being automatically reaped.  See L<perlipc> for details,
and for other examples.
 
Portability issues: L<perlport/waitpid>.
 
=item wantarray
X<wantarray> X<context>
 
=for Pod::Functions get void vs scalar vs list context of current subroutine call
 
Returns true if the context of the currently executing subroutine or
L<C<eval>|/eval EXPR> is looking for a list value.  Returns false if the
context is
looking for a scalar.  Returns the undefined value if the context is
looking for no value (void context).
 
    return unless defined wantarray; # don't bother doing more
    my @a = complex_calculation();
    return wantarray ? @a : "@a";
 
L<C<wantarray>|/wantarray>'s result is unspecified in the top level of a file,
in a C<BEGIN>, C<UNITCHECK>, C<CHECK>, C<INIT> or C<END> block, or
in a C<DESTROY> method.
 
This function should have been named wantlist() instead.
 
=item warn LIST
X<warn> X<warning> X<STDERR>
 
=for Pod::Functions print debugging info
 
Emits a warning, usually by printing it to C<STDERR>.  C<warn> interprets
its operand LIST in the same way as C<die>, but is slightly different
in what it defaults to when LIST is empty or makes an empty string.
If it is empty and L<C<$@>|perlvar/$@> already contains an exception
value then that value is used after appending C<"\t...caught">.  If it
is empty and C<$@> is also empty then the string C<"Warning: Something's
wrong"> is used.
 
By default, the exception derived from the operand LIST is stringified
and printed to C<STDERR>.  This behaviour can be altered by installing
a L<C<$SIG{__WARN__}>|perlvar/%SIG> handler.  If there is such a
handler then no message is automatically printed; it is the handler's
responsibility to deal with the exception
as it sees fit (like, for instance, converting it into a
L<C<die>|/die LIST>).  Most
handlers must therefore arrange to actually display the
warnings that they are not prepared to deal with, by calling
L<C<warn>|/warn LIST>
again in the handler.  Note that this is quite safe and will not
produce an endless loop, since C<__WARN__> hooks are not called from
inside one.
 
You will find this behavior is slightly different from that of
L<C<$SIG{__DIE__}>|perlvar/%SIG> handlers (which don't suppress the
error text, but can instead call L<C<die>|/die LIST> again to change
it).
 
Using a C<__WARN__> handler provides a powerful way to silence all
warnings (even the so-called mandatory ones).  An example:
 
    # wipe out *all* compile-time warnings
    BEGIN { $SIG{'__WARN__'} = sub { warn $_[0] if $DOWARN } }
    my $foo = 10;
    my $foo = 20;          # no warning about duplicate my $foo,
                           # but hey, you asked for it!
    # no compile-time or run-time warnings before here
    $DOWARN = 1;
 
    # run-time warnings enabled after here
    warn "\$foo is alive and $foo!";     # does show up
 
See L<perlvar> for details on setting L<C<%SIG>|perlvar/%SIG> entries
and for more
examples.  See the L<Carp> module for other kinds of warnings using its
C<carp> and C<cluck> functions.
 
=item write FILEHANDLE
X<write>
 
=item write EXPR
 
=item write
 
=for Pod::Functions print a picture record
 
Writes a formatted record (possibly multi-line) to the specified FILEHANDLE,
using the format associated with that file.  By default the format for
a file is the one having the same name as the filehandle, but the
format for the current output channel (see the
L<C<select>|/select FILEHANDLE> function) may be set explicitly by
assigning the name of the format to the L<C<$~>|perlvar/$~> variable.
 
Top of form processing is handled automatically:  if there is insufficient
room on the current page for the formatted record, the page is advanced by
writing a form feed and a special top-of-page
format is used to format the new
page header before the record is written.  By default, the top-of-page
format is the name of the filehandle with C<_TOP> appended, or C<top>
in the current package if the former does not exist.  This would be a
problem with autovivified filehandles, but it may be dynamically set to the
format of your choice by assigning the name to the L<C<$^>|perlvar/$^>
variable while that filehandle is selected.  The number of lines
remaining on the current page is in variable L<C<$->|perlvar/$->, which
can be set to C<0> to force a new page.
 
If FILEHANDLE is unspecified, output goes to the current default output
channel, which starts out as STDOUT but may be changed by the
L<C<select>|/select FILEHANDLE> operator.  If the FILEHANDLE is an EXPR,
then the expression
is evaluated and the resulting string is used to look up the name of
the FILEHANDLE at run time.  For more on formats, see L<perlform>.
 
Note that write is I<not> the opposite of
L<C<read>|/read FILEHANDLE,SCALAR,LENGTH,OFFSET>.  Unfortunately.
 
=item y///
 
=for Pod::Functions transliterate a string
 
The transliteration operator.  Same as
L<C<trE<sol>E<sol>E<sol>>|/trE<sol>E<sol>E<sol>>.  See
L<perlop/"Quote-Like Operators">.
 
=back
 
=head2 Non-function Keywords by Cross-reference
 
=head3 perldata
 
=over
 
=item __DATA__
 
=item __END__
 
These keywords are documented in L<perldata/"Special Literals">.
 
=back
 
=head3 perlmod
 
=over
 
=item BEGIN
 
=item CHECK
 
=item END
 
=item INIT
 
=item UNITCHECK
 
These compile phase keywords are documented in L<perlmod/"BEGIN, UNITCHECK, CHECK, INIT and END">.
 
=back
 
=head3 perlobj
 
=over
 
=item DESTROY
 
This method keyword is documented in L<perlobj/"Destructors">.
 
=back
 
=head3 perlop
 
=over
 
=item and
 
=item cmp
 
=item eq
 
=item ge
 
=item gt
 
=item le
 
=item lt
 
=item ne
 
=item not
 
=item or
 
=item x
 
=item xor
 
These operators are documented in L<perlop>.
 
=back
 
=head3 perlsub
 
=over
 
=item AUTOLOAD
 
This keyword is documented in L<perlsub/"Autoloading">.
 
=back
 
=head3 perlsyn
 
=over
 
=item else
 
=item elsif
 
=item for
 
=item foreach
 
=item if
 
=item unless
 
=item until
 
=item while
 
These flow-control keywords are documented in L<perlsyn/"Compound Statements">.
 
=item elseif
 
The "else if" keyword is spelled C<elsif> in Perl.  There's no C<elif>
or C<else if> either.  It does parse C<elseif>, but only to warn you
about not using it.
 
See the documentation for flow-control keywords in L<perlsyn/"Compound
Statements">.
 
=back
 
=over
 
=item default
 
=item given
 
=item when
 
These flow-control keywords related to the experimental switch feature are
documented in L<perlsyn/"Switch Statements">.
 
=back
 
=cut