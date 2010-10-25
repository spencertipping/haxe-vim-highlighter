" Vim syntax file
" Language: haxe

" Please check :help haxe.vim for comments on some of the options available.

set errorformat=%f\:%l\:\ characters\ %c-%*[^\ ]\ %m,%f\:%l\:\ %m

" Quit when a syntax file was already loaded
if !exists("main_syntax")
  if version < 600
    syntax clear
  elseif exists("b:current_syntax")
    finish
  endif
  " we define it here so that included files can test for it
  let main_syntax='haxe'
endif

" some characters that cannot be in a haxe program (outside a string)
syn match haxeError "[\\@`]"
syn match haxeError "<<<\|=>\|<>\|||=\|&&=\|\*\/"

" use separate name so that it can be deleted in haxecc.vim
syn match   haxeError2 "#\|=<"
hi def link haxeError2 haxeError

" keyword definitions
syn keyword haxeExternal        import extern package using
syn keyword haxeConditional     if else switch
syn keyword haxeRepeat          while for do in
syn keyword haxeBoolean         true false
syn keyword haxeConstant        null
syn keyword haxeClassRef        this super
syn keyword haxeOperator        new cast 
syn keyword haxeType            Void Bool Int Float Dynamic
syn keyword haxeStatement       return
syn keyword haxeStorageClass    final typedef enum
" syn keyword haxeStatic                
syn keyword haxeExceptions      throw try catch finally untyped
syn keyword haxeAssert          assert
syn keyword haxeMethodDecl      synchronized throws
syn keyword haxeClassDecl       extends implements interface
syn match   haxeOperator "\.\.\."
" to differentiate the keyword class from MyClass.class we use a match here
syn match   haxeTypedef         "\.\s*\<class\>"ms=s+1
syn match   haxeClassDecl       "^class\>"
syn match   haxeClassDecl       "[^.]\s*\<class\>"ms=s+1
syn keyword haxeBranch          break continue nextgroup=haxeUserLabelRef skipwhite
syn match   haxeUserLabelRef    "\k\+" contained
syn keyword haxeScopeDecl       static public protected private abstract override 

" haxe.lang.*
syn match haxeLangClass "\<System\>"
syn keyword haxeLangClass  Array BasicType Class Date DateTools EReg Hash IntHash IntIter Iterator Lambda List Math Md5 Reflect Std String StringBuf StringTools Xml XmlType
hi def link haxeLangClass                     haxeType
hi def link haxeLangObject                    haxeConstant
syn cluster haxeTop add=haxeLangObject,haxeLangClass
syn cluster haxeClasses add=haxeLangClass

if filereadable(expand("<sfile>:p:h")."/haxeid.vim")
  source <sfile>:p:h/haxeid.vim
endif

if exists("haxe_space_errors")
  if !exists("haxe_no_trail_space_error")
    syn match   haxeSpaceError  "\s\+$"
  endif
  if !exists("haxe_no_tab_space_error")
    syn match   haxeSpaceError  " \+\t"me=e-1
  endif
endif

syn region  haxeLabelRegion     transparent matchgroup=haxeLabel start="\<case\>" matchgroup=NONE end=":" contains=haxeNumber,haxeCharacter
syn match   haxeUserLabel       "^\s*[_$a-zA-Z][_$a-zA-Z0-9_]*\s*:"he=e-1 contains=haxeLabel
syn keyword haxeLabel           default

" The following cluster contains all haxe groups except the contained ones
syn cluster haxeTop add=haxeExternal,haxeError,haxeBranch,haxeLabelRegion,haxeLabel,haxeConditional,haxeRepeat,haxeBoolean,haxeConstant,haxeTypedef,haxeOperator,haxeType,haxeStatement,haxeStorageClass,haxeAssert,haxeExceptions,haxeMethodDecl,haxeClassDecl,haxeClassDecl,haxeClassDecl,haxeScopeDecl,haxeError2,haxeUserLabel,haxeLangObject

