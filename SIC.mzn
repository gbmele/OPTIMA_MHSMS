%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% SSU 

array[docs,days] of var 0..1: ssu;

constraint forall (d in days, doc in docs) ((roster[doc,d]= a <- ssu[doc,d]==1));

constraint forall(d in days) (count(ssu[..,d],1,1));


constraint forall(d in docs) (global_cardinality_low_up(ssu[d,..],[1],[0],[100]));

constraint forall(d in docs) (global_cardinality_low_up(ssu[d, 1..14],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(ssu[d,15..28],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(ssu[d,29..42],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(ssu[d,43..56],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(ssu[d,57..70],[1],[0],[13]));

int: ssu_hi=6;
%constraint global_cardinality_low_up(ssu[GM,..],[1],[0],[ssu_hi]); constraint count([ssu[GM,day]|day in fridays],1,0);


%%not sat and sun ssu in same weekend


constraint forall(doc in docs,day in saturdays)
                (if     ssu[doc,day] = 1 then ssu[doc,day+1]= 0
                elseif ssu[doc,day+1]=1 then ssu[doc,day]  = 0
                 else true
                endif);



%  INCHARGE

array[docs,days] of var 0..1: incharge;

constraint forall (d in days, doc in docs) ((roster[doc,d]= a /\ ssu[doc,d] != 1)  <- (incharge[doc,d]==1));

constraint forall(d in days) (count(incharge[..,d],1,1));


%constraint forall(d in days) (trace("doing incharge counting \(d) \n", count(incharge[..,d],1,1)));

constraint forall(d in docs) (global_cardinality_low_up(incharge[d,..],[1],[0],[75]));

constraint forall(d in docs) (global_cardinality_low_up(incharge[d, 1..14],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(incharge[d,15..28],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(incharge[d,29..42],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(incharge[d,43..56],[1],[0],[13]));
constraint forall(d in docs) (global_cardinality_low_up(incharge[d,57..70],[1],[0],[13]));


int: inc_hi=6;
int: inc_lo=0;
%constraint global_cardinality_low_up(incharge[RG,..],[1],[0],[inc_hi]);


constraint forall(doc in docs,day in saturdays)
                (if     incharge[doc,day] = 1 then incharge[doc,day+1]= 0
                 elseif incharge[doc,day+1]=1 then incharge[doc,day]  = 0
                 else true
                 endif);


% ONCALL

array[docs,days] of var 0..1: oncall;       

    %% am ->ssu      - as per oncall above  

constraint forall (d in days, doc in docs) ((roster[doc,d]= p <- oncall[doc,d]==1));

constraint forall(d in days) (count(oncall[..,d],1,1));  %%only 1 person on call per day

%constraint global_cardinality_low_up(oncall[RG,..],[1],[0],[0]);
constraint forall(d in docs) (global_cardinality_low_up(oncall[d,..],[1],[0],[18]));        %% 5 oncall max per 10 weeks


constraint forall(d in docs) (global_cardinality_low_up(oncall[d, 1..14],[1],[0],[21]));    %%once per fortnight if possible!!!!!
constraint forall(d in docs) (global_cardinality_low_up(oncall[d,15..28],[1],[0],[21]));
constraint forall(d in docs) (global_cardinality_low_up(oncall[d,29..42],[1],[0],[21]));
constraint forall(d in docs) (global_cardinality_low_up(oncall[d,43..56],[1],[0],[21]));
constraint forall(d in docs) (global_cardinality_low_up(oncall[d,57..70],[1],[0],[21]));

%array[days] of var docs: display_oncall;
%constraint forall (day in days, doc in docs) (oncall[doc,day]=1 <- display_oncall[day]=doc);

%%%%%



output[show(doc)   ++ 
			" we am: " ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],a)))         ++

                   " we pm  "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {saturday,sunday}],p)))         ++

	           " fri pm  "  ++ show(fix(count([roster[doc,d]| d in days where d mod 7 in {friday}],p)))         ++
                    
                    
                    " oncall:" ++ show(fix(count(oncall[doc,..],1)))  ++ 
                    
                    "  ssu count: " ++ show(count(ssu[doc,..],1))          ++  
                    
                    "  INCHARGE COUNT: " ++  show(count(incharge[doc,..],1))  ++   "\n"
                    
                    | doc in docs];

%output[ show(roster[display_oncall[day],day])  ++ " " ++ "dr is " ++ show(display_oncall[day]) ++ "  " ++ show(get_empnum((fix(display_oncall[day])))) ++ " "  ++ get_day(day) ++ "\n" | day in days];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



