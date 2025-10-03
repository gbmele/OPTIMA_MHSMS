%%OUTPUT

  function var shifts: prnt(var shifts:s) =
     (if      s in leave_shifts then l
      else  s
      endif);



%output[if day = 1 then show(doc) ++ "," else "" endif ++ show(roster[doc,day]) ++ if day = 70 then "\n" else "," endif | doc in docs,day in days];

output["\n"];
output ["wk 1          |wk 2          ||  wk 3        |   wk 4       ||    wk 5      |   wk 6       ||    wk 7      |   wk 8       ||     wk 9     |   wk 10      \n"];
output ["M T W T F S S |M T W T F S S ||M T W T F S S |M T W T F S S ||M T W T F S S | M T W T F S S||M T W T F S S |M T W T F S S ||M T W T F S S |M T W T F S S \n"];
output["--------------------------------------------------------------------------------------------------------------------------------------------------------\n"];
output[show(prnt(roster[doc,day])) ++ " " ++ if day mod 7 = sunday then "|" else "" endif  ++if day mod 14==0 then"|" else "" endif  ++ if day = 70  then show(doc) ++  " " ++ 
                                                                                                            " \n" else "" endif 
      | doc in docs, day in days];
      
output["--------------------------------------------------------------------------------------------------------------------------------------------------------\n"];
output [show(count([roster[doc,day]|doc in docs],a)) ++ " " ++ if day mod 7 = sunday then "|" else "" endif   ++if day mod 14==0 then"|" else "" endif  ++ if day = 70 then "am" else "" endif | day in days] ;output["\n"];
output [show(count(roster[..,day],p)) ++ " " ++ if day mod 7 = sunday then "|" else "" endif   ++if day mod 14==0 then"|" else "" endif  ++ if day = 70 then "pm" else "" endif| day in days] ;output["\n"];
%output [show(count(incharge[..,day],1)) ++ " " ++ if day mod 7 = sunday then "|" else "" endif    ++if day mod 14==0 then"|" else "" endif ++ if day = 70 then "INCHARGE" else "" endif| day in days] ;output["\n"];
%output [show(count(ssu[..,day],1)) ++ " " ++ if day mod 7 = sunday then "|" else "" endif    ++if day mod 14==0 then"|" else "" endif ++ if day = 70 then "SSU" else "" endif| day in days] ;output["\n"];


output["%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"];

output["%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%\n"];



%%THIS IS THE CSV OUTPUTTER!!!!!
output [
  show(doc) ++ "," ++
  concat([show(roster[doc, day]) ++ if day != 70 then "," else "" endif | day in days]) ++"\n"
  | doc in docs ];
%%SSU
output [
  "SSU" ++ "," ++
  concat([show(ssu_doc[day]) ++ if day != 70 then "," else "" endif| day in days])];
output ["\n"];
%%INCHAARGE
output [
  "IC" ++ "," ++
  concat([show(incharge_doc[day]) ++ if day != 70 then "," else "" endif| day in days])];
output ["\n"];
%%ONCLL
output [
  "CALL" ++ "," ++
  concat([show(oncall_doc[day]) ++ if day != 70 then "," else "" endif| day in days])];
output ["\n"];




output[show(doc)   ++ 
			" we_am: " ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],a))) ++ ","         ++

                   " we_pm: "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],p))) ++","         ++

	           " fri_pm: "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {friday}],p)))  ++ ","        ++
                    
                    
                    " oncall: " ++ show(fix(count(oncall[doc,..],1)))  ++ ","  ++
                    
                    "  ssu_count: " ++ show(count(ssu[doc,..],1))    ++ ","       ++  
                    
                    "  INCHARGE_COUNT: " ++  show(count(incharge[doc,..],1)) ++ ","  ++   "\n"
                    
                    | doc in docs];