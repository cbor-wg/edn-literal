---
v: 3

title: >
  CBOR Extended Diagnostic Notation (EDN)
docname: draft-ietf-cbor-edn-literals-latest
# date: 2024-08-24

keyword: Internet-Draft
cat: info
stream: IETF
# consensus: true

pi: [toc, sortrefs, symrefs, compact, comments]

author:
  -
    ins: C. Bormann
    name: Carsten Bormann
    org: Universität Bremen TZI
    street: Postfach 330440
    city: Bremen
    code: D-28359
    country: Germany
    phone: +49-421-218-63921
    email: cabo@tzi.org

venue:
  mail: cbor@ietf.org
  github: cbor-wg/edn-literal
  latest: "https://cbor-wg.github.io/edn-literal/"

normative:
  STD94: cbor
  RFC8742: seq
  STD68: abnf
  RFC7405: abnfcs
  RFC3339: datetime
  RFC3986: uri
  RFC9164: iptag
  IANA.cbor-tags: tags
  IANA.media-types:
  IANA.core-parameters:
  BCP26: ianacons
  STD80: ascii
  IEEE754:
    target: https://ieeexplore.ieee.org/document/8766229
    title: IEEE Standard for Floating-Point Arithmetic
    author:
    - org: IEEE
    date: false
    seriesinfo:
      IEEE Std: 754-2019
      DOI: 10.1109/IEEESTD.2019.8766229
  C:
    target: https://www.iso.org/standard/74528.html
    title: Information technology — Programming languages — C
    author:
    - org: International Organization for Standardization
    date: 2018-06
    seriesinfo:
      ISO/IEC: 9899:2018
    refcontent:
    - Fourth Edition
    annotation: The text of the standard is also available via https://www.open-std.org/jtc1/sc22/wg14/www/docs/n2310.pdf
  Cplusplus:
    target: https://www.iso.org/standard/79358.html
    title: Programming languages — C++
    author:
    - org: International Organization for Standardization
    date: 2020-12
    seriesinfo:
      ISO/IEC: 14882:2020
    refcontent:
    - Sixth Edition
    annotation: The text of the standard is also available via https://isocpp.org/files/papers/N4860.pdf
informative:
  RFC8610: cddl
  RFC7049: old-cbor
  RFC4648: base
  RFC9290: pd
  STD90: json
  RFC7493: i-json
  I-D.bormann-cbor-numbers: numbers
  RFC9165: controls
  I-D.ietf-cbor-update-8610-grammar: cddlupd
  I-D.ietf-cbor-edn-e-ref: eref
  I-D.bormann-t2trg-deref-id: deref
  RFC9512: yaml-media-type
  YAML:
    target: https://yaml.org/spec/1.2.2/
    title: YAML Ain't Markup Language (YAML™) Version 1.2
    author:
    - name: Oren Ben-Kiki
    - name: Clark Evans
    - name: Ingy | döt Net
    date: 2021-10-01
    refcontent:
    - Revision 1.2.2

--- abstract

[^abs0-]: The Concise Binary Object Representation (CBOR) (STD 94, RFC 8949)
    is a data format whose design goals include the possibility of
    extremely small code size, fairly small message size, and
    extensibility without the need for version negotiation.

[^abs0-]

[^abs1a-]: In addition to the binary interchange format, CBOR from the outset

[^abs1b-]: defined a text-based "diagnostic notation" in
    order to be able to converse about CBOR data items without having
    to resort to binary data.

[^abs1c-]:
    extended this into what is known as Extended Diagnostic
    Notation (EDN).

[^abs1a-] (RFC 7049) [^abs1b-] RFC 8610 [^abs1c-]

[^abs3-]: This document consolidates the definition of EDN, sets forth
    a further step of its evolution,
    and is intended to serve as a single reference target in
    specifications that use EDN.

    It specifies an extension point for adding application-oriented extensions to
    the diagnostic notation.
    It then defines two such extensions that enhance EDN with text
    representations of epoch-based date/times and of IP addresses
    and prefixes

​[^abs3-] (RFC 9164).

[^abs4a-]: A few further additions close some gaps in usability.
     The document modifies one extension originally specified in

[^abs4a-] Appendix G.4 of RFC 8610 [^abs4b-], and it adds media types.

[^abs4b-]: to enable further increasing usability.
     To facilitate tool interoperation, this document
     specifies a formal ABNF grammar


--- middle

