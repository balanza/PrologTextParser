/*
*  Gestisce la conversione tra lista di token e testo con l'aggiunta di tag pseudo-xml
*/

:- module(textifier, [textify/2]).


/* textify(Parsed, ParsedText) */

textify([], []).

textify([E | Rest], Text):-
	textifyElem(E, TextElem),
	textify(Rest, Text0),
	last(" ", TextElem, Text1),
	append(Text1, Text0, Text).


/* 
*  textifyElem(Elem, Text) 
*/
textifyElem(t(_, W), W).

textifyElem([t(_, W) | Rest], Text):-
	textifyElem(Rest, Text0),
	append(W, Text0, Text).
	
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
	append("<", T, Open0),
	append(Open0, ">", Open),
	append("</", T, Close0),
	append(Close0, ">", Close),
	append(Open, Text, W0),
	append(W0, Close, W).
