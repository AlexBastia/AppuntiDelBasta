type token =
  | INT of (
# 5 "parser.mly"
        int
# 6 "parser.ml"
)
  | VAR of (
# 6 "parser.mly"
        string
# 11 "parser.ml"
)
  | TEST of (
# 7 "parser.mly"
        Ast.info
# 16 "parser.ml"
)
  | PLUS
  | MINUS
  | TIMES
  | EOF
  | LPAREN
  | RPAREN
  | TRUE
  | FALSE
  | EQUALS
  | NOTEQUALS
  | LESS
  | LESSEQ
  | GREATER
  | GREATEREQ
  | FORALL
  | EXISTS
  | NOT
  | AND
  | OR
  | IMPLIES
  | DOLLAR
  | SKIP
  | ASSIGN
  | PRINT
  | SEMI
  | IF
  | THEN
  | ELSE
  | WHILE
  | DO
  | LBRACE
  | RBRACE
  | AT

open Parsing
let _ = parse_error;;
# 2 "parser.mly"
open Ast
# 56 "parser.ml"
let yytransl_const = [|
  260 (* PLUS *);
  261 (* MINUS *);
  262 (* TIMES *);
    0 (* EOF *);
  263 (* LPAREN *);
  264 (* RPAREN *);
  265 (* TRUE *);
  266 (* FALSE *);
  267 (* EQUALS *);
  268 (* NOTEQUALS *);
  269 (* LESS *);
  270 (* LESSEQ *);
  271 (* GREATER *);
  272 (* GREATEREQ *);
  273 (* FORALL *);
  274 (* EXISTS *);
  275 (* NOT *);
  276 (* AND *);
  277 (* OR *);
  278 (* IMPLIES *);
  279 (* DOLLAR *);
  280 (* SKIP *);
  281 (* ASSIGN *);
  282 (* PRINT *);
  283 (* SEMI *);
  284 (* IF *);
  285 (* THEN *);
  286 (* ELSE *);
  287 (* WHILE *);
  288 (* DO *);
  289 (* LBRACE *);
  290 (* RBRACE *);
  291 (* AT *);
    0|]

let yytransl_block = [|
  257 (* INT *);
  258 (* VAR *);
  259 (* TEST *);
    0|]

let yylhs = "\255\255\
\002\000\002\000\002\000\005\000\005\000\006\000\006\000\006\000\
\006\000\007\000\007\000\007\000\008\000\008\000\009\000\009\000\
\009\000\009\000\009\000\003\000\003\000\010\000\010\000\011\000\
\011\000\012\000\012\000\012\000\012\000\012\000\012\000\012\000\
\012\000\012\000\001\000\001\000\001\000\014\000\014\000\014\000\
\015\000\015\000\015\000\015\000\015\000\013\000\016\000\016\000\
\017\000\017\000\018\000\018\000\019\000\019\000\020\000\020\000\
\020\000\020\000\020\000\020\000\020\000\020\000\020\000\020\000\
\020\000\004\000\000\000"

let yylen = "\002\000\
\003\000\003\000\001\000\003\000\001\000\001\000\002\000\001\000\
\003\000\003\000\003\000\001\000\003\000\001\000\001\000\002\000\
\001\000\002\000\003\000\003\000\001\000\003\000\001\000\002\000\
\001\000\001\000\001\000\003\000\003\000\003\000\003\000\003\000\
\003\000\003\000\004\000\003\000\001\000\006\000\005\000\001\000\
\001\000\003\000\002\000\002\000\003\000\003\000\003\000\001\000\
\003\000\001\000\003\000\001\000\002\000\001\000\001\000\001\000\
\003\000\003\000\003\000\003\000\003\000\003\000\006\000\006\000\
\003\000\004\000\002\000"

let yydefred = "\000\000\
\000\000\000\000\000\000\067\000\000\000\015\000\017\000\000\000\
\000\000\055\000\056\000\000\000\000\000\000\000\000\000\000\000\
\000\000\014\000\000\000\000\000\000\000\052\000\054\000\000\000\
\000\000\041\000\000\000\000\000\000\000\000\000\000\000\037\000\
\040\000\016\000\000\000\000\000\000\000\000\000\053\000\018\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\046\000\000\000\000\000\000\000\000\000\006\000\008\000\
\000\000\000\000\026\000\027\000\000\000\000\000\000\000\000\000\
\005\000\000\000\023\000\025\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\019\000\065\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\013\000\000\000\047\000\051\000\000\000\007\000\000\000\000\000\
\024\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\045\000\
\000\000\036\000\066\000\000\000\000\000\000\000\009\000\034\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\004\000\022\000\000\000\000\000\035\000\000\000\000\000\
\000\000\039\000\063\000\064\000\038\000"

