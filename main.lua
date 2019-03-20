-- Debuger console
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------- VARIABLE GLOBAL -----------------------------------------

local start = love.timer.getTime();
local mouse = {};

----------------------------- ECRAN COURANT ----------------------------------------

ecran_courant = "Menu";

-------------------------- IMAGES ECRANS -------------------------------------------

-- Fond
local imgMenu = love.graphics.newImage("collection/fond/arene.jpg")

-- Image des boutons
local imgBtnJouerN = love.graphics.newImage("menu/Bouton/btnJouerN.png")
local imgBtnJouerA = love.graphics.newImage("menu/Bouton/btnJouerA.png")
local imgBtnDeckN = love.graphics.newImage("menu/Bouton/btnDeckN.png")
local imgBtnDeckA = love.graphics.newImage("menu/Bouton/btnDeckA.png")
local imgBtnExitN = love.graphics.newImage("menu/Bouton/btnExitN.png")
local imgBtnExitA = love.graphics.newImage("menu/Bouton/btnExitA.png")

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
end

function love.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition() 
end

function love.draw()
  drawMenu()
  changeBtn();
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("Mouse Coordinates: " .. mouse.x .. ", " .. mouse.y)
end

function love.mousepressed(mx, my, button)
  if button == 1 then
  -- Vérifie si zone Jouer
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 376 and mouse.y <= 436)) then

    end

  -- Vérifie si zone Collection
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 203 and mouse.y <= 263)) then

    end

  -- Vérifie si zone Quitter
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 30 and mouse.y <= 90)) then

    end
  end
end

function drawMenu()
  love.graphics.draw(imgBtnJouerN, 500, 100, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnDeckN, 500, 300, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnExitN, 500, 500, 0, 0.8, 0.8)
end

function changeBtn()
  -- Vérifie si zone cavalier
  if ((mouse.x >= 560 and mouse.x <= 960) and (mouse.y >= 130 and mouse.y <= 330)) then
    love.graphics.draw(imgBtnJouerA, 500, 100, 0, 0.8, 0.8)
  end
  -- Vérifie si zone catapulte
  if ((mouse.x >= 540 and mouse.x <= 975) and (mouse.y >= 370 and mouse.y <= 500)) then
    love.graphics.draw(imgBtnDeckA, 500, 300, 0, 0.8, 0.8)
  end
  -- Vérifie si zone archer
  if ((mouse.x >= 570 and mouse.x <= 950) and (mouse.y >= 565 and mouse.y <= 680)) then
    love.graphics.draw(imgBtnExitA, 500, 500, 0, 0.8, 0.8)
  end
end