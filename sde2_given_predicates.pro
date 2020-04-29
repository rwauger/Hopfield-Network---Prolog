/* SDE 2 sp 2020 given predicates:
   sde2_sp2020_given_predicates.pro */

/**************************************************************************/
/* Hopfield activation function for (-1,1) units; this is for a single unit:
Prototype:
hop11Activation(+Net,+Oldo,-Output)
*/

hop11Activation(Net,_,1.0) :- Net > 0.0,!.

hop11Activation(Net,Oldo,Oldo) :- Net = 0.0,!.

hop11Activation(Net,_,-1.0) :- Net < 0.0, !.

/**************************************************************************/
/* Entire Hopfield network state, given network net activation:
Prototype:
hop11ActAll(+AllNet,+OldState,-NewState)
 */

hop11ActAll([ANH|ANT],[OSH|OST],[NSH|NST]) :-
                     hop11Activation(ANH,OSH,NSH),
                     hop11ActAll(ANT,OST,NST),!.

hop11ActAll([],_,[]).

/* utility */

inner([HI|TI],[HW|TW],Res) :-
     inner(TI,TW,Tres), Res is (HI*HW) + Tres.

inner([],[],0.0).

/**************************************************************************/
/* net activation computation for single set of weights (one unit):
Prototype:
netUnit(+Inputs,+Weights,-Net)
 */

netUnit(Inputs, Weights,Net) :- inner(Inputs,Weights,Net).

/**************************************************************************/
/* net activation computation for entire network:
Prototype:
netAll(+State,+WeightMatrix,-NetEntire)
 */

netAll(State,[WMH|WMT],[NAH|NAT]) :-
                netUnit(State,WMH,NAH),
                netAll(State,WMT,NAT),!.

netAll(_,[],[]).

