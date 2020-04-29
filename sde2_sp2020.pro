nextState([],_,[]).

nextState(CurrentState, WeightMatrix, NewState) :-
  netAll(CurrentState,WeightMatrix, NST),
  hop11ActAll(NST, CurrentState, NewState),!.

updateN(CurrentState,_,0,CurrentState) :- !.

updateN(CurrentState, WeightMatrix, N, Res) :-
  I is N-1,
  nextState(CurrentState,WeightMatrix, Result),
  updateN(Result, WeightMatrix , I, Res).

findsEquilibrium(InitialState, WeightMatrix, Range) :-
    Range > 0,
    I is Range-1,
		updateN(InitialState, WeightMatrix, Range, Result1),
    updateN(InitialState, WeightMatrix, I, Result2),
    Result1 = Result2, !.

energy(_, [], 0.0).

energy(State, WeightMatrix, EN) :-
  netAll(State, WeightMatrix, NST),
	inner(NST, State, Res),
  EN is -0.5 * Res, !.

ms([], _, _, _, []).

ms([_|ST], V, Pos, N, R) :- Pos = N,
    I = N+1,
    ms(ST, V, Pos, I, Result),
    append([0.0], Result, R),!.

ms([SH|ST], V, Pos, N, R) :-
    I is N+1,
    ms(ST, V, Pos, I, Result),
    S is SH * V,
    append([S], Result, R),!.

outer([],_,_,[]).

outer([V1H|V1T], V2, Pos, Matrix) :-
    I is Pos + 1,
    ms(V2, V1H, Pos, 0, Matrix1),
    outer(V1T, V2, I, Matrix2),
    append([Matrix1], Matrix2, Matrix), !.

hopTrainAstate(Astate, Matrix) :-
  outer(Astate, Astate, 0, Matrix), !.


add([],_,[]).

add([M1H|M1T], [M2H|M2T], Result) :-
  R is M1H + M2H,
  add(M1T, M2T, Res),
  append([R], Res, Result),!.

addMatrices(M1, [], M1).

addMatrices([M1H|M1T], [M2H|M2T], Result) :-
  add(M1H, M2H, R),
  addMatrices(M1T, M2T, Res),
  append([R], Res, Result), !.

hopTrain([], []).

hopTrain([ASH|AST], Result) :-
  hopTrainAstate(ASH, R),
  hopTrain(AST, Res),
  addMatrices(R, Res, Result), !.