let yydgoto = "\002\000\
\031\000\062\000\063\000\004\000\064\000\065\000\016\000\017\000\
\018\000\066\000\067\000\068\000\005\000\032\000\033\000\019\000\
\020\000\021\000\022\000\023\000"

let yysindex = "\002\000\
\236\254\000\000\140\000\000\000\209\255\000\000\000\000\020\255\
\140\000\000\000\000\000\004\255\016\255\159\000\056\255\213\000\
\068\255\000\000\045\255\106\255\079\255\000\000\000\000\097\255\
\178\000\000\000\138\255\178\000\178\000\209\255\037\255\000\000\
\000\000\000\000\187\000\130\255\112\255\147\255\000\000\000\000\
\009\255\009\255\009\255\009\255\009\255\009\255\009\255\009\255\
\009\255\000\000\140\000\140\000\140\000\138\255\000\000\000\000\
\151\255\178\000\000\000\000\000\242\000\226\000\133\255\156\255\
\000\000\152\255\000\000\000\000\138\255\142\255\077\255\041\255\
\086\255\002\255\175\000\000\000\000\000\174\255\177\255\009\255\
\068\255\068\255\166\255\166\255\166\255\166\255\166\255\166\255\
\000\000\079\255\000\000\000\000\142\255\000\000\200\000\254\254\
\000\000\138\255\138\255\138\255\138\255\138\255\138\255\138\255\
\138\255\178\000\138\255\178\000\107\255\005\255\236\254\000\000\
\209\255\000\000\000\000\140\000\140\000\155\255\000\000\000\000\
\156\255\156\255\142\255\142\255\142\255\142\255\142\255\142\255\
\152\255\000\000\000\000\161\255\005\255\000\000\178\255\186\255\
\005\255\000\000\000\000\000\000\000\000"

let yyrindex = "\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\055\255\000\000\000\000\015\255\057\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\246\254\089\255\
\000\000\067\000\000\000\000\000\000\000\061\255\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\185\255\210\255\026\255\056\000\095\000\100\000\105\000\111\000\
\000\000\109\255\000\000\000\000\216\255\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\121\255\153\255\228\255\244\255\004\000\020\000\036\000\052\000\
\077\000\000\000\000\000\000\000\000\000\000\000\000\000\000\000\
\000\000\000\000\000\000\000\000\000\000"

let yygindex = "\000\000\
\162\000\238\255\240\255\000\000\078\000\088\000\009\000\137\000\
\153\000\097\000\096\000\147\000\226\255\184\255\168\255\247\255\
\000\000\158\000\157\000\199\000"

