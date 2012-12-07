:- use_module(library(tokenizer)).
:- use_module(library(textFile)).
:- use_module(library(textifier)).


oracleDir("./text/oracle/").
systemDir("./text/system/").

main:-
	oracleDir(Or),
	systemDir(Sy),
	append(Or, "clapton.txt", OrFile),
	append(Sy, "clapton.txt", SyFile), 
	solve(OrFile, SyFile).



/* soluzione per un file */
solve(SourceFile, ParsedFile):-
	/* legge l'intero testo dal file */
	readText(SourceFile, Text),
	/* trasforma il testo in una lista di tokens t(Index, Word) */
	tokenize(Text, Tokens),
	/* trasforma la lista di token semplici Tokens in una lista di token ai quali è assegnata una classe */
	parse(Tokens, Parsed),
	/* riscrive la lista parsata in notazione pseudo-xml */
	textify(Parsed, ParsedText),
	
	/* scrive il testo parsato nel file */
	writeText(ParsedFile, ParsedText).



parse(Tokens, Parsed):-
	true. /* parser(Tokens, Parsed). */
	


	
	


	
 	
