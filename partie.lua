local imgVictoire = love.graphics.newImage("images/Ecrans/Victoire.png")

function drawPartie()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgPartie)
  love.graphics.pop()
end

function updatePartie(dt)
  if love.keyboard.isDown('q') then
    ecran_courant = "Victoire"
  end
  
  if love.keyboard.isDown('w') then
    ecran_courant = "Defaite"
  end
  
  if love.keyboard.isDown('e') then
    love.event.quit()
  end
end