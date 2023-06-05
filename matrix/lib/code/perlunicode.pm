=head1 NAME
 
perlunicode - Unicode support in Perl
 
=head1 DESCRIPTION
 
If you haven't already, before reading this document, you should become
familiar with both L<perlunitut> and L<perluniintro>.
 
Unicode aims to B<UNI>-fy the en-B<CODE>-ings of all the world's
character sets into a single Standard.   For quite a few of the various
coding standards that existed when Unicode was first created, converting
from each to Unicode essentially meant adding a constant to each code
point in the original standard, and converting back meant just
subtracting that same constant.  For ASCII and ISO-8859-1, the constant
is 0.  For ISO-8859-5, (Cyrillic) the constant is 864; for Hebrew
(ISO-8859-8), it's 1488; Thai (ISO-8859-11), 3424; and so forth.  This
made it easy to do the conversions, and facilitated the adoption of
Unicode.
 
And it worked; nowadays, those legacy standards are rarely used.  Most
everyone uses Unicode.
 
Unicode is a comprehensive standard.  It specifies many things outside
the scope of Perl, such as how to display sequences of characters.  For
a full discussion of all aspects of Unicode, see
L<https://www.unicode.org>.
 
=head2 Important Caveats
 
Even though some of this section may not be understandable to you on
first reading, we think it's important enough to highlight some of the
gotchas before delving further, so here goes:
 
Unicode support is an extensive requirement. While Perl does not
implement the Unicode standard or the accompanying technical reports
from cover to cover, Perl does support many Unicode features.
 
Also, the use of Unicode may present security issues that aren't
obvious, see L</Security Implications of Unicode> below.
 
=over 4
 
=item Safest if you C<use feature 'unicode_strings'>
 
In order to preserve backward compatibility, Perl does not turn
on full internal Unicode support unless the pragma
L<S<C<use feature 'unicode_strings'>>|feature/The 'unicode_strings' feature>
is specified.  (This is automatically
selected if you S<C<use 5.012>> or higher.)  Failure to do this can
trigger unexpected surprises.  See L</The "Unicode Bug"> below.
 
This pragma doesn't affect I/O.  Nor does it change the internal
representation of strings, only their interpretation.  There are still
several places where Unicode isn't fully supported, such as in
filenames.
 
=item Input and Output Layers
 
Use the C<:encoding(...)> layer  to read from and write to
filehandles using the specified encoding.  (See L<open>.)
 
=item You must convert your non-ASCII, non-UTF-8 Perl scripts to be
UTF-8.
 
The L<encoding> module has been deprecated since perl 5.18 and the
perl internals it requires have been removed with perl 5.26.
 
=item C<use utf8> still needed to enable L<UTF-8|/Unicode Encodings> in scripts
 
If your Perl script is itself encoded in L<UTF-8|/Unicode Encodings>,
the S<C<use utf8>> pragma must be explicitly included to enable
recognition of that (in string or regular expression literals, or in
identifier names).  B<This is the only time when an explicit S<C<use
utf8>> is needed.>  (See L<utf8>).
 
If a Perl script begins with the bytes that form the UTF-8 encoding of
the Unicode BYTE ORDER MARK (C<BOM>, see L</Unicode Encodings>), those
bytes are completely ignored.
 
=item L<UTF-16|/Unicode Encodings> scripts autodetected
 
If a Perl script begins with the Unicode C<BOM> (UTF-16LE,
UTF16-BE), or if the script looks like non-C<BOM>-marked
UTF-16 of either endianness, Perl will correctly read in the script as
the appropriate Unicode encoding.
 
=back
 
=head2 Byte and Character Semantics
 
Before Unicode, most encodings used 8 bits (a single byte) to encode
each character.  Thus a character was a byte, and a byte was a
character, and there could be only 256 or fewer possible characters.
"Byte Semantics" in the title of this section refers to
this behavior.  There was no need to distinguish between "Byte" and
"Character".
 
Then along comes Unicode which has room for over a million characters
(and Perl allows for even more).  This means that a character may
require more than a single byte to represent it, and so the two terms
are no longer equivalent.  What matter are the characters as whole
entities, and not usually the bytes that comprise them.  That's what the
term "Character Semantics" in the title of this section refers to.
 
Perl had to change internally to decouple "bytes" from "characters".
It is important that you too change your ideas, if you haven't already,
so that "byte" and "character" no longer mean the same thing in your
mind.
 
The basic building block of Perl strings has always been a "character".
The changes basically come down to that the implementation no longer
thinks that a character is always just a single byte.
 
There are various things to note:
 
=over 4
 
=item *
 
String handling functions, for the most part, continue to operate in
terms of characters.  C<length()>, for example, returns the number of
characters in a string, just as before.  But that number no longer is
necessarily the same as the number of bytes in the string (there may be
more bytes than characters).  The other such functions include
C<chop()>, C<chomp()>, C<substr()>, C<pos()>, C<index()>, C<rindex()>,
C<sort()>, C<sprintf()>, and C<write()>.
 
The exceptions are:
 
=over 4
 
=item *
 
the bit-oriented C<vec>
 
E<nbsp>
 
=item *
 
the byte-oriented C<pack>/C<unpack> C<"C"> format
 
However, the C<W> specifier does operate on whole characters, as does the
C<U> specifier.
 
=item *
 
some operators that interact with the platform's operating system
 
Operators dealing with filenames are examples.
 
=item *
 
when the functions are called from within the scope of the
S<C<L<use bytes|bytes>>> pragma
 
Likely, you should use this only for debugging anyway.
 
=back
 
=item *
 
Strings--including hash keys--and regular expression patterns may
contain characters that have ordinal values larger than 255.
 
If you use a Unicode editor to edit your program, Unicode characters may
occur directly within the literal strings in UTF-8 encoding, or UTF-16.
(The former requires a C<use utf8>, the latter may require a C<BOM>.)
 
L<perluniintro/Creating Unicode> gives other ways to place non-ASCII
characters in your strings.
 
=item *
 
The C<chr()> and C<ord()> functions work on whole characters.
 
=item *
 
Regular expressions match whole characters.  For example, C<"."> matches
a whole character instead of only a single byte.
 
=item *
 
The C<tr///> operator translates whole characters.  (Note that the
C<tr///CU> functionality has been removed.  For similar functionality to
that, see C<pack('U0', ...)> and C<pack('C0', ...)>).
 
=item *
 
C<scalar reverse()> reverses by character rather than by byte.
 
=item *
 
The bit string operators, C<& | ^ ~> and (starting in v5.22)
C<&. |. ^.  ~.> can operate on bit strings encoded in UTF-8, but this
can give unexpected results if any of the strings contain code points
above 0xFF.  Starting in v5.28, it is a fatal error to have such an
operand.  Otherwise, the operation is performed on a non-UTF-8 copy of
the operand.  If you're not sure about the encoding of a string,
downgrade it before using any of these operators; you can use
L<C<utf8::utf8_downgrade()>|utf8/Utility functions>.
 
=back
 
The bottom line is that Perl has always practiced "Character Semantics",
but with the advent of Unicode, that is now different than "Byte
Semantics".
 
=head2 ASCII Rules versus Unicode Rules
 
Before Unicode, when a character was a byte was a character,
Perl knew only about the 128 characters defined by ASCII, code points 0
through 127 (except for under L<S<C<use locale>>|perllocale>).  That
left the code
points 128 to 255 as unassigned, and available for whatever use a
program might want.  The only semantics they have is their ordinal
numbers, and that they are members of none of the non-negative character
classes.  None are considered to match C<\w> for example, but all match
C<\W>.
 
Unicode, of course, assigns each of those code points a particular
meaning (along with ones above 255).  To preserve backward
compatibility, Perl only uses the Unicode meanings when there is some
indication that Unicode is what is intended; otherwise the non-ASCII
code points remain treated as if they are unassigned.
 
Here are the ways that Perl knows that a string should be treated as
Unicode:
 
=over
 
=item *
 
Within the scope of S<C<use utf8>>
 
If the whole program is Unicode (signified by using 8-bit B<U>nicode
B<T>ransformation B<F>ormat), then all literal strings within it must be
Unicode.
 
=item *
 
Within the scope of
L<S<C<use feature 'unicode_strings'>>|feature/The 'unicode_strings' feature>
 
This pragma was created so you can explicitly tell Perl that operations
executed within its scope are to use Unicode rules.  More operations are
affected with newer perls.  See L</The "Unicode Bug">.
 
=item *
 
Within the scope of S<C<use 5.012>> or higher
 
This implicitly turns on S<C<use feature 'unicode_strings'>>.
 
=item *
 
Within the scope of
L<S<C<use locale 'not_characters'>>|perllocale/Unicode and UTF-8>,
or L<S<C<use locale>>|perllocale> and the current
locale is a UTF-8 locale.
 
The former is defined to imply Unicode handling; and the latter
indicates a Unicode locale, hence a Unicode interpretation of all
strings within it.
 
=item *
 
When the string contains a Unicode-only code point
 
Perl has never accepted code points above 255 without them being
Unicode, so their use implies Unicode for the whole string.
 
=item *
 
When the string contains a Unicode named code point C<\N{...}>
 
The C<\N{...}> construct explicitly refers to a Unicode code point,
even if it is one that is also in ASCII.  Therefore the string
containing it must be Unicode.
 
=item *
 
When the string has come from an external source marked as
Unicode
 
The L<C<-C>|perlrun/-C [numberE<sol>list]> command line option can
specify that certain inputs to the program are Unicode, and the values
of this can be read by your Perl code, see L<perlvar/"${^UNICODE}">.
 
=item * When the string has been upgraded to UTF-8
 
The function L<C<utf8::utf8_upgrade()>|utf8/Utility functions>
can be explicitly used to permanently (unless a subsequent
C<utf8::utf8_downgrade()> is called) cause a string to be treated as
Unicode.
 
=item * There are additional methods for regular expression patterns
 
A pattern that is compiled with the C<< /u >> or C<< /a >> modifiers is
treated as Unicode (though there are some restrictions with C<< /a >>).
Under the C<< /d >> and C<< /l >> modifiers, there are several other
indications for Unicode; see L<perlre/Character set modifiers>.
 
=back
 
Note that all of the above are overridden within the scope of
C<L<use bytes|bytes>>; but you should be using this pragma only for
debugging.
 
Note also that some interactions with the platform's operating system
never use Unicode rules.
 
When Unicode rules are in effect:
 
=over 4
 
=item *
 
Case translation operators use the Unicode case translation tables.
 
Note that C<uc()>, or C<\U> in interpolated strings, translates to
uppercase, while C<ucfirst>, or C<\u> in interpolated strings,
translates to titlecase in languages that make the distinction (which is
equivalent to uppercase in languages without the distinction).
 
There is a CPAN module, C<L<Unicode::Casing>>, which allows you to
define your own mappings to be used in C<lc()>, C<lcfirst()>, C<uc()>,
C<ucfirst()>, and C<fc> (or their double-quoted string inlined versions
such as C<\U>).  (Prior to Perl 5.16, this functionality was partially
provided in the Perl core, but suffered from a number of insurmountable
drawbacks, so the CPAN module was written instead.)
 
