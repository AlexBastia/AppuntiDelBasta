open Ast
open Util

(* The type checker. You do not need to modify this file, but you may
   read it to understand where definitional equality is used.

   The function `infer` computes the type of an expression, and the
   function `check` checks an expression against a type that we
   already know. A function lambda x. e does not say what the type of
   x is, and a pair (e1, e2) does not say how the type of e2 depends
   on e1. So their types cannot be inferred: a function can only be
   checked against a Pi type, and a pair against a Sigma type, which
   provide the missing information. This is a simple form of
   bidirectional type checking*)

exception TypeError of string

let error (msg : string) = raise (TypeError msg)

(* A typing context maps the variables in scope to their types. The names
   in a context are always distinct. *)
type context = (string * exp) list

(* Entering the scope of a bound variable `x`, with body `b`. If a variable
   named `x` is already in scope, rename the new one, so that the names in
   the context stay distinct. *)
let enter (ctx : context) (x : string) (b : exp) : string * exp =
  if List.mem_assoc x ctx then
    let x' = fresh (List.map fst ctx @ vars b) x in
    (x', subst b x (Var x'))
  else
    (x, b)

let str = Pprint.string_of_exp

(* The type of an expression might not look like a Pi, a Sigma, or a Type
   until we compute it. If it already does, we leave it alone. *)
let expose (sg : signature) (t : exp) : exp =
  match t with
  | Pi _ | Sigma _ | Type _ -> t
  | _ -> Modes.compute sg t

(* `infer sg ctx e` computes the type of `e` in the signature `sg` and the
   typing context `ctx`, or raises `TypeError` if `e` is not well-typed. *)
let rec infer (sg : signature) (ctx : context) (e : exp) : exp =
  match e with
  | Var x ->
    (match List.assoc_opt x ctx with
     | Some t -> t
     | None -> error (Printf.sprintf "unbound variable %s" x))
  | Const c ->
    (match lookup_type sg c with
     | Some t -> t
     | None -> error (Printf.sprintf "unknown constant %s" c))
  | Type i -> Type (i + 1)
  | Pi (x, a, b) | Sigma (x, a, b) ->
    let i = universe sg ctx a in
    let (x, b) = enter ctx x b in
    let j = universe sg ((x, a) :: ctx) b in
    Type (max i j)
  | App (e1, e2) ->
    let t1 = infer sg ctx e1 in
    (match expose sg t1 with
     | Pi (x, a, b) ->
       check sg ctx e2 a;
       (* The type of the result depends on the argument! *)
       subst b x e2
     | _ ->
       error (Printf.sprintf
                "the expression\n  %s\nhas type\n  %s\nwhich is not a \
                 function type, so it cannot be applied to an argument"
                (str e1) (str t1)))
  | Fst e1 ->
    let t1 = infer sg ctx e1 in
    (match expose sg t1 with
     | Sigma (_, a, _) -> a
     | _ -> error (Printf.sprintf
                     "the expression\n  %s\nhas type\n  %s\nwhich is not a \
                      pair type, so it has no first component"
                     (str e1) (str t1)))
  | Snd e1 ->
    let t1 = infer sg ctx e1 in
    (match expose sg t1 with
     | Sigma (x, _, b) ->
       (* The type of the second component depends on the first! *)
       subst b x (Fst e1)
     | _ -> error (Printf.sprintf
                     "the expression\n  %s\nhas type\n  %s\nwhich is not a \
                      pair type, so it has no second component"
                     (str e1) (str t1)))
  | Lam _ | Pair _ ->
    error (Printf.sprintf
             "the type of the expression\n  %s\ncannot be inferred. A \
              function or a pair can only be used where its type is known: \
              as the body of a def, or as an argument." (str e))

(* `universe sg ctx a` checks that `a` is a type, and returns the level of
   the universe that it is in. *)
and universe (sg : signature) (ctx : context) (a : exp) : int =
  let t = infer sg ctx a in
  match expose sg t with
  | Type i -> i
  | _ -> error (Printf.sprintf
                  "the expression\n  %s\nis used as a type, but it has \
                   type\n  %s" (str a) (str t))

