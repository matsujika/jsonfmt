let rec format (json : Yojson.Basic.t) =
  let double_quotize s = "\"" ^ s ^ "\"" in
  match json with
  | `Null -> "null"
  | `Bool b -> ( match b with true -> "true" | false -> "false" )
  | `Int i -> string_of_int i
  | `Float f -> string_of_float f
  | `String s -> double_quotize s
  | `Assoc obj -> (
      match obj with
      | [] -> "{}"
      | hd :: tl ->
          let format_pair e = double_quotize (fst e) ^ ": " ^ format (snd e) in
          let body tl =
            format_pair hd
            ^ List.fold_left (fun acc tl -> acc ^ ", " ^ format_pair tl) "" tl
          in
          "{" ^ body tl ^ "}" )
  | `List li -> (
      match li with
      | [] -> "[]"
      | hd :: tl ->
          let body tl =
            format hd
            ^ List.fold_left (fun acc tl -> acc ^ ", " ^ format tl) "" tl
          in
          "[" ^ body tl ^ "]" )
