-- Debuger console
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------- VARIABLE GLOBAL -----------------------------------------
local SCREEN_WIDTH  = love.graphics.getWidth();
local SCREEN_HEIGHT = love.graphics.getHeight();

local start = love.timer.getTime();

local compteur = 0; -- Incrémental / permet de savoir quand changer de niveau

----------------------------- ECRAN COURANT ----------------------------------------

ecran_courant = "Menu";

-------------------------- IMAGES ECRANS -------------------------------------------

local imgMenu = love.graphics.newImage("images/Ecrans/MenuScreen.jpg")
local imgPartie = love.graphics.newImage("images/Ecrans/Partie.png")
local imgDeck = love.graphics.newImage("images/Ecrans/Constructeur_deck.png")
local imgVictoire = love.graphics.newImage("images/Ecrans/Victoire.png")
local imgDefaite = love.graphics.newImage("images/Ecrans/Defaite.png")

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
end

function love.update(dt)
  if ecran_courant == "Menu" then
    updateMenu(dt)
  elseif ecran_courant == "Partie" then
    updatePartie(dt)
  elseif ecran_courant == "Deck"then
    updateDeck(dt)
  elseif ecran_courant == "Victoire"then
    updateVictoire(dt)
  elseif ecran_courant == "Defaite"then
    updateDefaite(dt)
  end
end

function love.draw()
  if ecran_courant == "Menu" then
    drawMenu(dt)
  elseif ecran_courant == "Partie" then
    drawPartie(dt)
  elseif ecran_courant == "Deck"then
    drawDeck(dt)
  elseif ecran_courant == "Victoire"then
    drawVictoire(dt)
  elseif ecran_courant == "Defaite"then
    drawDefaite(dt)
  end
end


function updateMenu(dt)
  if love.keyboard.isDown('q') then
    ecran_courant = "Partie"
  end
  
  if love.keyboard.isDown('w') then
    ecran_courant = "Deck"
  end
  
  if love.keyboard.isDown('e') then
    love.event.quit()
  end
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

function updateDeck(dt)
  if love.keyboard.isDown('q') then
    ecran_courant = "Menu"
  end
  
  if love.keyboard.isDown('e') then
    love.event.quit()
  end
end

function updateVictoire(dt)
  if love.keyboard.isDown('q') then
    ecran_courant = "Menu"
  end
  
  if love.keyboard.isDown('e') then
    love.event.quit()
  end
end

function updateDefaite(dt)
  if love.keyboard.isDown('q') then
    ecran_courant = "Menu"
  end
  
  if love.keyboard.isDown('e') then
    love.event.quit()
  end
end

function drawMenu()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgMenu)
  love.graphics.pop()
end

function drawPartie()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgPartie)
  love.graphics.pop()
end

function drawDeck()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgDeck)
  love.graphics.pop()
end

function drawVictoire()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgVictoire)
  love.graphics.pop()
end

function drawDefaite()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)
  love.graphics.draw(imgDefaite)
  love.graphics.pop()
end