/*
*  Gestisce la trasformazione di un testo in lista di token
*/



:- module(tokenizer, [tokenize/2]).



/* 
*  tokenize(+Text, ?Tokens) 
*     interfaccia pubblica di tokenizer, vero se Tokens è una lista di tokens in forma t(+Index, +Word) che rappresenta il testo Text
*/
tokenize(Text, Tokens):-
	tokenizer(Text, nil, Tokens, 0).

/*
* tokenizer(+RemainedText, +ProcessingToken, ?Tokens, +Index)
*   predicato che è vero se Tokens è la riscrittura di RemainedText come lista di token t(Index, Word). I tokens sono aggiunti alla lista in maniera bottom-up
*/

/* fine del testo, ho un token */
tokenizer([], T, [T], _).	

/* fine del testo, NON ho un token */
tokenizer([], nil, [], _).

/* vero se sto leggo un carattere separatorChare, da ignorare e nn sto analizzando nessun token */
tokenizer([First | Rest], nil, Tokens, Cursor):-
	separatorChar(First),
	ignoreChar(First), !, 
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens, NewCursor).

/* vero se sto leggo un carattere separatorChare, da NON ignorare e nn sto analizzando nessun token */
tokenizer([First | Rest], nil, [t(Cursor, [First]) | Tokens], Cursor):-
	separatorChar(First), !, 
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens, NewCursor). /* siccome è già separatorChare egli stesso, lo aggiungo direttamente */
	

/* vero se sto leggo un carattere separatore, da ignorare e sto analizzando un token */	
tokenizer([First | Rest], t(I, W) , [t(I, W) | Tokens], Cursor):-
	separatorChar(First),  	
	ignoreChar(First), !,
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens, NewCursor).
	
	
/* vero se sto leggo un carattere separatore, da NON ignorare e sto analizzando un token */	
tokenizer([First | Rest], t(I, W) , [t(I, W), t(Cursor, [First]) | Tokens], Cursor):-
	separatorChar(First), !, 
	NewCursor is Cursor + 1,  /* siccome è già separatore egli stesso, lo aggiungo direttamente */
	tokenize(Rest, nil, Tokens, NewCursor).
	
/* vero se sto leggendo un carattere NON separatore e NON sto già analizzando un token */
tokenizer([First | Rest], nil, Tokens, Cursor):-
	NewCursor is Cursor + 1,
	tokenizer(Rest, t(Cursor, [First]), Tokens, NewCursor).	

/* vero se sto leggendo un carattere NON separatore e sto già analizzando un token */
tokenizer([Char | Rest], t(I, W), Tokens, Cursor):-
	NewCursor is Cursor + 1,
	append(W, [Char], Word),
	tokenizer(Rest, t(I, Word), Tokens, NewCursor).



/* 
* separatorChar(Char) 
*   vero se Char fa parte della lista dei caratteri separatorChari
*/
separatorChar(C):-
	member(C, [" ", "\t", "\n", ".", ",", ";", ":", "(", ")", "!", "?"]).

/* 
* ignoreChar(Char) 
*   vero se Char fa parte della lista dei caratteri da ignorare
*/
ignoreChar(C):-
	member(C, [" ", "\t", "\n", ",", ";", ":", "(", ")", "!", "?"]).