Introduction        {#intro}
============

[^abs0-]

[^abs1a-] ({{Section 6 of RFC7049}}, now {{Section 8 of RFC8949@-cbor}}) [^abs1b-] {{Appendix G of -cddl}} [^abs1c-]

Diagnostic notation syntax is based on JSON, with extensions
for representing CBOR constructs such as binary data and tags.
[^abs2-]

[^abs2-]: (Standardizing this together with the actual interchange format does
    not serve to create another interchange format, but enables the use of
    a shared diagnostic notation in tools for and in documents about CBOR.)

[^abs3-] {{-iptag}}.

[^abs4a-] {{Appendix G.4 of -cddl}} [^abs4b-].
    (See {{grammar}} for an overall ABNF grammar as well as the
    ABNF definitions in {{app-grammars}} for grammars for both the
    byte string presentations predefined in {{-cbor}} and the
    application-extensions defined here.)

In addition, this document finally registers a media type identifier
and a content-format for CBOR diagnostic notation.  This does not
elevate its status as an interchange format, but recognizes that
interaction between tools is often smoother if media types can be used.

{:aside}
>
> Examples in RFCs often do not use media type identifiers, but
> special sourcecode type names that are allocated
> in <https://www.rfc-editor.org/materials/sourcecode-types.txt>.
> At the time of writing, this resource lists four sourcecode type
> names that can be used in RFCs for including CBOR data items and
> CBOR-related languages:
>
> * `cbor` (which is actually not useful, as CBOR is a binary format
>   and cannot be used in textual examples in an RFC),
> * `cbor-diag` (which is another name for EDN, as defined in the
>   present document),
> * `cbor-pretty` (which is a possibly annotated and pretty-printed
>   hexdump of an encoded CBOR data item, along the lines of the
>   grammar of {{h-grammar}}, as used for instance for some of the examples
>   in {{Section A.3 of RFC9290}}), and
> * `cddl` (which is used for the Concise Data Definition Language,
>   CDDL, see {{terminology}} below).

Note that EDN is not meant to be the only text-based representation of
CBOR data items.
For instance, {{YAML}} {{-yaml-media-type}} is able to represent most CBOR
data items, possibly requiring use of YAML's extension points.
YAML does not provide certain features that can be useful with tools
and documents needing text-based representations of CBOR data items
(such as embedded CBOR or encoding indicators),
but it does provide a host of other features that EDN does not provide
such as anchor/alias data sharing, at a cost of higher implementation
and learning complexity.

## Structure of This Document

{{diagnostic-notation}} of this document has been built from {{Section 8
of RFC8949@-cbor}} and {{Section G of RFC8610}}.
The latter provided a number of useful extensions to the
diagnostic notation originally defined in {{Section 6 of -old-cbor}}.
{{Section 8 of RFC8949@-cbor}} and {{Section G of RFC8610}} have
collectively been called "Extended Diagnostic Notation" (EDN), giving
the present document its name.
<!--
Similarly, this notation could be extended in a separate document to
provide documentation for NaN payloads, which are not covered in this document.
-->

After introductory material, {{application-oriented-extension-literals}}
introduces the concept of application-oriented extension literals and
defines the "dt" and "ip" extensions.
{{stand-in}} defines mechanisms
for dealing with unknown application-oriented literals and
deliberately elided information.
{{grammars}} gives the formal syntax of EDN in ABNF, with
explanations for some features of and additions to this syntax, as an
overall grammar ({{grammar}}) and specific grammars for the content of
app-string and byte-string literals ({{app-grammars}}).
This is followed by the conventional sections
for
{{<<sec-iana}} ({{<sec-iana}}),
{{<<seccons}} ({{<seccons}}),
and References ({{<sec-normative-references}}, {{<sec-informative-references}}).
An informational comparison of EDN with CDDL follows in {{edn-and-cddl}}.

## Terminology

{{Section 8 of RFC8949@-cbor}} defines the original CBOR diagnostic notation,
and {{Appendix G of -cddl}} supplies a number of extensions to the
diagnostic notation that result in the Extended Diagnostic Notation
(EDN).
The diagnostic notation extensions include popular features such as
embedded CBOR (encoded CBOR data items in byte strings) and comments.
A simple diagnostic notation extension that enables representing CBOR
sequences was added in {{Section 4.2 of -seq}}.
As diagnostic notation is not used in the kind of interchange
situations where backward compatibility would pose a significant
obstacle, there is little point in not using these extensions.

Therefore, when we refer to "_diagnostic notation_", we mean to
include the original notation from {{Section 8 of RFC8949@-cbor}} as well as the
extensions from {{Appendix G of -cddl}}, {{Section 4.2 of -seq}}, and the
present document.
However, we stick to the abbreviation "_EDN_" as it has become quite
popular and is more sharply distinguishable from other meanings than
"DN" would be.

In a similar vein, the term "ABNF" in this document refers to the
language defined in {{-abnf}} as extended in {{-abnfcs}}, where the
"characters" of {{Section 2.3 of RFC5234@-abnf}} are Unicode scalar values.

The term "CDDL" (Concise Data Definition Language) refers to the data
definition language defined in
{{-cddl}} and its registered extensions (such as those in {{-controls}}), as
well as {{-cddlupd}}.
Additional information about the relationship between the two
languages EDN and CDDL is captured in {{edn-and-cddl}}.

{::boilerplate bcp14-tagged}

## (Non-)Objectives of this Document

{{Section 8 of RFC8949@-cbor}} states the objective of defining a
common human-readable diagnostic notation with CBOR.
In particular, it states:

{:quote}
> All actual interchange always happens in the binary format.

One important application of EDN is the notation of CBOR data for
humans: in specifications, on whiteboards, and for entering test data.
A number of features, such as comments in string literals, are mainly
useful for people-to-people communication via EDN.
Programs also often output EDN for diagnostic purposes, such as in
error messages or to enable comparison (including generation of diffs
via tools) with test data.

For comparison with test data, it is often useful if different
implementations generate the same (or similar) output for the same
CBOR data items.
This is comparable to the objectives of deterministic serialization
for CBOR data items themselves ({{Section 4.2 of RFC8949@-cbor}}).
However, there are even more representation variants in EDN than in
binary CBOR, and there is little point in specifically endorsing a
single variant as "deterministic" when other variants may be more
useful for human understanding, e.g., the `<< >>` notation as
opposed to `h''`; an EDN generator may have quite a few options
that control what presentation variant is most desirable for the
application that it is being used for.

Because of this, a deterministic representation is not defined for
EDN, and there is no expectation for "roundtripping" from EDN to
CBOR and back, i.e., for an ability
to convert EDN to binary CBOR and back to EDN while achieving exactly
the same result as the original input EDN — the original EDN possibly
was created by humans or by a different EDN generator.

However, there is a certain expectation that EDN generators can be
configured to some basic output format, which:

* looks like JSON where that is possible;
* inserts encoding indicators only where the binary form differs from
  preferred encoding;
* uses hexadecimal representation (`h''`) for byte strings, not
  `b64''` or embedded CBOR (`<<>>`);
* does not generate elaborate blank space (newlines, indentation) for
  pretty-printing, but does use common blank spaces such as after `,`
  and `:`.

Additional features such as ensuring deterministic map ordering
({{Section 4.2 of RFC8949@-cbor}}) on output, or even deviating from the basic
configuration in some systematic way, can further assist in comparing
test data.
Information obtained from a CDDL model can help in choosing
application-oriented literals or specific string representations such
as embedded CBOR or `b64''` in the appropriate places.

Overview over CBOR Extended Diagnostic Notation (EDN) {#diagnostic-notation}
=====================================================

CBOR is a binary interchange format.  To facilitate documentation and
debugging, and in particular to facilitate communication between
entities cooperating in debugging, this document defines a simple
human-readable diagnostic notation.  All actual interchange always
happens in the binary format.

Note that diagnostic notation truly was designed as a diagnostic
format; it originally was not meant to be parsed.
Therefore, no formal definition (as in ABNF) was given in the original
documents.
Recognizing that formal grammars can aid interoperation of tools and
usability of documents that employ EDN, {{grammars}} now provides ABNF
definitions.

EDN is a true superset of JSON as it is defined in {{STD90}} in
conjunction with {{-i-json}} (that is, any interoperable {{-i-json}} JSON
text also is an EDN text), extending it both to cover the greater
expressiveness of CBOR and to increase its usability.

EDN borrows the JSON syntax for numbers (integer and
floating-point, {{numbers}}), certain simple values ({{simple-values}}),
UTF-8 text
strings, arrays, and maps (maps are called objects in JSON; the
diagnostic notation extends JSON here by allowing any data item in the
map key position).

As EDN is used for truly diagnostic purposes, its implementations MAY
support generation and possibly ingestion of EDN for CBOR data items
that are well-formed but not valid.
It is RECOMMENDED that an implementation enables such usage only
explicitly by an API flag.
Validity of CBOR data items is discussed in {{Section 5.3 of RFC8949@-cbor}},
with basic validity discussed in {{Section 5.3.1 of RFC8949@-cbor}}, and
tag validity discussed in {{Section 5.3.2 of RFC8949@-cbor}}.
Tag validity is more likely a subject for individual
application-oriented extensions, while the two cases of basic validity
(for text strings and for maps) are addressed below under the heading
of *validity*.

The rest of this section provides an overview over specific features
of EDN, starting with certain common syntactical features and then
going through kinds of CBOR data items roughly in the order of CBOR major
types.
Any additional detailed syntax discussion needed has been deferred to
{{grammar}}.

## Comments {#comments}

For presentation to humans, EDN text may benefit from comments.
JSON famously does not provide for comments, and the original
diagnostic notation in {{Section 6 of -old-cbor}} inherited this property.

EDN now provides two comment syntaxes, which can be used where the
syntax allows blank space (outside of constructs such as numbers,
string literals, etc.):


* inline comments, delimited by slashes ("`/`"):

  In a position that allows blank space, any text within and including
  a pair of slashes is considered blank space (and thus effectively a
  comment).

* end-of-line comments, delimited by "`#`" and an end of line (LINE
  FEED, U+000A):

  In a position that allows blank space, any text within and including
  a pair of a "`#`" and the end of the line is considered blank space
  (and thus effectively a comment).

Comments can be used to annotate a CBOR structure as in:

~~~~ cbor-diag
/grasp-message/ [/M_DISCOVERY/ 1, /session-id/ 10584416,
                 /objective/ [/objective-name/ "opsonize",
                              /D, N, S/ 7, /loop-count/ 105]]
~~~~

or, combining the use of inline and end-of-line comments:

~~~ cbor-diag
{
 /kty/ 1 : 4, # Symmetric
 /alg/ 3 : 5, # HMAC 256-256
  /k/ -1 : h'6684523ab17337f173500e5728c628547cb37df
             e68449c65f885d1b73b49eae1'
}
~~~


## Encoding Indicators {#encoding-indicators}

XXX align with {{spec}}

Sometimes it is useful to indicate in the diagnostic notation which of
several alternative representations were actually used; for example, a
data item written >1.5\< by a diagnostic decoder might have been
encoded as a half-, single-, or double-precision float.

The convention for encoding indicators is that anything starting with
an underscore and all following characters that are alphanumeric or
underscore is an encoding indicator, and can be ignored by anyone not
interested in this information.  For example, `_` or `_3`.
Encoding indicators are always
optional.

An underscore followed by a decimal digit n indicates that the
preceding item (or, for arrays and maps, the item starting with the
preceding bracket or brace) was encoded with an additional information
value of 24+n.  For example, `1.5_1` is a half-precision floating-point
number, while `1.5_3` is encoded as double precision.
<!--
This encoding
indicator is not shown in {{examples}}.
 -->
(Note that the encoding
indicator "_" is thus an abbreviation of the full form "_7", which is
not used.)

Encoding Indicators are discussed further below for indefinite length
strings, and for arrays and maps.

## Numbers

<!--
## Hexadecimal, Octal, and Binary Numbers {#hexadecimal-octal-and-binary-numbers}
 -->

In addition to JSON's decimal number literals, EDN provides hexadecimal, octal,
and binary number literals in the usual C-language notation (octal with 0o
prefix present only).

The following are equivalent:

~~~~ cbor-diag
   4711
   0x1267
   0o11147
   0b1001001100111
~~~~

As are:

~~~~ cbor-diag
   1.5
   0x1.8p0
   0x18p-4
~~~~

Numbers composed only of digits (of the respective base) are
interpreted as CBOR integers (major type 0/1, or where the number
cannot be represented in this way, major type 6 with tag 2/3).
A leading "`+`" sign is a no-op, and a leading "`-`" sign inverts the
sign of the number.
So `0`, `000`, `+0` all represent the same integer zero, as does `-0`;
`1`, `001`, `+1` and `+0001` all stand for the same integer one, and
`-1` and `-0001` both designate the same integer minus one.

Using a decimal point (`.`) and/or an exponent (`e` for decimal, `p`
for hexadecimal) turns the number into a floating point number (major
type 7) instead, irrespective of whether it is an integral number
mathematically.
Note that, in floating point numbers, `0.0` is not the same number as
`-0.0`, even if they are mathematically equal.

The non-finite floating-point numbers `Infinity`, `-Infinity`, and `NaN` are
written exactly as in this sentence (this is also a way they can be
written in JavaScript, although JSON does not allow them).

See {{decnumber}} for additional details of the EDN number syntax.

(Note that literals for further number formats, e.g., for representing
rational numbers as fractions, or for NaNs with non-zero payloads, can
be added as application-oriented literals.
Background information beyond that in {{-cbor}} about the representation
of numbers in CBOR can be found in the informational document
{{-numbers}}.)

## Strings

CBOR distinguishes two kinds of strings: text strings (the bytes in
the string constitute UTF-8 text, major type 3), and byte strings
(CBOR does not further characterize the bytes that constitute the
string, major type 2).

EDN notates text strings in a form compatible to that of notating text
strings in JSON, with a number of usability extensions.
In JSON, no control characters are allowed to occur
directly in text string literals; if needed, they can be specified using
escapes such as `\t` or `\r`.
In EDN, string literals additionally can contain newlines (LINEFEED
U+000A), which are copied into the resulting string like other
characters in the string literal.
To deal with variability in platform presentation of newlines, any
carriage return characters (U+000D) that may be present in the EDN
text are not copied into the resulting string (see {{cr}}).
No other control characters can occur in a string literal, and the
handling of escaped characters (`\r` etc.) is as in JSON.

JSON's escape scheme for characters that are not on Unicode's basic
multilingual plane (BMP) is cumbersome.
EDN keeps it, but also adds the syntax `\u{NNN}` where NNN is the
Unicode scalar value as a hexadecimal number.
This means the following are equivalent (the first `o` is escaped as
`\u{6f}` for no particular reason):

~~~ cbor-diag
"D\u{6f}mino's \u{1F073} + \u{2318}"   # \u{}-escape 3 chars
"Domino's \uD83C\uDC73 + \u2318"       # escape JSON-like
"Domino's 🁳 + ⌘"                       # unescaped
~~~

EDN adds a number of ways to notate byte strings, some of which
provide detailed access to the bits within those bytes (see
{{encoded-byte-strings}}).
However, quite often, byte strings carry bytes that can be meaningfully
notated as UTF-8 text.
Analogously to text string literals delimited by double quotes, EDN
allows the use of single quotes (without a prefix) to express byte
string literals with UTF-8 text; for instance, the following are
equivalent:

~~~~
'hello world'
h'68656c6c6f20776f726c64'
~~~~

The escaping rules of JSON strings are applied equivalently for
text-based byte string literals, e.g., `\\` stands for a single
backslash and `\'` stands for a single quote.
(See {{concat}} for details.)

### Encoding Indicators of Strings

The detailed chunk structure of byte and text strings encoded with
indefinite length can be
notated in the form (_ h'0123', h'4567') and (_ "foo", "bar").
However, for an indefinite-length string with no chunks inside, (_ )
would be ambiguous as to whether a byte string (0x5fff) or a text string
(0x7fff) is meant and is therefore not used.
The basic forms ''_ and ""_ can be used instead and are reserved for
the case of no chunks only --- not as short forms for the (permitted,
but not really useful) encodings with only empty chunks, which
need to be notated as (_ ''), (_ ""), etc.,
to preserve the chunk structure.


### Base-Encoded Byte String Literals {#encoded-byte-strings}

Besides the unprefixed byte string literals that are analogous to JSON text
string literals, EDN provides base-encoded byte string literals.
These are notated in one of the base encodings {{-base}}, without
padding, enclosed in a single-quoted string literal, prefixed by >h\< for base16 or
>b64\< for base64 or base64url (the actual encodings of the latter do
not overlap, so the string remains unambiguous).
For example, the byte string consisting of the four bytes `12 34 56
78` (given in hexadecimal here) could be written `h'12345678'` or `b64'EjRWeA'`.

(Note that {{Section 8 of RFC8949@-cbor}} also mentions >b32\< for
base32 and >h32\< for base32hex.
This has not been implemented widely
and therefore is not directly included in this specification.
These and further byte string formats now can easily be added back as
application-oriented literals.)

Examples often benefit from some blank space (spaces, line breaks) in
byte strings.  In EDN, blank space is ignored in prefixed byte strings; for
instance, the following are equivalent:

~~~~ cbor-diag
   h'48656c6c6f20776f726c64'
   h'48 65 6c 6c 6f 20 77 6f 72 6c 64'
   h'4 86 56c 6c6f
     20776 f726c64'
~~~~

Note that the internal syntax of prefixed single-quote literals such
as h'' and b64'' can allow comments as blank space (see {{comments}}).
Since slash characters are allowed in b64'', only inline comments are
available in b64 string literals.

~~~~ cbor-diag
   h'68656c6c6f20776f726c64'
   h'68 65 6c /doubled l!/ 6c 6f # hello
     20 /space/
     77 6f 72 6c 64' /world/
~~~~

### Embedded CBOR and CBOR Sequences in Byte Strings {#embedded-cbor-and-cbor-sequences-in-byte-strings}

Where a byte string is to carry an embedded CBOR-encoded item, or more
generally a sequence of zero or more such items, the diagnostic
notation for these zero or more CBOR data items, separated by commas,
can be enclosed in `<<` and `>>` to notate the byte string
resulting from encoding the data items and concatenating the result.
For
instance, each pair of columns in the following are equivalent:


~~~~ cbor-diag
   <<1>>              h'01'
   <<1, 2>>           h'0102'
   <<"hello", null>>  h'65 68656c6c6f f6'
   <<>>               h''
~~~~

### Validity of Text Strings

XXX

<!--
## Concatenated Strings {#concatenated-strings}

While the ability to include whitespace enables line-breaking of
encoded byte strings, a mechanism is needed to be able to include
text strings as well as byte strings in direct UTF-8 representation
into line-based documents (such as RFCs and source code).

We extend the diagnostic notation by allowing multiple text strings or
multiple byte strings to be notated separated by whitespace; these
are then concatenated into a single text or byte string, respectively.
Text strings and byte strings do not mix within such a
concatenation, except that byte string notation can be used inside a
sequence of concatenated text string notation to encode characters
that may be better represented in an encoded way.  The following four
values are equivalent:


~~~~
   "Hello world"
   "Hello " "world"
   "Hello" h'20' "world"
   "" h'48656c6c6f20776f726c64' ""
~~~~

Similarly, the following byte string values are equivalent:


~~~~
   'Hello world'
   'Hello ' 'world'
   'Hello ' h'776f726c64'
   'Hello' h'20' 'world'
   '' h'48656c6c6f20776f726c64' '' b64''
   h'4 86 56c 6c6f' h' 20776 f726c64'
~~~~

(Note that the approach of separating by whitespace, while familiar
from the C language, requires some attention — a single comma makes a
big difference here.)

-->

## Arrays and Maps

EDN borrows the JSON syntax for arrays and maps.
(Maps are called objects in JSON.)

For maps, EDN extends the JSON syntax by allowing any data item in the
map key position (before the colon).

JSON requires the use of a comma as a separator character between
the elements of an array as well as between the members (key/value
pairs) of a map.
(These commas also were required in the original diagnostic
notation defined in {{-cbor}} and {{-cddl}}.)
The separator commas are now optional in the places where EDN syntax
allows commas.
(Stylistically, leaving out the commas is more idiomatic when they
occur at line breaks.)

In addition, EDN also allows, but does not require, a trailing comma before the closing bracket/brace,
enabling an easier to maintain "terminator" style of their use.

In summary, the following eight examples are all equivalent:

~~~ cbor-diag
[1, 2, 3]
[1, 2, 3,]
[1  2  3]
[1  2  3,]
[1  2, 3]
[1  2, 3,]
[1, 2  3]
[1, 2  3,]
~~~

as are

~~~ cbor-diag
{1: "n", "x": "a"}
{1: "n", "x": "a",}
{1: "n"  "x": "a"}
# etc.
~~~

{:aside}
> CDDL's comma separators in the equivalent contexts (CDDL groups) are
  entirely optional
  (and actually are terminators, which together with their optionality
  allows them to be used like separators as well, or even not at all).
  In summary, comma use is now aligned between EDN and CDDL, in a
  fully backwards compatible way.

### Encoding Indicators of Arrays and Maps

A single underscore can be written after the opening brace of a map or
the opening bracket of an array to indicate that the data item was
represented in indefinite-length format.  For example, `[_ 1, 2]`
contains an indicator that an indefinite-length representation was
used to represent the data item `[1, 2]`.

### Validity of Maps

As discussed at the start of {{diagnostic-notation}}, EDN implementations MAY support
generation and possibly ingestion of EDN for CBOR data items that are
well-formed but not valid.

For maps, this is relevant for map keys that occur more than once, as in:

~~~ cbor-diag
{1: "to", 1: "fro"}
~~~

## Tags

A tag is
written as a decimal unsigned integer for the tag number, followed by the tag content
in parentheses; for instance, a date in the format specified by RFC 3339
(ISO 8601) could be
notated as:

{: indent='5'}
0("2013-03-21T20:04:00Z")

or the equivalent epoch-based time as the following:

{: indent='5'}
1(1363896240)



## Simple values

EDN uses JSON syntax for the simple values True (>`true`\<), False
(>`false`\<), and Null (>`null`\<).
Undefined is written >`undefined`\< as in JavaScript.

Other simple values are given as "simple()" with the appropriate
integer in the parentheses. For example, >`simple(42)`\< indicates major
type 7, value 42.


Application-Oriented Extension Literals
=======================================

This document extends the syntax used in diagnostic notation for byte
string literals to also be available for application-oriented extensions.

As per {{Section 8 of RFC8949@-cbor}}, the diagnostic notation can notate byte
strings in a number of {{-base}} base encodings, where the encoded text
is enclosed in single quotes, prefixed by an identifier (»h« for
base16, »b32« for base32, »h32« for base32hex, »b64« for base64 or
base64url).

This syntax can be thought to establish a name space, with the names
"h", "b32", "h32", and "b64" taken, but other names being unallocated.
The present specification defines additional names for this namespace,
which we call *application-extension identifiers*.
For the quoted string, the same rules apply as for byte strings.
In particular, the escaping rules that were adapted from JSON strings
are applied
equivalently for application-oriented extensions, e.g., within the
quoted string `\\` stands
for a single backslash and `\'` stands for a single quote.

An application-extension identifier is a name consisting of a
lower-case ASCII letter (a-z) and zero or more additional ASCII
characters that are either lower-case letters or digits (a-z0-9).

Application-extension identifiers are registered in a registry
({{appext-iana}}).

Prefixing a single-quoted string, an application-extension identifier
is used to build an application-oriented extension literal, which
stands for a CBOR data item the value of which is derived from the
text given in the single-quoted string using a procedure defined in
the specification for an application-extension identifier.

An application-extension (such as `dt`) MAY also define the meaning of
a variant of the application-extension identifier where each
lower-case character is replaced by its upper-case counterpart (such
as `DT`), for building an application-oriented extension literal using
that all-uppercase variant as the prefix of a single-quoted string.

As a convention for such definitions, using the all-uppercase variant
implies making use of a tag appropriate for this application-oriented
extension (such as tag number 1 for `DT`).

Examples for application-oriented extensions to CBOR diagnostic
notation can be found in the following sections.


The "dt" Extension {#dt}
------------------

The application-extension identifier "dt" is used to notate a
date/time literal that can be used as an Epoch-Based Date/Time as per
{{Section 3.4.2 of RFC8949@-cbor}}.

The text of the literal is a Standard Date/Time String as per
{{Section 3.4.1 of RFC8949@-cbor}}.

The value of the literal is a number representing the result of a
conversion of the given Standard Date/Time String to an Epoch-Based
Date/Time.
If fractional seconds are given in the text (production
`time-secfrac` in {{abnf-grammar-dt}}), the value is a
floating-point number; the value is an integer number otherwise.
In the all-upper-case variant of the app-prefix, the value is enclosed
in a tag number 1.

As an example, the CBOR diagnostic notation

~~~ cbor-diag
dt'1969-07-21T02:56:16Z',
dt'1969-07-21T02:56:16.5Z',
DT'1969-07-21T02:56:16Z'
~~~

is equivalent to

~~~ cbor-diag
-14159024,
-14159023.5,
1(-14159024)
~~~

See {{dt-grammar}} for an ABNF definition for the content of `dt` literals.


The "ip" Extension {#ip}
------------------

The application-extension identifier "ip" is used to notate an IP
address literal that can be used as an IP address as per {{Section 3 of
-iptag}}.

The text of the literal is an IPv4address or IPv6address as per
{{Section 3.2.2 of -uri}}.

With the lower-case app-string `ip`, the value of the literal is a
byte string representing the binary IP address.
With the upper-case app-string `IP`, the literal is such a byte string
tagged with tag number 54, if an IPv6address is used, or tag number
52, if an IPv4address is used.

As an additional case, the upper-case app-string `IP''` can be used
with a prefix such as `2001:db8::/56` or `192.0.2.0/24`, with the equivalent tag as its value.
(Note that {{-iptag}} representations of address prefixes need to
implement the truncation of the address byte string as described in
{{Section 4.2 of -iptag}}; see example below.)
For completeness, the lower-case variant `ip'2001:db8::/56'` or  `ip'192.0.2.0/24'` stands for
an unwrapped `[56,h'20010db8']` or `[24,h'c00002']`; however, in this case the information
on whether an address is IPv4 or IPv6 often needs to come from the context.

Note that there is no direct representation of the "Interface format"
defined in {{Section 3.1.3 of -iptag}}, an address combined with an
optional prefix length and an optional zone identifier.
This can be represented as in `52([ip'192.0.2.42',24])`, if needed.

Examples: the CBOR diagnostic notation

~~~ cbor-diag
ip'192.0.2.42',
IP'192.0.2.42',
IP'192.0.2.0/24',
ip'2001:db8::42',
IP'2001:db8::42',
IP'2001:db8::/64'
~~~

is equivalent to

~~~ cbor-diag
h'c000022a',
52(h'c000022a'),
52([24,h'c00002']),
h'20010db8000000000000000000000042',
54(h'20010db8000000000000000000000042'),
54([64,h'20010db8'])
~~~

See {{ip-grammar}} for an ABNF definition for the content of `ip` literals.



Stand-in Representations in Binary CBOR {#stand-in}
=======================================

In some cases, an EDN consumer cannot construct actual CBOR items that
represent the CBOR data intended for eventual interchange.
This document defines stand-in representation for two such cases:

* The EDN consumer does not know (or does not implement) an
  application-extension identifier used in the EDN document
  ({{unknown}}) but wants to preserve the information for a later
  processor.

* The generator of some EDN intended for human consumption (such as in
  a specification document) may not want to include parts of the final
  data item, destructively replacing complete subtrees or possibly
  just parts of a lengthy string by _elisions_ ({{elision}}).

Implementation note:
Typically, the ultimate applications will fail if they encounter tags
unknown to them, which the ones defined in this section likely are.
Where chains of tools are involved in processing EDN, it may be useful
to fail earlier than at the ultimate receiver in the chain unless
specific processing options (e.g., command line flags) are given that
indicate which of these stand-ins are expected at this stage in the
chain.

Handling unknown application-extension identifiers {#unknown}
--------------------------------------------------

When ingesting CBOR diagnostic notation, any
application-oriented extension literals are usually decoded and
transformed into the corresponding data item during ingestion.
If an application-extension is not known or not implemented by the
ingesting process, this is usually an error and processing has to
stop.

However, in certain cases, it can be desirable to exceptionally carry an
uninterpreted application-oriented extension literal in an ingested
data item, allowing to postpone its decoding to a specific later
stage of ingestion.

This specification defines a CBOR Tag for this purpose:
The Diagnostic Notation Unresolved Application-Extension Tag, tag
number CPA999 ({{iana-standin}}).
The content of this tag is an array of two text strings: The
application-extension identifier, and the (escape-processed) content
of the single-quoted string.
For example, `dt'1969-07-21T02:56:16Z'` can be provisionally represented as
`/CPA/ 999(["dt", "1969-07-21T02:56:16Z"])`.

If a stage of ingestion is not prepared to handle the Unresolved
Application-Extension Tag, this is an error and processing has to
stop, as if this stage had been ingesting an unknown or unimplemented
application-extension literal itself.

[^cpa]

[^cpa]: RFC-Editor: This document uses the CPA (code point allocation)
      convention described in [I-D.bormann-cbor-draft-numbers].  For
      each usage of the term "CPA", please remove the prefix "CPA"
      from the indicated value and replace the residue with the value
      assigned by IANA; perform an analogous substitution for all other
      occurrences of the prefix "CPA" in the document.  Finally,
      please remove this note.

Handling information deliberately elided from an EDN document {#elision}
-------------------------------------------------------------

When using EDN for exposition in a document or on a whiteboard, it is
often useful to be able to leave out parts of an EDN document that are
not of interest at that point of the exposition.

To facilitate this, this specification
supports the use of an _ellipsis_ (notated as three or more dots
in a row, as in `...`) to indicate parts of an EDN document that have
been elided (and therefore cannot be reconstructed).

Upon ingesting EDN as a representation of a CBOR data item for further
processing, the occurrence of an ellipsis usually is an error and
processing has to stop.

However, it is useful to be able to process EDN documents with
ellipses in the automation scripts for the documents using them.
This specification defines a CBOR Tag that can be used in the ingestion
for this purpose:
The Diagnostic Notation Ellipsis Tag, tag number CPA888 ({{iana-standin}}).
The content of this tag either is

1. null (indicating a data item entirely replaced by an ellipsis), or it is
2. an array, the elements of which are alternating between fragments
   of a string and the actual elisions, represented as ellipses
   carrying a null as content.

Elisions can stand in for entire subtrees, e.g. in:

~~~ cbor-diag
[1, 2, ..., 3]
{ "a": 1,
  "b": ...,
  ...: ...
}
~~~

A single ellipsis (or key/value pair of ellipses) can imply eliding
multiple elements in an array (members in a map); if more detailed
control is required, a data definition language such as CDDL can be
employed.
(Note that the stand-in form defined here does not allow multiple
key/value pairs with an ellipsis as a key: the CBOR data item would
not be valid.)

Subtree elisions can be represented in a CBOR data item by using
`/CPA/888(null)` as the stand-in:

~~~ cbor-diag
[1, 2, 888(null), 3]
{ "a": 1,
  "b": 888(null),
  888(null): 888(null)
}
~~~

Elisions also can be used as part of a (text or byte) string:

~~~ cbor-diag
{ "contract": "Herewith I buy" + ... + "gned: Alice & Bob",
  "signature": h'4711...0815',
}
~~~

The example "contract" combines string concatenation via the `+`
operator ({{grammar}}) with
ellipses; while the example
"signature" uses special syntax that allows the use of ellipses
between the bytes notated _inside_ `h''` literals.

String elisions can be represented in a CBOR data item by a stand-in
that wraps an array of string fragments alternating with ellipsis
indicators:

~~~ cbor-diag
{ "contract": /CPA/888(["Herewith I buy", 888(null),
                        "gned: Alice & Bob"]),
  "signature": 888([h'4711', 888(null), h'0815']),
}
~~~

Note that the use of elisions is different from "commenting out" EDN
text, e.g.:


~~~ cbor-diag
{ "signature": h'4711/.../0815',
  # ...: ...
}
~~~

The consumer of this EDN will ignore the comments and therefore will
have no idea after ingestion that some information has been elided;
validation steps may then simply fail instead of being informed about
the elisions.


ABNF Definitions {#grammars}
================

This section collects grammars in ABNF form ({{-abnf}} as extended in
{{-abnfcs}}) that serve to define the syntax of EDN and some
application-oriented literals.

Implementation note: The ABNF definitions in this section are
intended to be useful in a Parsing Expression Grammar (PEG) parser
interpretation (see {{Appendix A
of -cddl}} for an introduction into PEG).

Overall ABNF Definition for Extended Diagnostic Notation {#grammar}
--------------------------------------------------------

This subsection provides an overall ABNF definition for the syntax of
CBOR extended diagnostic notation.

To complete the parsing of an `app-string` with prefix, say, `p`, the
processed `sqstr` inside it is further parsed using the ABNF definition specified
for the production `app-string-p` in {{app-grammars}}.

For simplicity, the internal parsing for the built-in EDN prefixes is
specified in the same way.
ABNF definitions for `h''` and `b64''` are provided in {{h-grammar}} and
{{b64-grammar}}.
However, the prefixes `b32''` and `h32''` are not in wide use and an
ABNF definition in this document could therefore not be based on
implementation experience.

~~~ abnf
{::include cbor-diag-parser.abnf}
~~~
{: #abnf-grammar title="Overall ABNF Definition of CBOR EDN"
   sourcecode-name="cbor-edn.abnf"}

While an ABNF grammar defines the set of character strings that are
considered to be valid EDN by this ABNF, the mapping of these
character strings into the generic data model of CBOR is not always
obvious.

The following additional items should help in the interpretation:

* As mentioned in the terminology ({{terminology}}), the ABNF terminal
  values in this document define Unicode scalar values (characters)
  rather than their UTF-8 encoding.  For example, the Unicode PLACE OF
  INTEREST SIGN (U+2318) would be defined in ABNF as %x2318.

* {: #cr} Unicode CARRIAGE RETURN (U+000D, often seen escaped as "\r" in many
  programming languages) that exist in the input (unescaped) are
  ignored as if they were not in the input wherever they appear.
  This is most important when they are found in (text or byte) string
  contexts (see the "unescaped" ABNF rule).
  On some platforms, a carriage return is always added in front of a
  LINE FEED (U+000A, also often seen escaped as "\n" in many
  programming languages), but on other platforms, carriage returns are
  not used at line breaks.
  The intent behind ignoring unescaped carriage returns is to ensure
  that input generated or processed on either of these kinds of
  platforms will generate the same bytes in the CBOR data items
  created from that input.
  (Platforms that use just a CARRIAGE RETURN to signify an end of line
  are no longer relevant and the files they produce are out of scope
  for this document.)
  If a carriage return is needed in the CBOR data item, it can be
  added explicitly using the escaped form `\r`.

* {: #decnumber}
  `decnumber` stands for an integer in the usual decimal notation, unless at
  least one of the optional parts starting with "." and "e" are
  present, in which case it stands for a floating point value in the
  usual decimal notation.  Note that the grammar now allows `3.` for
  `3.0` and `.3` for `0.3` (also for hexadecimal floating point
  below); implementers are advised that some platform numeric parsers
  accept only a subset of the floating point syntax in this document
  and may require some preprocessing to use here.
* `hexint`, `octint`, and `binint` stand for an integer in the usual base 16/hexadecimal
  ("0x"), base 8/octal ("0o"), or base 2/binary ("0b") notation.
  `hexfloat` stands
  for a floating point number in the usual hexadecimal notation (which
  uses a mantissa in hexadecimal and an exponent in decimal notation,
  see Section 5.12.3 of {{IEEE754}}, Section 6.4.4.2 of {{C}}, or Section
  5.13.4 of {{Cplusplus}}; floating-suffix/floating-point-suffix from
  the latter two is not used here).
* For `hexint`, `octint`, `binint`, and when `decnumber` stands for an integer, the
  corresponding CBOR data item is represented using major type 0 or 1
  if possible, or using tag 2 or 3 if not.
  In the latter case, this specification does not define any encoding
  indicators that apply.
  If fine control over encoding is desired, this can be expressed by
  being explicit about the representation as a tag:
  E.g., `987654321098765432310`, which is equivalent to `2(h'35 8a 75
  04 38 f3 80 f5 f6')` in its preferred serialization, might be
  written as `2_3(h'00 00 00 35 8a 75 04 38 f3 80 f5 f6'_1)` if
  leading zeros need to be added during serialization to obtain
  specific sizes for tag head, byte string head, and the overall byte
  string.

  When `decnumber` stands for a floating point value, and for
  `hexfloat` and `nonfin`, a floating point data item with major
  type 7 is used in preferred serialization (unless modified by an
  encoding indicator, which then needs to be `_1`, `_2`, or `_3`).
  For this, the number range needs to fit into an {{IEEE754}} binary64 (or the size
  corresponding to the encoding indicator), and the precision will be
  adjusted to binary64 before further applying preferred serialization
  (or to the size corresponding to the encoding indicator).
  Tag 4/5 representations are not generated in these cases.
  Future app-prefixes could be defined to allow more control for
  obtaining a tag 4/5 representation directly from a hex or decimal
  floating point literal.

* {: #spec} `spec` stands for an encoding indicator.

  (In the following, an abbreviation of the form `ai=`nn gives nn as
  the numeric value of the field _additional information_, the low-order 5
  bits of the initial byte: see {{Section 3 of RFC8949@-cbor}}.)

  As per {{Section 8.1 of RFC8949@-cbor}}:

  * an underscore `_` on its own stands
    for indefinite length encoding (`ai=31`, only available behind the
    opening brace/bracket for `map` and `array`: strings have a special
    syntax `streamstring` for indefinite length encoding except for the
    special cases ''_ and ""_), and
  * `_0` to `_3` stand for `ai=24` to `ai=27`, respectively.

  Surprisingly, {{Section 8.1 of RFC8949@-cbor}} does not address `ai=0` to
  `ai=23` — the assumption seems to be that preferred serialization
  ({{Section 4.1 of RFC8949@-cbor}}) will be used when converting CBOR
  diagnostic notation to an encoded CBOR data item, so leaving out the
  encoding indicator for a data item with a preferred serialization
  will implicitly use `ai=0` to `ai=23` if that is possible.
  The present specification allows to make this explicit:

  * `_i` ("immediate") stands for encoding with `ai=0` to `ai=23`.

  While no pressing use for further values for encoding indicators
  comes to mind, this is an extension point for EDN; {{reg-ei}} defines
  a registry for additional values.

* {: #concat}
  Extended diagnostic notation allows a (text or byte) string to be
  built up from multiple (text or byte) string literals, separated by
  a `+` operator; these are then concatenated into a single string.

  `string`, `string1e`, `string1`, and `ellipsis` realize: (1) the
  representation of strings in this form split up into multiple
  chunks, and (2) the use of ellipses to represent elisions
  ({{elision}}).

  Note that the syntax defined here for concatenation of components
  uses an explicit `+` operator between the components to be
  concatenated ({{Section G.4 of -cddl}} used simple juxtaposition,
  which was not widely implemented and got in the way of making the use
  of commas optional in other places via the rule `OC`).

  Text strings and byte strings do not mix within such a
  concatenation, except that byte string literal notation can be used
  inside a sequence of concatenated text string notation literals, to
  encode characters that may be better represented in an encoded way.
  The following four text string values (adapted from {{Section G.4 of
  -cddl}} by updating to explicit `+` operators) are equivalent:

      "Hello world"
      "Hello " + "world"
      "Hello" + h'20' + "world"
      "" + h'48656c6c6f20776f726c64' + ""

  Similarly, the following byte string values are equivalent:

      'Hello world'
      'Hello ' + 'world'
      'Hello ' + h'776f726c64'
      'Hello' + h'20' + 'world'
      '' + h'48656c6c6f20776f726c64' + '' + b64''
      h'4 86 56c 6c6f' + h' 20776 f726c64'

  The semantic processing of these constructs is governed by the
  following rules:

  * A single `...` is a general ellipsis, which by itself can stand
    for any data item.
    Multiple adjacent concatenated ellipses are equivalent to a single
    ellipsis.
  * An ellipsis can be concatenated (on one or both sides) with string
    chunks (`string1`); the result is a CBOR tag number CPA888 that contains an
    array with joined together spans of such chunks plus the ellipses
    represented by `888(null)`.
  * If there is no ellipsis in the concatenated list, the result of
    processing the list will always be a single item.
  * The bytes in the concatenated sequence of string chunks are simply
    joined together, proceeding from left to right.
    If the left hand side of a concatenation is a text string, the
    joining operation results in a text string, and that
    result needs to be valid UTF-8.
    If the left hand side is a byte string, the right hand side also
    needs to be a byte string.
  * Some of the strings may be app-strings.
    If the result type of the app-string is an actual (text or byte)
    string, joining of those string chunks occurs as with chunks
    directly notated as string literals; otherwise the occurrence of more than
    one app-string or an app-string together with a directly notated
    string cannot be processed.

ABNF Definitions for app-string Content {#app-grammars}
---------------------------------------

This subsection provides ABNF definitions for application-oriented extension
literals defined in {{-cbor}} and in this specification.
These grammars describe the *decoded* content of the `sqstr` components that
combine with the application-extension identifiers to form
application-oriented extension literals.
Each of these may make use of ABNF rules defined in {{abnf-grammar}}.

### h: ABNF Definition of Hexadecimal representation of a byte string {#h-grammar}


The syntax of the content of byte strings represented in hex,
such as `h''`, `h'0815'`, or `h'/head/ 63 /contents/ 66 6f 6f'`
(another representation of `<< "foo" >>`), is described by the ABNF in {{abnf-grammar-h}}.
This syntax accommodates both lower case and upper case hex digits, as
well as blank space (including comments) around each hex digit.

~~~ abnf
app-string-h    = S *(HEXDIG S HEXDIG S / ellipsis S)
                  ["#" *non-lf]
ellipsis        = 3*"."
HEXDIG          = DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
DIGIT           = %x30-39 ; 0-9
blank           = %x09 / %x0A / %x0D / %x20
non-slash       = blank / %x21-2e / %x30-10FFFF
non-lf          = %x09 / %x0D / %x20-D7FF / %xE000-10FFFF
S               = *blank *(comment *blank )
comment         = "/" *non-slash "/"
                / "#" *non-lf %x0A
~~~
{: #abnf-grammar-h sourcecode-name="cbor-edn-h.abnf"
title="ABNF Definition of Hexadecimal Representation of a Byte String"
}


### b64: ABNF Definition of Base64 representation of a byte string {#b64-grammar}


The syntax of the content of byte strings represented in base64 is
described by the ABNF in {{abnf-grammar-h}}.

This syntax allows both the classic ({{Section 4 of RFC4648}}) and the
URL-safe ({{Section 5 of RFC4648}}) alphabet to be used.
It accommodates, but does not require base64 padding.
Note that inclusion of classic base64 makes it impossible to have
in-line comments in b64, as "/" is valid base64-classic.

~~~ abnf
app-string-b64  = B *(4(b64dig B))
                  [b64dig B b64dig B ["=" B "=" / b64dig B ["="]] B]
                  ["#" *inon-lf]
b64dig          = ALPHA / DIGIT / "-" / "_" / "+" / "/"
B               = *iblank *(icomment *iblank)
iblank          = %x0A / %x20  ; Not HT or CR (gone)
icomment        = "#" *inon-lf %x0A
inon-lf         = %x20-D7FF / %xE000-10FFFF
ALPHA           = %x41-5a / %x61-7a
DIGIT           = %x30-39
~~~
{: #abnf-grammar-b64 sourcecode-name="cbor-edn-b64.abnf"
title="ABNF definition of Base64 Representation of a Byte String"
}

### dt: ABNF Definition of RFC 3339 Representation of a Date/Time {#dt-grammar}

The syntax of the content of `dt` literals can be described by the
ABNF for `date-time` from {{RFC3339}} as summarized in {{Section 3 of -controls}}:

~~~ abnf
app-string-dt   = date-time

date-fullyear   = 4DIGIT
date-month      = 2DIGIT  ; 01-12
date-mday       = 2DIGIT  ; 01-28, 01-29, 01-30, 01-31 based on
                          ; month/year
time-hour       = 2DIGIT  ; 00-23
time-minute     = 2DIGIT  ; 00-59
time-second     = 2DIGIT  ; 00-58, 00-59, 00-60 based on leap sec
                          ; rules
time-secfrac    = "." 1*DIGIT
time-numoffset  = ("+" / "-") time-hour ":" time-minute
time-offset     = "Z" / time-numoffset

partial-time    = time-hour ":" time-minute ":" time-second
                  [time-secfrac]
full-date       = date-fullyear "-" date-month "-" date-mday
full-time       = partial-time time-offset

date-time       = full-date "T" full-time
DIGIT           =  %x30-39 ; 0-9
~~~
{: #abnf-grammar-dt sourcecode-name="cbor-edn-dt.abnf"
title="ABNF Definition of RFC3339 Representation of a Date/Time"
}


### ip: ABNF Definition of Textual Representation of an IP Address {#ip-grammar}

The syntax of the content of `ip` literals can be described by the
ABNF for `IPv4address` and `IPv6address` in {{Section 3.2.2 of -uri}},
as included in slightly updated form in {{abnf-grammar-ip}}.

~~~ abnf
app-string-ip = IPaddress ["/" uint]

IPaddress     = IPv4address
              / IPv6address

; ABNF from RFC 3986, re-arranged for PEG compatibility:

IPv6address   =                            6( h16 ":" ) ls32
              /                       "::" 5( h16 ":" ) ls32
              / [ h16               ] "::" 4( h16 ":" ) ls32
              / [ h16 *1( ":" h16 ) ] "::" 3( h16 ":" ) ls32
              / [ h16 *2( ":" h16 ) ] "::" 2( h16 ":" ) ls32
              / [ h16 *3( ":" h16 ) ] "::"    h16 ":"   ls32
              / [ h16 *4( ":" h16 ) ] "::"              ls32
              / [ h16 *5( ":" h16 ) ] "::"              h16
              / [ h16 *6( ":" h16 ) ] "::"

h16           = 1*4HEXDIG
ls32          = ( h16 ":" h16 ) / IPv4address
IPv4address   = dec-octet "." dec-octet "." dec-octet "." dec-octet
dec-octet     = "25" %x30-35         ; 250-255
              / "2" %x30-34 DIGIT    ; 200-249
              / "1" 2DIGIT           ; 100-199
              / %x31-39 DIGIT        ; 10-99
              / DIGIT                ; 0-9

HEXDIG        = DIGIT / "A" / "B" / "C" / "D" / "E" / "F"
DIGIT         = %x30-39 ; 0-9
DIGIT1        = %x31-39 ; 1-9
uint          = "0" / DIGIT1 *DIGIT
~~~
{: #abnf-grammar-ip sourcecode-name="cbor-edn-ip.abnf"
title="ABNF Definition of Textual Representation of an IP Address"}


IANA Considerations {#sec-iana}
===================

[^to-be-removed]

[^to-be-removed]: RFC Editor: please replace RFC-XXXX with the RFC
    number of this RFC, \[IANA.cbor-diagnostic-notation] with a
    reference to the new registry group, and remove this note.


## CBOR Diagnostic Notation Application-extension Identifiers Registry {#appext-iana}

IANA is requested to create an "Application-Extension Identifiers"
registry in a new "CBOR Diagnostic Notation" registry group
\[IANA.cbor-diagnostic-notation], with the policy "expert review"
({{Section 4.5 of RFC8126@-ianacons}}).

The experts are instructed to be frugal in the allocation of
application-extension identifiers that are suggestive of generally applicable semantics,
keeping them in reserve for application-extensions that are likely to enjoy wide
use and can make good use of their conciseness.
The expert is also instructed to direct the registrant to provide a
specification ({{Section 4.6 of RFC8126@-ianacons}}), but can make exceptions,
for instance when a specification is not available at the time of
registration but is likely forthcoming.
If the expert becomes aware of application-extension identifiers that are deployed and
in use, they may also initiate a registration on their own if
they deem such a registration can avert potential future collisions.
{: #de-instructions}

Each entry in the registry must include:

{:vspace}
Application-Extension Identifier:
: a lower case ASCII {{-ascii}} string that starts with a letter and can
  contain letters and digits after that (`[a-z][a-z0-9]*`). No other
  entry in the registry can have the same application-extension identifier.

Description:
: a brief description

Change Controller:
: (see {{Section 2.3 of RFC8126@-ianacons}})

Reference:
: a reference document that provides a description of the
  application-extension identifier


The initial content of the registry is shown in {{tab-iana}}; all
initial entries have the Change Controller "IETF".

| Application-extension Identifier | Description                     | Reference |
|----------------------------------|---------------------------------|-----------|
| h                                | Reserved                        | RFC8949   |
| b32                              | Reserved                        | RFC8949   |
| h32                              | Reserved                        | RFC8949   |
| b64                              | Reserved                        | RFC8949   |
| dt                               | Date/Time                       | RFC-XXXX   |
| ip                               | IP Address/Prefix               | RFC-XXXX   |
{: #tab-iana title="Initial Content of Application-extension
Identifier Registry"}


## Encoding Indicators {#reg-ei}

IANA is requested to create an "Encoding Indicators"
registry in the newly created "CBOR Diagnostic Notation" registry group
\[IANA.cbor-diagnostic-notation], with the policy "specification required"
({{Section 4.6 of RFC8126@-ianacons}}).

The experts are instructed to be frugal in the allocation of
encoding indicators that are suggestive of generally applicable semantics,
keeping them in reserve for encoding indicator registrations that are likely to enjoy wide
use and can make good use of their conciseness.
If the expert becomes aware of encoding indicators that are deployed and
in use, they may also solicit a specification and initiate a registration on their own if
they deem such a registration can avert potential future collisions.
{: #de-instructions-ei}

Each entry in the registry must include:

{:vspace}
Encoding Indicator:
: an ASCII {{-ascii}} string that starts with an underscore letter and
  can contain zero or more underscores, letters and digits after that
  (`_[_A-Za-z0-9]*`). No other entry in the registry can have the same
  Encoding Indicator.

Description:
: a brief description.
  This description may employ an abbreviation of the form `ai=`nn,
  where nn is the numeric value of the field _additional information_, the
  low-order 5 bits of the initial byte (see {{Section 3 of RFC8949@-cbor}}).

Change Controller:
: (see {{Section 2.3 of RFC8126@-ianacons}})

Reference:
: a reference document that provides a description of the
  application-extension identifier


The initial content of the registry is shown in {{tab-iana-ei}}; all
initial entries have the Change Controller "IETF".

| Encoding Indicator | Description                        | Reference        |
|--------------------|------------------------------------|------------------|
| _                  | Indefinite Length Encoding (ai=31) | RFC8949, RFC-XXXX |
| _i                 | ai=0 to ai=23                      | RFC-XXXX          |
| _0                 | ai=24                              | RFC8949, RFC-XXXX |
| _1                 | ai=25                              | RFC8949, RFC-XXXX |
| _2                 | ai=26                              | RFC8949, RFC-XXXX |
| _3                 | ai=27                              | RFC8949, RFC-XXXX |
{: #tab-iana-ei title="Initial Content of Encoding Indicator Registry"}


{:aside}
>
As the "Reference" column reflects, all the encoding indicators
initially registered are already defined in {{Section 8.1 of RFC8949@-cbor}},
with the exception of `_i`, which is defined in {{grammar}} of the
present document.


## Media Type

IANA is requested to add the following Media-Type to the "Media Types"
registry {{IANA.media-types}}.

| Name            | Template                    | Reference              |
| cbor-diagnostic | application/cbor-diagnostic | RFC-XXXX, {{media-type}} |
{: #new-media-type align="left" title="New Media Type application/cbor-diagnostic"}

{:compact}
Type name:
: application

Subtype name:
: cbor-diagnostic

Required parameters:
: N/A

Optional parameters:
: N/A

Encoding considerations:
: binary (UTF-8)

Security considerations:
: {{seccons}} of RFC XXXX

Interoperability considerations:
: none

Published specification:
: {{media-type}} of RFC XXXX

Applications that use this media type:
: Tools interchanging a human-readable form of CBOR

Fragment identifier considerations:
: The syntax and semantics of fragment identifiers is as specified for
  "application/cbor".  (At publication of RFC XXXX, there is no
  fragment identification syntax defined for "application/cbor".)

Additional information:
: \\

  Deprecated alias names for this type:
  : N/A

  Magic number(s):
  : N/A

  File extension(s):
  : .diag

  Macintosh file type code(s):
  : N/A

Person & email address to contact for further information:
: CBOR WG mailing list (cbor@ietf.org),
  or IETF Applications and Real-Time Area (art@ietf.org)

Intended usage:
: LIMITED USE

Restrictions on usage:
: CBOR diagnostic notation represents CBOR data items, which are the
  format intended for actual interchange.
  The media type application/cbor-diagnostic is intended to be used
  within documents about CBOR data items, in diagnostics for human
  consumption, and in other representations of CBOR data items that
  are necessarily text-based such as in configuration files or other
  data edited by humans, often under source-code control.

Author/Change controller:
: IETF

Provisional registration:
: no

## Content-Format

IANA is requested to register a Content-Format number in the
{{content-formats ("CoAP Content-Formats")<IANA.core-parameters}}
sub-registry, within the "Constrained RESTful Environments (CoRE)
Parameters" Registry {{IANA.core-parameters}}, as follows:

| Content-Type                | Content Coding | ID   | Reference |
| application/cbor-diagnostic | -              | TBD1 | RFC-XXXX  |
{: align="left" title="New Content-Format"}

TBD1 is to be assigned from the space 256..9999, according to the
procedure "IETF Review or IESG Approval", preferably a number less
than 1000.

## Stand-in Tags {#iana-standin}

[^cpa]

In the "CBOR Tags" registry {{-tags}}, IANA is requested to assign the
tags in {{tab-tag-values}} from the "specification required" space
(suggested assignments: 888 and 999), with the present document as the
specification reference.

| Tag    | Data Item     | Semantics                                            | Reference |
| CPA888 | null or array | Diagnostic Notation Ellipsis                         | RFC-XXXX  |
| CPA999 | array         | Diagnostic Notation<br>Unresolved Application-Extension | RFC-XXXX  |
{: #tab-tag-values cols='r l l' title="Values for Tags"}


Security considerations {#seccons}
=======================

The security considerations of {{-cbor}} and {{-cddl}} apply.

The EDN specification provides two explicit extension points,
application-extension identifiers ({{appext-iana}}) and encoding
indicators ({{reg-ei}}).
Extensions introduced this way can have their own security
considerations (see, e.g., {{Section 5 of -eref}}).
When implementing tools that support the use of EDN extensions, the
implementer needs to be careful not to inadvertently introduce a
vector for an attacker to invoke extensions not planned for by the
tool operator, who might not have considered security considerations
of specific extensions such as those posed by their use of
dereferenceable identifiers ({{Section 6 of -deref}}).
For instance, tools might require explicitly enabling the use of each
extension that is not on an allowlist.
This task can possibly be
made less onerous by combining it with a mechanism for supplying any
parameters controlling such an extension.

--- back

EDN and CDDL
============

This appendix is for information.

EDN was designed as a language to provide a human-readable
representation of an instance, i.e., a single CBOR data item or CBOR
sequence.
CDDL was designed as a language to describe an (often large) set of
such instances (which itself constitutes a language), in the form of a
_data definition_ or _grammar_ (or sometimes called _schema_).

The two languages share some similarities, not the least because they
have mutually inspired each other.
But they have very different roots:

* EDN syntax is an extension to JSON syntax {{-json}}.
  (Any (interoperable) JSON text is also valid EDN.)
* CDDL syntax is inspired by ABNF's syntax {{-abnf}}.

For engineers that are using both EDN and CDDL, it is easy to write
"CDDLisms" or "EDNisms" into their drafts that are meant to be in the
other language.
(This is one more of the many motivations to always validate formal
language instances with tools.)

Important differences include:

* Comment syntax.  CDDL inherits ABNF's semicolon-delimited end of
  line characters, while EDN finds nothing in JSON that could be inherited here.
  Inspired by JavaScript, EDN simplifies JavaScript's copy of the
  original C comment syntax to be delimited by single slashes (where
  line breaks are not of interest); it also adds end-of-line comments
  starting with `#`.

  {:compact}
  EDN:
  : ~~~ cbor-diag
    { / alg / 1: -7 / ECDSA 256 / }
    ,
    { 1:   # alg
        -7 # ECDSA 256
    }
    ~~~

  CDDL:
  : `? 1 => int / tstr,  ; algorithm identifier`

* Syntax for tags.  CDDL's tag syntax is part of the system for
  referring to CBOR's fundamentals (the major type 6, in this case)
  and (with {{-cddlupd}}) allows specifying the actual tag number
  separately, while EDN's tag syntax is a simple decimal number and a
  pair of parentheses.

  EDN:
  : ~~~
    98([h'', # empty encoded protected header
        {},  # empty unprotected header
        ...  # rest elided here
       ])
    ~~~

  CDDL:
  : `COSE_Sign_Tagged = #6.98(COSE_Sign)`

* Embedded CBOR.  EDN has a special syntax to describe the content of
  byte strings that are encoded CBOR data items.  CDDL can specify
  these with a control operator, which looks very different.

  EDN:
  : ~~~
    98([<< {/alg/ 1: -7 /ECDSA 256/} >>, # == h'a10126'
        ...                              # rest elided here
       ])
    ~~~

  CDDL:
  : `serialized_map = bytes .cbor header_map`



Acknowledgements
================
{: numbered="no"}

The concept of application-oriented extensions to diagnostic notation,
as well as the definition for the "dt" extension, were inspired by the
CoRAL work by Klaus Hartke.

(TBD)
