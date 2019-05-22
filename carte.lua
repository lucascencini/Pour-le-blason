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

-- Image des cartes
local imgCatapulte = love.graphics.newImage("collection/Carte/Catapulte.png")
local imgCavalier = love.graphics.newImage("collection/Carte/Cavalier.png")
local imgLancier = love.graphics.newImage("collection/Carte/Lancier.png")
local imgArcher= love.graphics.newImage("collection/Carte/Archer.png")
local imgMassier = love.graphics.newImage("collection/Carte/Massier.png")

local imgDos = love.graphics.newImage("jouer/dos.png")
local imgCroix = love.graphics.newImage("jouer/croix.png")
local imgFight = love.graphics.newImage("jouer/fight.png")
local imgBanniereV = love.graphics.newImage("jouer/banniereV.png")
local imgBanniereR = love.graphics.newImage("jouer/banniereR.png")
local imgDefaite = love.graphics.newImage("jouer/defaite.png")
local imgVictoire = love.graphics.newImage("jouer/victoire.png")
local imgDrawFight = 0;

local nbCavalier = 4; -- Nombre d'exemplaire de cavalier
local nbLancier = 0; -- Nombre d'exemplaire de lancier
local nbCatapulte = 2; -- Nombre d'exemplaire de catapulte
local nbArcher = 2; -- Nombre d'exemplaire de archer
local nbMassier = 1; -- Nombre d'exemplaire de massier

local deckBotIsSet = 0;
local nbCavalierBot = 0; -- Nombre d'exemplaire de cavalier du bot
local nbLancierBot = 0; -- Nombre d'exemplaire de lancier du bot
local nbCatapulteBot = 0; -- Nombre d'exemplaire de catapulte du bot
local nbArcherBot = 0; -- Nombre d'exemplaire de archer du bot
local nbMassierBot = 0; -- Nombre d'exemplaire de massier du bot

local nbCavalierInGame = 0; -- Nombre d'exemplaire de cavalier
local nbLancierInGame = 0; -- Nombre d'exemplaire de lancier
local nbCatapulteInGame = 0; -- Nombre d'exemplaire de catapulte
local nbArcherInGame = 0; -- Nombre d'exemplaire de archer
local nbMassierInGame = 0; -- Nombre d'exemplaire de massier

local carteJ1; -- Carte jouer par le j1
local carteJ2; -- Carte jouer par le j2

local nbWinJ1 = 0; -- Nombre de bataille gagner par le j1
local nbWinJ2 = 1; -- Nombre de bataille gagner par le j1
local isFinish = 0; -- Etat de la partie

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
  setDeck()
end

function love.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition() 
end

function love.draw()
  drawJouer()
  drawBanniere()
  love.graphics.setColor(255, 255, 255)
  love.graphics.print("deckBot: [" .. nbCatapulteBot .. "' ".. nbCavalierBot .."' ".. nbArcherBot .."' ".. nbLancierBot .."' ".. nbMassierBot  .."]")
  if (isFinish == 1) then
    if (nbWinJ2 == 3) then
      love.graphics.draw(imgDefaite, 292, 130);
    else
      love.graphics.draw(imgVictoire, 292, 130);
    end
  end
end

