/* lista di separatori di token */
separators([" ", "\t", "\n", ".", ",", ";", ":", "-", "(", ")", "!", "?"]).
/* caratteri che il parser deve ignorare */
ignore([" ", "\t", "\n", ".", ",", ";", ":", "-", "(", ")", "!", "?"]).

/* main */
solve(SourceFile, ParsedFile):-
	/* legge l'intero testo dal file */
	readText(SourceFile, Text),
	/* trasforma il testo in una lista di tokens t(Index, Word) */
	tokenize(Text, Tokens),
	/* trasforma la lista di token semplici Tokens in una lista di token ai quali è assegnata una classe */
	parse(Tokens, Parsed),
	/* riscrive la lista parsata in notazione pseudo-xml */
	textify(Parsed, ParsedText).
	
	/* scrive il testo parsato nel file */
	writeText(ParsedFile, ParsedText).

tokenize(Text, Tokens):-
	tokenizer(Text, nil, Tokens, 0).

parse(Tokens, Parsed):-
	parser(Tokens, Parsed).
	
/*
*  last(Elem, List, NewList)
*/
last(E, [], [E]).
last(E, [H | T], NL):-
	end(E, T, NL).

/*
* first(Elem, List, NewList)
*/
first(E, [], [E]).
first(E, L, [E | L]).

/*
* tokenizer(RemainedText, ProcessingToken, Tokens, Index)
*   predicato che è vero se Tokens è la riscrittura di RemainedText come lista di token t(Index, Word). I tokens sono aggiunti alla lista in maniera bottom-up
*/

/* vero se sto leggo un carattere separatore, da ignorare e nn sto analizzando nessun token */
tokenizer([First | Rest], nil, Tokens, Cursor):-
	member(First, separators),
	member(First, ignore), !, 
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens, NewCursor).

/* vero se sto leggo un carattere separatore, da NON ignorare e nn sto analizzando nessun token */
tokenizer([First | Rest], nil, Tokens, Cursor):-
	member(First, separators), !, 
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens0, NewCursor),
	first(t(Cursor, [First]), Tokens0, Tokens). /* siccome è già separatore egli stesso, lo aggiungo direttamente */
	

/* vero se sto leggo un carattere separatore, da ignorare e sto analizzando un token */	
tokenizer([First | Rest], t(I, W) , Tokens, Cursor):-
	member(First, separators),  	
	member(First, ignore), !,
	NewCursor is Cursor + 1,
	tokenizer(Rest, nil, Tokens0, NewCursor),
	first(t(I, W), Tokens0, Tokens).
	
	
/* vero se sto leggo un carattere separatore, da NON ignorare e sto analizzando un token */	
tokenizer([First | Rest], t(I, W) , Tokens, Cursor):-
	member(First, separators), !, 
	NewCursor is Cursor + 1,  /* siccome è già separatore egli stesso, lo aggiungo direttamente */
	tokenize(Rest, nil, Tokens0, NewCursor),
	first(t(Cursor, [First]), Tokens0, Tokens1),
	first(t(I, W), Tokens1, Tokens).
	
/* vero se sto leggendo un carattere NON separatore e NON sto già analizzando un token */
tokenizer([First | Rest], nil, Tokens, Cursor):-
	NewCursor is Cursor + 1,
	tokenizer(Rest, t(Cursor, [First]), Tokens, NewCursor).	

/* vero se sto leggendo un carattere NON separatore e sto già analizzando un token */
tokenizer([First | Rest], t(I, W), Tokens, Cursor):-
	NewCursor is Cursor + 1,
	end(First, W, Word),
	tokenizer(Rest, t(I, Word), Tokens, NewCursor).

/* fine del testo, ho un token */
tokenizer([], T, [T], _).	

/* fine del testo, NON ho un token */
tokenizer([], nil, [], _).
	
	

/* textify(Parsed, ParsedText) */

textify([], []).

textify([E | Rest], Text):-
	textifyElem(E, TextElem),
	textify(Rest, Text0),
	end(" ", TextElem, Text1),
	concat(Text1, Text0, Text).


/* 
*  textifyElem(Elem, Text) 
*/
textifyElem(t(_, W), W).

textifyElem([t(_, W) | Rest], Text):-
	textifyElem(Rest, Text0),
	concat(W, Text0, Text).
	
textifyElem(d(L), Text):-
	textifyElem(L, Text0), 
	taggify("D", Text0, Text).
	
textifyElem(per(L), Text):-
	textifyElem(L, Text0), 
	taggify("PER", Text0, Text).
	
textifyElem(l(L), Text):-
	textifyElem(L, Text0), 
	taggify("L", Text0, Text).
	
	
/*
*  taggify(TagName, Text, WrappedText)
*/
taggify(T, TXT, W):-
	concat("<", T, Open0),
	concat(Open0, ">", Open),
	concat("</", T, Close0),
	concat(Close0, ">", Close),
	concat(Open, Text, W0),
	concat(W0, Close, W).
	
	

 
	

	
	 

	
 	
