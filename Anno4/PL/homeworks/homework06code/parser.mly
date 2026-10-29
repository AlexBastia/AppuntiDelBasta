%{
module C = Ast.Code
module L = Ast.Logic

(* Pure propositions describe the empty heap. Only Star can combine them
   with heap atoms; And, Or, and Not must stay entirely within a proposition. *)
type assertion_expr =
  | Pure of L.pure_assn
  | Atom of L.heap_atom
  | And of assertion_expr * assertion_expr
  | Or of assertion_expr * assertion_expr
  | Not of assertion_expr
  | Star of assertion_expr * assertion_expr

let rec pure = function
  | Pure p -> p
  | And (p, q) -> L.And (pure p, pure q)
  | Or (p, q) -> L.Or (pure p, pure q)
  | Not p -> L.Not (pure p)
  | _ -> raise Parsing.Parse_error

let conjoin p q = match p, q with
  | L.True, p | p, L.True -> p
  | p, q -> L.And (p, q)

let rec assertion : assertion_expr -> L.assn = function
  | Atom a -> (L.True, [a])
  | Star (p, q) ->
      let phi, atoms = assertion p in
      let psi, more = assertion q in
      (conjoin phi psi, atoms @ more)
  | p -> (pure p, [])
let sequence first rest =
  List.fold_left (fun left (annotation, right) -> C.Seq(left, annotation, right))
    first rest
%}

%token <int> INT
%token <string> VAR
%token <Ast.info> TEST
%token PLUS MINUS TIMES EOF
  LPAREN RPAREN TRUE FALSE EQUALS NOTEQUALS LESS LESSEQ GREATER GREATEREQ
  NOT AND OR DOLLAR UNDERSCORE POINTSTO LISTSEG LIST
  SKIP ASSIGN PRINT SEMI IF THEN ELSE WHILE DO LBRACE RBRACE AT
  NEW FREE COMMA

/* Prefer arithmetic multiplication inside an unparenthesized comparison.
   Parenthesize pure formulas before using them as separation operands.
   Also prefer multiplication to starting a memory write after an if without
   else; use a semicolon to separate that write from the preceding statement. */
%left PLUS MINUS
%left TIMES

%type <Ast.Code.com> com
%type <Ast.Code.aexp> aexp
%type <Ast.Code.bexp> bexp
%type <Ast.Logic.assn * Ast.Code.com * Ast.Logic.assn> program
%start program

%%

aexp: aexp PLUS taexp                    { C.Plus($1, $3) }
  | aexp MINUS taexp                     { C.Minus($1, $3) }
  | taexp %prec PLUS                    { $1 }
taexp: taexp TIMES aaexp                 { C.Times($1, $3) }
  | aaexp                               { $1 }
aaexp: INT                              { C.Int $1 }
  | MINUS INT                           { C.Int (- $2) }
  | VAR                                 { C.Var $1 }
  | LPAREN aexp RPAREN                  { $2 }

lexp: lexp PLUS tlexp                    { L.Plus($1, $3) }
  | lexp MINUS tlexp                     { L.Minus($1, $3) }
  | tlexp %prec PLUS                    { $1 }
tlexp: tlexp TIMES alexp                 { L.Times($1, $3) }
  | alexp                               { $1 }
alexp: INT                              { L.Int $1 }
  | MINUS INT                           { L.Int (- $2) }
  | VAR                                 { L.PVar $1 }
  | DOLLAR VAR                          { L.LVar $2 }
  | LPAREN lexp RPAREN                  { $2 }

bexp: bexp OR cbexp                      { C.Or($1, $3) }
  | cbexp                               { $1 }
cbexp: cbexp AND nbexp                   { C.And($1, $3) }
  | nbexp                               { $1 }
nbexp: NOT nbexp                         { C.Not $2 }
  | abexp                               { $1 }
abexp: TRUE                             { C.True }
  | FALSE                               { C.False }
  | aexp EQUALS aexp                    { C.Equals($1, $3) }
  | aexp NOTEQUALS aexp                 { C.NotEquals($1, $3) }
  | aexp LESS aexp                      { C.Less($1, $3) }
  | aexp LESSEQ aexp                    { C.LessEq($1, $3) }
  | aexp GREATER aexp                   { C.Greater($1, $3) }
  | aexp GREATEREQ aexp                 { C.GreaterEq($1, $3) }
  | LPAREN bexp RPAREN                  { $2 }

