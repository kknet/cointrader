grammar Base;

@header {
    import java.util.Set;
    import java.util.HashSet;
}

@lexer::members {

    private void stripQuotes()
    {
        setText(getText().substring(1,getText().length()-1));  // strip the quotes
    }


    private void ident()
    {
        if( currencySymbols.contains(getText().toUpperCase()) )
            setType(Currency);
         else if( promptSymbols.contains(getText().toUpperCase()) )
            setType(Prompt);
        else if( exchangeSymbols.contains(getText().toUpperCase()) )
            setType(Exchange);
    }

    private static Set<String> marketSymbols;
    private static Set<String> listingSymbols;
    private static Set<String> exchangeSymbols;
    private static Set<String> currencySymbols;
    private static Set<String> promptSymbols;

    static {
        marketSymbols = new HashSet<String>(org.cryptocoinpartners.schema.Market.allSymbols());
        listingSymbols = new HashSet<String>(org.cryptocoinpartners.schema.Listing.allSymbols());
        exchangeSymbols = new HashSet<String>(org.cryptocoinpartners.schema.Exchange.allSymbols());
        currencySymbols = new HashSet<String>(org.cryptocoinpartners.schema.Currency.allSymbols());
        promptSymbols = new HashSet<String>(org.cryptocoinpartners.schema.Prompt.allSymbols());
    }
  
}


Amount
: [0-9]+
| [0-9]* '.' [0-9]+
;

Ident
: [a-zA-Z_][a-zA-Z_]* { ident(); }
;

Market: Exchange ':' Listing ;
Listing: Currency '.' Currency '.' Prompt ;
Prompt: Ident; // set by ident();
Currency: Ident; // set by ident();
Exchange: Ident; // set by ident();

fragment
Alpha
: [a-zA-Z]
;


fragment
Alphanum
: Alpha
| [0-9]
;


String
: '\'' (EscapeSequence | ~['\r\n\\])* '\'' { stripQuotes(); }
| '"' (EscapeSequence | ~["\r\n\\])* '"' { stripQuotes(); }
;


fragment
EscapeSequence
: '\\'
( // The standard escaped character set such as tab, newline, etc.
[btnfr"'\\]
| // Invalid escape
.
| // Invalid escape at end of file
EOF
)
;


// ignore whitespace.  leave this at the bottom as the lowest priority lexer rule
/*
WS : [ \t\r\n\f]+ -> channel(HIDDEN) ;
*/

WS
: [ \t\r\n\f]+
-> skip
;