let yytablesize = 508
let yytable = "\036\000\
\075\000\114\000\001\000\024\000\025\000\120\000\024\000\025\000\
\070\000\006\000\007\000\071\000\072\000\008\000\003\000\080\000\
\044\000\035\000\106\000\044\000\034\000\132\000\048\000\044\000\
\044\000\026\000\037\000\027\000\026\000\028\000\027\000\015\000\
\029\000\057\000\030\000\093\000\003\000\030\000\038\000\095\000\
\134\000\096\000\091\000\113\000\138\000\057\000\057\000\057\000\
\141\000\048\000\109\000\083\000\084\000\085\000\086\000\087\000\
\088\000\040\000\012\000\012\000\057\000\106\000\012\000\074\000\
\050\000\012\000\012\000\012\000\012\000\012\000\012\000\003\000\
\111\000\049\000\012\000\012\000\012\000\050\000\050\000\050\000\
\133\000\123\000\124\000\125\000\126\000\127\000\128\000\043\000\
\118\000\012\000\043\000\050\000\003\000\003\000\043\000\043\000\
\003\000\106\000\053\000\003\000\003\000\003\000\003\000\003\000\
\003\000\110\000\135\000\136\000\003\000\003\000\098\000\099\000\
\074\000\078\000\119\000\003\000\049\000\003\000\003\000\112\000\
\003\000\054\000\003\000\003\000\001\000\001\000\051\000\052\000\
\001\000\049\000\049\000\001\000\001\000\001\000\001\000\001\000\
\001\000\077\000\055\000\056\000\001\000\001\000\057\000\049\000\
\069\000\098\000\099\000\001\000\079\000\001\000\001\000\094\000\
\001\000\106\000\001\000\001\000\002\000\002\000\041\000\042\000\
\002\000\107\000\076\000\002\000\002\000\002\000\002\000\002\000\
\002\000\041\000\042\000\108\000\002\000\002\000\115\000\121\000\
\122\000\081\000\082\000\002\000\116\000\002\000\002\000\117\000\
\002\000\139\000\002\000\002\000\010\000\010\000\137\000\073\000\
\010\000\140\000\130\000\010\000\010\000\010\000\010\000\010\000\
\010\000\089\000\129\000\131\000\010\000\010\000\010\000\097\000\
\090\000\092\000\024\000\025\000\039\000\011\000\011\000\000\000\
\000\000\011\000\000\000\010\000\011\000\011\000\011\000\011\000\
\011\000\011\000\000\000\000\000\000\000\011\000\011\000\011\000\
\026\000\000\000\027\000\028\000\028\000\000\000\000\000\029\000\
\000\000\030\000\042\000\000\000\011\000\042\000\000\000\028\000\
\028\000\042\000\042\000\029\000\000\000\000\000\028\000\000\000\
\028\000\028\000\000\000\028\000\000\000\028\000\028\000\029\000\
\029\000\000\000\000\000\030\000\000\000\000\000\029\000\000\000\
\029\000\029\000\000\000\029\000\000\000\029\000\029\000\030\000\
\030\000\000\000\000\000\031\000\000\000\000\000\030\000\000\000\
\030\000\030\000\000\000\030\000\000\000\030\000\030\000\031\000\
\031\000\000\000\000\000\032\000\000\000\000\000\031\000\000\000\
\031\000\031\000\000\000\031\000\000\000\031\000\031\000\032\000\
\032\000\000\000\000\000\033\000\000\000\000\000\032\000\058\000\
\032\000\032\000\000\000\032\000\000\000\032\000\032\000\033\000\
\033\000\000\000\021\000\058\000\058\000\058\000\033\000\000\000\
\033\000\033\000\000\000\033\000\020\000\033\000\033\000\021\000\
\000\000\000\000\058\000\000\000\000\000\021\000\000\000\021\000\
\021\000\020\000\021\000\000\000\021\000\021\000\059\000\020\000\
\000\000\020\000\020\000\060\000\020\000\000\000\020\000\020\000\
\061\000\000\000\059\000\059\000\059\000\000\000\062\000\060\000\
\060\000\060\000\000\000\000\000\061\000\061\000\061\000\000\000\
\000\000\059\000\062\000\062\000\062\000\000\000\060\000\000\000\
\000\000\000\000\000\000\061\000\006\000\007\000\000\000\000\000\
\008\000\062\000\009\000\000\000\010\000\011\000\000\000\000\000\
\000\000\000\000\000\000\000\000\012\000\013\000\014\000\006\000\
\007\000\000\000\015\000\008\000\000\000\009\000\000\000\010\000\
\011\000\000\000\000\000\000\000\000\000\000\000\000\000\012\000\
\013\000\000\000\055\000\056\000\000\000\015\000\057\000\000\000\
\058\000\000\000\059\000\060\000\000\000\000\000\041\000\042\000\
\000\000\000\000\076\000\000\000\061\000\043\000\044\000\045\000\
\046\000\047\000\048\000\098\000\099\000\000\000\000\000\119\000\
\000\000\000\000\100\000\101\000\102\000\103\000\104\000\105\000\
\041\000\042\000\000\000\000\000\000\000\000\000\000\000\043\000\
\044\000\045\000\046\000\047\000\048\000\098\000\099\000\000\000\
\000\000\000\000\000\000\000\000\100\000\101\000\102\000\103\000\
\104\000\105\000\055\000\056\000\000\000\000\000\057\000\000\000\
\058\000\000\000\059\000\060\000"

