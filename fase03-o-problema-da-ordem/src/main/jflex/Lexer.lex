package br.maua.cic303;

import java_cup.runtime.Symbol; // Importação necessária para o CUP

%%

%class Lexer
%public
%unicode
%cup       // <-- CRÍTICO: Esta diretiva ativa a integração com o CUP
%line
%column

%{
    // Funções auxiliares para gerar objetos Symbol para o CUP
    private Symbol symbol(int type) {
        return new Symbol(type, yyline, yycolumn);
    }
    
    private Symbol symbol(int type, Object value) {
        return new Symbol(type, yyline, yycolumn, value);
    }
%}

/* ========================================================================= */
/* MACROS (Expressões Regulares Auxiliares)                                  */
/* ========================================================================= */
LineTerminator = \r|\n|\r\n
WhiteSpace     = {LineTerminator} | [ \t\f]

/* Número (Notação de Engenharia) */
Number = [0-9]+(\.[0-9]+)?([Ee][+-]?[0-9]+)?

/* Identificador - Trocamos {0,31} por * para evitar o erro de macro no JFlex */
Letter = [a-zA-Z]
Digit  = [0-9]
Identifier = {Letter}({Letter}|{Digit}|_)*

%%
/* ========================================================================= */
/* REGRAS LÉXICAS                                                            */
/* ========================================================================= */

<YYINITIAL> {
    
    /* Regra para ignorar espaços em branco */
    {WhiteSpace}    { /* Não faz nada */ }

    /* Palavras Reservadas */
    "if"            { return symbol(sym.IF); }
    "then"          { return symbol(sym.THEN); }
    "else"          { return symbol(sym.ELSE); }
    "while"         { return symbol(sym.WHILE); }

    /* Pontuação */
    "("             { return symbol(sym.LPAREN); }
    ")"             { return symbol(sym.RPAREN); }
    "{"             { return symbol(sym.LBRACE); }
    "}"             { return symbol(sym.RBRACE); }
    ";"             { return symbol(sym.SEMI); }

    /* Operadores de Atribuição e Relacionais (Ordem é importante!) */
    "=="            { return symbol(sym.REL_OP, yytext()); }
    "!="            { return symbol(sym.REL_OP, yytext()); }
    "<="            { return symbol(sym.REL_OP, yytext()); }
    ">="            { return symbol(sym.REL_OP, yytext()); }
    "<"             { return symbol(sym.REL_OP, yytext()); }
    ">"             { return symbol(sym.REL_OP, yytext()); }
    "="             { return symbol(sym.ASSIGN); }

    /* Operadores Matemáticos */
    "+" | "-"       { return symbol(sym.ADD_OP, yytext()); }
    "*" | "/" | "%" { return symbol(sym.MUL_OP, yytext()); }

    /* Regras para as Macros */
    {Number}        { return symbol(sym.NUMBER, yytext()); }

    {Identifier}    { 
        /* Validação do tamanho realocada para cá para evitar bug do JFlex */
        if (yytext().length() > 32) {
            throw new RuntimeException("Erro Léxico: Identificador ultrapassou 32 caracteres -> " + yytext());
        }
        return symbol(sym.ID, yytext()); 
    }

    /* Fallback: Qualquer outro caractere não reconhecido gera um Erro */
    .               { throw new RuntimeException("Erro Léxico: Caractere Ilegal -> " + yytext()); }
}

/* Regra para o Final do Arquivo (Ajustado para retornar sym.EOF) */
<<EOF>>             { return symbol(sym.EOF); }