function love.mousepressed(mx, my, button)
  -- Clic Catapulte
  if ((mouse.x >= 30 and mouse.x <= 230) and (mouse.y >= 650 and mouse.y <= 850) and (nbCatapulteInGame > 0)) then
      imgDrawFight = imgCatapulte;
      carteJ1 = "CT";
  end
  -- Clic Cavalier
  if ((mouse.x >= 280 and mouse.x <= 480) and (mouse.y >= 650 and mouse.y <= 850) and (nbCavalierInGame > 0)) then
      imgDrawFight = imgCavalier;
      carteJ1 = "C";
  end
  -- Clic Lancier
  if ((mouse.x >= 530 and mouse.x <= 730) and (mouse.y >= 650 and mouse.y <= 850) and (nbLancierInGame > 0)) then
      imgDrawFight = imgLancier;
      carteJ1 = "L";
  end
  -- Clic Archer
  if ((mouse.x >= 780 and mouse.x <= 980) and (mouse.y >= 650 and mouse.y <= 850) and (nbArcherInGame > 0)) then
      imgDrawFight = imgArcher;
      carteJ1 = "A";
  end
  -- Clic Massier
  if ((mouse.x >= 1030 and mouse.x <= 1230) and (mouse.y >= 650 and mouse.y <= 850) and (nbMassierInGame > 0)) then
      imgDrawFight = imgMassier;
      carteJ1 = "M";
  end
  -- Clic Fight
  if ((mouse.x >= 520 and mouse.x <= 720) and (mouse.y >= 200 and mouse.y <= 400) and (imgDrawFight ~= 0)) then
      choixCarteBot();
      resultBataille();
  end
  -- Clic Finish
  if (isFinish == 1) then
    -- change ecran
  end
end

function choixCarteBot()
  isCorrect = 0;
  while isCorrect == 0 do
    rand = math.random(1,5)
    if (rand == 1 and nbCatapulteBot > 0) then
      carteJ2 = 'CT';
      isCorrect = 1;
    end
    if (rand == 2 and nbCavalierBot > 0) then
      carteJ2 = 'C';
      isCorrect = 1;
    end
    if (rand == 3 and nbArcherBot > 0) then
      carteJ2 = 'A';
      isCorrect = 1;
    end
    if (rand == 4 and nbLancierBot > 0) then
      carteJ2 = 'L';
      isCorrect = 1;
    end
    if (rand == 5 and nbMassierBot > 0) then
      carteJ2 = 'M';
      isCorrect = 1;
    end
  end
end

function setDeck()
  nbCavalierInGame = nbCavalier;
  nbArcherInGame = nbArcher;
  nbCatapulteInGame = nbCatapulte;
  nbLancierInGame = nbLancier;
  nbMassierInGame = nbMassier;
  
  if (deckBotIsSet == 0) then
    carteInDeck = 0;
    while carteInDeck < 9  do
      rand = math.random(1,5)
      if (rand == 1 and nbCatapulteBot < 4) then
        nbCatapulteBot = nbCatapulteBot + 1
      end
      if (rand == 2 and nbCavalierBot < 4) then
        nbCavalierBot = nbCavalierBot + 1
      end
      if (rand == 3 and nbArcherBot < 4) then
        nbArcherBot = nbArcherBot + 1
      end
      if (rand == 4 and nbLancierBot < 4) then
        nbLancierBot = nbLancierBot + 1
      end
      if (rand == 5 and nbMassierBot < 4) then
        nbMassierBot = nbMassierBot + 1
      end
      carteInDeck = carteInDeck +1;
    end 
    deckBotIsSet = 1;
  end
end

function drawCarte()
  if imgDrawFight == 0 then
  else
    love.graphics.draw(imgDrawFight, 310, 395)
    love.graphics.draw(imgFight, 520, 200, 0, 0.2)
  end

  love.graphics.draw(imgDos, 720, 5)
  love.graphics.print(nbCatapulteInGame, 130, 600)
  love.graphics.print(nbCavalierInGame, 380, 600)
  love.graphics.print(nbLancierInGame, 630, 600)
  love.graphics.print(nbArcherInGame, 880, 600)
  love.graphics.print(nbMassierInGame, 1130, 600)
  -- Draw Catapulte
  if (nbCatapulteInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgCatapulte, 30, 650)
    love.graphics.draw(imgCroix, 30, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgCatapulte, 30, 650)
  end
  -- Draw Cavalier
  if (nbCavalierInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgCavalier, 280, 650)
    love.graphics.draw(imgCroix, 280, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgCavalier, 280, 650)
  end
  -- Draw Lancier
  if (nbLancierInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgLancier, 530, 650)
    love.graphics.draw(imgCroix, 530, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgLancier, 530, 650)
  end
  -- Draw Archer
  if (nbArcherInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgArcher, 780, 650)
    love.graphics.draw(imgCroix, 780, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgArcher, 780, 650)
  end
  -- Draw Massier
  if (nbMassierInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgMassier, 1030, 650)
    love.graphics.draw(imgCroix, 1030, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgMassier, 1030, 650)
  end
