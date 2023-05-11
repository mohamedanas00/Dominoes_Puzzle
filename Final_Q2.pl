create_Board(Rows,Columns,First_BombA,First_BombB,Second_BombA,Second_BombB,R) :-
    Size is Columns * Rows,
    length(List,Size),
    maplist(=(1), List),
    First_Bomb is ((First_BombA-1)*Columns) + (First_BombB-1),
    update_index(First_Bomb,List,0,NewList),
    Second_Bomb is ((Second_BombA-1)*Columns) + (Second_BombB-1),
    update_index(Second_Bomb,NewList,0,FinalList),  
    set_global_value(Columns),
    set_global_List(FinalList),
    set_global_Array([]),
    search([[FinalList,null,0,x,0]], [],R).


is_goal(State,Flag):-
  move(State,Next,1),
  Flag = 1 ,!.

is_goal(State,Flag):-  
  Flag = 0.

max_list([X], X).
max_list([X | Xs], Max) :- 
    max_list(Xs, T),
    (X > T -> Max = X ; Max = T).

check_number(Num, Result) :-
	get_global_Array(Array),
	max_list(Array,Max),
    (Num =:= Max ->
        Result is 1
    ;
        Result is 0
    ).
	
search(Open, Closed,R):-
  getBestState(Open, [CurrentState,Parent,G,H,F], _), % Step 1
    is_goal(CurrentState,Flag),
    Flag = 0,
	check_number(H,Result),
	Result =1,
	R = CurrentState.

search(Open, Closed,R):-
  getBestState(Open, CurrentNode, TmpOpen),
  getAllValidChildren(CurrentNode,TmpOpen,Closed,Children), % Step3
  addChildren(Children, TmpOpen, NewOpen), % Step 4
  append(Closed, [CurrentNode], NewClosed), % Step 5.1
  search(NewOpen, NewClosed,R). % Step 5.2

getAllValidChildren(Node, Open, Closed, Children):-
  findall(Next, getNextState(Node, Open, Closed, Next), Children).

getNextState([State,_,G,_,_],Open,Closed,[Next,State,NewG,NewH,NewF]):-
move(State, Next, MoveCost),
isOkay(Next),
get_global_List(FinalList),
calculateH(Next,FinalList,NewH),
NewG is G + MoveCost,
NewF is NewG + NewH,
not(member([Next,_,_,_,_], Open)),
not(member([Next,_,_,_,_], Closed)).

addChildren(Children, Open, NewOpen):-
append(Open, Children, NewOpen).

getBestState(Open, BestChild, Rest):-
findMax(Open, BestChild),
delete(Open, BestChild, Rest).
findMax([X], X):- !.
findMax([Head|T], Max):-
findMax(T, TmpMax),
Head = [_,_,_,HeadH,HeadF],
TmpMax = [_,_,_,TmpH,TmpF],
(TmpF >HeadF -> Max = TmpMax ; Max = Head),
get_global_Array(Array),
set_global_Array([TmpH|Array]).



memberButBetter(Next, List, NewF):-
findall(F, member([Next,_,_,_,F], List), Numbers),
max_list(Numbers, MaxOldF),
MaxOldF < NewF.

printSolution([State, null, G, H, F],_):-
write([State, G, H, F]), nl.
printSolution([State, Parent, G, H, F], Closed):-
member([Parent, GrandParent, PrevG, Ph, Pf], Closed),
printSolution([Parent, GrandParent, PrevG, Ph, Pf], Closed),
write([State, G, H, F]), nl.





move(FinalList, Next,1):-
  horizontal(FinalList, Next).


move(FinalList, Next,1):-
   vertical(FinalList, Next).



%[1,2,3,4,5]
%[2,[1,2,3,4,5],10,l=[1|R]]
%[1,[2,3,4,5],10,l=[2|R]]


update_index(0, [_|T], X, [X|T]).
update_index(I, [H|T], X, [H|R]) :-
    I > 0,
    J is I - 1,
    update_index(J, T, X, R).



vertical(FinalList, Next):-
  nth0(EmptyTileIndex, FinalList, 1),
  nth0(BombIndex, FinalList, 0), 
  NewIndex is EmptyTileIndex + 1,
  %(-)check that newindex is empty.
  nth0(NewIndex, FinalList, R),
  not(R = 0),
  not(R = 2),
  not(R = 6),
  get_global_value(Value),
  not(0 is NewIndex mod Value),
  update_index(EmptyTileIndex,FinalList,6,List1),
  update_index(NewIndex,List1,6,Next).



horizontal(FinalList, Next):-
 nth0(EmptyTileIndex, FinalList, 1),
  nth0(BombIndex, FinalList, 0),
  get_global_value(Value),
  %(-)check that newindex is empty.
  NewIndex is EmptyTileIndex + Value,
  nth0(NewIndex, FinalList, R),
  not(R = 0),
  not(R = 2),
  not(R = 6),
  update_index(EmptyTileIndex,FinalList,2,List1),
  update_index(NewIndex,List1,2,Next).

calculateH([], [], 0):- !.
calculateH([Head|T1], [Head|T2], Hvalue):-
!,calculateH(T1, T2, Hvalue).

calculateH([_|T1], [_|T2], Hvalue):-
calculateH(T1, T2, Count),
Hvalue is Count + 1.

isOkay(_):- true.




% Define a predicate to set the global value
set_global_value(Value) :-
    retractall(global_value(_)),
    assertz(global_value(Value)).

% Define a predicate to get the global value
get_global_value(Value) :-
    global_value(Value).


set_global_List(List) :-
    retractall(global_List(_)),
    assertz(global_List(List)).

get_global_List(List) :-
    global_List(List).
	

set_global_Array(Array) :-
    retractall(global_Array(_)),
    assertz(global_Array(Array)).

get_global_Array(Array) :-
    global_Array(Array).