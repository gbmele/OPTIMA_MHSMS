% Days: 0 = Monday, ..., 6 = Sunday
set of int: Days = 1..7;
set of int: Weekdays = 1..5;
set of int: Weekend = {6,7};

% Shifts: 0 = None, 1 = A, 2 = P, 3 = C
enum Shift = {Off, A, P, C};

% Decision variable: shift assigned each day
array[Days] of var Shift: schedule;

% Count total shifts
var int: total_shifts = sum(d in Days)(bool2int(schedule[d] != Off));

% Count weekend A and P shifts
var int: weekend_A = sum(d in Weekend)(bool2int(schedule[d] == A));
var int: weekend_P = sum(d in Weekend)(bool2int(schedule[d] == P));

% Count weekday C shifts
var int: weekday_C = sum(d in Weekdays)(bool2int(schedule[d] == C));

% Weekend work indicator
var bool: works_weekend = exists(d in Weekend)(schedule[d] != Off);

% Constraints
constraint total_shifts == 3;

constraint
  if works_weekend then
    (weekend_A == 2 \/ weekend_P == 2) /\ weekday_C == 1
  else
    % Must work A, P, and C during the week
    exists(d in Weekdays)(schedule[d] == A) /\
    exists(d in Weekdays)(schedule[d] == P) /\
    exists(d in Weekdays)(schedule[d] == C)
  endif;

solve satisfy;