=item *
 
Character classes in regular expressions match based on the character
properties specified in the Unicode properties database.
 
C<\w> can be used to match a Japanese ideograph, for instance; and
C<[[:digit:]]> a Bengali number.
 
=item *
 
Named Unicode properties, scripts, and block ranges may be used (like
bracketed character classes) by using the C<\p{}> "matches property"
construct and the C<\P{}> negation, "doesn't match property".
 
See L</"Unicode Character Properties"> for more details.
 
You can define your own character properties and use them
in the regular expression with the C<\p{}> or C<\P{}> construct.
See L</"User-Defined Character Properties"> for more details.
 
=back
 
=head2 Extended Grapheme Clusters (Logical characters)
 
Consider a character, say C<H>.  It could appear with various marks around it,
such as an acute accent, or a circumflex, or various hooks, circles, arrows,
I<etc.>, above, below, to one side or the other, I<etc>.  There are many
possibilities among the world's languages.  The number of combinations is
astronomical, and if there were a character for each combination, it would
soon exhaust Unicode's more than a million possible characters.  So Unicode
took a different approach: there is a character for the base C<H>, and a
character for each of the possible marks, and these can be variously combined
to get a final logical character.  So a logical character--what appears to be a
single character--can be a sequence of more than one individual characters.
The Unicode standard calls these "extended grapheme clusters" (which
is an improved version of the no-longer much used "grapheme cluster");
Perl furnishes the C<\X> regular expression construct to match such
sequences in their entirety.
 
But Unicode's intent is to unify the existing character set standards and
practices, and several pre-existing standards have single characters that
mean the same thing as some of these combinations, like ISO-8859-1,
which has quite a few of them. For example, C<"LATIN CAPITAL LETTER E
WITH ACUTE"> was already in this standard when Unicode came along.
Unicode therefore added it to its repertoire as that single character.
But this character is considered by Unicode to be equivalent to the
sequence consisting of the character C<"LATIN CAPITAL LETTER E">
followed by the character C<"COMBINING ACUTE ACCENT">.
 
C<"LATIN CAPITAL LETTER E WITH ACUTE"> is called a "pre-composed"
character, and its equivalence with the "E" and the "COMBINING ACCENT"
sequence is called canonical equivalence.  All pre-composed characters
are said to have a decomposition (into the equivalent sequence), and the
decomposition type is also called canonical.  A string may be comprised
as much as possible of precomposed characters, or it may be comprised of
entirely decomposed characters.  Unicode calls these respectively,
"Normalization Form Composed" (NFC) and "Normalization Form Decomposed".
The C<L<Unicode::Normalize>> module contains functions that convert
between the two.  A string may also have both composed characters and
decomposed characters; this module can be used to make it all one or the
other.
 
You may be presented with strings in any of these equivalent forms.
There is currently nothing in Perl 5 that ignores the differences.  So
you'll have to specially handle it.  The usual advice is to convert your
inputs to C<NFD> before processing further.
 
For more detailed information, see L<http://unicode.org/reports/tr15/>.
 
=head2 Unicode Character Properties
 
(The only time that Perl considers a sequence of individual code
points as a single logical character is in the C<\X> construct, already
mentioned above.   Therefore "character" in this discussion means a single
Unicode code point.)
 
Very nearly all Unicode character properties are accessible through
regular expressions by using the C<\p{}> "matches property" construct
and the C<\P{}> "doesn't match property" for its negation.
 
For instance, C<\p{Uppercase}> matches any single character with the Unicode
C<"Uppercase"> property, while C<\p{L}> matches any character with a
C<General_Category> of C<"L"> (letter) property (see
L</General_Category> below).  Brackets are not
required for single letter property names, so C<\p{L}> is equivalent to C<\pL>.
 
More formally, C<\p{Uppercase}> matches any single character whose Unicode
C<Uppercase> property value is C<True>, and C<\P{Uppercase}> matches any character
whose C<Uppercase> property value is C<False>, and they could have been written as
C<\p{Uppercase=True}> and C<\p{Uppercase=False}>, respectively.
 
This formality is needed when properties are not binary; that is, if they can
take on more values than just C<True> and C<False>.  For example, the
C<Bidi_Class> property (see L</"Bidirectional Character Types"> below),
can take on several different
values, such as C<Left>, C<Right>, C<Whitespace>, and others.  To match these, one needs
to specify both the property name (C<Bidi_Class>), AND the value being
matched against
(C<Left>, C<Right>, I<etc.>).  This is done, as in the examples above, by having the
two components separated by an equal sign (or interchangeably, a colon), like
C<\p{Bidi_Class: Left}>.
 
All Unicode-defined character properties may be written in these compound forms
of C<\p{I<property>=I<value>}> or C<\p{I<property>:I<value>}>, but Perl provides some
additional properties that are written only in the single form, as well as
single-form short-cuts for all binary properties and certain others described
below, in which you may omit the property name and the equals or colon
separator.
 
Most Unicode character properties have at least two synonyms (or aliases if you
prefer): a short one that is easier to type and a longer one that is more
descriptive and hence easier to understand.  Thus the C<"L"> and
C<"Letter"> properties above are equivalent and can be used
interchangeably.  Likewise, C<"Upper"> is a synonym for C<"Uppercase">,
and we could have written C<\p{Uppercase}> equivalently as C<\p{Upper}>.
Also, there are typically various synonyms for the values the property
can be.   For binary properties, C<"True"> has 3 synonyms: C<"T">,
C<"Yes">, and C<"Y">; and C<"False"> has correspondingly C<"F">,
C<"No">, and C<"N">.  But be careful.  A short form of a value for one
property may not mean the same thing as the short form spelled the same
for another.
Thus, for the C<L</General_Category>> property, C<"L"> means
C<"Letter">, but for the L<C<Bidi_Class>|/Bidirectional Character Types>
property, C<"L"> means C<"Left">.  A complete list of properties and
synonyms is in L<perluniprops>.
 
Upper/lower case differences in property names and values are irrelevant;
thus C<\p{Upper}> means the same thing as C<\p{upper}> or even C<\p{UpPeR}>.
Similarly, you can add or subtract underscores anywhere in the middle of a
word, so that these are also equivalent to C<\p{U_p_p_e_r}>.  And white space
is generally irrelevant adjacent to non-word characters, such as the
braces and the equals or colon separators, so C<\p{   Upper  }> and
C<\p{ Upper_case : Y }> are equivalent to these as well.  In fact, white
space and even hyphens can usually be added or deleted anywhere.  So
even C<\p{ Up-per case = Yes}> is equivalent.  All this is called
"loose-matching" by Unicode.  The "name" property has some restrictions
on this due to a few outlier names.  Full details are given in
L<https://www.unicode.org/reports/tr44/tr44-24.html#UAX44-LM2>.
 
The few places where stricter matching is
used is in the middle of numbers, the "name" property, and in the Perl
extension properties that begin or end with an underscore.  Stricter
matching cares about white space (except adjacent to non-word
characters), hyphens, and non-interior underscores.
 
You can also use negation in both C<\p{}> and C<\P{}> by introducing a caret
(C<^>) between the first brace and the property name: C<\p{^Tamil}> is
equal to C<\P{Tamil}>.
 
