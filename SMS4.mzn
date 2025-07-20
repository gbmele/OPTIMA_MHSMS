% Use this editor as a MiniZinc scratch book
include "globals.mzn";
include "global_calendar.mzn";

%%move this to global_calendar
%%PAY_FORTNIGHT
predicate shifts_each_fortnight (docs: doc,int: lo,int:hi ) =     %%THIS IS PAY FORTNIGHT
        (global_cardinality_low_up(roster[doc,1..14],[o],[14-hi],[14-lo]) /\
         global_cardinality_low_up(roster[doc,15..28],[o],[14-hi],[14-lo]) /\
         global_cardinality_low_up(roster[doc,29..42],[o],[14-hi],[14-lo]) /\
         global_cardinality_low_up(roster[doc,43..56],[o],[14-hi],[14-lo]) /\
         global_cardinality_low_up(roster[doc,57..70],[o],[14-hi],[14-lo]));



%include "apr_may24.mzn";

%include "dec_jan24.mzn";  %%the request array from awk....
%include "SIC.mzn";

%%MODEL FEATURES

set of int: days  = 1..70; 
int:        DAYS  =    70;
include "working.mzn";
array[docs,days] of var shifts: roster;

%enum docs =             {RG,GM,DB,CC,MC,SD,ML,HL,DL,RM,GN,EW,LB,DH,SK,BL,RP,AR,LS,AV,LC,KM,BB,JD,CK,TB,BLEE,JL};

enum shifts =   {o,a,p,c,l,s,i,  perl,al,cl,lsl,mat,pat,lwop,sab,phnw,   apo ,x ,oc};

set of shifts: leave_shifts =   {perl,al,cl,lsl,mat,pat,lwop,sab,phnw};


  function var shifts: prnt(var shifts:s) =
     (if      s in leave_shifts then l
      else  s
      endif);


constraint forall(d in fridays   )    (global_cardinality_low_up(roster[..,d],                      [ a , p ],   [ 0,0   ],   [  14 , 14     ]  )); %fri
constraint forall(d in saturdays )    (global_cardinality_low_up(roster[..,d],                      [ a , p ],   [ 0, 0   ],   [  13 , 14     ]  )); %sat 
constraint forall(d in sundays   )    (global_cardinality_low_up(roster[..,d],                     [ a , p ],   [ 0, 0   ],   [  13 , 14     ]  )); %sun


constraint DOC_TABLE(GM,[| c,p,o,c,a, o,o
                         | c,p,o,c,c, o,o
                         | c,p,o,c,o, o,a
                         |]);

constraint assign_shifts(GM,friday,p,0,0);
constraint assign_shifts(GM,saturday,a,0,0);
constraint assign_shifts(GM,saturday,p,0,0);
constraint assign_shifts(GM,sunday,a,3,4);
constraint assign_shifts(GM,sunday,p,0,0);
constraint no_consec_weekends(GM);

constraint assign_shifts(DB,friday,p,2,2);
constraint assign_shifts(DB,saturday,a,1,1);
constraint assign_shifts(DB,saturday,p,1,1);
constraint assign_shifts(DB,sunday,a,1,1);
constraint assign_shifts(DB,sunday,p,1,1);
constraint no_consec_weekends(DB);
constraint no_split_weekend(DB);
constraint no_fri_before_sat(DB);

constraint assign_shifts(CC,friday,p,2,2);
constraint assign_shifts(CC,saturday,a,1,1);
constraint assign_shifts(CC,saturday,p,1,1);
constraint assign_shifts(CC,sunday,a,1,1);
constraint assign_shifts(CC,sunday,p,1,1);
constraint no_consec_weekends(CC);
constraint no_split_weekend(CC);
constraint no_fri_before_sat(CC);






%%OUTPUT


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



/*
array[docs,days] of var shifts: ROSTER_OUTPUT;

constraint forall(doc in docs, day in days)
           ( if    ssu[doc,day]=1        then ROSTER_OUTPUT[doc,day]=s 
           elseif  incharge[doc,day]=1   then ROSTER_OUTPUT[doc,day]=i 
           else    ROSTER_OUTPUT[doc,day]=roster[doc,day]
           endif);
*/

/*
output[if day = 1 then show(doc) ++ "," else "" endif ++ show(ROSTER_OUTPUT[doc,day]) ++ if day=70 then "\n" else "," endif | doc in docs,day in days];

array[docs,days] of var shifts: ONCALL;
constraint forall(doc in docs,day in days) (if oncall[doc,day]=1 then ONCALL[doc,day]=oc else ONCALL[doc,day]=o endif);
   
output[if day = 1 then show(doc) ++ "," else "" endif ++ show(ONCALL[doc,day]) ++ if day=70 then "\n" else "," endif | doc in docs,day in days];

*/


%%output[show(doc)++","++show(day)++","++show(ROSTER_OUTPUT[doc,day])++"\n" | doc in docs,day in days];


output(show2d(roster));
output["\n"];
output[show(doc)   ++ 
			" we am: " ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],a)))         ++

                   " we pm  "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],p)))         ++

	           " fri pm  "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {friday}],p)))    ++ "\n"
                    
                    
                  %  " oncall:" ++ show(fix(count(oncall[doc,..],1))) 
                    
                   % "  ssu count: " ++ show(count(ssu[doc,..],1))   
                    
                   % "  INCHARGE COUNT: " ++  show(count(incharge[doc,..],1))  ++   "\n"
                    
                    | doc in docs];

output["\n\n"];