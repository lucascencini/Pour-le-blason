-- Debuger console
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette ligne permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------- DEPENDANCES ---------------------------------------------

local Carte = require("carte")

-------------------------- VARIABLE GLOBAL -----------------------------------------

local start = love.timer.getTime();

local nbCarte = 0; -- Nombre de carte dans un deck
local nbCarteDeck = 0; -- Nombre de carte dans le deck du joueur
local nbExemplaireMax = 4; -- Nombre max d'exemplaire par carte
local nbCavalier = 0; -- Nombre d'exemplaire de cavalier
local nbLancier = 0; -- Nombre d'exemplaire de lancier
local nbCatapulte = 0; -- Nombre d'exemplaire de catapulte
local nbArcher = 1; -- Nombre d'exemplaire de archer
local nbMassier = 0; -- Nombre d'exemplaire de massier
local mouse = {}

-- Variable des différentes lignes
local ligneCTA;
local ligneCTL;
local ligneAL;
local ligneAM;
local ligneLM;
local ligneLC;
local ligneMC;
local ligneMCT;
local ligneCCT;
local ligneCA;

----------------------------- ECRAN COURANT ----------------------------------------

ecran_courant = "Collection";

-------------------------- IMAGES ECRANS -------------------------------------------

local imgMenu = love.graphics.newImage("collection/fond/arene.jpg")
local imgCatapulte = love.graphics.newImage("collection/Carte/Catapulte.png")
local imgCavalier = love.graphics.newImage("collection/Carte/Cavalier.png")
local imgLancier = love.graphics.newImage("collection/Carte/Lancier.png")
local imgArcher= love.graphics.newImage("collection/Carte/Archer.png")
local imgMassier = love.graphics.newImage("collection/Carte/Massier.png")

local imgFlecheN = love.graphics.newImage("collection/Fond/flecheN.png")
local imgFlecheV = love.graphics.newImage("collection/Fond/flecheV.png")
local imgFlecheR = love.graphics.newImage("collection/Fond/flecheR.png")

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
end

function love.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition() 
  
end

function love.draw()
  drawCollection()
  
  -- Vérifie si zone cavalier
  if ((mouse.x >= 70 and mouse.x <= 270) and (mouse.y >= 250 and mouse.y <= 450)) then
    drawCavalierMode()
  end
  -- Vérifie si zone catapulte
  if ((mouse.x >= 420 and mouse.x <= 620) and (mouse.y >= 30 and mouse.y <= 230)) then
    drawCatapulteMode()
  end
  -- Vérifie si zone archer
  if ((mouse.x >= 750 and mouse.x <= 950) and (mouse.y >= 250 and mouse.y <= 450)) then
    drawArcherMode()
  end
  -- Vérifie si zone massier
  if ((mouse.x >= 180 and mouse.x <= 380) and (mouse.y >= 630 and mouse.y <= 830)) then
    drawMassierMode()
  end
  -- Vérifie si zone lancier
  if ((mouse.x >= 680 and mouse.x <= 880) and (mouse.y >= 630 and mouse.y <= 830)) then
    drawLancierMode()
  end
end

function updateDeck()

end

function drawCollection()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)

  width = imgMenu:getWidth()
  height = imgMenu:getHeight()

  love.graphics.draw(imgMenu, 0, 0, math.rad(0), 2, 2, width / 2, height / 2)
  
  drawListe()
  drawPenta()
  love.graphics.pop()
end

function drawListe()
  -- Draw Liste Deck
  love.graphics.setColor(255,255,0)
  love.graphics.rectangle( "line", 1050, 0, 500, 173)
  love.graphics.rectangle( "line", 1050, 173, 500, 173)
  love.graphics.rectangle( "line", 1050, 346, 500, 173)
  love.graphics.rectangle( "line", 1050, 519, 500, 173)
  love.graphics.rectangle( "line", 1050, 692, 500, 172)
  love.graphics.setColor(255,255,255)
  
  -- Draw button +/-
  
  -- Draw title
  font = love.graphics.newFont(30)
  love.graphics.print("Archer", 1150, 50, 0, 1.5, 1.5)
  love.graphics.print("Catapulte", 1150, 230, 0, 1.5, 1.5)
  love.graphics.print("Cavalier", 1150, 400, 0, 1.5, 1.5)
  love.graphics.print("Massier", 1150, 570, 0, 1.5, 1.5)
  love.graphics.print("Lancier", 1150, 750, 0, 1.5, 1.5)
  
  -- Draw card number
  font = love.graphics.newFont(40)
  love.graphics.setFont(font)    
  love.graphics.print(nbArcher, 1470, 40, 0, 2, 2)
  love.graphics.print(nbCatapulte, 1470, 220, 0, 2, 2)
  love.graphics.print(nbCavalier, 1470, 390, 0, 2, 2)
  love.graphics.print(nbMassier, 1470, 560, 0, 2, 2)
  love.graphics.print(nbLancier, 1470, 740, 0, 2, 2)
