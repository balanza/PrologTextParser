:- use_module(library(lib/tokenizer)).


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



parse(Tokens, Parsed):-
	true. /* parser(Tokens, Parsed). */
	

/*
*  readText(+File, -Text)
*/	
readText(File, Text):-
	open(File, read, Stream),
	read(Stream, Text),
	close(Stream).
	
/*
*  writeText(+File, +Text)
*/	
writeText(File, Text):-
	open(File, write, Stream),
	write(Stream, Text),
	close(Stream).
	
	
/* 
* separator(Char) 
*   vero se Char fa parte della lista dei caratteri separatori
*/
separator(C):-
	member(C, [" ", "\t", "\n", ".", ",", ";", ":", "(", ")", "!", "?"]).

/* 
* ignore(Char) 
*   vero se Char fa parte della lista dei caratteri da ignorare
*/
ignore(C):-
	member(C, [" ", "\t", "\n", ",", ";", ":", "(", ")", "!", "?"]).


tokenizer([], nil, [], _).
	
	

/* textify(Parsed, ParsedText) */

textify([], []).

textify([E | Rest], Text):-
	textifyElem(E, TextElem),
	textify(Rest, Text0),
	last(" ", TextElem, Text1),
	applast(Text1, Text0, Text).


/* 
*  textifyElem(Elem, Text) 
*/
textifyElem(t(_, W), W).

textifyElem([t(_, W) | Rest], Text):-
	textifyElem(Rest, Text0),
	applast(W, Text0, Text).
	
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
	applast("<", T, Open0),
	applast(Open0, ">", Open),
	applast("</", T, Close0),
	applast(Close0, ">", Close),
	applast(Open, Text, W0),
	applast(W0, Close, W).
	
	

 
	

	
	 

	
 	
