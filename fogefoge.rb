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

def posicao_valida?(mapa, nova_posicao)
  linhas = mapa.size
  colunas = mapa[0].size
  estourou_linhas = nova_posicao[0] < 0 || nova_posicao[0] >= linhas
  estourou_colunas = nova_posicao[1] < 0 || nova_posicao[1] >= colunas
  colidiu_com_a_parede = mapa[nova_posicao[0]][nova_posicao[1]] == "X"

  if estourou_linhas || estourou_colunas || colidiu_com_a_parede
    return false
  end
  true
end

def joga(nome)
  mapa = le_mapa(1)
  while true
    desenha(mapa)
    heroi = encontra_jogador(mapa)
    nova_posicao = encontra_jogador(mapa)
    direcao = pede_movimento
    nova_posicao = calcula_nova_posicao(nova_posicao, direcao)

    unless posicao_valida?(mapa, nova_posicao)
      next
    end

    puts "#{heroi}"
    puts "#{nova_posicao}"
    mapa[heroi[0]][heroi[1]] = " "
    mapa[nova_posicao[0]][nova_posicao[1]] = "H"
  end
end

def inicia_fogefoge
  nome = da_boas_vindas
  joga(nome)
end