basic: SKIP                              { C.Skip }
  | VAR ASSIGN aexp                     { C.Assign($1, $3) }
  | PRINT aexp                          { C.Print $2 }
  | TEST bexp                           { C.Test($1, $2) }
  | VAR ASSIGN TIMES aaexp              { C.ReadMem($1, $4) }
  | TIMES aaexp ASSIGN aexp              { C.WriteMem($2, $4) }
  | VAR ASSIGN NEW LPAREN aexp_list RPAREN { C.New($1, $5) }
  | FREE LPAREN INT COMMA aexp RPAREN    {
      if $3 <= 0 then raise Parsing.Parse_error else C.Free($3, $5)
    }

aexp_list: aexp                         { [$1] }
  | aexp COMMA aexp_list                { $1 :: $3 }

/* A simple statement needs a semicolon to be terminated. A statement ending
   in a block is already terminated, and may also have a semicolon. */
unterminated: basic                      { $1 }
  | IF bexp THEN acom ELSE basic         { C.If($2, $4, $6) }
  | WHILE bexp DO spec basic             { C.While($2, $4, $5) }
terminated: unterminated SEMI           { $1 }
  | block optional_semi                 { $1 }
  | IF bexp THEN acom ELSE block optional_semi { C.If($2, $4, $6) }
  | IF bexp THEN acom optional_semi { C.If($2, $4, C.Skip) }
  | WHILE bexp DO spec block optional_semi { C.While($2, $4, $5) }
optional_semi:                          { () }
  | SEMI                                { () }
acom: basic                              { $1 }
  | block                               { $1 }
block: LBRACE com RBRACE                { $2 }
  | LBRACE RBRACE                       { C.Skip }

/* Collect terminated statements followed by an optional unterminated one.
   Fold the list to preserve the sequence AST's left associativity. */
com: statements                        { let first, rest = $1 in sequence first rest }
statements: unterminated                { ($1, []) }
  | terminated statement_tail           { ($1, $2) }
statement_tail:                         { [] }
  | statements                          { let first, rest = $1 in (None, first) :: rest }
  | spec statements                     { let first, rest = $2 in (Some $1, first) :: rest }

/* At program level, an assertion can either separate two statements or be
   the postcondition. Consume it before choosing based on the following token. */
program_statements: unterminated spec   { ($1, [], $2) }
  | terminated program_tail             { let rest, post = $2 in ($1, rest, post) }
program_tail: spec                      { ([], $1) }
  | program_statements                  { let first, rest, post = $1 in ((None, first) :: rest, post) }
  | spec program_statements             { let first, rest, post = $2 in ((Some $1, first) :: rest, post) }

spec: AT assn AT                        { assertion $2 }

/* Program annotations contain only simple heap assertions. Classical
   connectives are restricted to pure propositions by `pure` above. */
assn: dassn                             { $1 }
dassn: dassn OR cassn                    { Or($1, $3) }
  | cassn                               { $1 }
cassn: cassn AND sassn                   { And($1, $3) }
  | sassn                               { $1 }
sassn: nassn TIMES sassn                 { Star($1, $3) }
  | nassn                               { $1 }
nassn: NOT nassn                         { Not $2 }
  | aassn                               { $1 }
aassn: TRUE                             { Pure L.True }
  | FALSE                               { Pure L.False }
  | lexp EQUALS lexp                    { Pure (L.Equals($1, $3)) }
  | lexp NOTEQUALS lexp                 { Pure (L.NotEquals($1, $3)) }
  | lexp LESS lexp                      { Pure (L.Less($1, $3)) }
  | lexp LESSEQ lexp                    { Pure (L.LessEq($1, $3)) }
  | lexp GREATER lexp                   { Pure (L.Greater($1, $3)) }
  | lexp GREATEREQ lexp                 { Pure (L.GreaterEq($1, $3)) }
  | lexp POINTSTO alexp                 { Atom (L.PointsTo($1, $3)) }
  | lexp POINTSTO UNDERSCORE            { Atom (L.PointsToSomething $1) }
  | LISTSEG LPAREN lexp COMMA lexp RPAREN { Atom (L.ListSeg($3, $5)) }
  | LIST LPAREN lexp RPAREN              { Atom (L.ListSeg($3, L.Int 0)) }
  | LPAREN assn RPAREN                  { $2 }

program: spec program_statements EOF   {
    let first, rest, post = $2 in ($1, sequence first rest, post)
  }