Almost all properties are immune to case-insensitive matching.  That is,
adding a C</i> regular expression modifier does not change what they
match.  There are two sets that are affected.
The first set is
C<Uppercase_Letter>,
C<Lowercase_Letter>,
and C<Titlecase_Letter>,
all of which match C<Cased_Letter> under C</i> matching.
And the second set is
C<Uppercase>,
C<Lowercase>,
and C<Titlecase>,
all of which match C<Cased> under C</i> matching.
This set also includes its subsets C<PosixUpper> and C<PosixLower> both
of which under C</i> match C<PosixAlpha>.
(The difference between these sets is that some things, such as Roman
numerals, come in both upper and lower case so they are C<Cased>, but
aren't considered letters, so they aren't C<Cased_Letter>'s.)
 
See L</Beyond Unicode code points> for special considerations when
matching Unicode properties against non-Unicode code points.
 
=head3 B<General_Category>
 
Every Unicode character is assigned a general category, which is the "most
usual categorization of a character" (from
L<https://www.unicode.org/reports/tr44>).
 
The compound way of writing these is like C<\p{General_Category=Number}>
(short: C<\p{gc:n}>).  But Perl furnishes shortcuts in which everything up
through the equal or colon separator is omitted.  So you can instead just write
C<\pN>.
 
Here are the short and long forms of the values the C<General Category> property
can have:
 
    Short       Long
 
    L           Letter
    LC, L&      Cased_Letter (that is: [\p{Ll}\p{Lu}\p{Lt}])
    Lu          Uppercase_Letter
    Ll          Lowercase_Letter
    Lt          Titlecase_Letter
    Lm          Modifier_Letter
    Lo          Other_Letter
 
    M           Mark
    Mn          Nonspacing_Mark
    Mc          Spacing_Mark
    Me          Enclosing_Mark
 
    N           Number
    Nd          Decimal_Number (also Digit)
    Nl          Letter_Number
    No          Other_Number
 
    P           Punctuation (also Punct)
    Pc          Connector_Punctuation
    Pd          Dash_Punctuation
    Ps          Open_Punctuation
    Pe          Close_Punctuation
    Pi          Initial_Punctuation
                (may behave like Ps or Pe depending on usage)
    Pf          Final_Punctuation
                (may behave like Ps or Pe depending on usage)
    Po          Other_Punctuation
 
    S           Symbol
    Sm          Math_Symbol
    Sc          Currency_Symbol
    Sk          Modifier_Symbol
    So          Other_Symbol
 
    Z           Separator
    Zs          Space_Separator
    Zl          Line_Separator
    Zp          Paragraph_Separator
 
    C           Other
    Cc          Control (also Cntrl)
    Cf          Format
    Cs          Surrogate
    Co          Private_Use
    Cn          Unassigned
 
Single-letter properties match all characters in any of the
two-letter sub-properties starting with the same letter.
C<LC> and C<L&> are special: both are aliases for the set consisting of everything matched by C<Ll>, C<Lu>, and C<Lt>.
 
=head3 B<Bidirectional Character Types>
 
Because scripts differ in their directionality (Hebrew and Arabic are
written right to left, for example) Unicode supplies a C<Bidi_Class> property.
Some of the values this property can have are:
 
    Value       Meaning
 
    L           Left-to-Right
    LRE         Left-to-Right Embedding
    LRO         Left-to-Right Override
    R           Right-to-Left
    AL          Arabic Letter
    RLE         Right-to-Left Embedding
    RLO         Right-to-Left Override
    PDF         Pop Directional Format
    EN          European Number
    ES          European Separator
    ET          European Terminator
    AN          Arabic Number
    CS          Common Separator
    NSM         Non-Spacing Mark
    BN          Boundary Neutral
    B           Paragraph Separator
    S           Segment Separator
    WS          Whitespace
    ON          Other Neutrals
 
This property is always written in the compound form.
For example, C<\p{Bidi_Class:R}> matches characters that are normally
written right to left.  Unlike the
C<L</General_Category>> property, this
property can have more values added in a future Unicode release.  Those
listed above comprised the complete set for many Unicode releases, but
others were added in Unicode 6.3; you can always find what the
current ones are in L<perluniprops>.  And
L<https://www.unicode.org/reports/tr9/> describes how to use them.
 
=head3 B<Scripts>
 
The world's languages are written in many different scripts.  This sentence
(unless you're reading it in translation) is written in Latin, while Russian is
written in Cyrillic, and Greek is written in, well, Greek; Japanese mainly in
Hiragana or Katakana.  There are many more.
 
The Unicode C<Script> and C<Script_Extensions> properties give what
script a given character is in.  The C<Script_Extensions> property is an
improved version of C<Script>, as demonstrated below.  Either property
can be specified with the compound form like
C<\p{Script=Hebrew}> (short: C<\p{sc=hebr}>), or
C<\p{Script_Extensions=Javanese}> (short: C<\p{scx=java}>).
In addition, Perl furnishes shortcuts for all
C<Script_Extensions> property names.  You can omit everything up through
the equals (or colon), and simply write C<\p{Latin}> or C<\P{Cyrillic}>.
(This is not true for C<Script>, which is required to be
written in the compound form.  Prior to Perl v5.26, the single form
returned the plain old C<Script> version, but was changed because
C<Script_Extensions> gives better results.)
 
The difference between these two properties involves characters that are
used in multiple scripts.  For example the digits '0' through '9' are
used in many parts of the world.  These are placed in a script named
C<Common>.  Other characters are used in just a few scripts.  For
example, the C<"KATAKANA-HIRAGANA DOUBLE HYPHEN"> is used in both Japanese
scripts, Katakana and Hiragana, but nowhere else.  The C<Script>
property places all characters that are used in multiple scripts in the
C<Common> script, while the C<Script_Extensions> property places those
that are used in only a few scripts into each of those scripts; while
still using C<Common> for those used in many scripts.  Thus both these
match:
 
 "0" =~ /\p{sc=Common}/     # Matches
 "0" =~ /\p{scx=Common}/    # Matches
 
and only the first of these match:
 
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{sc=Common}  # Matches
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{scx=Common} # No match
 
And only the last two of these match:
 
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{sc=Hiragana}  # No match
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{sc=Katakana}  # No match
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{scx=Hiragana} # Matches
 "\N{KATAKANA-HIRAGANA DOUBLE HYPHEN}" =~ /\p{scx=Katakana} # Matches
 
C<Script_Extensions> is thus an improved C<Script>, in which there are
fewer characters in the C<Common> script, and correspondingly more in
other scripts.  It is new in Unicode version 6.0, and its data are likely
to change significantly in later releases, as things get sorted out.
New code should probably be using C<Script_Extensions> and not plain
C<Script>.  If you compile perl with a Unicode release that doesn't have
C<Script_Extensions>, the single form Perl extensions will instead refer
to the plain C<Script> property.  If you compile with a version of
Unicode that doesn't have the C<Script> property, these extensions will
not be defined at all.
 
(Actually, besides C<Common>, the C<Inherited> script, contains
characters that are used in multiple scripts.  These are modifier
characters which inherit the script value
of the controlling character.  Some of these are used in many scripts,
and so go into C<Inherited> in both C<Script> and C<Script_Extensions>.
Others are used in just a few scripts, so are in C<Inherited> in
C<Script>, but not in C<Script_Extensions>.)
 
It is worth stressing that there are several different sets of digits in
Unicode that are equivalent to 0-9 and are matchable by C<\d> in a
regular expression.  If they are used in a single language only, they
are in that language's C<Script> and C<Script_Extensions>.  If they are
used in more than one script, they will be in C<sc=Common>, but only
if they are used in many scripts should they be in C<scx=Common>.
 
The explanation above has omitted some detail; refer to UAX#24 "Unicode
Script Property": L<https://www.unicode.org/reports/tr24>.
 
A complete list of scripts and their shortcuts is in L<perluniprops>.
 
=head3 B<Use of the C<"Is"> Prefix>
 
For backward compatibility (with ancient Perl 5.6), all properties writable
without using the compound form mentioned
so far may have C<Is> or C<Is_> prepended to their name, so C<\P{Is_Lu}>, for
example, is equal to C<\P{Lu}>, and C<\p{IsScript:Arabic}> is equal to
C<\p{Arabic}>.
 
=head3 B<Blocks>
 
In addition to B<scripts>, Unicode also defines B<blocks> of
characters.  The difference between scripts and blocks is that the
concept of scripts is closer to natural languages, while the concept
of blocks is more of an artificial grouping based on groups of Unicode
characters with consecutive ordinal values. For example, the C<"Basic Latin">
block is all the characters whose ordinals are between 0 and 127, inclusive; in
other words, the ASCII characters.  The C<"Latin"> script contains some letters
from this as well as several other blocks, like C<"Latin-1 Supplement">,
C<"Latin Extended-A">, I<etc.>, but it does not contain all the characters from
those blocks. It does not, for example, contain the digits 0-9, because
those digits are shared across many scripts, and hence are in the
C<Common> script.
 
For more about scripts versus blocks, see UAX#24 "Unicode Script Property":
L<https://www.unicode.org/reports/tr24>
 
The C<Script_Extensions> or C<Script> properties are likely to be the
ones you want to use when processing
natural language; the C<Block> property may occasionally be useful in working
with the nuts and bolts of Unicode.
 
Block names are matched in the compound form, like C<\p{Block: Arrows}> or
C<\p{Blk=Hebrew}>.  Unlike most other properties, only a few block names have a
Unicode-defined short name.
 
Perl also defines single form synonyms for the block property in cases
where these do not conflict with something else.  But don't use any of
these, because they are unstable.  Since these are Perl extensions, they
are subordinate to official Unicode property names; Unicode doesn't know
nor care about Perl's extensions.  It may happen that a name that
currently means the Perl extension will later be changed without warning
to mean a different Unicode property in a future version of the perl
interpreter that uses a later Unicode release, and your code would no
longer work.  The extensions are mentioned here for completeness:  Take
the block name and prefix it with one of: C<In> (for example
C<\p{Blk=Arrows}> can currently be written as C<\p{In_Arrows}>); or
sometimes C<Is> (like C<\p{Is_Arrows}>); or sometimes no prefix at all
(C<\p{Arrows}>).  As of this writing (Unicode 9.0) there are no
conflicts with using the C<In_> prefix, but there are plenty with the
other two forms.  For example, C<\p{Is_Hebrew}> and C<\p{Hebrew}> mean
C<\p{Script_Extensions=Hebrew}> which is NOT the same thing as
C<\p{Blk=Hebrew}>.  Our
advice used to be to use the C<In_> prefix as a single form way of
specifying a block.  But Unicode 8.0 added properties whose names begin
with C<In>, and it's now clear that it's only luck that's so far
prevented a conflict.  Using C<In> is only marginally less typing than
C<Blk:>, and the latter's meaning is clearer anyway, and guaranteed to
never conflict.  So don't take chances.  Use C<\p{Blk=foo}> for new
code.  And be sure that block is what you really really want to do.  In
most cases scripts are what you want instead.
 
A complete list of blocks is in L<perluniprops>.
 
=head3 B<Other Properties>
 
There are many more properties than the very basic ones described here.
A complete list is in L<perluniprops>.
 
Unicode defines all its properties in the compound form, so all single-form
properties are Perl extensions.  Most of these are just synonyms for the
Unicode ones, but some are genuine extensions, including several that are in
the compound form.  And quite a few of these are actually recommended by Unicode
(in L<https://www.unicode.org/reports/tr18>).
 
This section gives some details on all extensions that aren't just
synonyms for compound-form Unicode properties
(for those properties, you'll have to refer to the
L<Unicode Standard|https://www.unicode.org/reports/tr44>.
 
=over
 
=item B<C<\p{All}>>
 
This matches every possible code point.  It is equivalent to C<qr/./s>.
Unlike all the other non-user-defined C<\p{}> property matches, no
warning is ever generated if this is property is matched against a
non-Unicode code point (see L</Beyond Unicode code points> below).
 
=item B<C<\p{Alnum}>>
 
This matches any C<\p{Alphabetic}> or C<\p{Decimal_Number}> character.
 
=item B<C<\p{Any}>>
 
This matches any of the 1_114_112 Unicode code points.  It is a synonym
for C<\p{Unicode}>.
 
=item B<C<\p{ASCII}>>
 
This matches any of the 128 characters in the US-ASCII character set,
which is a subset of Unicode.
 
=item B<C<\p{Assigned}>>
 
This matches any assigned code point; that is, any code point whose L<general
category|/General_Category> is not C<Unassigned> (or equivalently, not C<Cn>).
 
=item B<C<\p{Blank}>>
 
This is the same as C<\h> and C<\p{HorizSpace}>:  A character that changes the
spacing horizontally.
 
=item B<C<\p{Decomposition_Type: Non_Canonical}>>    (Short: C<\p{Dt=NonCanon}>)
 
Matches a character that has a non-canonical decomposition.
 
The L</Extended Grapheme Clusters (Logical characters)> section above
talked about canonical decompositions.  However, many more characters
have a different type of decomposition, a "compatible" or
"non-canonical" decomposition.  The sequences that form these
decompositions are not considered canonically equivalent to the
pre-composed character.  An example is the C<"SUPERSCRIPT ONE">.  It is
somewhat like a regular digit 1, but not exactly; its decomposition into
the digit 1 is called a "compatible" decomposition, specifically a
"super" decomposition.  There are several such compatibility
decompositions (see L<https://www.unicode.org/reports/tr44>), including
one called "compat", which means some miscellaneous type of
decomposition that doesn't fit into the other decomposition categories
that Unicode has chosen.
 
Note that most Unicode characters don't have a decomposition, so their
decomposition type is C<"None">.
 
For your convenience, Perl has added the C<Non_Canonical> decomposition
type to mean any of the several compatibility decompositions.
 
=item B<C<\p{Graph}>>
 
Matches any character that is graphic.  Theoretically, this means a character
that on a printer would cause ink to be used.
 
=item B<C<\p{HorizSpace}>>
 
This is the same as C<\h> and C<\p{Blank}>:  a character that changes the
spacing horizontally.
 
=item B<C<\p{In=*}>>
 
This is a synonym for C<\p{Present_In=*}>
 
=item B<C<\p{PerlSpace}>>
 
This is the same as C<\s>, restricted to ASCII, namely C<S<[ \f\n\r\t]>>
and starting in Perl v5.18, a vertical tab.
 
Mnemonic: Perl's (original) space
 
=item B<C<\p{PerlWord}>>
 
This is the same as C<\w>, restricted to ASCII, namely C<[A-Za-z0-9_]>
 
Mnemonic: Perl's (original) word.
 
=item B<C<\p{Posix...}>>
 
There are several of these, which are equivalents, using the C<\p{}>
notation, for Posix classes and are described in
L<perlrecharclass/POSIX Character Classes>.
 
=item B<C<\p{Present_In: *}>>    (Short: C<\p{In=*}>)
 
This property is used when you need to know in what Unicode version(s) a
character is.
 
The "*" above stands for some Unicode version number, such as
C<1.1> or C<12.0>; or the "*" can also be C<Unassigned>.  This property will
match the code points whose final disposition has been settled as of the
Unicode release given by the version number; C<\p{Present_In: Unassigned}>
will match those code points whose meaning has yet to be assigned.
 
For example, C<U+0041> C<"LATIN CAPITAL LETTER A"> was present in the very first
Unicode release available, which is C<1.1>, so this property is true for all
valid "*" versions.  On the other hand, C<U+1EFF> was not assigned until version
5.1 when it became C<"LATIN SMALL LETTER Y WITH LOOP">, so the only "*" that
would match it are 5.1, 5.2, and later.
 
Unicode furnishes the C<Age> property from which this is derived.  The problem
with Age is that a strict interpretation of it (which Perl takes) has it
matching the precise release a code point's meaning is introduced in.  Thus
C<U+0041> would match only 1.1; and C<U+1EFF> only 5.1.  This is not usually what
you want.
 
Some non-Perl implementations of the Age property may change its meaning to be
the same as the Perl C<Present_In> property; just be aware of that.
 
Another confusion with both these properties is that the definition is not
that the code point has been I<assigned>, but that the meaning of the code point
has been I<determined>.  This is because 66 code points will always be
unassigned, and so the C<Age> for them is the Unicode version in which the decision
to make them so was made.  For example, C<U+FDD0> is to be permanently
unassigned to a character, and the decision to do that was made in version 3.1,
so C<\p{Age=3.1}> matches this character, as also does C<\p{Present_In: 3.1}> and up.
 
=item B<C<\p{Print}>>
 
This matches any character that is graphical or blank, except controls.
 
=item B<C<\p{SpacePerl}>>
 
This is the same as C<\s>, including beyond ASCII.
 
Mnemonic: Space, as modified by Perl.  (It doesn't include the vertical tab
until v5.18, which both the Posix standard and Unicode consider white space.)
 
=item B<C<\p{Title}>> and  B<C<\p{Titlecase}>>
 
Under case-sensitive matching, these both match the same code points as
C<\p{General Category=Titlecase_Letter}> (C<\p{gc=lt}>).  The difference
is that under C</i> caseless matching, these match the same as
C<\p{Cased}>, whereas C<\p{gc=lt}> matches C<\p{Cased_Letter>).
 
=item B<C<\p{Unicode}>>
 
This matches any of the 1_114_112 Unicode code points.
C<\p{Any}>.
 
=item B<C<\p{VertSpace}>>
 
This is the same as C<\v>:  A character that changes the spacing vertically.
 
=item B<C<\p{Word}>>
 
This is the same as C<\w>, including over 100_000 characters beyond ASCII.
 
=item B<C<\p{XPosix...}>>
 
There are several of these, which are the standard Posix classes
extended to the full Unicode range.  They are described in
L<perlrecharclass/POSIX Character Classes>.
 
=back
 
=head2 Comparison of C<\N{...}> and C<\p{name=...}>
 
Starting in Perl 5.32, you can specify a character by its name in
regular expression patterns using C<\p{name=...}>.  This is in addition
to the longstanding method of using C<\N{...}>.  The following
summarizes the differences between these two:
 
                       \N{...}       \p{Name=...}
 can interpolate    only with eval       yes            [1]
 custom names            yes             no             [2]
 name aliases            yes             yes            [3]
 named sequences         yes             yes            [4]
 name value parsing     exact       Unicode loose       [5]
 
=over
 
=item [1]
 
The ability to interpolate means you can do something like
 
 qr/\p{na=latin capital letter $which}/
 
and specify C<$which> elsewhere.
 
=item [2]
 
You can create your own names for characters, and override official
ones when using C<\N{...}>.  See L<charnames/CUSTOM ALIASES>.
 
=item [3]
 
Some characters have multiple names (synonyms).
 
=item [4]
 
Some particular sequences of characters are given a single name, in
addition to their individual ones.
 
=item [5]
 
Exact name value matching means you have to specify case, hyphens,
underscores, and spaces precisely in the name you want.  Loose matching
follows the Unicode rules
L<https://www.unicode.org/reports/tr44/tr44-24.html#UAX44-LM2>,
where these are mostly irrelevant.  Except for a few outlier character
names, these are the same rules as are already used for any other
C<\p{...}> property.
 
=back
 
=head2 Wildcards in Property Values
 
Starting in Perl 5.30, it is possible to do something like this:
 
 qr!\p{numeric_value=/\A[0-5]\z/}!
 
or, by abbreviating and adding C</x>,
 
 qr! \p{nv= /(?x) \A [0-5] \z / }!
 
This matches all code points whose numeric value is one of 0, 1, 2, 3,
4, or 5.  This particular example could instead have been written as
 
 qr! \A [ \p{nv=0}\p{nv=1}\p{nv=2}\p{nv=3}\p{nv=4}\p{nv=5} ] \z !xx
 
in earlier perls, so in this case this feature just makes things easier
and shorter to write.  If we hadn't included the C<\A> and C<\z>, these
would have matched things like C<1E<sol>2> because that contains a 1 (as
well as a 2).  As written, it matches things like subscripts that have
these numeric values.  If we only wanted the decimal digits with those
numeric values, we could say,
 
 qr! (?[ \d & \p{nv=/[0-5]/ ]) }!x
 
The C<\d> gets rid of needing to anchor the pattern, since it forces the
result to only match C<[0-9]>, and the C<[0-5]> further restricts it.
 
The text in the above examples enclosed between the C<"E<sol>">
characters can be just about any regular expression.  It is independent
of the main pattern, so doesn't share any capturing groups, I<etc>.  The
delimiters for it must be ASCII punctuation, but it may NOT be
delimited by C<"{">, nor C<"}"> nor contain a literal C<"}">, as that
delimits the end of the enclosing C<\p{}>.  Like any pattern, certain
other delimiters are terminated by their mirror images.  These are
C<"(">, C<"[>", and C<"E<lt>">.  If the delimiter is any of C<"-">,
C<"_">, C<"+">, or C<"\">, or is the same delimiter as is used for the
enclosing pattern, it must be preceded by a backslash escape, both
fore and aft.
 
Beware of using C<"$"> to indicate to match the end of the string.  It
can too easily be interpreted as being a punctuation variable, like
C<$/>.
 
No modifiers may follow the final delimiter.  Instead, use
L<perlre/(?adlupimnsx-imnsx)> and/or
L<perlre/(?adluimnsx-imnsx:pattern)> to specify modifiers.
However, certain modifiers are illegal in your wildcard subpattern.
The only character set modifier specifiable is C</aa>;
any other character set, and C<-m>, and C<p>, and C<s> are all illegal.
Specifying modifiers like C<qr/.../gc> that aren't legal in the
C<(?...)> notation normally raise a warning, but with wildcard
subpatterns, their use is an error.  The C<m> modifier is ineffective;
everything that matches will be a single line.
 
By default, your pattern is matched case-insensitively, as if C</i> had
been specified.  You can change this by saying C<(?-i)> in your pattern.
 
There are also certain operations that are illegal.  You can't nest
C<\p{...}> and C<\P{...}> calls within a wildcard subpattern, and C<\G>
doesn't make sense, so is also prohibited.
 
And the C<*> quantifier (or its equivalent C<(0,}>) is illegal.
 
This feature is not available when the left-hand side is prefixed by
C<Is_>, nor for any form that is marked as "Discouraged" in
L<perluniprops/Discouraged>.
 
This experimental feature has been added to begin to implement
L<https://www.unicode.org/reports/tr18/#Wildcard_Properties>.  Using it
will raise a (default-on) warning in the
C<experimental::uniprop_wildcards> category.  We reserve the right to
change its operation as we gain experience.
 
Your subpattern can be just about anything, but for it to have some
utility, it should match when called with either or both of
a) the full name of the property value with underscores (and/or spaces
in the Block property) and some things uppercase; or b) the property
value in all lowercase with spaces and underscores squeezed out.  For
example,
 
 qr!\p{Blk=/Old I.*/}!
 qr!\p{Blk=/oldi.*/}!
 
would match the same things.
 
Another example that shows that within C<\p{...}>, C</x> isn't needed to
have spaces:
 
 qr!\p{scx= /Hebrew|Greek/ }!
 
To be safe, we should have anchored the above example, to prevent
matches for something like C<Hebrew_Braille>, but there aren't
any script names like that, so far.
A warning is issued if none of the legal values for a property are
matched by your pattern.  It's likely that a future release will raise a
warning if your pattern ends up causing every possible code point to
match.
 
Starting in 5.32, the Name, Name Aliases, and Named Sequences properties
are allowed to be matched.  They are considered to be a single
combination property, just as has long been the case for C<\N{}>.  Loose
matching doesn't work in exactly the same way for these as it does for
the values of other properties.  The rules are given in
L<https://www.unicode.org/reports/tr44/tr44-24.html#UAX44-LM2>.  As a
result, Perl doesn't try loose matching for you, like it does in other
properties.  All letters in names are uppercase, but you can add C<(?i)>
to your subpattern to ignore case.  If you're uncertain where a blank
is, you can use C< ?> in your subpattern.  No character name contains an
underscore, so don't bother trying to match one.  The use of hyphens is
particularly problematic; refer to the above link.  But note that, as of
Unicode 13.0, the only script in modern usage which has weirdnesses with
these is Tibetan; also the two Korean characters U+116C HANGUL JUNGSEONG
OE and U+1180 HANGUL JUNGSEONG O-E.  Unicode makes no promises to not
add hyphen-problematic names in the future.
 
Using wildcards on these is resource intensive, given the hundreds of
thousands of legal names that must be checked against.
 
An example of using Name property wildcards is
 
 qr!\p{name=/(SMILING|GRINNING) FACE/}!
 
Another is
 
 qr/(?[ \p{name=\/CJK\/} - \p{ideographic} ])/
 
which is the 200-ish (as of Unicode 13.0) CJK characters that aren't
ideographs.
 
There are certain properties that wildcard subpatterns don't currently
work with.  These are:
 
 Bidi Mirroring Glyph
 Bidi Paired Bracket
 Case Folding
 Decomposition Mapping
 Equivalent Unified Ideograph
 Lowercase Mapping
 NFKC Case Fold
 Titlecase Mapping
 Uppercase Mapping
 
Nor is the C<@I<unicode_property>@> form implemented.
 
Here's a complete example of matching IPV4 internet protocol addresses
in any (single) script
 
 no warnings 'experimental::regex_sets';
 no warnings 'experimental::uniprop_wildcards';
 
 # Can match a substring, so this intermediate regex needs to have
 # context or anchoring in its final use.  Using nt=de yields decimal
 # digits.  When specifying a subset of these, we must include \d to
 # prevent things like U+00B2 SUPERSCRIPT TWO from matching
 my $zero_through_255 =
  qr/ \b (*sr:                                  # All from same sript
            (?[ \p{nv=0} & \d ])*               # Optional leading zeros
        (                                       # Then one of:
                                  \d{1,2}       #   0 - 99
            | (?[ \p{nv=1} & \d ])  \d{2}       #   100 - 199
            | (?[ \p{nv=2} & \d ])
               (  (?[ \p{nv=:[0-4]:} & \d ]) \d #   200 - 249
                | (?[ \p{nv=5}     & \d ])
                  (?[ \p{nv=:[0-5]:} & \d ])    #   250 - 255
               )
        )
      )
    \b
  /x;
 
 my $ipv4 = qr/ \A (*sr:         $zero_through_255
                         (?: [.] $zero_through_255 ) {3}
                   )
                \z
            /x;
 
=head2 User-Defined Character Properties
 
You can define your own binary character properties by defining subroutines
whose names begin with C<"In"> or C<"Is">.  (The experimental feature
L<perlre/(?[ ])> provides an alternative which allows more complex
definitions.)  The subroutines can be defined in any
package.  They override any Unicode properties expressed as the same
names.  The user-defined properties can be used in the regular
expression
C<\p{}> and C<\P{}> constructs; if you are using a user-defined property from a
package other than the one you are in, you must specify its package in the
C<\p{}> or C<\P{}> construct.
 
    # assuming property Is_Foreign defined in Lang::
    package main;  # property package name required
    if ($txt =~ /\p{Lang::IsForeign}+/) { ... }
 
    package Lang;  # property package name not required
    if ($txt =~ /\p{IsForeign}+/) { ... }
 
 
Note that the effect is compile-time and immutable once defined.
However, the subroutines are passed a single parameter, which is 0 if
case-sensitive matching is in effect and non-zero if caseless matching
is in effect.  The subroutine may return different values depending on
the value of the flag, and one set of values will immutably be in effect
for all case-sensitive matches, and the other set for all case-insensitive
matches.
 
Note that if the regular expression is tainted, then Perl will die rather
than calling the subroutine when the name of the subroutine is
determined by the tainted data.
 
The subroutines must return a specially-formatted string, with one
or more newline-separated lines.  Each line must be one of the following:
 
=over 4
 
=item *
 
A single hexadecimal number denoting a code point to include.
 
=item *
 
Two hexadecimal numbers separated by horizontal whitespace (space or
tabular characters) denoting a range of code points to include.  The
second number must not be smaller than the first.
 
=item *
 
Something to include, prefixed by C<"+">: a built-in character
property (prefixed by C<"utf8::">) or a fully qualified (including package
name) user-defined character property,
to represent all the characters in that property; two hexadecimal code
points for a range; or a single hexadecimal code point.
 
=item *
 
Something to exclude, prefixed by C<"-">: an existing character
property (prefixed by C<"utf8::">) or a fully qualified (including package
name) user-defined character property,
to represent all the characters in that property; two hexadecimal code
points for a range; or a single hexadecimal code point.
 
=item *
 
Something to negate, prefixed C<"!">: an existing character
property (prefixed by C<"utf8::">) or a fully qualified (including package
name) user-defined character property,
to represent all the characters in that property; two hexadecimal code
points for a range; or a single hexadecimal code point.
 
=item *
 
Something to intersect with, prefixed by C<"&">: an existing character
property (prefixed by C<"utf8::">) or a fully qualified (including package
name) user-defined character property,
for all the characters except the characters in the property; two
hexadecimal code points for a range; or a single hexadecimal code point.
 
=back
 
For example, to define a property that covers both the Japanese
syllabaries (hiragana and katakana), you can define
 
    sub InKana {
        return <<END;
    3040\t309F
    30A0\t30FF
    END
    }
 
Imagine that the here-doc end marker is at the beginning of the line.
Now you can use C<\p{InKana}> and C<\P{InKana}>.
 
You could also have used the existing block property names:
 
    sub InKana {
        return <<'END';
    +utf8::InHiragana
    +utf8::InKatakana
    END
    }
 
Suppose you wanted to match only the allocated characters,
not the raw block ranges: in other words, you want to remove
the unassigned characters:
 
    sub InKana {
        return <<'END';
    +utf8::InHiragana
    +utf8::InKatakana
    -utf8::IsCn
    END
    }
 
The negation is useful for defining (surprise!) negated classes.
 
    sub InNotKana {
        return <<'END';
    !utf8::InHiragana
    -utf8::InKatakana
    +utf8::IsCn
    END
    }
 
This will match all non-Unicode code points, since every one of them is
not in Kana.  You can use intersection to exclude these, if desired, as
this modified example shows:
 
    sub InNotKana {
        return <<'END';
    !utf8::InHiragana
    -utf8::InKatakana
    +utf8::IsCn
    &utf8::Any
    END
    }
 
C<&utf8::Any> must be the last line in the definition.
 
Intersection is used generally for getting the common characters matched
by two (or more) classes.  It's important to remember not to use C<"&"> for
the first set; that would be intersecting with nothing, resulting in an
empty set.  (Similarly using C<"-"> for the first set does nothing).
 
Unlike non-user-defined C<\p{}> property matches, no warning is ever
generated if these properties are matched against a non-Unicode code
point (see L</Beyond Unicode code points> below).
 
=head2 User-Defined Case Mappings (for serious hackers only)
 
B<This feature has been removed as of Perl 5.16.>
The CPAN module C<L<Unicode::Casing>> provides better functionality without
the drawbacks that this feature had.  If you are using a Perl earlier
than 5.16, this feature was most fully documented in the 5.14 version of
this pod:
L<http://perldoc.perl.org/5.14.0/perlunicode.html#User-Defined-Case-Mappings-%28for-serious-hackers-only%29>
 
=head2 Character Encodings for Input and Output
 
See L<Encode>.
 
=head2 Unicode Regular Expression Support Level
 
The following list of Unicode supported features for regular expressions describes
all features currently directly supported by core Perl.  The references
to "Level I<N>" and the section numbers refer to
L<UTS#18 "Unicode Regular Expressions"|https://www.unicode.org/reports/tr18>,
version 18, October 2016.
 
=head3 Level 1 - Basic Unicode Support
 
 RL1.1   Hex Notation                     - Done          [1]
 RL1.2   Properties                       - Done          [2]
 RL1.2a  Compatibility Properties         - Done          [3]
 RL1.3   Subtraction and Intersection     - Experimental  [4]
 RL1.4   Simple Word Boundaries           - Done          [5]
 RL1.5   Simple Loose Matches             - Done          [6]
 RL1.6   Line Boundaries                  - Partial       [7]
 RL1.7   Supplementary Code Points        - Done          [8]
 
=over 4
 
=item [1] C<\N{U+...}> and C<\x{...}>
 
=item [2]
C<\p{...}> C<\P{...}>.  This requirement is for a minimal list of
properties.  Perl supports these.  See R2.7 for other properties.
 
=item [3]
Perl has C<\d> C<\D> C<\s> C<\S> C<\w> C<\W> C<\X> C<[:I<prop>:]>
C<[:^I<prop>:]>, plus all the properties specified by
L<https://www.unicode.org/reports/tr18/#Compatibility_Properties>.  These
are described above in L</Other Properties>
 
=item [4]
 
The experimental feature C<"(?[...])"> starting in v5.18 accomplishes
this.
 
See L<perlre/(?[ ])>.  If you don't want to use an experimental
feature, you can use one of the following:
 
=over 4
 
=item *
Regular expression lookahead
 
You can mimic class subtraction using lookahead.
For example, what UTS#18 might write as
 
    [{Block=Greek}-[{UNASSIGNED}]]
 
in Perl can be written as:
 
    (?!\p{Unassigned})\p{Block=Greek}
    (?=\p{Assigned})\p{Block=Greek}
 
But in this particular example, you probably really want
 
    \p{Greek}
 
which will match assigned characters known to be part of the Greek script.
 
=item *
 
CPAN module C<L<Unicode::Regex::Set>>
 
It does implement the full UTS#18 grouping, intersection, union, and
removal (subtraction) syntax.
 
=item *
 
L</"User-Defined Character Properties">
 
C<"+"> for union, C<"-"> for removal (set-difference), C<"&"> for intersection
 
=back
 
=item [5]
C<\b> C<\B> meet most, but not all, the details of this requirement, but
C<\b{wb}> and C<\B{wb}> do, as well as the stricter R2.3.
 
=item [6]
 
Note that Perl does Full case-folding in matching, not Simple:
 
For example C<U+1F88> is equivalent to C<U+1F00 U+03B9>, instead of just
C<U+1F80>.  This difference matters mainly for certain Greek capital
letters with certain modifiers: the Full case-folding decomposes the
letter, while the Simple case-folding would map it to a single
character.
 
=item [7]
 
The reason this is considered to be only partially implemented is that
Perl has L<C<qrE<sol>\b{lb}E<sol>>|perlrebackslash/\b{lb}> and
C<L<Unicode::LineBreak>> that are conformant with
L<UAX#14 "Unicode Line Breaking Algorithm"|https://www.unicode.org/reports/tr14>.
The regular expression construct provides default behavior, while the
heavier-weight module provides customizable line breaking.
 
But Perl treats C<\n> as the start- and end-line
delimiter, whereas Unicode specifies more characters that should be
so-interpreted.
 
These are:
 
 VT   U+000B  (\v in C)
 FF   U+000C  (\f)
 CR   U+000D  (\r)
 NEL  U+0085
 LS   U+2028
 PS   U+2029
 
C<^> and C<$> in regular expression patterns are supposed to match all
these, but don't.
These characters also don't, but should, affect C<< <> >> C<$.>, and
script line numbers.
 
Also, lines should not be split within C<CRLF> (i.e. there is no
empty line between C<\r> and C<\n>).  For C<CRLF>, try the C<:crlf>
layer (see L<PerlIO>).
 
=item [8]
UTF-8/UTF-EBDDIC used in Perl allows not only C<U+10000> to
C<U+10FFFF> but also beyond C<U+10FFFF>
 
=back
 
=head3 Level 2 - Extended Unicode Support
 
 RL2.1   Canonical Equivalents           - Retracted     [9]
                                           by Unicode
 RL2.2   Extended Grapheme Clusters and  - Partial       [10]
         Character Classes with Strings
 RL2.3   Default Word Boundaries         - Done          [11]
 RL2.4   Default Case Conversion         - Done
 RL2.5   Name Properties                 - Done
 RL2.6   Wildcards in Property Values    - Partial       [12]
 RL2.7   Full Properties                 - Partial       [13]
 RL2.8   Optional Properties             - Partial       [14]
 
=over 4
 
=item [9]
Unicode has rewritten this portion of UTS#18 to say that getting
canonical equivalence (see UAX#15
L<"Unicode Normalization Forms"|https://www.unicode.org/reports/tr15>)
is basically to be done at the programmer level.  Use NFD to write
both your regular expressions and text to match them against (you
can use L<Unicode::Normalize>).
 
=item [10]
Perl has C<\X> and C<\b{gcb}>.  Unicode has retracted their "Grapheme
Cluster Mode", and recently added string properties, which Perl does not
yet support.
 
=item [11] see
L<UAX#29 "Unicode Text Segmentation"|https://www.unicode.org/reports/tr29>,
 
=item [12] see
L</Wildcards in Property Values> above.
 
=item [13]
Perl supports all the properties in the Unicode Character Database
(UCD).  It does not yet support the listed properties that come from
other Unicode sources.
 
=item [14]
The only optional property that Perl supports is Named Sequence.  None
of these properties are in the UCD.
 
=back
 
=head3 Level 3 - Tailored Support
 
This has been retracted by Unicode.
 
=head2 Unicode Encodings
 
Unicode characters are assigned to I<code points>, which are abstract
numbers.  To use these numbers, various encodings are needed.
 
=over 4
 
=item *
 
UTF-8
 
UTF-8 is a variable-length (1 to 4 bytes), byte-order independent
encoding.  In most of Perl's documentation, including elsewhere in this
document, the term "UTF-8" means also "UTF-EBCDIC".  But in this section,
"UTF-8" refers only to the encoding used on ASCII platforms.  It is a
superset of 7-bit US-ASCII, so anything encoded in ASCII has the
identical representation when encoded in UTF-8.
 
The following table is from Unicode 3.2.
 
 Code Points            1st Byte  2nd Byte  3rd Byte 4th Byte
 
   U+0000..U+007F       00..7F
   U+0080..U+07FF     * C2..DF    80..BF
   U+0800..U+0FFF       E0      * A0..BF    80..BF
   U+1000..U+CFFF       E1..EC    80..BF    80..BF
   U+D000..U+D7FF       ED        80..9F    80..BF
   U+D800..U+DFFF       +++++ utf16 surrogates, not legal utf8 +++++
   U+E000..U+FFFF       EE..EF    80..BF    80..BF
  U+10000..U+3FFFF      F0      * 90..BF    80..BF    80..BF
  U+40000..U+FFFFF      F1..F3    80..BF    80..BF    80..BF
 U+100000..U+10FFFF     F4        80..8F    80..BF    80..BF
 
Note the gaps marked by "*" before several of the byte entries above.  These are
caused by legal UTF-8 avoiding non-shortest encodings: it is technically
possible to UTF-8-encode a single code point in different ways, but that is
explicitly forbidden, and the shortest possible encoding should always be used
(and that is what Perl does).
 
Another way to look at it is via bits:
 
                Code Points  1st Byte  2nd Byte  3rd Byte  4th Byte
 
                   0aaaaaaa  0aaaaaaa
           00000bbbbbaaaaaa  110bbbbb  10aaaaaa
           ccccbbbbbbaaaaaa  1110cccc  10bbbbbb  10aaaaaa
 00000dddccccccbbbbbbaaaaaa  11110ddd  10cccccc  10bbbbbb  10aaaaaa
 
As you can see, the continuation bytes all begin with C<"10">, and the
leading bits of the start byte tell how many bytes there are in the
encoded character.
 
The original UTF-8 specification allowed up to 6 bytes, to allow
encoding of numbers up to C<0x7FFF_FFFF>.  Perl continues to allow those,
and has extended that up to 13 bytes to encode code points up to what
can fit in a 64-bit word.  However, Perl will warn if you output any of
these as being non-portable; and under strict UTF-8 input protocols,
they are forbidden.  In addition, it is now illegal to use a code point
larger than what a signed integer variable on your system can hold.  On
32-bit ASCII systems, this means C<0x7FFF_FFFF> is the legal maximum
(much higher on 64-bit systems).
 
=item *
 
UTF-EBCDIC
 
Like UTF-8, but EBCDIC-safe, in the way that UTF-8 is ASCII-safe.
This means that all the basic characters (which includes all
those that have ASCII equivalents (like C<"A">, C<"0">, C<"%">, I<etc.>)
are the same in both EBCDIC and UTF-EBCDIC.)
 
UTF-EBCDIC is used on EBCDIC platforms.  It generally requires more
bytes to represent a given code point than UTF-8 does; the largest
Unicode code points take 5 bytes to represent (instead of 4 in UTF-8),
and, extended for 64-bit words, it uses 14 bytes instead of 13 bytes in
UTF-8.
 
=item *
 
UTF-16, UTF-16BE, UTF-16LE, Surrogates, and C<BOM>'s (Byte Order Marks)
 
The followings items are mostly for reference and general Unicode
knowledge, Perl doesn't use these constructs internally.
 
Like UTF-8, UTF-16 is a variable-width encoding, but where
UTF-8 uses 8-bit code units, UTF-16 uses 16-bit code units.
All code points occupy either 2 or 4 bytes in UTF-16: code points
C<U+0000..U+FFFF> are stored in a single 16-bit unit, and code
points C<U+10000..U+10FFFF> in two 16-bit units.  The latter case is
using I<surrogates>, the first 16-bit unit being the I<high
surrogate>, and the second being the I<low surrogate>.
 
Surrogates are code points set aside to encode the C<U+10000..U+10FFFF>
range of Unicode code points in pairs of 16-bit units.  The I<high
surrogates> are the range C<U+D800..U+DBFF> and the I<low surrogates>
are the range C<U+DC00..U+DFFF>.  The surrogate encoding is
 
    $hi = ($uni - 0x10000) / 0x400 + 0xD800;
    $lo = ($uni - 0x10000) % 0x400 + 0xDC00;
 
and the decoding is
 
    $uni = 0x10000 + ($hi - 0xD800) * 0x400 + ($lo - 0xDC00);
 
Because of the 16-bitness, UTF-16 is byte-order dependent.  UTF-16
itself can be used for in-memory computations, but if storage or
transfer is required either UTF-16BE (big-endian) or UTF-16LE
(little-endian) encodings must be chosen.
 
This introduces another problem: what if you just know that your data
is UTF-16, but you don't know which endianness?  Byte Order Marks, or
C<BOM>'s, are a solution to this.  A special character has been reserved
in Unicode to function as a byte order marker: the character with the
code point C<U+FEFF> is the C<BOM>.
 
The trick is that if you read a C<BOM>, you will know the byte order,
since if it was written on a big-endian platform, you will read the
bytes C<0xFE 0xFF>, but if it was written on a little-endian platform,
you will read the bytes C<0xFF 0xFE>.  (And if the originating platform
was writing in ASCII platform UTF-8, you will read the bytes
C<0xEF 0xBB 0xBF>.)
 
The way this trick works is that the character with the code point
C<U+FFFE> is not supposed to be in input streams, so the
sequence of bytes C<0xFF 0xFE> is unambiguously "C<BOM>, represented in
little-endian format" and cannot be C<U+FFFE>, represented in big-endian
format".
 
Surrogates have no meaning in Unicode outside their use in pairs to
represent other code points.  However, Perl allows them to be
represented individually internally, for example by saying
C<chr(0xD801)>, so that all code points, not just those valid for open
interchange, are
representable.  Unicode does define semantics for them, such as their
C<L</General_Category>> is C<"Cs">.  But because their use is somewhat dangerous,
Perl will warn (using the warning category C<"surrogate">, which is a
sub-category of C<"utf8">) if an attempt is made
to do things like take the lower case of one, or match
case-insensitively, or to output them.  (But don't try this on Perls
before 5.14.)
 
=item *
 
UTF-32, UTF-32BE, UTF-32LE
 
The UTF-32 family is pretty much like the UTF-16 family, except that
the units are 32-bit, and therefore the surrogate scheme is not
needed.  UTF-32 is a fixed-width encoding.  The C<BOM> signatures are
C<0x00 0x00 0xFE 0xFF> for BE and C<0xFF 0xFE 0x00 0x00> for LE.
 
=item *
 
UCS-2, UCS-4
 
Legacy, fixed-width encodings defined by the ISO 10646 standard.  UCS-2 is a 16-bit
encoding.  Unlike UTF-16, UCS-2 is not extensible beyond C<U+FFFF>,
because it does not use surrogates.  UCS-4 is a 32-bit encoding,
functionally identical to UTF-32 (the difference being that
UCS-4 forbids neither surrogates nor code points larger than C<0x10_FFFF>).
 
=item *
 
UTF-7
 
A seven-bit safe (non-eight-bit) encoding, which is useful if the
transport or storage is not eight-bit safe.  Defined by RFC 2152.
 
=back
 
=head2 Noncharacter code points
 
66 code points are set aside in Unicode as "noncharacter code points".
These all have the C<Unassigned> (C<Cn>) C<L</General_Category>>, and
no character will ever be assigned to any of them.  They are the 32 code
points between C<U+FDD0> and C<U+FDEF> inclusive, and the 34 code
points:
 
 U+FFFE   U+FFFF
 U+1FFFE  U+1FFFF
 U+2FFFE  U+2FFFF
 ...
 U+EFFFE  U+EFFFF
 U+FFFFE  U+FFFFF
 U+10FFFE U+10FFFF
 
Until Unicode 7.0, the noncharacters were "B<forbidden> for use in open
interchange of Unicode text data", so that code that processed those
streams could use these code points as sentinels that could be mixed in
with character data, and would always be distinguishable from that data.
(Emphasis above and in the next paragraph are added in this document.)
 
Unicode 7.0 changed the wording so that they are "B<not recommended> for
use in open interchange of Unicode text data".  The 7.0 Standard goes on
to say:
 
=over 4
 
"If a noncharacter is received in open interchange, an application is
not required to interpret it in any way.  It is good practice, however,
to recognize it as a noncharacter and to take appropriate action, such
as replacing it with C<U+FFFD> replacement character, to indicate the
problem in the text.  It is not recommended to simply delete
noncharacter code points from such text, because of the potential
security issues caused by deleting uninterpreted characters.  (See
conformance clause C7 in Section 3.2, Conformance Requirements, and
L<Unicode Technical Report #36, "Unicode Security
Considerations"|https://www.unicode.org/reports/tr36/#Substituting_for_Ill_Formed_Subsequences>)."
 
=back
 
This change was made because it was found that various commercial tools
like editors, or for things like source code control, had been written
so that they would not handle program files that used these code points,
effectively precluding their use almost entirely!  And that was never
the intent.  They've always been meant to be usable within an
application, or cooperating set of applications, at will.
 
If you're writing code, such as an editor, that is supposed to be able
to handle any Unicode text data, then you shouldn't be using these code
points yourself, and instead allow them in the input.  If you need
sentinels, they should instead be something that isn't legal Unicode.
For UTF-8 data, you can use the bytes 0xC1 and 0xC2 as sentinels, as
they never appear in well-formed UTF-8.  (There are equivalents for
UTF-EBCDIC).  You can also store your Unicode code points in integer
variables and use negative values as sentinels.
 
If you're not writing such a tool, then whether you accept noncharacters
as input is up to you (though the Standard recommends that you not).  If
you do strict input stream checking with Perl, these code points
continue to be forbidden.  This is to maintain backward compatibility
(otherwise potential security holes could open up, as an unsuspecting
application that was written assuming the noncharacters would be
filtered out before getting to it, could now, without warning, start
getting them).  To do strict checking, you can use the layer
C<:encoding('UTF-8')>.
 
Perl continues to warn (using the warning category C<"nonchar">, which
is a sub-category of C<"utf8">) if an attempt is made to output
noncharacters.
 
=head2 Beyond Unicode code points
 
The maximum Unicode code point is C<U+10FFFF>, and Unicode only defines
operations on code points up through that.  But Perl works on code
points up to the maximum permissible signed number available on the
platform.  However, Perl will not accept these from input streams unless
lax rules are being used, and will warn (using the warning category
C<"non_unicode">, which is a sub-category of C<"utf8">) if any are output.
 
Since Unicode rules are not defined on these code points, if a
Unicode-defined operation is done on them, Perl uses what we believe are
sensible rules, while generally warning, using the C<"non_unicode">
category.  For example, C<uc("\x{11_0000}")> will generate such a
warning, returning the input parameter as its result, since Perl defines
the uppercase of every non-Unicode code point to be the code point
itself.  (All the case changing operations, not just uppercasing, work
this way.)
 
The situation with matching Unicode properties in regular expressions,
the C<\p{}> and C<\P{}> constructs, against these code points is not as
clear cut, and how these are handled has changed as we've gained
experience.
 
One possibility is to treat any match against these code points as
undefined.  But since Perl doesn't have the concept of a match being
undefined, it converts this to failing or C<FALSE>.  This is almost, but
not quite, what Perl did from v5.14 (when use of these code points
became generally reliable) through v5.18.  The difference is that Perl
treated all C<\p{}> matches as failing, but all C<\P{}> matches as
succeeding.
 
One problem with this is that it leads to unexpected, and confusing
results in some cases:
 
 chr(0x110000) =~ \p{ASCII_Hex_Digit=True}      # Failed on <= v5.18
 chr(0x110000) =~ \p{ASCII_Hex_Digit=False}     # Failed! on <= v5.18
 
That is, it treated both matches as undefined, and converted that to
false (raising a warning on each).  The first case is the expected
result, but the second is likely counterintuitive: "How could both be
false when they are complements?"  Another problem was that the
implementation optimized many Unicode property matches down to already
existing simpler, faster operations, which don't raise the warning.  We
chose to not forgo those optimizations, which help the vast majority of
matches, just to generate a warning for the unlikely event that an
above-Unicode code point is being matched against.
 
As a result of these problems, starting in v5.20, what Perl does is
to treat non-Unicode code points as just typical unassigned Unicode
characters, and matches accordingly.  (Note: Unicode has atypical
unassigned code points.  For example, it has noncharacter code points,
and ones that, when they do get assigned, are destined to be written
Right-to-left, as Arabic and Hebrew are.  Perl assumes that no
non-Unicode code point has any atypical properties.)
 
Perl, in most cases, will raise a warning when matching an above-Unicode
code point against a Unicode property when the result is C<TRUE> for
C<\p{}>, and C<FALSE> for C<\P{}>.  For example:
 
 chr(0x110000) =~ \p{ASCII_Hex_Digit=True}      # Fails, no warning
 chr(0x110000) =~ \p{ASCII_Hex_Digit=False}     # Succeeds, with warning
 
In both these examples, the character being matched is non-Unicode, so
Unicode doesn't define how it should match.  It clearly isn't an ASCII
hex digit, so the first example clearly should fail, and so it does,
with no warning.  But it is arguable that the second example should have
an undefined, hence C<FALSE>, result.  So a warning is raised for it.
 
Thus the warning is raised for many fewer cases than in earlier Perls,
and only when what the result is could be arguable.  It turns out that
none of the optimizations made by Perl (or are ever likely to be made)
cause the warning to be skipped, so it solves both problems of Perl's
earlier approach.  The most commonly used property that is affected by
this change is C<\p{Unassigned}> which is a short form for
C<\p{General_Category=Unassigned}>.  Starting in v5.20, all non-Unicode
code points are considered C<Unassigned>.  In earlier releases the
matches failed because the result was considered undefined.
 
The only place where the warning is not raised when it might ought to
have been is if optimizations cause the whole pattern match to not even
be attempted.  For example, Perl may figure out that for a string to
match a certain regular expression pattern, the string has to contain
the substring C<"foobar">.  Before attempting the match, Perl may look
for that substring, and if not found, immediately fail the match without
actually trying it; so no warning gets generated even if the string
contains an above-Unicode code point.
 
This behavior is more "Do what I mean" than in earlier Perls for most
applications.  But it catches fewer issues for code that needs to be
strictly Unicode compliant.  Therefore there is an additional mode of
operation available to accommodate such code.  This mode is enabled if a
regular expression pattern is compiled within the lexical scope where
the C<"non_unicode"> warning class has been made fatal, say by:
 
 use warnings FATAL => "non_unicode"
 
(see L<warnings>).  In this mode of operation, Perl will raise the
warning for all matches against a non-Unicode code point (not just the
arguable ones), and it skips the optimizations that might cause the
warning to not be output.  (It currently still won't warn if the match
isn't even attempted, like in the C<"foobar"> example above.)
 
In summary, Perl now normally treats non-Unicode code points as typical
Unicode unassigned code points for regular expression matches, raising a
warning only when it is arguable what the result should be.  However, if
this warning has been made fatal, it isn't skipped.
 
There is one exception to all this.  C<\p{All}> looks like a Unicode
property, but it is a Perl extension that is defined to be true for all
possible code points, Unicode or not, so no warning is ever generated
when matching this against a non-Unicode code point.  (Prior to v5.20,
it was an exact synonym for C<\p{Any}>, matching code points C<0>
through C<0x10FFFF>.)
 
=head2 Security Implications of Unicode
 
First, read
L<Unicode Security Considerations|https://www.unicode.org/reports/tr36>.
 
Also, note the following:
 
=over 4
 
=item *
 
Malformed UTF-8
 
UTF-8 is very structured, so many combinations of bytes are invalid.  In
the past, Perl tried to soldier on and make some sense of invalid
combinations, but this can lead to security holes, so now, if the Perl
core needs to process an invalid combination, it will either raise a
fatal error, or will replace those bytes by the sequence that forms the
Unicode REPLACEMENT CHARACTER, for which purpose Unicode created it.
 
Every code point can be represented by more than one possible
syntactically valid UTF-8 sequence.  Early on, both Unicode and Perl
considered any of these to be valid, but now, all sequences longer
than the shortest possible one are considered to be malformed.
 
Unicode considers many code points to be illegal, or to be avoided.
Perl generally accepts them, once they have passed through any input
filters that may try to exclude them.  These have been discussed above
(see "Surrogates" under UTF-16 in L</Unicode Encodings>,
L</Noncharacter code points>, and L</Beyond Unicode code points>).
 
=item *
 
Regular expression pattern matching may surprise you if you're not
accustomed to Unicode.  Starting in Perl 5.14, several pattern
modifiers are available to control this, called the character set
modifiers.  Details are given in L<perlre/Character set modifiers>.
 
=back
 
As discussed elsewhere, Perl has one foot (two hooves?) planted in
each of two worlds: the old world of ASCII and single-byte locales, and
the new world of Unicode, upgrading when necessary.
If your legacy code does not explicitly use Unicode, no automatic
switch-over to Unicode should happen.
 
=head2 Unicode in Perl on EBCDIC
 
Unicode is supported on EBCDIC platforms.  See L<perlebcdic>.
 
Unless ASCII vs. EBCDIC issues are specifically being discussed,
references to UTF-8 encoding in this document and elsewhere should be
read as meaning UTF-EBCDIC on EBCDIC platforms.
See L<perlebcdic/Unicode and UTF>.
 
Because UTF-EBCDIC is so similar to UTF-8, the differences are mostly
hidden from you; S<C<use utf8>> (and NOT something like
S<C<use utfebcdic>>) declares the script is in the platform's
"native" 8-bit encoding of Unicode.  (Similarly for the C<":utf8">
layer.)
 
=head2 Locales
 
See L<perllocale/Unicode and UTF-8>
 
=head2 When Unicode Does Not Happen
 
There are still many places where Unicode (in some encoding or
another) could be given as arguments or received as results, or both in
Perl, but it is not, in spite of Perl having extensive ways to input and
output in Unicode, and a few other "entry points" like the C<@ARGV>
array (which can sometimes be interpreted as UTF-8).
 
The following are such interfaces.  Also, see L</The "Unicode Bug">.
For all of these interfaces Perl
currently (as of v5.16.0) simply assumes byte strings both as arguments
and results, or UTF-8 strings if the (deprecated) C<encoding> pragma has been used.
 
One reason that Perl does not attempt to resolve the role of Unicode in
these situations is that the answers are highly dependent on the operating
system and the file system(s).  For example, whether filenames can be
in Unicode and in exactly what kind of encoding, is not exactly a
portable concept.  Similarly for C<qx> and C<system>: how well will the
"command-line interface" (and which of them?) handle Unicode?
 
=over 4
 
=item *
 
C<chdir>, C<chmod>, C<chown>, C<chroot>, C<exec>, C<link>, C<lstat>, C<mkdir>,
C<rename>, C<rmdir>, C<stat>, C<symlink>, C<truncate>, C<unlink>, C<utime>, C<-X>
 
=item *
 
C<%ENV>
 
=item *
 
C<glob> (aka the C<E<lt>*E<gt>>)
 
=item *
 
C<open>, C<opendir>, C<sysopen>
 
=item *
 
C<qx> (aka the backtick operator), C<system>
 
=item *
 
C<readdir>, C<readlink>
 
=back
 
=head2 The "Unicode Bug"
 
The term, "Unicode bug" has been applied to an inconsistency with the
code points in the C<Latin-1 Supplement> block, that is, between
128 and 255.  Without a locale specified, unlike all other characters or
code points, these characters can have very different semantics
depending on the rules in effect.  (Characters whose code points are
above 255 force Unicode rules; whereas the rules for ASCII characters
are the same under both ASCII and Unicode rules.)
 
Under Unicode rules, these upper-Latin1 characters are interpreted as
Unicode code points, which means they have the same semantics as Latin-1
(ISO-8859-1) and C1 controls.
 
As explained in L</ASCII Rules versus Unicode Rules>, under ASCII rules,
they are considered to be unassigned characters.
 
This can lead to unexpected results.  For example, a string's
semantics can suddenly change if a code point above 255 is appended to
it, which changes the rules from ASCII to Unicode.  As an
example, consider the following program and its output:
 
 $ perl -le'
     no feature "unicode_strings";
     $s1 = "\xC2";
     $s2 = "\x{2660}";
     for ($s1, $s2, $s1.$s2) {
         print /\w/ || 0;
     }
 '
 0
 0
 1
 
If there's no C<\w> in C<s1> nor in C<s2>, why does their concatenation
have one?
 
This anomaly stems from Perl's attempt to not disturb older programs that
didn't use Unicode, along with Perl's desire to add Unicode support
seamlessly.  But the result turned out to not be seamless.  (By the way,
you can choose to be warned when things like this happen.  See
C<L<encoding::warnings>>.)
 
L<S<C<use feature 'unicode_strings'>>|feature/The 'unicode_strings' feature>
was added, starting in Perl v5.12, to address this problem.  It affects
these things:
 
=over 4
 
=item *
 
Changing the case of a scalar, that is, using C<uc()>, C<ucfirst()>, C<lc()>,
and C<lcfirst()>, or C<\L>, C<\U>, C<\u> and C<\l> in double-quotish
contexts, such as regular expression substitutions.
 
Under C<unicode_strings> starting in Perl 5.12.0, Unicode rules are
generally used.  See L<perlfunc/lc> for details on how this works
in combination with various other pragmas.
 
=item *
 
Using caseless (C</i>) regular expression matching.
 
Starting in Perl 5.14.0, regular expressions compiled within
the scope of C<unicode_strings> use Unicode rules
even when executed or compiled into larger
regular expressions outside the scope.
 
=item *
 
Matching any of several properties in regular expressions.
 
These properties are C<\b> (without braces), C<\B> (without braces),
C<\s>, C<\S>, C<\w>, C<\W>, and all the Posix character classes
I<except> C<[[:ascii:]]>.
 
Starting in Perl 5.14.0, regular expressions compiled within
the scope of C<unicode_strings> use Unicode rules
even when executed or compiled into larger
regular expressions outside the scope.
 
=item *
 
In C<quotemeta> or its inline equivalent C<\Q>.
 
Starting in Perl 5.16.0, consistent quoting rules are used within the
scope of C<unicode_strings>, as described in L<perlfunc/quotemeta>.
Prior to that, or outside its scope, no code points above 127 are quoted
in UTF-8 encoded strings, but in byte encoded strings, code points
between 128-255 are always quoted.
 
=item *
 
In the C<..> or L<range|perlop/Range Operators> operator.
 
Starting in Perl 5.26.0, the range operator on strings treats their lengths
consistently within the scope of C<unicode_strings>. Prior to that, or
outside its scope, it could produce strings whose length in characters
exceeded that of the right-hand side, where the right-hand side took up more
bytes than the correct range endpoint.
 
=item *
 
In L<< C<split>'s special-case whitespace splitting|perlfunc/split >>.
 
Starting in Perl 5.28.0, the C<split> function with a pattern specified as
a string containing a single space handles whitespace characters consistently
within the scope of C<unicode_strings>. Prior to that, or outside its scope,
characters that are whitespace according to Unicode rules but not according to
ASCII rules were treated as field contents rather than field separators when
they appear in byte-encoded strings.
 
=back
 
You can see from the above that the effect of C<unicode_strings>
increased over several Perl releases.  (And Perl's support for Unicode
continues to improve; it's best to use the latest available release in
order to get the most complete and accurate results possible.)  Note that
C<unicode_strings> is automatically chosen if you S<C<use 5.012>> or
higher.
 
For Perls earlier than those described above, or when a string is passed
to a function outside the scope of C<unicode_strings>, see the next section.
 
=head2 Forcing Unicode in Perl (Or Unforcing Unicode in Perl)
 
Sometimes (see L</"When Unicode Does Not Happen"> or L</The "Unicode Bug">)
there are situations where you simply need to force a byte
string into UTF-8, or vice versa.  The standard module L<Encode> can be
used for this, or the low-level calls
L<C<utf8::upgrade($bytestring)>|utf8/Utility functions> and
L<C<utf8::downgrade($utf8string[, FAIL_OK])>|utf8/Utility functions>.
 
Note that C<utf8::downgrade()> can fail if the string contains characters
that don't fit into a byte.
 
Calling either function on a string that already is in the desired state is a
no-op.
 
L</ASCII Rules versus Unicode Rules> gives all the ways that a string is
made to use Unicode rules.
 
=head2 Using Unicode in XS
 
See L<perlguts/"Unicode Support"> for an introduction to Unicode at
the XS level, and L<perlapi/Unicode Support> for the API details.
 
=head2 Hacking Perl to work on earlier Unicode versions (for very serious hackers only)
 
Perl by default comes with the latest supported Unicode version built-in, but
the goal is to allow you to change to use any earlier one.  In Perls
v5.20 and v5.22, however, the earliest usable version is Unicode 5.1.
Perl v5.18 and v5.24 are able to handle all earlier versions.
 
Download the files in the desired version of Unicode from the Unicode web
site L<https://www.unicode.org>).  These should replace the existing files in
F<lib/unicore> in the Perl source tree.  Follow the instructions in
F<README.perl> in that directory to change some of their names, and then build
perl (see L<INSTALL>).
 
=head2 Porting code from perl-5.6.X
 
Perls starting in 5.8 have a different Unicode model from 5.6. In 5.6 the
programmer was required to use the C<utf8> pragma to declare that a
given scope expected to deal with Unicode data and had to make sure that
only Unicode data were reaching that scope. If you have code that is
working with 5.6, you will need some of the following adjustments to
your code. The examples are written such that the code will continue to
work under 5.6, so you should be safe to try them out.
 
=over 3
 
=item *
 
A filehandle that should read or write UTF-8
 
  if ($] > 5.008) {
    binmode $fh, ":encoding(UTF-8)";
  }
 
=item *
 
A scalar that is going to be passed to some extension
 
Be it C<Compress::Zlib>, C<Apache::Request> or any extension that has no
mention of Unicode in the manpage, you need to make sure that the
UTF8 flag is stripped off. Note that at the time of this writing
(January 2012) the mentioned modules are not UTF-8-aware. Please
check the documentation to verify if this is still true.
 
  if ($] > 5.008) {
    require Encode;
    $val = Encode::encode("UTF-8", $val); # make octets
  }
 
=item *
 
A scalar we got back from an extension
 
If you believe the scalar comes back as UTF-8, you will most likely
want the UTF8 flag restored:
 
  if ($] > 5.008) {
    require Encode;
    $val = Encode::decode("UTF-8", $val);
  }
 
=item *
 
Same thing, if you are really sure it is UTF-8
 
  if ($] > 5.008) {
    require Encode;
    Encode::_utf8_on($val);
  }
 
=item *
 
A wrapper for L<DBI> C<fetchrow_array> and C<fetchrow_hashref>
 
When the database contains only UTF-8, a wrapper function or method is
a convenient way to replace all your C<fetchrow_array> and
C<fetchrow_hashref> calls. A wrapper function will also make it easier to
adapt to future enhancements in your database driver. Note that at the
time of this writing (January 2012), the DBI has no standardized way
to deal with UTF-8 data. Please check the L<DBI documentation|DBI> to verify if
that is still true.
 
  sub fetchrow {
    # $what is one of fetchrow_{array,hashref}
    my($self, $sth, $what) = @_;
    if ($] < 5.008) {
      return $sth->$what;
    } else {
      require Encode;
      if (wantarray) {
        my @arr = $sth->$what;
        for (@arr) {
          defined && /[^\000-\177]/ && Encode::_utf8_on($_);
        }
        return @arr;
      } else {
        my $ret = $sth->$what;
        if (ref $ret) {
          for my $k (keys %$ret) {
            defined
            && /[^\000-\177]/
            && Encode::_utf8_on($_) for $ret->{$k};
          }
          return $ret;
        } else {
          defined && /[^\000-\177]/ && Encode::_utf8_on($_) for $ret;
          return $ret;
        }
      }
    }
  }
 
 
=item *
 
A large scalar that you know can only contain ASCII
 
Scalars that contain only ASCII and are marked as UTF-8 are sometimes
a drag to your program. If you recognize such a situation, just remove
the UTF8 flag:
 
  utf8::downgrade($val) if $] > 5.008;
 
