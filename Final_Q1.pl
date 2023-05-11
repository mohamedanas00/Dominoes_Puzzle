:- dynamic global_value/1.
:- dynamic global_List/1.
create_Board(Rows,Columns,First_BombA,First_BombB,Second_BombA,Second_BombB,State) :-
    Size is Columns * Rows,
    length(List,Size),
    maplist(=(1), List),
    First_Bomb is ((First_BombA-1)*Columns) + (First_BombB-1),
    update_index(First_Bomb,List,0,NewList),
    Second_Bomb is ((Second_BombA-1)*Columns) + (Second_BombB-1),
    update_index(Second_Bomb,NewList,0,FinalList),  
    set_global_value(Columns),
    set_global_List([]),
    search([[FinalList,null]], [],State).


is_goal(State,Flag):-
  move(State,Next),
  Flag = 1 ,!.

is_goal(State,Flag):-  
  Flag = 0.


search(Open, Closed, State):-
    getState(Open, [CurrentState,Parent], _), % Step 1
    is_goal(CurrentState,Flag),
  Flag = 0,
	get_global_List(List),
	\+member(CurrentState,List),
	set_global_List([CurrentState|List]),
  State = CurrentState.
    % write("\n-----------\n"),
    % write(CurrentState),
    % write("\n-----------\n"),
    % write("Search is complete!").


search(Open, Closed, State):-
  getState(Open, CurrentNode, TmpOpen),
  getAllValidChildren(CurrentNode,TmpOpen,Closed,Children), % Step3
  addChildren(Children, TmpOpen, NewOpen), % Step 4
  append(Closed, [CurrentNode], NewClosed), % Step 5.1
  search(NewOpen, NewClosed, State). % Step 5.2


  
% Implementation of step 3 to get the next states
getAllValidChildren(Node, Open, Closed, Children):-
  findall(Next, getNextState(Node, Open, Closed, Next), Children).

getNextState([State,_], Open, Closed, [Next,State]):-
  move(State, Next),
  not(member([Next,_], Open)),
  not(member([Next,_], Closed)),
  isOkay(Next).
  
% Implementation of getState and addChildren determine the search
alg.
% BFS
getState([CurrentNode|Rest], CurrentNode, Rest).

addChildren(Children, Open, NewOpen):-
  append(Open, Children, NewOpen).
  
% Implementation of printSolution to print the actual solution path
printSolution([State, null],_):-
  write(State), nl.

printSolution([State, Parent], Closed):-
  member([Parent, GrandParent], Closed),
  printSolution([Parent, GrandParent], Closed),
  write(State), nl.


move(FinalList, Next):-
  vertical(FinalList, Next).

move(FinalList, Next):-
  horizontal(FinalList, Next).



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




isOkay(_):- true.




% Define a predicate to set the global value
set_global_value(Value) :-
    retractall(global_value(_)),
    assertz(global_value(Value)).

% Define a predicate to get the global value
get_global_value(Value) :-
    global_value(Value).

% Define a predicate to set the global value
set_global_List(List) :-
    retractall(global_List(_)),
    assertz(global_List(List)).

% Define a predicate to get the global value
get_global_List(List) :-
    global_List(List).