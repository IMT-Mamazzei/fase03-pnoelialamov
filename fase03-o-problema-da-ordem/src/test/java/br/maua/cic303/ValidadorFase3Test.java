package br.maua.cic303;

import org.junit.Test;
import static org.junit.Assert.*;
import java.io.StringReader;

public class ValidadorFase3Test {

    // Helper que roda o Léxico integrado com o Sintático (CUP)
    private void analisarSintaxe(String codigo) throws Exception {
        Lexer lexer = new Lexer(new StringReader(codigo));
        parser parser1 = new parser(lexer);
        parser1.parse(); // Se a sintaxe for inválida, lançará RuntimeException
    }

    @Test
    public void test01_AtribuicaoSimples() throws Exception {
        // Código válido
        analisarSintaxe("x = 10 ; y = x + 2 * 3 ;");
        assertTrue(true); // Se chegou aqui, passou!
    }

    @Test
    public void test02_EstruturasDeControle() throws Exception {
        // Código válido com aninhamento
        String codigo = "while (x < 10) { if (y == 2) then { x = x + 1 ; } else { y = 0 ; } }";
        analisarSintaxe(codigo);
        assertTrue(true);
    }

    @Test
    public void test03_RejeitaCodigoMalFormado() {
        String codigoInvalido = "while x < 10 { x = x + 1 ; }"; // Faltam os parênteses do while!

        try {
            analisarSintaxe(codigoInvalido);
            fail("O analisador deveria ter rejeitado o WHILE sem parênteses!");
        } catch (Exception e) {
            assertTrue("Erro sintático capturado com sucesso.", true);
        }
    }

    @Test
    public void test04_RejeitaFaltaDePontoEVirgula() {
        String codigoInvalido = "x = 10 \n y = 20 ;"; // Falta ; na primeira linha

        try {
            analisarSintaxe(codigoInvalido);
            fail("O analisador deveria ter rejeitado atribuição sem ponto e vírgula.");
        } catch (Exception e) {
            assertTrue(true);
        }
    }

    @Test
    public void test05_BlocoVazioENullStatement() throws Exception {
        // Código válido: Bloco vazio e comandos nulos (;;;)
        String codigo = "if ( a != b ) then { ; } else { ; ; ; }";
        analisarSintaxe(codigo);
        assertTrue(true);
    }
}
