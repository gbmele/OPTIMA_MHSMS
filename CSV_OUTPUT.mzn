array[docs,days] of var shifts: ROSTER_OUTPUT;

constraint forall(doc in docs, day in days)
           ( if    ssu[doc,day]=1        then ROSTER_OUTPUT[doc,day]=s 
           elseif  incharge[doc,day]=1   then ROSTER_OUTPUT[doc,day]=i 
           else    ROSTER_OUTPUT[doc,day]=roster[doc,day]
           endif);

%%THIS IS THE CSV OUTPUTTER!!!!!
output [
  show(doc) ++ "," ++
  concat([show(ROSTER_OUTPUT[doc, day]) ++ if day != 70 then "," else "" endif | day in days]) ++"\n"
  | doc in docs ];


%%THIS IS THE CSV OUTPUTTER!!!!!
%output [
%  show(doc) ++ "," ++
%  concat([show(roster[doc, day]) ++ if day != 70 then "," else "" endif | day in days]) ++"\n"
%  | doc in docs ];






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