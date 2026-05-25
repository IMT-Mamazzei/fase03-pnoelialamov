package br.maua.cic303;



%%



%class Lexer

%public

%unicode

%type Token

%line

%column



%{

    // Função auxiliar para gerar Tokens

    private Token token(Tag tag, String lexeme) {

        return new Token(tag, lexeme);

    }

%}



/* ========================================================================= */

/* MACROS (Expressões Regulares Auxiliares)                                  */

/* ========================================================================= */

LineTerminator = \r|\n|\r\n

WhiteSpace     = {LineTerminator} | [ \t\f]



/* TODO 1: Crie a macro para Número (Notação de Engenharia) */

/* Dica: Deve aceitar 7, 3.14, 6.02E23, 6.62e-34 */

Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?



/* TODO 2: Crie a macro para Identificador */

/* Dica: Letras, seguidas de letras, números ou _. MÁXIMO de 32 caracteres! */

/* Se a macro de max 32 for difícil, use {Letter}({Letter}|{Digit}|_)* e trate o tamanho na regra! */

Letter = [a-zA-Z]

Digit  = [0-9]

Identifier = {Letter}({Letter}|{Digit}|_){0,31}



%%

/* ========================================================================= */

/* REGRAS LÉXICAS                                                            */

/* ========================================================================= */



<YYINITIAL> {

    

    /* Regra para ignorar espaços em branco */

    {WhiteSpace}    { /* Não faz nada */ }



    /* TODO 3: Palavras Reservadas (if, then, else, while) */

    "if"            { return token(Tag.IF, yytext()); }

    "then"          { return token(Tag.THEN, yytext()); }

    "else"          { return token(Tag.ELSE, yytext()); }

    "while"         { return token(Tag.WHILE, yytext()); }



    /* TODO 4: Pontuação ( ) { } ; */

    "("             { return token(Tag.LPAREN, yytext()); }

    ")"             { return token(Tag.RPAREN, yytext()); }

    "{"             { return token(Tag.LBRACE, yytext()); }

    "}"             { return token(Tag.RBRACE, yytext()); }

    ";"             { return token(Tag.SEMI, yytext()); }



    /* TODO 5: Operadores de Atribuição e Relacionais (=, ==, !=, <, >, <=, >=) */

    /* CUIDADO COM A ORDEM! O JFlex casa a regra que aparece primeiro se houver empate de tamanho. */

    /* Coloque os operadores duplos antes dos simples! */

    "=="            { return token(Tag.REL_OP, yytext()); }

    "!="            { return token(Tag.REL_OP, yytext()); }

    "<="            { return token(Tag.REL_OP, yytext()); }

    ">="            { return token(Tag.REL_OP, yytext()); }

    "="             { return token(Tag.ASSIGN, yytext()); }

    "<"             { return token(Tag.REL_OP, yytext()); }

    ">"             { return token(Tag.REL_OP, yytext()); }



    /* TODO 6: Operadores Matemáticos (+, -, *, /, %) */

    /* Dica: "+" | "-" retornam Tag.ADD_OP. Os outros retornam Tag.MUL_OP */

    "+" | "-"       { return token(Tag.ADD_OP, yytext()); }

    "*" | "/" | "%" { return token(Tag.MUL_OP, yytext()); }



    /* Regras para as Macros */

    {Identifier}    { return token(Tag.ID, yytext()); }

    {Number}        { return token(Tag.NUMBER, yytext()); }



    /* Identificadores grandes demais (Captura o erro) */

    {Letter}({Letter}|{Digit}|_){32} { 

        return token(Tag.ERROR, "Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext()); 

    }



    /* Fallback: Qualquer outro caractere não reconhecido gera um Erro */

    .               { return token(Tag.ERROR, "Erro Léxico: Caractere Ilegal -> " + yytext()); }

}



/* Regra para o Final do Arquivo */

<<EOF>>             { return token(Tag.EOF, ""); }