end

function drawJouer()
  love.graphics.setColor(255,255,0)
  love.graphics.rectangle("line", 1250, 0, 300, 864)
  love.graphics.setColor(255,255,255)
  font = love.graphics.newFont(30)
  love.graphics.setFont(font)
  love.graphics.draw(imgMenu, 0, 0);
  drawCarte()
end

function drawBanniere()
  -- Draw Joueur 2
  if (nbWinJ2 == 0) then
    love.graphics.draw(imgBanniereR, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 1) then
    love.graphics.draw(imgBanniereV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 2) then
    love.graphics.draw(imgBanniereV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 3) then
    love.graphics.draw(imgBanniereV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 235, 0, 0.8);
  end
  
  -- Draw Joueur 1
  if (nbWinJ1 == 0) then
    love.graphics.draw(imgBanniereR, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 1) then
    love.graphics.draw(imgBanniereV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 2) then
    love.graphics.draw(imgBanniereV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBanniereR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 3) then
    love.graphics.draw(imgBanniereV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBanniereV, 1350, 735, 0, 0.8);
  end
end

function retireCarte()
  -- Retire carte j1
  if (carteJ1 == "CT") then
    nbCatapulteInGame = nbCatapulteInGame - 1
  end
  if (carteJ1 == "C") then
    nbCavalierInGame = nbCavalierInGame - 1
  end
  if (carteJ1 == "M") then
    nbMassierInGame = nbMassierInGame - 1
  end
  if (carteJ1 == "L") then
    nbLancierInGame = nbLancierInGame - 1
  end
  if (carteJ1 == "A") then
    nbArcherInGame = nbArcherInGame - 1
  end
  -- Retire carte j2
  if (carteJ2 == "CT") then
    nbCatapulteBot = nbCatapulteBot - 1
  end
  if (carteJ2 == "C") then
    nbCavalierBot = nbCavalierBot - 1
  end
  if (carteJ2 == "M") then
    nbMassierBot = nbMassierBot - 1
  end
  if (carteJ2 == "L") then
    nbLancierBot = nbLancierBot - 1
  end
  if (carteJ2 == "A") then
    nbArcherBot = nbArcherBot - 1
  end
end

function combat()
  if (carteJ1 == carteJ2) then
    return 1;
  else
    if (carteJ1 == 'C') then
      if (carteJ2 == 'A' or carteJ2 == 'CT') then
        return 2;
      else
        return 3;
      end
    end
    
    if (carteJ1 == 'CT') then
      if (carteJ2 == 'A' or carteJ2 == 'L') then
        return 2;
      else
        return 3;
      end
    end
    
    if (carteJ1 == 'A') then
      if (carteJ2 == 'M' or carteJ2 == 'L') then
        return 2;
      else
        return 3;
      end
    end
    
    if (carteJ1 == 'L') then
      if (carteJ2 == 'C' or carteJ2 == 'M') then
        return 2;
      else
        return 3;
      end
    end
    
    if (carteJ1 == 'M') then
      if (carteJ2 == 'C' or carteJ2 == 'CT') then
        return 2;
      else
        return 3;
      end
    end
  end
end

function resultBataille()
  result = combat();
  if (result == 1) then
  else
    if (result == 2) then
      nbWinJ1 = nbWinJ1 + 1;
      retireCarte()
    else
      nbWinJ2 = nbWinJ2 + 1;
      retireCarte()
    end
  end

  imgDrawFight = 0;
  carteJ1 = 0;
  carteJ2 = 0;
  if (nbWinJ1 == 3) then
    isFinish = 1;
  end
  if (nbWinJ2 == 3) then
    isFinish = 1;
  end
end