let yycheck = "\009\000\
\031\000\074\000\001\000\002\001\003\001\008\001\002\001\003\001\
\027\000\001\001\002\001\028\000\029\000\005\001\035\001\007\001\
\027\001\009\000\021\001\030\001\001\001\110\000\008\001\034\001\
\035\001\024\001\023\001\026\001\024\001\028\001\026\001\023\001\
\031\001\008\001\033\001\054\000\035\001\033\001\023\001\058\000\
\113\000\058\000\052\000\074\000\133\000\020\001\021\001\022\001\
\137\000\035\001\069\000\043\000\044\000\045\000\046\000\047\000\
\048\000\002\001\004\001\005\001\035\001\021\001\008\001\027\001\
\008\001\011\001\012\001\013\001\014\001\015\001\016\001\035\001\
\032\001\006\001\020\001\021\001\022\001\021\001\022\001\035\001\
\111\000\100\000\101\000\102\000\103\000\104\000\105\000\027\001\
\080\000\035\001\030\001\035\001\004\001\005\001\034\001\035\001\
\008\001\021\001\020\001\011\001\012\001\013\001\014\001\015\001\
\016\001\029\001\116\000\117\000\020\001\021\001\004\001\005\001\
\027\001\002\001\008\001\027\001\008\001\029\001\030\001\034\001\
\032\001\025\001\034\001\035\001\004\001\005\001\021\001\022\001\
\008\001\021\001\022\001\011\001\012\001\013\001\014\001\015\001\
\016\001\008\001\001\001\002\001\020\001\021\001\005\001\035\001\
\007\001\004\001\005\001\027\001\002\001\029\001\030\001\001\001\
\032\001\021\001\034\001\035\001\004\001\005\001\004\001\005\001\
\008\001\006\001\008\001\011\001\012\001\013\001\014\001\015\001\
\016\001\004\001\005\001\020\001\020\001\021\001\000\000\098\000\
\099\000\041\000\042\000\027\001\007\001\029\001\030\001\007\001\
\032\001\008\001\034\001\035\001\004\001\005\001\030\001\030\000\
\008\001\008\001\107\000\011\001\012\001\013\001\014\001\015\001\
\016\001\049\000\106\000\108\000\020\001\021\001\022\001\061\000\
\051\000\053\000\002\001\003\001\014\000\004\001\005\001\255\255\
\255\255\008\001\255\255\035\001\011\001\012\001\013\001\014\001\
\015\001\016\001\255\255\255\255\255\255\020\001\021\001\022\001\
\024\001\255\255\026\001\008\001\028\001\255\255\255\255\031\001\
\255\255\033\001\027\001\255\255\035\001\030\001\255\255\020\001\
\021\001\034\001\035\001\008\001\255\255\255\255\027\001\255\255\
\029\001\030\001\255\255\032\001\255\255\034\001\035\001\020\001\
\021\001\255\255\255\255\008\001\255\255\255\255\027\001\255\255\
\029\001\030\001\255\255\032\001\255\255\034\001\035\001\020\001\
\021\001\255\255\255\255\008\001\255\255\255\255\027\001\255\255\
\029\001\030\001\255\255\032\001\255\255\034\001\035\001\020\001\
\021\001\255\255\255\255\008\001\255\255\255\255\027\001\255\255\
\029\001\030\001\255\255\032\001\255\255\034\001\035\001\020\001\
\021\001\255\255\255\255\008\001\255\255\255\255\027\001\008\001\
\029\001\030\001\255\255\032\001\255\255\034\001\035\001\020\001\
\021\001\255\255\008\001\020\001\021\001\022\001\027\001\255\255\
\029\001\030\001\255\255\032\001\008\001\034\001\035\001\021\001\
\255\255\255\255\035\001\255\255\255\255\027\001\255\255\029\001\
\030\001\021\001\032\001\255\255\034\001\035\001\008\001\027\001\
\255\255\029\001\030\001\008\001\032\001\255\255\034\001\035\001\
\008\001\255\255\020\001\021\001\022\001\255\255\008\001\020\001\
\021\001\022\001\255\255\255\255\020\001\021\001\022\001\255\255\
\255\255\035\001\020\001\021\001\022\001\255\255\035\001\255\255\
\255\255\255\255\255\255\035\001\001\001\002\001\255\255\255\255\
\005\001\035\001\007\001\255\255\009\001\010\001\255\255\255\255\
\255\255\255\255\255\255\255\255\017\001\018\001\019\001\001\001\
\002\001\255\255\023\001\005\001\255\255\007\001\255\255\009\001\
\010\001\255\255\255\255\255\255\255\255\255\255\255\255\017\001\
\018\001\255\255\001\001\002\001\255\255\023\001\005\001\255\255\
\007\001\255\255\009\001\010\001\255\255\255\255\004\001\005\001\
\255\255\255\255\008\001\255\255\019\001\011\001\012\001\013\001\
\014\001\015\001\016\001\004\001\005\001\255\255\255\255\008\001\
\255\255\255\255\011\001\012\001\013\001\014\001\015\001\016\001\
\004\001\005\001\255\255\255\255\255\255\255\255\255\255\011\001\
\012\001\013\001\014\001\015\001\016\001\004\001\005\001\255\255\
\255\255\255\255\255\255\255\255\011\001\012\001\013\001\014\001\
\015\001\016\001\001\001\002\001\255\255\255\255\005\001\255\255\
\007\001\255\255\009\001\010\001"