" Comments
syn keyword haxeTodo             contained TODO FIXME XXX
syn region  haxeComment          start="/\*"  end="\*/" contains=@haxeCommentSpecial,haxeTodo,@Spell
syn match   haxeCommentStar      contained "^\s*\*[^/]"me=e-1
syn match   haxeCommentStar      contained "^\s*\*$"
syn match   haxeLineComment      "//.*$" contains=@haxeCommentSpecial2,haxeTodo,@Spell
hi def link haxeCommentString haxeString
hi def link haxeComment2String haxeString
hi def link haxeCommentCharacter haxeCharacter

syn cluster haxeTop add=haxeComment,haxeLineComment

" match the special comment /**/
syn match   haxeComment          "/\*\*/"

" Strings and constants
syn match   haxeSpecialError     contained "\\."
syn match   haxeSpecialCharError contained "[^']"
syn match   haxeSpecialChar      contained "\\\([4-9]\d\|[0-3]\d\d\|[\"\\'ntbrf]\|u\x\{4\}\)"
syn match haxeEregEscape        contained "\(\\\\\|\\/\)"
syn region  haxeEreg            start=+\~\/+ end=+\/[gims]*+ contains=haxeEregEscape

syn region  haxeString          matchgroup=haxeQuotationMarks start=+"+ end=+"+ contains=haxeSpecialChar,haxeSpecialError,@Spell
syn region  haxeSingleString    matchgroup=haxeQuotationMarks start=+'+ end=+'+ 
syn match   haxeCharacter        "'\\''" contains=haxeSpecialChar
syn match   haxeCharacter        "'[^\\]'"
syn match   haxeNumber           "\<\(0[0-7]*\|0[xX]\x\+\|\d\+\)[lL]\=\>"
syn match   haxeNumber           "\(\<\d\+\.\d\+\)\([eE][-+]\=\d\+\)\=[fFdD]\="
syn match   haxeNumber           "\<\d\+[eE][-+]\=\d\+[fFdD]\=\>"
syn match   haxeNumber           "\<\d\+\([eE][-+]\=\d\+\)\=[fFdD]\>"

syn region  haxeVar             matchgroup=haxeVarBoundaries start=/var / matchgroup=NONE end=/\w\W/me=e-1

syn match   haxeOperator        /[-+*<>\[\]{}();%!,\.:&=|]/