(* `check sg ctx e t` checks that `e` has type `t`, or raises `TypeError`. *)
and check (sg : signature) (ctx : context) (e : exp) (t : exp) : unit =
  match e with
  | Lam (x, b) ->
    (* A function is checked against a Pi type: its body is checked against
       the codomain, in a context where the variable has the domain type. *)
    (match expose sg t with
     | Pi (y, a, c) ->
       let (x, b) = enter ctx x b in
       check sg ((x, a) :: ctx) b (subst c y (Var x))
     | _ -> error (Printf.sprintf
                     "the function\n  %s\nis expected to have type\n  %s\n\
                      which is not a function type" (str e) (str t)))
  | Pair (e1, e2) ->
    (* A pair is checked against a Sigma type, component by component. The
       type of the second component depends on the first. *)
    (match expose sg t with
     | Sigma (x, a, b) ->
       check sg ctx e1 a;
       check sg ctx e2 (subst b x e1)
     | _ -> error (Printf.sprintf
                     "the pair\n  %s\nis expected to have type\n  %s\n\
                      which is not a pair type" (str e) (str t)))
  | _ ->
    (* The conversion rule: `e` has type `t` if it has some type `t'` that
       is definitionally equal to `t`. *)
    let t' = infer sg ctx e in
    if not (Modes.equal sg t t') then
      error (Printf.sprintf
               "the expression\n  %s\nhas type\n  %s\nbut is expected to \
                have type\n  %s" (str e) (str t') (str t))

(* The parser produces `Var x` for every identifier `x`. Before type
   checking, we replace each identifier that is not bound by an enclosing
   binder with the constant of the same name, and report an error if there
   is no such constant. *)
let rec resolve (sg : signature) (bound : string list) (e : exp) : exp =
  match e with
  | Var "_" -> error "_ cannot be used as a variable"
  | Var x ->
    if List.mem x bound then e
    else if List.mem_assoc x sg then Const x
    else error (Printf.sprintf "unbound variable %s" x)
  | Const _ | Type _ -> e
  | Pi (x, a, b) -> Pi (x, resolve sg bound a, resolve sg (x :: bound) b)
  | Sigma (x, a, b) -> Sigma (x, resolve sg bound a, resolve sg (x :: bound) b)
  | Lam (x, b) -> Lam (x, resolve sg (x :: bound) b)
  | App (e1, e2) -> App (resolve sg bound e1, resolve sg bound e2)
  | Pair (e1, e2) -> Pair (resolve sg bound e1, resolve sg bound e2)
  | Fst e1 -> Fst (resolve sg bound e1)
  | Snd e1 -> Snd (resolve sg bound e1)

(* Add a new constant to a signature. *)
let declare (sg : signature) (c : string) (entry : entry) : signature =
  if List.mem_assoc c sg then
    error (Printf.sprintf "the constant %s is already declared" c);
  (c, entry) :: sg

(* Process a command: type check it, print the result (unless `quiet` is
   true), and return the signature extended with any new constant. *)
let command ?(quiet = false) (sg : signature) (cmd : command) : signature =
  let print (s : string) = if not quiet then print_endline s in
  match cmd with
  | Axiom (c, t) ->
    let t = resolve sg [] t in
    ignore (universe sg [] t);
    print (Printf.sprintf "axiom %s : %s" c (str t));
    declare sg c { typ = t; def = None }
  | Def (c, t, e) ->
    let t = resolve sg [] t in
    let e = resolve sg [] e in
    ignore (universe sg [] t);
    check sg [] e t;
    print (Printf.sprintf "def %s : %s" c (str t));
    declare sg c { typ = t; def = Some e }
  | Check e ->
    let e = resolve sg [] e in
    let t = infer sg [] e in
    print (Printf.sprintf "check %s : %s" (str e) (str t));
    sg
  | Eval e ->
    let e = resolve sg [] e in
    ignore (infer sg [] e);
    print (Printf.sprintf "eval %s = %s" (str e) (str (Equality.normalize sg e)));
    sg
