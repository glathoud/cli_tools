open Lib_page_of_cols;;
open Sys;;
  
  
(* Application *)
let narg = Array.length Sys.argv
    in
    let lipp = if narg < 2 then 105 else int_of_string Sys.argv.(1)
    in
    let copp = if narg < 3 then 119 * lipp / 105 else int_of_string Sys.argv.(2)
    in
    let li = let lines = ref []
             in
             try
               while true; do
                 lines := input_line stdin :: !lines
               done; !lines
             with End_of_file ->
               List.rev !lines
                        
    in
    
    let pages = page_of_cols lipp copp li
    in
    List.iter print_endline pages
;;
