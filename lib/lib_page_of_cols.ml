let page_of_cols ?(intersp=1) lipp copp line_li  =

  let finish_page pdone = function
    | [] -> pdone
    | pc -> (String.concat "\n" pc) :: pdone
          ;

  in

  let ensure_column_width ?(before=0) lc lcw =
    List.map (fun s -> (if before > 0 then "|" ^ String.make (before - 1) ' ' else "") ^ (
                let delta = lcw - (String.length s) in if delta > 0
                                                       then s ^ (String.make delta ' ')
                                                       else s
              )
             ) lc
  in

  let append_column pc lc lcw = match (pc,(List.rev lc)) with
    | pc,[] -> pc
    | [],lc -> ensure_column_width lc lcw
    | pc,lc ->
       let rec sub acc pc lc = match (pc,lc) with
         | [],[] -> acc
         | [],_ -> failwith "bug"
         | h::r,[]     -> sub (h::acc)        r []
         | h::r,h2::r2 -> sub ((h ^ h2)::acc) r r2
       in
       List.rev (sub [] pc (ensure_column_width ~before:intersp lc lcw ))
                
                
  in
  let finish_lines ~pdone ~pcurr ~pcw ~lcurr ~nlc = match (lcurr,nlc) with
      
    | [],0 -> (pdone,pcurr,pcw)
                
    | _,0  |  [],_ -> failwith "bug"
                               
    | lcurr,nlc ->
       let maxw = List.fold_left (fun a b -> max a (String.length b)) 0 lcurr
       in
       let mip = maxw + intersp + pcw
       in
       if mip > copp
                  
       then ((finish_page pdone pcurr), (append_column [] lcurr maxw), maxw)    (* overflow -> create a new page out of `lcurr` *)
              
       else 
         let pcurr = append_column pcurr lcurr maxw    (* no overflow -> append column *)
         in
         (pdone, pcurr, mip)
         ;
         ;
           
  in
  
  let rec sub ~pages_done ~page_current ~pcw ~lines_current ~nlc = function
    | []       -> let pd,pc,_ = finish_lines ~pdone:pages_done ~pcurr:page_current ~pcw:pcw ~lcurr:lines_current ~nlc:nlc 
                  in
                  finish_page pd pc
                              
    | li::rest -> let lc2,nlc2 = (li::lines_current, 1+nlc)
                  in
                  if nlc2 < lipp
                              
                  then sub ~pages_done ~page_current ~pcw ~lines_current:lc2 ~nlc:nlc2 rest
                           
                  else let pd,pc,pcw = finish_lines ~pdone:pages_done ~pcurr:page_current ~pcw:pcw ~lcurr:lc2 ~nlc:nlc2
                       in
                       sub ~pages_done:pd ~page_current:pc ~pcw:pcw ~lines_current:[] ~nlc:0 rest
                       ;
                         
  in
  List.rev (sub ~pages_done:[] ~page_current:[] ~pcw:0 ~lines_current:[] ~nlc:0 line_li)
;;
