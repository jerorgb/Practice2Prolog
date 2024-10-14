
:- discontiguous parent/2, children/2, sibling/2, grandparent/2, uncle/2, cousin/2.

%Parental relationships
%parent(X, Y).
%children(X, Y) :- parent(X, Y).

%Sibling relationships
%sibling(X, Y) :- parent(Z, X), parent(Z, Y), X \= Y.

%Grandparent relationships
%grandparent(X, Y) :- parent(X, Z), parent(Z, Y).

%Uncle relationships
%uncle(X, Y) :- sibling(X, Z), parent(Z, Y).

%Cousin relationships
%cousin(X, Y) :- parent(Z, X), parent(W, Y), sibling(Z, W).

% Level 1 relationships
levelConsanguinity(X, Y, 1) :- parent(X, Y).
levelConsanguinity(X, Y, 1) :- children(X, Y).

% Level 2 relationships
levelConsanguinity(X, Y, 2) :- sibling(X, Y).
levelConsanguinity(X, Y, 2) :- grandparent(X, Y).

% Level 3 relationships
levelConsanguinity(X, Y, 3) :- uncle(X, Y).
levelConsanguinity(X, Y, 3) :- cousin(X, Y).

% Heirs and their levels
heirLevel((X, 1)) :- levelConsanguinity(X, _, 1).
heirLevel((X, 2)) :- levelConsanguinity(X, _, 2).
heirLevel((X, 3)) :- levelConsanguinity(X, _, 3).

% Count the number of heirs at each level
countLevels([], 0, 0, 0).
countLevels([(X, 1)|T], Count1, Count2, Count3) :- 
    countLevels(T, Count1Next, Count2, Count3),
    Count1 is Count1Next + 1.
countLevels([(X, 2)|T], Count1, Count2, Count3) :- 
    countLevels(T, Count1, Count2Next, Count3),
    Count2 is Count2Next + 1.
countLevels([(X, 3)|T], Count1, Count2, Count3) :- 
    countLevels(T, Count1, Count2, Count3Next),
    Count3 is Count3Next + 1.

% Calculate distribution based on levels
calculateDistribution(Heirs, Total, Distribution) :-
    countLevels(Heirs, Count1, Count2, Count3),
    Percent1 is 30 * Count1,
    Percent2 is 20 * Count2,
    Percent3 is 10 * Count3,
    TotalPercent is Percent1 + Percent2 + Percent3,
    adjustDistribution(TotalPercent, Percent1, Percent2, Percent3, Total, Distribution),
    write('Total Percentage: '), write(TotalPercent), nl.

% Adjust the distribution to sum to 100%
adjustDistribution(TotalPercent, P1, P2, P3, Total, Distribution) :-
    TotalPercent > 0, %Avoid division by zero
    Factor is 100 / TotalPercent,
    Adjusted1 is round(P1 * Factor) / 100,
    Adjusted2 is round(P2 * Factor) / 100,
    Adjusted3 is round(P3 * Factor) / 100,
    Total1 is Total * Adjusted1, 
    Total2 is Total * Adjusted2, 
    Total3 is Total * Adjusted3,
    Distribution = [$Total1, $Total2, $Total3],
    write('Adjustment Factor: '), write(Factor), nl.

% Distributing the inheritance
distributeInheritance(InheritanceTotal, Distribution) :-
    findall(Level, heirLevel(Level), Levels),
    calculateDistribution(Levels, InheritanceTotal, Distribution).

children(john, mary).
children(ana, mary).
sibling(mary, jess).
cousin(jorge, mary).



