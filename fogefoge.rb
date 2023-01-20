require_relative 'ui'
require_relative 'heroi'

def le_mapa(numero)
  arquivo = "mapa#{numero}.txt"
  texto = File.read(arquivo)
  mapa = texto.split("\n")
end

def encontra_jogador(mapa)
  caracter_do_heroi = "H"
  mapa.each_with_index do |linha_atual, linha|
    coluna_do_heroi = linha_atual.index(caracter_do_heroi)
    if coluna_do_heroi
      jogador = Heroi.new
      jogador.linha = linha
      jogador.coluna = coluna_do_heroi
      return jogador
    end
  end
  false
end

def soma_vetor(vetor1, vetor2)
  [vetor1[0] + vetor2[0], vetor1[1] + vetor2[1]]
end

def posicoes_validas_a_partir_de(mapa, novo_mapa, posicao)
  posicoes = []
  movimentos = [[+1, 0],[0, +1],[-1, 0],[0, -1]]
  movimentos.each do |movimento|
    nova_posicao = soma_vetor(movimento, posicao)
    if posicao_valida?(mapa, nova_posicao, "F") && posicao_valida?(novo_mapa, nova_posicao, "F")
      posicoes << nova_posicao
    else
      posicoes << posicao
    end
  end
  posicoes
end

def move_fantasma(mapa, novo_mapa, linha, coluna)
  posicoes = posicoes_validas_a_partir_de(mapa, novo_mapa, [linha, coluna])
  return if posicoes.empty?
  
  aleatoria = rand(posicoes.size)
  posicao = posicoes[aleatoria]
  mapa[linha][coluna] = " "
  novo_mapa[posicao[0]][posicao[1]] = "F"
end

def copia_mapa(mapa)
  novo_mapa = mapa.join("\n").tr("F", " ").split("\n")
end

def move_fantasmas(mapa)
  caractere_do_fantasma = "F"
  novo_mapa = copia_mapa(mapa)
  mapa.each_with_index do |linha_atual, linha|
    linha_atual.chars.each_with_index do |caractere_atual, coluna|
      eh_fantasma = caractere_atual == caractere_do_fantasma
      if eh_fantasma
        move_fantasma(mapa, novo_mapa, linha, coluna)
      end
    end
  end
  novo_mapa
end

def posicao_valida?(mapa, nova_posicao, personagem)
  linhas = mapa.size
  colunas = mapa[0].size
  posicao_atual = mapa[nova_posicao[0]][nova_posicao[1]]
  estourou_linhas = nova_posicao[0] < 0 || nova_posicao[0] >= linhas
  estourou_colunas = nova_posicao[1] < 0 || nova_posicao[1] >= colunas
  colidiu_com_a_parede = posicao_atual == "X"
  colidiu_com_um_fantasma = posicao_atual == "F"

  if personagem == "H"
    if estourou_linhas || estourou_colunas || colidiu_com_a_parede
      return false
    end
  else
    if estourou_linhas || estourou_colunas || colidiu_com_a_parede || colidiu_com_um_fantasma
      return false
    end
  end
  
  true
end

def colidiu_com_fantasma?(mapa, nova_posicao)
  posicao_atual = mapa[nova_posicao[0]][nova_posicao[1]]
  colidiu_com_um_fantasma = posicao_atual == "F"
  if colidiu_com_um_fantasma
    return true
  end
  false
end

def jogador_perdeu?(mapa)
  !encontra_jogador(mapa)
end

def executa_remocao(mapa, posicao, qtde)
  if mapa[posicao.linha][posicao.coluna] == "X"
    return 
  end
  posicao.remove_do(mapa)
  remove(mapa, posicao, qtde - 1)
end

def remove(mapa, posicao, qtde)
  if qtde == 0
    return
  end
  executa_remocao(mapa, posicao.direita, qtde)
  executa_remocao(mapa, posicao.esquerda, qtde)
  executa_remocao(mapa, posicao.cima, qtde)
  executa_remocao(mapa, posicao.baixo, qtde)
end

def joga(nome)
  mapa = le_mapa(4)
  while true
    desenha(mapa)
    direcao = pede_movimento
    heroi = encontra_jogador(mapa)
    nova_posicao = heroi.calcula_nova_posicao(direcao)
    
    unless posicao_valida?(mapa, nova_posicao.to_array, "H")
      next
    end
    
    if colidiu_com_fantasma?(mapa, nova_posicao.to_array)
      heroi.remove_do(mapa)
    else
      heroi.remove_do(mapa)
      if mapa[nova_posicao.linha][nova_posicao.coluna] == "*"
        remove(mapa, nova_posicao, 4)
      end
      nova_posicao.coloca_no(mapa)
    end
    
    mapa = move_fantasmas(mapa)
    if jogador_perdeu?(mapa)
      game_over
      break
    end
  end
end

def inicia_fogefoge
  nome = da_boas_vindas
  joga(nome)
end
