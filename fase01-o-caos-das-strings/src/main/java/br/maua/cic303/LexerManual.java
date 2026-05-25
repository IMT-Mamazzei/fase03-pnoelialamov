package br.maua.cic303;

public class LexerManual {
    private String entrada;
    private int posicao;

    public LexerManual(String entrada) {
        this.entrada = entrada;
        this.posicao = 0;
    }

    /**
     * Tenta ler o próximo Token da entrada.
     * Retorna um Token com a Tag.EOF quando a entrada terminar.
     */
    public Token nextToken() {
        
        // 1. Pular espaços em branco (\s, \t, \n, \r)
        while (posicao < entrada.length() && Character.isWhitespace(entrada.charAt(posicao))) {
            posicao++;
        }

        // 2. Verificar se chegou no final da string (Retornar Tag.EOF)
        if (posicao >= entrada.length()) {
            return new Token(Tag.EOF, "");
        }

        // Pega o caractere atual para análise
        char atual = entrada.charAt(posicao);

        // 3. Identificar Atribuição e Operadores
        if (atual == '=') {
            posicao++;
            return new Token(Tag.ASSIGN, "=");
        }

        if (atual == '+' || atual == '-') {
            posicao++;
            return new Token(Tag.ADD_OP, String.valueOf(atual));
        }

        if (atual == '*' || atual == '/') {
            posicao++;
            return new Token(Tag.MUL_OP, String.valueOf(atual));
        }

        // 4. Identificar Números (Inteiros e Decimais)
        if (Character.isDigit(atual)) {
            StringBuilder sb = new StringBuilder();
            
            // Lê a parte inteira do número
            while (posicao < entrada.length() && Character.isDigit(entrada.charAt(posicao))) {
                sb.append(entrada.charAt(posicao));
                posicao++;
            }
            
            // Verifica se o próximo caractere é um ponto flutuante (ex: .14)
            // É importante garantir que exista um dígito APÓS o ponto para não confundir com chamadas de métodos ou fins de frase
            if (posicao < entrada.length() && entrada.charAt(posicao) == '.') {
                // Olhada à frente (lookahead) para ver se há um dígito após o ponto
                if (posicao + 1 < entrada.length() && Character.isDigit(entrada.charAt(posicao + 1))) {
                    sb.append(entrada.charAt(posicao)); // Adiciona o '.'
                    posicao++; // Consome o '.'
                    
                    // Lê a parte decimal do número
                    while (posicao < entrada.length() && Character.isDigit(entrada.charAt(posicao))) {
                        sb.append(entrada.charAt(posicao));
                        posicao++;
                    }
                }
            }
            
            return new Token(Tag.NUMBER, sb.toString());
        }

        // 5. Identificar Identificadores (Tag.ID)
        if (Character.isLetter(atual) || atual == '_') {
            StringBuilder sb = new StringBuilder();
            
            while (posicao < entrada.length() && 
                  (Character.isLetterOrDigit(entrada.charAt(posicao)) || entrada.charAt(posicao) == '_')) {
                sb.append(entrada.charAt(posicao));
                posicao++;
            }
            return new Token(Tag.ID, sb.toString());
        }

        // Se chegou até aqui e não reconheceu nada, retorna Tag.ERROR
        String lexemaNaoReconhecido = String.valueOf(entrada.charAt(posicao));
        posicao++; // Avança 1 caractere para não travar num loop infinito

        return new Token(Tag.ERROR, lexemaNaoReconhecido);
    }
}