=back
 
=head1 BUGS
 
See also L</The "Unicode Bug"> above.
 
=head2 Interaction with Extensions
 
When Perl exchanges data with an extension, the extension should be
able to understand the UTF8 flag and act accordingly. If the
extension doesn't recognize that flag, it's likely that the extension
will return incorrectly-flagged data.
 
So if you're working with Unicode data, consult the documentation of
every module you're using if there are any issues with Unicode data
exchange. If the documentation does not talk about Unicode at all,
suspect the worst and probably look at the source to learn how the
module is implemented. Modules written completely in Perl shouldn't
cause problems. Modules that directly or indirectly access code written
in other programming languages are at risk.
 
For affected functions, the simple strategy to avoid data corruption is
to always make the encoding of the exchanged data explicit. Choose an
encoding that you know the extension can handle. Convert arguments passed
to the extensions to that encoding and convert results back from that
encoding. Write wrapper functions that do the conversions for you, so
you can later change the functions when the extension catches up.
 
To provide an example, let's say the popular C<Foo::Bar::escape_html>
function doesn't deal with Unicode data yet. The wrapper function
would convert the argument to raw UTF-8 and convert the result back to
Perl's internal representation like so:
 
    sub my_escape_html ($) {
        my($what) = shift;
        return unless defined $what;
        Encode::decode("UTF-8", Foo::Bar::escape_html(
                                     Encode::encode("UTF-8", $what)));
    }
 
