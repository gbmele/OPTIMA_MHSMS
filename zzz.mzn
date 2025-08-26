include "globals.mzn";
include "global_calendar.mzn";
%include "SIC.mzn";
include "staff_sic.mzn";
include "CSV_OUTPUT.mzn";

int: DAYS = 14;
set of int: days = 1..DAYS;

enum docs = {gm, db, cc, av};
enum shifts = {u, i, x, l, a, o, c, p, s, phnw, perl, mat, lwop, pat, sabb, dfl, lppa, al, cl};
set of shifts: leave_shifts = {phnw, perl, mat, lwop, pat, sabb, dfl, lppa, al, cl};

% ===== DECISION VARIABLES =====
array[docs, 1..DAYS] of var shifts: roster;
array[docs, 1..DAYS] of var 0..1: ssu;
array[docs, 1..DAYS] of var 0..1: incharge;
array[docs, 1..DAYS] of var 0..1: oncall;

% ===== CONSTRAINTS =====
 constraint forall(doc in docs, day in 1..DAYS)
 (if       u in requests[doc,day] then roster[doc,day]=o
  elseif   x in requests[doc,day] then roster[doc,day]=o
  else roster[doc, day] in requests[doc, day]
 endif);

array[1..DAYS] of var docs: ssu_doc;
constraint forall(doc in docs,day in days)
(if ssu[doc,day]=1 then ssu_doc[day]=doc
endif);

array[1..DAYS] of var docs: incharge_doc;
constraint forall(doc in docs,day in days)
(if incharge[doc,day]=1 then incharge_doc[day]=doc
endif);

array[1..DAYS] of var docs: oncall_doc;
constraint forall(doc in docs,day in days)
(if oncall[doc,day]=1 then oncall_doc[day]=doc
endif);
array[docs, 1..DAYS] of set of shifts: requests =
array2d(docs, 1..DAYS, [
  {a, c}, {p}, {o}, {c}, {a, o}, {o}, {a, o}, {a, c}, {p}, {o}, {c}, {a, o}, {o}, {a, o}, % gm
  {a}, {p}, {o}, {a}, {a, p, o}, {a, p, o}, {a, p, o}, {a}, {p}, {o}, {a}, {a, p, o}, {a, p, o}, {a, p, o}, % db
  {p, o}, {o}, {a}, {a}, {a, p, o}, {a, p, o}, {a, p, o}, {p, o}, {o}, {a}, {a}, {a, p, o}, {a, p, o}, {a, p, o}, % cc
  {a, c, p, o}, {a, p, c, o}, {a, p, c, o}, {a, p, c, o}, {a, p, o}, {a, p, o}, {a, p, o}, {a, c, p, o}, {a, p, c, o}, {a, p, c, o}, {a, p, c, o}, {a, p, o}, {a, p, o}, {a, p, o} % av
]);

array[days] of var int: A_COUNT;
array[days] of var int: P_COUNT;
constraint forall(day in days)
   (count(roster[..,day], a, A_COUNT[day]) /\
    count(roster[..,day], p, P_COUNT[day]));

% ===== OUTPUT =====
%output[show2d(roster)++"\n"];
%output["AM " ++ show(A_COUNT)++"\n"];
%output["PM " ++ show(P_COUNT)];
