class Heroi
  attr_accessor :linha, :coluna

  def calcula_nova_posicao(direcao)
    novo_heroi = dup
    case direcao
    when "W"
      novo_heroi.linha -= 1
    when "S"
      novo_heroi.linha += 1
    when "A"
      novo_heroi.coluna -= 1
    when "D"
      novo_heroi.coluna += 1
    else
      novo_heroi
    end
    novo_heroi
  end
  
  def to_array
    [linha, coluna]
  end
  
  def remove_do(mapa)
    mapa[linha][coluna] = " "
  end
  
  def coloca_no(mapa)
    mapa[linha][coluna] = "H"
  end
  
  def direita
    calcula_nova_posicao("D")
  end

  def esquerda
    calcula_nova_posicao("A")
  end

  def cima
    calcula_nova_posicao("W")
  end

  def baixo
    calcula_nova_posicao("S")
  end
end