Sometimes, when the extension does not convert data but just stores
and retrieves it, you will be able to use the otherwise
dangerous L<C<Encode::_utf8_on()>|Encode/_utf8_on> function. Let's say
the popular C<Foo::Bar> extension, written in C, provides a C<param>
method that lets you store and retrieve data according to these prototypes:
 
    $self->param($name, $value);            # set a scalar
    $value = $self->param($name);           # retrieve a scalar
 
If it does not yet provide support for any encoding, one could write a
derived class with such a C<param> method:
 
    sub param {
      my($self,$name,$value) = @_;
      utf8::upgrade($name);     # make sure it is UTF-8 encoded
      if (defined $value) {
        utf8::upgrade($value);  # make sure it is UTF-8 encoded
        return $self->SUPER::param($name,$value);
      } else {
        my $ret = $self->SUPER::param($name);
        Encode::_utf8_on($ret); # we know, it is UTF-8 encoded
        return $ret;
      }
    }
 
Some extensions provide filters on data entry/exit points, such as
C<DB_File::filter_store_key> and family. Look out for such filters in
the documentation of your extensions; they can make the transition to
Unicode data much easier.
 
=head2 Speed
 
Some functions are slower when working on UTF-8 encoded strings than
on byte encoded strings.  All functions that need to hop over
characters such as C<length()>, C<substr()> or C<index()>, or matching
regular expressions can work B<much> faster when the underlying data are
byte-encoded.
 
In Perl 5.8.0 the slowness was often quite spectacular; in Perl 5.8.1
a caching scheme was introduced which improved the situation.  In general,
operations with UTF-8 encoded strings are still slower. As an example,
the Unicode properties (character classes) like C<\p{Nd}> are known to
be quite a bit slower (5-20 times) than their simpler counterparts
like C<[0-9]> (then again, there are hundreds of Unicode characters matching
C<Nd> compared with the 10 ASCII characters matching C<[0-9]>).
 
=head1 SEE ALSO
 
L<perlunitut>, L<perluniintro>, L<perluniprops>, L<Encode>, L<open>, L<utf8>, L<bytes>,
L<perlretut>, L<perlvar/"${^UNICODE}">,
L<https://www.unicode.org/reports/tr44>).
 
=cut