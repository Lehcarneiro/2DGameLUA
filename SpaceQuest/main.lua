-- Programa Principal

-- Apelidos
local LG = love.graphics -- métodos de renderização
local LK = love.keyboard -- métodos de controle do teclado

--Variáveis Globais

--imgJogador = nil
jogador = {posx = 0, posy = 0, veloc = 150, img = nil}

--Timer para controle de tiros
podeAtirar = true
atiraMax = 0.2
tempoTiro = atiraMax
-- Estrutura controlar ps tiros
imgProjetil = nil
disparos = {}

-- Timer para controle de inimigos
dtMaxCriaInimigo = 0.4
dtAtualInimigo = dtMaxCriaInimigo
margemInimigo = 10

-- Estrutura para controle dos inimigos 
imgInimigo = nil
inimigos = {}

--Controle de Fim de Jogo e Pontuação
Vivo = true
Pontos = 0




--Responsável pela carga dos insumos (assets)
function  love.load()  
  
  imgJogador = LG.newImage("Nave.png") -- carga da imagem  
  fundo = LG.newImage("Espaco.png") -- fundo do jogo
  jogador.img = LG.newImage("Nave.png") --jogador
  meioh = (LG.getWidth() - jogador.img:getWidth()) / 2
  meiov = (LG.getHeight() - jogador.img:getHeight())
  jogador.posx = meioh
  jogador.posy = meiov
  imgProjetil = LG.newImage("projetil.png")
  imgInimigo = LG.newImage("Nave-Inimiga.png")
  margemInimigo = imgInimigo:getWidth()/2  
end

-- Responsável pela renderização na tel (fps)
function love.draw()
  LG.draw(fundo,0,0)
 -- Desenhar a imagem passando o arquivo e o (x,y)
 if (Vivo) then
  LG.draw(jogador.img, jogador.posx, jogador.posy)
else
  LG.print("Game Over\nPressione R para reiniciar!", LG.getWidth()/2 - 50, LG.getHeight() /2 -10)
end
 -- Atualização disparos executados
  for i, proj in ipairs(disparos) do
   LG.draw(proj.img, proj.x, proj.y)
  end
 -- Atualizar os inimigos na tela
  for i, atual in ipairs(inimigos) do
   LG.draw(atual.img, atual.x, atual.y)
  end
end

-- Responsável pelas interações com o tempo 
-- Animação, coleta de pressionar o teclado
function love.update(dt)
    -- Detecção de colisões
for i, atual in ipairs(inimigos) do
  -- Inimigos com disparos
  for j, proj in ipairs(disparos) do
    if (verColisao(atual.x, atual.y, atual.img:getWidth(), atual.img:getHeight(),
        proj.x, proj.y, proj.img:getWidth(), proj.img:getHeight())) then 
      -- Ocorreu colisão mata o inimigo
      table.remove(inimigos, i)
      table.remove(disparos, j)
      Pontos = Pontos+10
  end
end
--Verificar  se o inimigo colidiu com o personagem
if (verColisao(atual.x, atual.y, atual.img:getWidth(), atual.img:getHeight(),
    jogador.posx, jogador.posy, jogador.img:getWidth(), jogador.img:getHeight())) then
  table.remove(inimigos,i)
  Vivo = false
 end
end
--Reiniciar jogo
if(not Vivo and LK.isDown('r')) then
  --Limpar as tabelas
  inimigos = {}
  disparos = {}
  -- Reiniciar temporizadores
  tempoTiro = atiraMax
  dtAtualInimigo = dtMaxCriaInimigo
  --Posicionar a nave
  jogador.posx = meioh
  jogador.posy = meiov
  -- reiniciar placar
  Vivo = true
  Pontos = 0
end


  -- Controle para a direita e esquerda
  if(LK.isDown('left','a')) then
    if (jogador.posx >0) then
      jogador.posx = jogador.posx - (jogador.veloc * dt)
    end
  elseif (LK.isDown('right','d')) then
    if(jogador.posx <(LG.getWidth() - jogador.img:getWidth()))then
      jogador.posx = jogador.posx + (jogador.veloc * dt)
    end
end
-- Temporização dos disparos
  tempoTiro = tempoTiro -(1 * dt)
  if (tempoTiro < 0) then
    podeAtirar = true
  end
  -- Controle do disparo
  if (LK.isDown('space','rctrl','lctrl')and podeAtirar)then
    -- Criar uma instância do projetil
    nvProj = {
      x =(jogador.posx + jogador.img:getWidth()/2),
      y = jogador.posy,
      img = imgProjetil
    }
    table.insert(disparos, nvProj)
    podeAtirar = false
    tempoTiro = atiraMax    
  end  
  --Atualização posição tiros
  for i, proj in ipairs(disparos) do
  proj.y = proj.y -(250 *dt)
  -- Se o dispato sair da tel, eliminar
  if (proj.y <0 ) then
    table.remove(disparos, i)
  end
end
  -- Temporização da distancia de inimigos
  dtAtualInimigo = dtAtualInimigo -(1*dt)
  if(dtAtualInimigo <0) then
    dtAtualInimigo = dtMaxCriaInimigo
    -- Criar uma instancia do inimigo
    posDinamica = math.random(10 + margemInimigo, LG.getWidth() - (10 + margemInimigo))
    nvInimigo = {x = posDinamica, y = -10, img = imgInimigo}
    table.insert(inimigos, nvInimigo)
    
end
  
  --Movimentação dos inimigos
  for i, atual in ipairs(inimigos) do
    atual.y = atual.y + (200 * dt)
    -- Se ele sair abaixo da tela, remover
    if(atual.y > LG.getHeight()) then
      table.remove(inimigos, i)
    end
  end
  
  end

-- Função personalizada para controle de colisão
--Método da Bouding Box (Caixa Continente)
function verColisao(x1, y1, w1, h1, x2, y2, w2, h2)
return(x2 + w2 >= x1 and x2 <= x1 + w1 and y2 + h2 >= y1 and h2 <= y1 + h1)


end