end

function drawPenta()
  -- Draw img soldier
  love.graphics.draw(imgCatapulte, 420, 30)
  love.graphics.draw(imgCavalier, 70, 250)
  love.graphics.draw(imgArcher, 750, 250)
  love.graphics.draw(imgMassier, 180, 630)
  love.graphics.draw(imgLancier, 680, 630)

  -- Draw arrow
  ligneCA = love.graphics.draw(imgFlecheN, 750, 400, math.rad(180), 0.5, 0.15)
  ligneCCT = love.graphics.draw(imgFlecheN, 450, 200, math.rad(150), 0.2, 0.2)
  ligneCTA = love.graphics.draw(imgFlecheN, 735, 300, math.rad(-140), 0.2, 0.2)
  ligneCTL = love.graphics.draw(imgFlecheN, 700, 675, math.rad(-120), 0.5, 0.15)
  ligneAL = love.graphics.draw(imgFlecheN, 700, 575, math.rad(-60), 0.2, 0.2)
  ligneAM = love.graphics.draw(imgFlecheN, 315, 560, math.rad(-35), 0.48, 0.2)
  ligneMC = love.graphics.draw(imgFlecheN, 300, 418, math.rad(70), 0.2, 0.2)
  ligneMCT = love.graphics.draw(imgFlecheN, 590, 260, math.rad(120), 0.5, 0.15)
  ligneLM = love.graphics.draw(imgFlecheN, 380, 640, math.rad(0), 0.3, 0.2)
  ligneLC = love.graphics.draw(imgFlecheN, 330, 280, math.rad(35), 0.5, 0.2)
end

function drawCatapulteMode()
  ligneCCT = love.graphics.draw(imgFlecheR, 450, 200, math.rad(150), 0.2, 0.2)
  ligneCTA = love.graphics.draw(imgFlecheV, 735, 300, math.rad(-140), 0.2, 0.2)
  ligneCTL = love.graphics.draw(imgFlecheV, 700, 675, math.rad(-120), 0.5, 0.15)
  ligneMCT = love.graphics.draw(imgFlecheR, 590, 260, math.rad(120), 0.5, 0.15)
end

function drawCavalierMode()
  ligneCA = love.graphics.draw(imgFlecheV, 750, 400, math.rad(180), 0.5, 0.15)
  ligneCCT = love.graphics.draw(imgFlecheV, 450, 200, math.rad(150), 0.2, 0.2)
  ligneMC = love.graphics.draw(imgFlecheR, 300, 418, math.rad(70), 0.2, 0.2)
  ligneLC = love.graphics.draw(imgFlecheR, 330, 280, math.rad(35), 0.5, 0.2)
end

function drawMassierMode()
  ligneAM = love.graphics.draw(imgFlecheR, 315, 560, math.rad(-35), 0.48, 0.2)
  ligneMC = love.graphics.draw(imgFlecheV, 300, 418, math.rad(70), 0.2, 0.2)
  ligneMCT = love.graphics.draw(imgFlecheV, 590, 260, math.rad(120), 0.5, 0.15)
  ligneLM = love.graphics.draw(imgFlecheR, 380, 640, math.rad(0), 0.3, 0.2)
end

function drawArcherMode()
  ligneCA = love.graphics.draw(imgFlecheR, 750, 400, math.rad(180), 0.5, 0.15)
  ligneCTA = love.graphics.draw(imgFlecheR, 735, 300, math.rad(-140), 0.2, 0.2)
  ligneAL = love.graphics.draw(imgFlecheV, 700, 575, math.rad(-60), 0.2, 0.2)
  ligneAM = love.graphics.draw(imgFlecheV, 315, 560, math.rad(-35), 0.48, 0.2)
end

function drawLancierMode()
  ligneLM = love.graphics.draw(imgFlecheV, 380, 640, math.rad(0), 0.3, 0.2)
  ligneLC = love.graphics.draw(imgFlecheV, 330, 280, math.rad(35), 0.5, 0.2)
  ligneCTL = love.graphics.draw(imgFlecheR, 700, 675, math.rad(-120), 0.5, 0.15)
  ligneAL = love.graphics.draw(imgFlecheR, 700, 575, math.rad(-60), 0.2, 0.2)
end