let yynames_const = "\
  PLUS\000\
  MINUS\000\
  TIMES\000\
  EOF\000\
  LPAREN\000\
  RPAREN\000\
  TRUE\000\
  FALSE\000\
  EQUALS\000\
  NOTEQUALS\000\
  LESS\000\
  LESSEQ\000\
  GREATER\000\
  GREATEREQ\000\
  FORALL\000\
  EXISTS\000\
  NOT\000\
  AND\000\
  OR\000\
  IMPLIES\000\
  DOLLAR\000\
  SKIP\000\
  ASSIGN\000\
  PRINT\000\
  SEMI\000\
  IF\000\
  THEN\000\
  ELSE\000\
  WHILE\000\
  DO\000\
  LBRACE\000\
  RBRACE\000\
  AT\000\
  "

let yynames_block = "\
  INT\000\
  VAR\000\
  TEST\000\
  "

let yyact = [|
  (fun _ -> failwith "parser")
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'taexp) in
    Obj.repr(
# 23 "parser.mly"
                                         ( Plus(_1, _3) )
# 374 "parser.ml"
               : aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'taexp) in
    Obj.repr(
# 24 "parser.mly"
                                         ( Minus(_1, _3) )
# 382 "parser.ml"
               : aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'taexp) in
    Obj.repr(
# 25 "parser.mly"
                                         ( _1 )
# 389 "parser.ml"
               : aexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'taexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'aaexp) in
    Obj.repr(
# 27 "parser.mly"
                                         ( Times(_1, _3) )
# 397 "parser.ml"
               : 'taexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'aaexp) in
    Obj.repr(
# 28 "parser.mly"
                                         ( _1 )
# 404 "parser.ml"
               : 'taexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 30 "parser.mly"
                                         ( Int(_1) )
# 411 "parser.ml"
               : 'aaexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 31 "parser.mly"
                                         ( Int(-_2) )
# 418 "parser.ml"
               : 'aaexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 32 "parser.mly"
                                         ( Var(_1) )
# 425 "parser.ml"
               : 'aaexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : aexp) in
    Obj.repr(
# 33 "parser.mly"
                                         ( _2 )
# 432 "parser.ml"
               : 'aaexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tlexp) in
    Obj.repr(
# 36 "parser.mly"
                                         ( LPlus(_1,_3) )
# 440 "parser.ml"
               : 'lexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'tlexp) in
    Obj.repr(
# 37 "parser.mly"
                                         ( LMinus(_1,_3) )
# 448 "parser.ml"
               : 'lexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'tlexp) in
    Obj.repr(
# 38 "parser.mly"
                                         ( _1 )
# 455 "parser.ml"
               : 'lexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'tlexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'alexp) in
    Obj.repr(
# 40 "parser.mly"
                                         ( LTimes(_1,_3) )
# 463 "parser.ml"
               : 'tlexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'alexp) in
    Obj.repr(
# 41 "parser.mly"
                                         ( _1 )
# 470 "parser.ml"
               : 'tlexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 44 "parser.mly"
                                         ( LInt(_1) )
# 477 "parser.ml"
               : 'alexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : int) in
    Obj.repr(
# 45 "parser.mly"
                                         ( LInt(-_2) )
# 484 "parser.ml"
               : 'alexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 46 "parser.mly"
                                         ( LPVar(_1) )
# 491 "parser.ml"
               : 'alexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : string) in
    Obj.repr(
# 47 "parser.mly"
                                         ( LLVar(_2) )
# 498 "parser.ml"
               : 'alexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'lexp) in
    Obj.repr(
# 48 "parser.mly"
                                         ( _2 )
# 505 "parser.ml"
               : 'alexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : bexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cbexp) in
    Obj.repr(
# 51 "parser.mly"
                                         ( Or(_1, _3) )
# 513 "parser.ml"
               : bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'cbexp) in
    Obj.repr(
# 52 "parser.mly"
                                         ( _1 )
# 520 "parser.ml"
               : bexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cbexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'nbexp) in
    Obj.repr(
# 54 "parser.mly"
                                         ( And(_1, _3) )
# 528 "parser.ml"
               : 'cbexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'nbexp) in
    Obj.repr(
# 55 "parser.mly"
                                         ( _1 )
# 535 "parser.ml"
               : 'cbexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'abexp) in
    Obj.repr(
# 57 "parser.mly"
                                         ( Not(_2) )
# 542 "parser.ml"
               : 'nbexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'abexp) in
    Obj.repr(
# 58 "parser.mly"
                                         ( _1 )
# 549 "parser.ml"
               : 'nbexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 60 "parser.mly"
                                         ( True )
# 555 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    Obj.repr(
# 61 "parser.mly"
                                         ( False )
# 561 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 62 "parser.mly"
                                         ( Equals(_1, _3) )
# 569 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 63 "parser.mly"
                                         ( NotEquals(_1, _3) )
# 577 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 64 "parser.mly"
                                         ( Less(_1, _3) )
# 585 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 65 "parser.mly"
                                         ( LessEq(_1, _3) )
# 593 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 66 "parser.mly"
                                         ( Greater(_1, _3) )
# 601 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : aexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 67 "parser.mly"
                                         ( GreaterEq(_1, _3) )
# 609 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : bexp) in
    Obj.repr(
# 68 "parser.mly"
                                         ( _2 )
# 616 "parser.ml"
               : 'abexp))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : com) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'spec) in
    let _4 = (Parsing.peek_val __caml_parser_env 0 : 'icom) in
    Obj.repr(
# 71 "parser.mly"
                                         ( Seq(_1,Some _3,_4) )
# 625 "parser.ml"
               : com))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : com) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'icom) in
    Obj.repr(
# 72 "parser.mly"
                                         ( Seq(_1,None,_3) )
# 633 "parser.ml"
               : com))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'icom) in
    Obj.repr(
# 73 "parser.mly"
                                         ( _1 )
# 640 "parser.ml"
               : com))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 4 : bexp) in
    let _4 = (Parsing.peek_val __caml_parser_env 2 : 'acom) in
    let _6 = (Parsing.peek_val __caml_parser_env 0 : 'acom) in
    Obj.repr(
# 75 "parser.mly"
                                         ( If(_2,_4,_6) )
# 649 "parser.ml"
               : 'icom))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 3 : bexp) in
    let _4 = (Parsing.peek_val __caml_parser_env 1 : 'spec) in
    let _5 = (Parsing.peek_val __caml_parser_env 0 : 'acom) in
    Obj.repr(
# 76 "parser.mly"
                                         ( While(_2,_4,_5) )
# 658 "parser.ml"
               : 'icom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'acom) in
    Obj.repr(
# 77 "parser.mly"
                                         ( _1 )
# 665 "parser.ml"
               : 'icom))
; (fun __caml_parser_env ->
    Obj.repr(
# 79 "parser.mly"
                                         ( Skip )
# 671 "parser.ml"
               : 'acom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : string) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 80 "parser.mly"
                                         ( Assign(_1,_3) )
# 679 "parser.ml"
               : 'acom))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : aexp) in
    Obj.repr(
# 81 "parser.mly"
                                         ( Print(_2) )
# 686 "parser.ml"
               : 'acom))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 1 : Ast.info) in
    let _2 = (Parsing.peek_val __caml_parser_env 0 : bexp) in
    Obj.repr(
# 82 "parser.mly"
                                         ( Test(_1,_2) )
# 694 "parser.ml"
               : 'acom))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : com) in
    Obj.repr(
# 83 "parser.mly"
                                         ( _2 )
# 701 "parser.ml"
               : 'acom))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'assn) in
    Obj.repr(
# 85 "parser.mly"
                                         ( _2 )
# 708 "parser.ml"
               : 'spec))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'dassn) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'assn) in
    Obj.repr(
# 87 "parser.mly"
                                         ( AImplies(_1,_3) )
# 716 "parser.ml"
               : 'assn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'dassn) in
    Obj.repr(
# 88 "parser.mly"
                                         ( _1 )
# 723 "parser.ml"
               : 'assn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'dassn) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'cassn) in
    Obj.repr(
# 90 "parser.mly"
                                         ( AOr(_1,_3) )
# 731 "parser.ml"
               : 'dassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'cassn) in
    Obj.repr(
# 91 "parser.mly"
                                         ( _1 )
# 738 "parser.ml"
               : 'dassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'cassn) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'nassn) in
    Obj.repr(
# 93 "parser.mly"
                                         ( AAnd(_1,_3) )
# 746 "parser.ml"
               : 'cassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'nassn) in
    Obj.repr(
# 94 "parser.mly"
                                         ( _1 )
# 753 "parser.ml"
               : 'cassn))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 0 : 'aassn) in
    Obj.repr(
# 96 "parser.mly"
                                         ( ANot(_2) )
# 760 "parser.ml"
               : 'nassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 0 : 'aassn) in
    Obj.repr(
# 97 "parser.mly"
                                         ( _1 )
# 767 "parser.ml"
               : 'nassn))
; (fun __caml_parser_env ->
    Obj.repr(
# 99 "parser.mly"
                                         ( ATrue )
# 773 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    Obj.repr(
# 100 "parser.mly"
                                         ( AFalse )
# 779 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 101 "parser.mly"
                                         ( AEquals(_1,_3) )
# 787 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 102 "parser.mly"
                                         ( ANotEquals(_1,_3) )
# 795 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 103 "parser.mly"
                                         ( ALess(_1,_3) )
# 803 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 104 "parser.mly"
                                         ( ALessEq(_1,_3) )
# 811 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 105 "parser.mly"
                                         ( AGreater(_1,_3) )
# 819 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 2 : 'lexp) in
    let _3 = (Parsing.peek_val __caml_parser_env 0 : 'lexp) in
    Obj.repr(
# 106 "parser.mly"
                                         ( AGreaterEq(_1,_3) )
# 827 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'assn) in
    Obj.repr(
# 107 "parser.mly"
                                         ( AForall(_3,_5) )
# 835 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _3 = (Parsing.peek_val __caml_parser_env 3 : string) in
    let _5 = (Parsing.peek_val __caml_parser_env 1 : 'assn) in
    Obj.repr(
# 108 "parser.mly"
                                         ( AExists(_3,_5) )
# 843 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _2 = (Parsing.peek_val __caml_parser_env 1 : 'assn) in
    Obj.repr(
# 109 "parser.mly"
                                         ( _2 )
# 850 "parser.ml"
               : 'aassn))
; (fun __caml_parser_env ->
    let _1 = (Parsing.peek_val __caml_parser_env 3 : 'spec) in
    let _2 = (Parsing.peek_val __caml_parser_env 2 : com) in
    let _3 = (Parsing.peek_val __caml_parser_env 1 : 'spec) in
    Obj.repr(
# 111 "parser.mly"
                            ( (_1,_2,_3) )
# 859 "parser.ml"
               : Ast.assn * Ast.com * Ast.assn))
(* Entry program *)
; (fun __caml_parser_env -> raise (Parsing.YYexit (Parsing.peek_val __caml_parser_env 0)))
|]
let yytables =
  { Parsing.actions=yyact;
    Parsing.transl_const=yytransl_const;
    Parsing.transl_block=yytransl_block;
    Parsing.lhs=yylhs;
    Parsing.len=yylen;
    Parsing.defred=yydefred;
    Parsing.dgoto=yydgoto;
    Parsing.sindex=yysindex;
    Parsing.rindex=yyrindex;
    Parsing.gindex=yygindex;
    Parsing.tablesize=yytablesize;
    Parsing.table=yytable;
    Parsing.check=yycheck;
    Parsing.error_function=parse_error;
    Parsing.names_const=yynames_const;
    Parsing.names_block=yynames_block }
let program (lexfun : Lexing.lexbuf -> token) (lexbuf : Lexing.lexbuf) =
   (Parsing.yyparse yytables 1 lexfun lexbuf : Ast.assn * Ast.com * Ast.assn)