syn region  haxeFunctionDef     matchgroup=haxeFunctionBoundaries start=/\Wfunction\W/ms=s+1,me=e-1 matchgroup=NONE end=/(/me=e-1 contains=haxeOperator
syn match   haxeAssignment      /\w\+\s*[-+*/&|]\?=/ contains=haxeOperator

syn region haxeCondIf start="#if \+!\?" end="\W" skip="([A-Za-z0-9_ |&!]\+)"
syn region haxeCondElse start="#else \+!\?" end="\W" skip="([A-Za-z0-9_ |&!]\+)"
syn match haxeCondEnd "#end"
syn match haxeCondError "#else *$"

" unicode characters
syn match   haxeSpecial "\\u\d\{4\}"

syn cluster haxeTop add=haxeString,haxeCharacter,haxeNumber,haxeSpecial,haxeStringError,haxeVar

if exists("haxe_highlight_functions")
  if haxe_highlight_functions == "indent"
    syn match  haxeFuncDef "^\(\t\| \{8\}\)[_$a-zA-Z][_$a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn region haxeFuncDef start=+^\(\t\| \{8\}\)[$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn match  haxeFuncDef "^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*)" contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
    syn region haxeFuncDef start=+^  [$_a-zA-Z][$_a-zA-Z0-9_. \[\]]*([^-+*/()]*,\s*+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,@haxeClasses
  else
    " This line catches method declarations at any indentation>0, but it assumes
    " two things:
    "   1. class names are always capitalized (ie: Button)
    "   2. method names are never capitalized (except constructors, of course)
    syn region haxeFuncDef start=+^\s\+\(\(public\|protected\|private\|static\|abstract\|override\|final\|native\|synchronized\)\s\+\)*\(\(void\|boolean\|char\|byte\|short\|int\|long\|float\|double\|\([A-Za-z_][A-Za-z0-9_$]*\.\)*[A-Z][A-Za-z0-9_$]*\)\(\[\]\)*\s\+[a-z][A-Za-z0-9_$]*\|[A-Z][A-Za-z0-9_$]*\)\s*(+ end=+)+ contains=haxeScopeDecl,haxeType,haxeStorageClass,haxeComment,haxeLineComment,@haxeClasses
  endif
  syn match  haxeBraces  "[{}]"
  syn cluster haxeTop add=haxeFuncDef,haxeBraces
endif

if exists("haxe_mark_braces_in_parens_as_errors")
  syn match haxeInParen          contained "[{}]"
  hi def link haxeInParen        haxeError
  syn cluster haxeTop add=haxeInParen
endif

if !exists("haxe_minlines")
  let haxe_minlines = 10
endif
exec "syn sync ccomment haxeComment minlines=" . haxe_minlines

" The default highlighting.
if version >= 508 || !exists("did_haxe_syn_inits")
  if version < 508
    let did_haxe_syn_inits = 1
  endif
  hi def link haxeFuncDef                Function
  hi def link haxeBraces         Function
  hi def link haxeBranch         Conditional
  hi def link haxeUserLabelRef   haxeUserLabel
  hi def link haxeLabel          Label
  hi def link haxeUserLabel              Label
  hi def link haxeConditional    Conditional
  hi def link haxeRepeat         Repeat
  hi def link haxeExceptions             Exception
  hi def link haxeAssert         Statement
  hi def link haxeStatic MoreMsg
  hi def link haxeStorageClass   StorageClass
  hi def link haxeMethodDecl             haxeStorageClass
  hi def link haxeClassDecl              Special
  hi def link haxeScopeDecl              Special
  hi def link haxeBoolean                Boolean
  hi def link haxeSpecial                Special
  hi def link haxeSpecialError   Error
  hi def link haxeSpecialCharError       Error
  hi def link haxeString         String
  hi def link haxeSingleString   String
  hi def link haxeEreg Special
  hi def link haxeEregEscape Special
  hi def link haxeCharacter      Character
  hi def link haxeSpecialChar    SpecialChar
  hi def link haxeNumber         Number
  hi def link haxeError          Error
  hi def link haxeStringError    Error
  hi def link haxeStatement      Statement
  hi def link haxeComment        Comment
  hi def link haxeDocComment     Comment
  hi def link haxeLineComment    Comment
  hi def link haxeConstant       Constant
  hi def link haxeTypedef        Typedef
  hi def link haxeTodo           Todo

  hi def link haxeOperator       Special
  hi def link haxeParen          Special
  hi def link haxeParen1         Special
  hi def link haxeParen2         Special

  hi def link haxeVarBoundaries  Special
  hi def link haxeVar            Identifier

  hi def link haxeQuotationMarks Special

  hi def link haxeCommentTitle   SpecialComment
  hi def link haxeDocTags        Special
  hi def link haxeDocParam       Function
  hi def link haxeCommentStar    haxeComment

  hi def link haxeType           Type
  hi def link haxeExternal       Include
  hi def link haxeAssignment     Type
  hi def link haxeClassRef       Special

  hi def link htmlComment        Special
  hi def link htmlCommentPart    Special
  hi def link haxeSpaceError     Error

  hi def link haxeFunctionDef    Type
  hi def link haxeFunctionBoundaries Keyword

  hi def link haxeCondIf Macro
  hi def link haxeCondElse Macro
  hi def link haxeCondEnd Macro
  hi def link haxeCondError Error
endif

let b:current_syntax = "haxe"

if main_syntax == 'haxe'
  unlet main_syntax
endif

let b:spell_options="contained"

" vim: ts=8
