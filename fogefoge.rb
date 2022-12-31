require_relative 'ui'

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
      return [linha, coluna_do_heroi]
    end
  end
end

def calcula_nova_posicao(heroi, direcao)
  case direcao
    when "W"
        heroi[0] -= 1
    when "S"
        heroi[0] += 1
    when "A"
        heroi[1] -= 1
    when "D"
        heroi[1] += 1
    else
      heroi
  end
  heroi
end

def move_fantasma(mapa, linha, coluna)
  posicao = [linha, coluna + 1]
  if posicao_valida? mapa, posicao
    mapa[linha][coluna] = " "
    mapa[posicao[0]][posicao[1]] = "F"
  end
end

def move_fantasmas(mapa)
  caractere_do_fantasma = "F"
  mapa.each_with_index do |linha_atual, linha|
    linha_atual.chars.each_with_index do |caractere_atual, coluna|
      eh_fantasma = caractere_atual == caractere_do_fantasma
      if eh_fantasma
        move_fantasma(mapa, linha, coluna)
      end
    end
  end
end

def posicao_valida?(mapa, nova_posicao)
  linhas = mapa.size
  colunas = mapa[0].size
  posicao_atual = mapa[nova_posicao[0]][nova_posicao[1]]
  estourou_linhas = nova_posicao[0] < 0 || nova_posicao[0] >= linhas
  estourou_colunas = nova_posicao[1] < 0 || nova_posicao[1] >= colunas
  colidiu_com_a_parede = posicao_atual == "X"
  colidiu_com_um_fantasma = posicao_atual == "F"

  if estourou_linhas || estourou_colunas || colidiu_com_a_parede || colidiu_com_um_fantasma
    return false
  end
  true
end

def joga(nome)
  mapa = le_mapa(2)
  while true
    desenha(mapa)
    heroi = encontra_jogador(mapa)
    nova_posicao = encontra_jogador(mapa)
    direcao = pede_movimento
    nova_posicao = calcula_nova_posicao(nova_posicao, direcao)

    unless posicao_valida?(mapa, nova_posicao)
      next
    end
    
    mapa[heroi[0]][heroi[1]] = " "
    mapa[nova_posicao[0]][nova_posicao[1]] = "H"
    
    move_fantasmas(mapa)
  end
end

def inicia_fogefoge
  nome = da_boas_vindas
  joga(nome)
end
