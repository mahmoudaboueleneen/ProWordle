main:-
		build_kb,nl,
		play.
build_kb:-
		write('Please enter a word and its category on separate lines'),nl,
		read(W),
		processing1(W).
play:-
		write('The available categories are: '),
		categories(L),
		write(L),nl,
		write('Choose a category:'),nl,
		read(X),
		choose_a_category(X,Cuser),
		write('Choose a length:'),nl,
		read(Y),
		choose_a_length(Y,Cuser,Luser),
		G is Luser+1,
		write('Game started. You have '),write(G),write(' guesses.'),nl,nl,
		allwordswithC(Cuser,Listallw),
		spec_words(Luser,Listallw,Listspecw),
		random_member(Rand,Listspecw),
		write('Enter a word composed of '),write(Luser),write(' letters:'),nl,
		read(Wrd),
		engine(G,Rand,Wrd).
		
engine(G,Rand,Rand):-
		G>0,
		write('You won!'),!.
engine(1,Rand,Wrd):-
		\+Rand=Wrd,
		write('You lost!'),!.

engine(G,Rand,Wrd):-
		atom_length(Rand,Len),
		\+ atom_length(Wrd,Len),
		write('Word is not composed of '),write(Len),write(' letters. Try again.'),nl,
		write('Remaining guesses are '),write(G),nl,nl,
		write('Enter a word composed of '),write(Len),write(' letters:'),nl,
		read(Wrd2),!,
		engine(G,Rand,Wrd2).

engine(G,Rand,Wrd):-
		allwords(L),\+member(Wrd,L),
		atom_length(Rand,Len),
		write('This word does not exist'),nl,
		write('Remaining Guesses are '),write(G),nl,nl,
		write('Enter a word composed of '),write(Len),write(' letters:'),nl,
		read(Wrd2),!,
		engine(G,Rand,Wrd2).
		

engine(G,Rand,Wrd):-
		write('Correct letters are: '),
		atom_chars(Rand,L1),
		atom_chars(Wrd,L2),
		correct_letters(L1,L2,Corrlet),
		write(Corrlet),nl,
		write('Correct letters in correct positions are: '),
		correct_positions(L2,L1,Corrpos),
		write(Corrpos),nl,
		write('Remaining Guesses are '),G1 is G-1,write(G1),nl,nl,
		atom_length(Rand,Len),
		write('Enter a word composed of '),write(Len),write(' letters:'),nl,
		read(Wrd2),
		engine(G1,Rand,Wrd2).
allwords(L):-
		setof(W,C^word(W,C),L).
allwordswithC(C,L):-
		setof(W,C^word(W,C),L).

spec_words(Len,L,R):-
		spec_words(Len,L,[],R).

spec_words(_,[],Ac,Ac).

spec_words(Len,[H|T],Ac,R):-
		atom_length(H,Len),
		append(Ac,[H],Ac1),
		spec_words(Len,T,Ac1,R).

spec_words(Len,[H|T],Ac,R):-
		\+atom_length(H,Len),
		spec_words(Len,T,Ac,R).
		
choose_a_category(X,R):-
		categories(L),
		\+member(X,L),
		write('This category does not exist.'),nl,
		write('Choose a category:'),nl,
		read(Y),
		choose_a_category(Y,R).
choose_a_category(X,X):-
		categories(L),
		member(X,L),!.

choose_a_length(Y,Cuser,Y):-
		word(W,Cuser),
		atom_length(W,Y),!.
		
choose_a_length(Y,Cuser,Luser):-
		\+ (word(W,Cuser),atom_length(W,Y)),
		write('There are no words of this length.'),nl,
		write('Choose a length:'),nl,
		read(K),
		choose_a_length(K,Cuser,Luser).
		
processing1(done):-
		write('Done building the words database...'),
		!.
				
processing1(W):-
		read(C),
		assert(word(W,C)),
		build_kb.
is_category(C):-
		word(_,C).
		
categories(L):-
		setof(C,W^word(W,C),L).
		
available_length(L):-
		word(W,_),
		atom_length(W,L),!.
		
pick_word(W,L,C):-
		word(W,C),
		atom_length(W,L).
		
correct_letters(Rand,Wrd,CL):-
		correct_letters(Rand,Wrd,[],CL).
		
correct_letters(_,[],Ac,Ac).

correct_letters(Rand,[Hwrd|Twrd],Ac,CL):-
		member(Hwrd,Rand),
		append(Ac,[Hwrd],Ac1),
		rem(Hwrd,Rand,Rand1),!,
		correct_letters(Rand1,Twrd,Ac1,CL).

correct_letters(Rand,[Hwrd|Twrd],Ac,CL):-
		\+member(Hwrd,Rand),
		correct_letters(Rand,Twrd,Ac,CL).
rem(E,L,R):-
		rem(E,L,[],R).
rem(_,[],Ac,Ac).
rem(E,[E|T],Ac,Ac1):-
		rem(E,T,Ac,Ac1).
rem(E,[H|T],Ac,R):-
		\+E=H,
		append(Ac,[H],Ac1),
		rem(E,T,Ac1,R).

		
correct_positions([H|T1],[H|T2],[H|R]):-
		correct_positions(T1,T2,R).
				
correct_positions([H1|T1],[H2|T2],R):-			
		\+ H1=H2,
		correct_positions(T1,T2,R).
correct_positions([],[],[]).