/*
*  Gestisce i testi da file
*/


:- module(textFile, [readText/2, writeText/2]).



/*
*  readText(+File, ?Text)
*/	
readText(File, Text):-
	open(File, read, Stream),
	readFile(Stream, Text),
	close(Stream).
	
	
/*
*  readFile(+Stream, ?Text)
*/	
readFile(Stream,[]) :-
   at_end_of_stream(Stream), !.

readFile(Stream,[X|L]) :-
   get0(Stream,X),
   readFile(Stream,L).

	
/*
*  writeText(+File, +Text)
*/	
writeText(File, Text):-
	open(File, write, Stream),
	write(Stream, Text),
	close(Stream).
	
	





