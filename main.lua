-- Debuger console
io.stdout:setvbuf('no')

-- Empèche Love de filtrer les contours des images quand elles sont redimentionnées
-- Indispensable pour du pixel art
love.graphics.setDefaultFilter("nearest")

-- Cette line permet de déboguer pas à pas dans ZeroBraneStudio
if arg[#arg] == "-debug" then require("mobdebug").start() end

-------------------------- VARIABLE GLOBAL -----------------------------------------
local start = love.timer.getTime();
local mouse = {};

----------------------------- ECRAN COURANT ----------------------------------------
current_screen = "Menu";

----------------------------------------------------------------
---------------------- Variable Menu ---------------------------
----------------------------------------------------------------
local imgBtnPlayN = love.graphics.newImage("menu/Button/btnPlayN.png")
local imgBtnPlayA = love.graphics.newImage("menu/Button/btnPlayA.png")
local imgBtnDeckN = love.graphics.newImage("menu/Button/btnDeckN.png")
local imgBtnDeckA = love.graphics.newImage("menu/Button/btnDeckA.png")
local imgBtnExitN = love.graphics.newImage("menu/Button/btnExitN.png")
local imgBtnExitA = love.graphics.newImage("menu/Button/btnExitA.png")

----------------------------------------------------------------
------------------- Variable Deck ------------------------
----------------------------------------------------------------
-- Variable Deck
local nbCard = 9; -- Nombre de Card dans un deck
local nbCardDeck = 0; -- Nombre de Card dans le deck du joueur
local nbCopyMax = 4; -- Nombre max d'exemplaire par Card
local nbCavalier = 0; -- Nombre d'exemplaire de cavalier
local nbLancer = 0; -- Nombre d'exemplaire de Lancer
local nbCatapult = 0; -- Nombre d'exemplaire de Catapult
local nbArcher = 0; -- Nombre d'exemplaire de archer
local nbMassier = 0; -- Nombre d'exemplaire de massier

-- Variable Play
local imgDrawFight = 0;
local deckBotIsSet = 0;
local nbCavalierBot = 0; -- Nombre d'exemplaire de cavalier du bot
local nbLancerBot = 0; -- Nombre d'exemplaire de Lancer du bot
local nbCatapultBot = 0; -- Nombre d'exemplaire de Catapult du bot
local nbArcherBot = 0; -- Nombre d'exemplaire de archer du bot
local nbMassierBot = 0; -- Nombre d'exemplaire de massier du bot

local nbCavalierInGame = 0; -- Nombre d'exemplaire de cavalier
local nbLancerInGame = 0; -- Nombre d'exemplaire de Lancer
local nbCatapultInGame = 0; -- Nombre d'exemplaire de Catapult
local nbArcherInGame = 0; -- Nombre d'exemplaire de archer
local nbMassierInGame = 0; -- Nombre d'exemplaire de massier

local cardJ1; -- Card Play par le j1
local cardJ2; -- Card Play par le j2

local nbWinJ1 = 0; -- Nombre de bataille gagner par le j1
local nbWinJ2 = 0; -- Nombre de bataille gagner par le j1
local isFinish = 0; -- Etat de la partie
local setBattle = 0; -- Etat de la partie
local exit = 0;

-- Variable des différentes lines
local lineCTA;
local lineCTL;
local lineAL;
local lineAM;
local lineLM;
local lineLC;
local lineMC;
local lineMCT;
local lineCCT;
local lineCA;

-- Background
local imgBackground = love.graphics.newImage("Deck/Background/arena.jpg")
local imgMenu = love.graphics.newImage("menu/Background.png")

-- Image des Cards
local imgCatapult = love.graphics.newImage("Deck/Card/Catapult.png")
local imgCavalier = love.graphics.newImage("Deck/Card/Cavalier.png")
local imgLancer = love.graphics.newImage("Deck/Card/Lancer.png")
local imgArcher= love.graphics.newImage("Deck/Card/Archer.png")
local imgMassier = love.graphics.newImage("Deck/Card/Massier.png")

-- Image des Arrows
local imgArrowN = love.graphics.newImage("Deck/Background/ArrowN.png")
local imgArrowV = love.graphics.newImage("Deck/Background/ArrowV.png")
local imgArrowR = love.graphics.newImage("Deck/Background/ArrowR.png")

-- Image des Buttons
local imgBtnPlusR = love.graphics.newImage("Deck/Button/plusR.png")
local imgBtnPlus = love.graphics.newImage("Deck/Button/plus.png")
local imgBtnMoinsR = love.graphics.newImage("Deck/Button/minusR.png")
local imgBtnMoins = love.graphics.newImage("Deck/Button/minus.png")
local imgBtnback = love.graphics.newImage("Deck/Button/back.png")
local imgBtnbackB = love.graphics.newImage("Deck/Button/backB.png")

-- Image écran Play
local imgBack = love.graphics.newImage("Play/Back.png")
local imgCross = love.graphics.newImage("Play/Cross.png")
local imgFight = love.graphics.newImage("Play/fight.png")
local imgBannerV = love.graphics.newImage("Play/BannerV.png")
local imgBannerR = love.graphics.newImage("Play/BannerR.png")
local imgLose = love.graphics.newImage("Play/Lose.png")
local imgWin = love.graphics.newImage("Play/Win.png")
local imgLoseBackground = love.graphics.newImage("Play/Lose_background.png")
local imgWinBackground = love.graphics.newImage("Play/Win_background.png")

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
end

function love.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition()
  if ((current_screen == "Play") and (setBattle == 0)) then
    setDeck()
    setBattle = 1
  end
end

function love.draw()
  if (current_screen == "Menu") then
    drawMenu()
    changeBtn();
  end
  if (current_screen == "Deck") then
    drawDeck()
    drawBtnArcher();
    drawBtnCatapult();
    drawBtnCavalier();
    drawBtnMassier();
    drawBtnLancer();
    changeArrow();
  end
  if (current_screen == "Play") then
    drawPlay()
    drawBanner()
    if (isFinish == 1) then
      if (nbWinJ2 == 3) then
        love.graphics.draw(imgLoseBackground, 0, 0, 0, 0.8);
        love.graphics.draw(imgLose, 292, 130);
        exit = 1;
      else
        love.graphics.draw(imgWinBackground, 0, 0);
        love.graphics.draw(imgWin, 292, 130);
        exit = 1;
      end
    end
  end
end

function love.mousepressed(mx, my, button)
  -- MousePressed Menu
  if ((button == 1) and (current_screen == "Menu")) then
    -- Vérifie si zone Play
    if ((mouse.x >= 560 and mouse.x <= 960) and (mouse.y >= 130 and mouse.y <= 330) and (nbCardDeck > 8)) then
      current_screen = "Play";
    end
    -- Vérifie si zone Deck
    if ((mouse.x >= 540 and mouse.x <= 975) and (mouse.y >= 370 and mouse.y <= 500)) then
      current_screen = "Deck";
    end
    -- Vérifie si zone exit
    if ((mouse.x >= 570 and mouse.x <= 950) and (mouse.y >= 565 and mouse.y <= 680)) then
      love.event.quit();
    end
  end
  
  -- MousePressed Deck
  if ((button == 1) and (current_screen == "Deck")) then
    if ((mouse.x >= 10 and mouse.x <= 140) and (mouse.y >= 730 and mouse.y <= 860)) then
      current_screen = "Menu";
    end
    -- Vérifie si zone cavalier
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 376 and mouse.y <= 436) and (nbCavalier < nbCopyMax) and (          nbCardDeck < nbCard)) then
      nbCavalier = nbCavalier + 1;
      nbCardDeck = nbCardDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 436 and mouse.y <= 496) and (nbCavalier > 0)) then
      nbCavalier = nbCavalier - 1;
      nbCardDeck = nbCardDeck - 1;
    end
    -- Vérifie si zone Catapult
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 203 and mouse.y <= 263) and (nbCatapult < nbCopyMax) and (         nbCardDeck < nbCard)) then
      nbCatapult = nbCatapult + 1;
      nbCardDeck = nbCardDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 263 and mouse.y <= 323) and (nbCatapult > 0)) then
      nbCatapult = nbCatapult - 1;
      nbCardDeck = nbCardDeck - 1;
    end
    -- Vérifie si zone archer
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 30 and mouse.y <= 90) and (nbArcher < nbCopyMax) and (nbCardDeck < nbCard)) then
      nbArcher = nbArcher + 1;
      nbCardDeck = nbCardDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 90 and mouse.y <= 150) and (nbArcher > 0)) then
      nbArcher = nbArcher - 1;
      nbCardDeck = nbCardDeck - 1;
    end
    -- Vérifie si zone massier
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 559 and mouse.y <= 619) and (nbMassier < nbCopyMax) and (nbCardDeck < nbCard)) then
      nbMassier = nbMassier + 1;
      nbCardDeck = nbCardDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 619 and mouse.y <= 679) and (nbMassier > 0)) then
      nbMassier = nbMassier - 1;
      nbCardDeck = nbCardDeck - 1;
    end
    -- Vérifie si zone Lancer
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 722 and mouse.y <= 782) and (nbLancer < nbCopyMax) and (nbCardDeck < nbCard)) then
      nbLancer = nbLancer + 1;
      nbCardDeck = nbCardDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 782 and mouse.y <= 842) and (nbLancer > 0)) then
      nbLancer = nbLancer - 1;
      nbCardDeck = nbCardDeck - 1;
    end
  end
  
  -- MousePressed Play
  if ((button == 1) and (current_screen == "Play")) then
    -- Clic Catapult
    if ((mouse.x >= 30 and mouse.x <= 230) and (mouse.y >= 650 and mouse.y <= 850) and (nbCatapultInGame > 0)) then
      imgDrawFight = imgCatapult;
      cardJ1 = "CT";
    end
    -- Clic Cavalier
    if ((mouse.x >= 280 and mouse.x <= 480) and (mouse.y >= 650 and mouse.y <= 850) and (nbCavalierInGame > 0)) then
      imgDrawFight = imgCavalier;
      cardJ1 = "C";
    end
    -- Clic Lancer
    if ((mouse.x >= 530 and mouse.x <= 730) and (mouse.y >= 650 and mouse.y <= 850) and (nbLancerInGame > 0)) then
      imgDrawFight = imgLancer;
      cardJ1 = "L";
    end
    -- Clic Archer
    if ((mouse.x >= 780 and mouse.x <= 980) and (mouse.y >= 650 and mouse.y <= 850) and (nbArcherInGame > 0)) then
      imgDrawFight = imgArcher;
      cardJ1 = "A";
    end
    -- Clic Massier
    if ((mouse.x >= 1030 and mouse.x <= 1230) and (mouse.y >= 650 and mouse.y <= 850) and (nbMassierInGame > 0)) then
      imgDrawFight = imgMassier;
      cardJ1 = "M";
    end
    -- Clic Fight
    if ((mouse.x >= 520 and mouse.x <= 720) and (mouse.y >= 200 and mouse.y <= 400) and (imgDrawFight ~= 0)) then
      choixCardBot();
      resultBataille();
    end
    -- Clic Finish
    if ((mouse.x >= 0 and mouse.x <= 1600) and (mouse.y >= 0 and mouse.y <= 900) and (exit == 1) ) then
      imgDrawFight = 0;
      deckBotIsSet = 0;
      nbCavalierBot = 0; 
      nbLancerBot = 0; 
      nbCatapultBot = 0; 
      nbArcherBot = 0; 
      nbMassierBot = 0; 

      nbCavalierInGame = 0; 
      nbLancerInGame = 0; 
      nbCatapultInGame = 0; 
      nbArcherInGame = 0; 
      nbMassierInGame = 0; 

      cardJ1 = 0;
      cardJ2 = 0;

      nbWinJ1 = 0; 
      nbWinJ2 = 0; 
      isFinish = 0; 
      setBattle = 0; 
      exit = 0;
      current_screen = "Menu";
    end
  end  
end


----------------------------------------------------------------
---------------------- Function Menu ---------------------------
----------------------------------------------------------------
function drawMenu()
  love.graphics.draw(imgMenu, 0, 0);
  love.graphics.draw(imgBtnPlayN, 500, 100, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnDeckN, 500, 300, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnExitN, 500, 500, 0, 0.8, 0.8)
end

function changeBtn()
  -- Vérifie si zone Play
  if ((mouse.x >= 560 and mouse.x <= 960) and (mouse.y >= 130 and mouse.y <= 330)) then
    love.graphics.draw(imgBtnPlayA, 500, 100, 0, 0.8, 0.8)
  end
  -- Vérifie si zone Deck
  if ((mouse.x >= 540 and mouse.x <= 975) and (mouse.y >= 370 and mouse.y <= 500)) then
    love.graphics.draw(imgBtnDeckA, 500, 300, 0, 0.8, 0.8)
  end
  -- Vérifie si zone exit
  if ((mouse.x >= 570 and mouse.x <= 950) and (mouse.y >= 565 and mouse.y <= 680)) then
    love.graphics.draw(imgBtnExitA, 500, 500, 0, 0.8, 0.8)
  end
end

----------------------------------------------------------------
------------------- Function Deck ------------------------
----------------------------------------------------------------

function changeArrow()
  -- Vérifie si zone cavalier
  if ((mouse.x >= 70 and mouse.x <= 270) and (mouse.y >= 250 and mouse.y <= 450)) then
    drawCavalierMode()
  end
  -- Vérifie si zone Catapult
  if ((mouse.x >= 420 and mouse.x <= 620) and (mouse.y >= 30 and mouse.y <= 230)) then
    drawCatapultMode()
  end
  -- Vérifie si zone archer
  if ((mouse.x >= 750 and mouse.x <= 950) and (mouse.y >= 250 and mouse.y <= 450)) then
    drawArcherMode()
  end
  -- Vérifie si zone massier
  if ((mouse.x >= 180 and mouse.x <= 380) and (mouse.y >= 630 and mouse.y <= 830)) then
    drawMassierMode()
  end
  -- Vérifie si zone Lancer
  if ((mouse.x >= 680 and mouse.x <= 880) and (mouse.y >= 630 and mouse.y <= 830)) then
    drawLancerMode()
  end
  
  -- Vérifie si zone back
  if ((mouse.x >= 10 and mouse.x <= 140) and (mouse.y >= 730 and mouse.y <= 860)) then
    love.graphics.draw(imgBtnbackB, 10, 730, 0, 0.2);
  end
end

function drawDeck()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)

  width = imgMenu:getWidth()
  height = imgMenu:getHeight()

  love.graphics.draw(imgBackground, 0, 0, math.rad(0), 2, 2, width / 2, height / 2)
  
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
  drawBtnArcher();
  drawBtnCatapult();
  drawBtnCavalier();
  drawBtnMassier();
  drawBtnLancer();
  love.graphics.draw(imgBtnback, 10, 730, 0, 0.2)
  
  -- Draw title
  font = love.graphics.newFont(30)
  love.graphics.print("Archer", 1150, 50, 0, 1.5, 1.5)
  love.graphics.print("Catapult", 1150, 230, 0, 1.5, 1.5)
  love.graphics.print("Cavalier", 1150, 400, 0, 1.5, 1.5)
  love.graphics.print("Massier", 1150, 570, 0, 1.5, 1.5)
  love.graphics.print("Lancer", 1150, 750, 0, 1.5, 1.5)
  
  -- Draw card number
  font = love.graphics.newFont(40)
  love.graphics.setFont(font)    
  love.graphics.print(nbArcher, 1470, 40, 0, 2, 2)
  love.graphics.print(nbCatapult, 1470, 220, 0, 2, 2)
  love.graphics.print(nbCavalier, 1470, 390, 0, 2, 2)
  love.graphics.print(nbMassier, 1470, 560, 0, 2, 2)
  love.graphics.print(nbLancer, 1470, 740, 0, 2, 2)
end

function drawPenta()
  -- Draw img soldier
  love.graphics.draw(imgCatapult, 420, 30)
  love.graphics.draw(imgCavalier, 70, 250)
  love.graphics.draw(imgArcher, 750, 250)
  love.graphics.draw(imgMassier, 180, 630)
  love.graphics.draw(imgLancer, 680, 630)

  -- Draw arrow
  lineCA = love.graphics.draw(imgArrowN, 750, 400, math.rad(180), 0.5, 0.15)
  lineCCT = love.graphics.draw(imgArrowN, 450, 200, math.rad(150), 0.2, 0.2)
  lineCTA = love.graphics.draw(imgArrowN, 735, 300, math.rad(-140), 0.2, 0.2)
  lineCTL = love.graphics.draw(imgArrowN, 700, 675, math.rad(-120), 0.5, 0.15)
  lineAL = love.graphics.draw(imgArrowN, 700, 575, math.rad(-60), 0.2, 0.2)
  lineAM = love.graphics.draw(imgArrowN, 315, 560, math.rad(-35), 0.48, 0.2)
  lineMC = love.graphics.draw(imgArrowN, 300, 418, math.rad(70), 0.2, 0.2)
  lineMCT = love.graphics.draw(imgArrowN, 590, 260, math.rad(120), 0.5, 0.15)
  lineLM = love.graphics.draw(imgArrowN, 380, 640, math.rad(0), 0.3, 0.2)
  lineLC = love.graphics.draw(imgArrowN, 330, 280, math.rad(35), 0.5, 0.2)
end

function drawCatapultMode()
  lineCCT = love.graphics.draw(imgArrowR, 450, 200, math.rad(150), 0.2, 0.2)
  lineCTA = love.graphics.draw(imgArrowV, 735, 300, math.rad(-140), 0.2, 0.2)
  lineCTL = love.graphics.draw(imgArrowV, 700, 675, math.rad(-120), 0.5, 0.15)
  lineMCT = love.graphics.draw(imgArrowR, 590, 260, math.rad(120), 0.5, 0.15)
end

function drawCavalierMode()
  lineCA = love.graphics.draw(imgArrowV, 750, 400, math.rad(180), 0.5, 0.15)
  lineCCT = love.graphics.draw(imgArrowV, 450, 200, math.rad(150), 0.2, 0.2)
  lineMC = love.graphics.draw(imgArrowR, 300, 418, math.rad(70), 0.2, 0.2)
  lineLC = love.graphics.draw(imgArrowR, 330, 280, math.rad(35), 0.5, 0.2)
end

function drawMassierMode()
  lineAM = love.graphics.draw(imgArrowR, 315, 560, math.rad(-35), 0.48, 0.2)
  lineMC = love.graphics.draw(imgArrowV, 300, 418, math.rad(70), 0.2, 0.2)
  lineMCT = love.graphics.draw(imgArrowV, 590, 260, math.rad(120), 0.5, 0.15)
  lineLM = love.graphics.draw(imgArrowR, 380, 640, math.rad(0), 0.3, 0.2)
end

function drawArcherMode()
  lineCA = love.graphics.draw(imgArrowR, 750, 400, math.rad(180), 0.5, 0.15)
  lineCTA = love.graphics.draw(imgArrowR, 735, 300, math.rad(-140), 0.2, 0.2)
  lineAL = love.graphics.draw(imgArrowV, 700, 575, math.rad(-60), 0.2, 0.2)
  lineAM = love.graphics.draw(imgArrowV, 315, 560, math.rad(-35), 0.48, 0.2)
end

function drawLancerMode()
  lineLM = love.graphics.draw(imgArrowV, 380, 640, math.rad(0), 0.3, 0.2)
  lineLC = love.graphics.draw(imgArrowV, 330, 280, math.rad(35), 0.5, 0.2)
  lineCTL = love.graphics.draw(imgArrowR, 700, 675, math.rad(-120), 0.5, 0.15)
  lineAL = love.graphics.draw(imgArrowR, 700, 575, math.rad(-60), 0.2, 0.2)
end

function drawBtnCatapult()
    if (nbCardDeck == nbCard) then
    love.graphics.draw(imgBtnPlus, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  elseif (nbCatapult == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoins, 1070, 263, 0, 0.5)
  elseif (nbCatapult == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  end
end

function drawBtnArcher()
  if (nbCardDeck == nbCard) then
    love.graphics.draw(imgBtnPlus, 1070, 30, 0, 0.5)
     love.graphics.draw(imgBtnMoinsR, 1070, 90, 0, 0.5)
  elseif (nbArcher == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 30, 0, 0.5)
    love.graphics.draw(imgBtnMoins, 1070, 90, 0, 0.5)
  elseif (nbArcher == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 30, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 90, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 30, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 90, 0, 0.5)
  end
  
end

function drawBtnCavalier()
  if (nbCardDeck == nbCard) then
    love.graphics.draw(imgBtnPlus, 1070, 376, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 436, 0, 0.5)
  elseif (nbCavalier == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 376, 0, 0.5)
  love.graphics.draw(imgBtnMoins, 1070, 436, 0, 0.5)
  elseif (nbCavalier == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 376, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 436, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 376, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 436, 0, 0.5)
end
end

function drawBtnMassier()
  if (nbCardDeck == nbCard) then
    love.graphics.draw(imgBtnPlus, 1070, 549, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 609, 0, 0.5)
  elseif (nbMassier == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 549, 0, 0.5)
  love.graphics.draw(imgBtnMoins, 1070, 609, 0, 0.5)
  elseif (nbMassier == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 549, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 609, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 549, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 609, 0, 0.5)
  end
end

function drawBtnLancer()
  if (nbCardDeck == nbCard) then
    love.graphics.draw(imgBtnPlus, 1070, 722, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  elseif (nbLancer == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoins, 1070, 782, 0, 0.5)
  elseif (nbLancer == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  end
end

----------------------------------------------------------------
---------------------- Function Play --------------------------
----------------------------------------------------------------
function setDeck()
  nbCavalierInGame = nbCavalier;
  nbArcherInGame = nbArcher;
  nbCatapultInGame = nbCatapult;
  nbLancerInGame = nbLancer;
  nbMassierInGame = nbMassier;
  
  if (deckBotIsSet == 0) then
    CardInDeck = 0;
    while CardInDeck < 10  do
      rand = math.random(1,5)
      if (rand == 1 and nbCatapultBot < 4) then
        nbCatapultBot = nbCatapultBot + 1
      end
      if (rand == 2 and nbCavalierBot < 4) then
        nbCavalierBot = nbCavalierBot + 1
      end
      if (rand == 3 and nbArcherBot < 4) then
        nbArcherBot = nbArcherBot + 1
      end
      if (rand == 4 and nbLancerBot < 4) then
        nbLancerBot = nbLancerBot + 1
      end
      if (rand == 5 and nbMassierBot < 4) then
        nbMassierBot = nbMassierBot + 1
      end
      CardInDeck = CardInDeck +1;
    end 
    deckBotIsSet = 1;
  end
end

function drawCard()
  if imgDrawFight == 0 then
  else
    love.graphics.draw(imgDrawFight, 310, 395)
    love.graphics.draw(imgFight, 520, 200, 0, 0.2)
  end

  love.graphics.draw(imgBack, 720, 5)
  love.graphics.print(nbCatapultInGame, 130, 600)
  love.graphics.print(nbCavalierInGame, 380, 600)
  love.graphics.print(nbLancerInGame, 630, 600)
  love.graphics.print(nbArcherInGame, 880, 600)
  love.graphics.print(nbMassierInGame, 1130, 600)
  -- Draw Catapult
  if (nbCatapultInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgCatapult, 30, 650)
    love.graphics.draw(imgCross, 30, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgCatapult, 30, 650)
  end
  -- Draw Cavalier
  if (nbCavalierInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgCavalier, 280, 650)
    love.graphics.draw(imgCross, 280, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgCavalier, 280, 650)
  end
  -- Draw Lancer
  if (nbLancerInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgLancer, 530, 650)
    love.graphics.draw(imgCross, 530, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgLancer, 530, 650)
  end
  -- Draw Archer
  if (nbArcherInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgArcher, 780, 650)
    love.graphics.draw(imgCross, 780, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgArcher, 780, 650)
  end
  -- Draw Massier
  if (nbMassierInGame == 0) then
    love.graphics.setColor(128,128,128)
    love.graphics.draw(imgMassier, 1030, 650)
    love.graphics.draw(imgCross, 1030, 650,0 , 0.4)
    love.graphics.setColor(255,255,255)
  else
    love.graphics.draw(imgMassier, 1030, 650)
  end
end

function drawPlay()
  love.graphics.setColor(255,255,0)
  love.graphics.rectangle("line", 1250, 0, 300, 864)
  love.graphics.setColor(255,255,255)
  font = love.graphics.newFont(30)
  love.graphics.setFont(font)
  love.graphics.draw(imgMenu, 0, 0);
  love.graphics.draw(imgBackground, 0, 0, math.rad(0), 2, 2, width / 2, height / 2)
  drawCard()
end

function drawBanner()
  -- Draw Joueur 2
  if (nbWinJ2 == 0) then
    love.graphics.draw(imgBannerR, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 1) then
    love.graphics.draw(imgBannerV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 2) then
    love.graphics.draw(imgBannerV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 235, 0, 0.8);
  end
  if (nbWinJ2 == 3) then
    love.graphics.draw(imgBannerV, 1350, 5, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 115, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 235, 0, 0.8);
  end
  
  -- Draw Joueur 1
  if (nbWinJ1 == 0) then
    love.graphics.draw(imgBannerR, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 1) then
    love.graphics.draw(imgBannerV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 2) then
    love.graphics.draw(imgBannerV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBannerR, 1350, 735, 0, 0.8);
  end
  if (nbWinJ1 == 3) then
    love.graphics.draw(imgBannerV, 1350, 505, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 615, 0, 0.8);
    love.graphics.draw(imgBannerV, 1350, 735, 0, 0.8);
  end
end

function retireCard()
  -- Retire Card j1
  if (cardJ1 == "CT") then
    nbCatapultInGame = nbCatapultInGame - 1
  end
  if (cardJ1 == "C") then
    nbCavalierInGame = nbCavalierInGame - 1
  end
  if (cardJ1 == "M") then
    nbMassierInGame = nbMassierInGame - 1
  end
  if (cardJ1 == "L") then
    nbLancerInGame = nbLancerInGame - 1
  end
  if (cardJ1 == "A") then
    nbArcherInGame = nbArcherInGame - 1
  end
  -- Retire Card j2
  if (cardJ2 == "CT") then
    nbCatapultBot = nbCatapultBot - 1
  end
  if (cardJ2 == "C") then
    nbCavalierBot = nbCavalierBot - 1
  end
  if (cardJ2 == "M") then
    nbMassierBot = nbMassierBot - 1
  end
  if (cardJ2 == "L") then
    nbLancerBot = nbLancerBot - 1
  end
  if (cardJ2 == "A") then
    nbArcherBot = nbArcherBot - 1
  end
end

function combat()
  if (cardJ1 == cardJ2) then
    return 1;
  else
    if (cardJ1 == 'C') then
      if (cardJ2 == 'A' or cardJ2 == 'CT') then
        return 2;
      else
        return 3;
      end
    end
    
    if (cardJ1 == 'CT') then
      if (cardJ2 == 'A' or cardJ2 == 'L') then
        return 2;
      else
        return 3;
      end
    end
    
    if (cardJ1 == 'A') then
      if (cardJ2 == 'M' or cardJ2 == 'L') then
        return 2;
      else
        return 3;
      end
    end
    
    if (cardJ1 == 'L') then
      if (cardJ2 == 'C' or cardJ2 == 'M') then
        return 2;
      else
        return 3;
      end
    end
    
    if (cardJ1 == 'M') then
      if (cardJ2 == 'C' or cardJ2 == 'CT') then
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
      retireCard()
    else
      nbWinJ2 = nbWinJ2 + 1;
      retireCard()
    end
  end

  imgDrawFight = 0;
  cardJ1 = 0;
  cardJ2 = 0;
  if (nbWinJ1 == 3) then
    isFinish = 1;
  end
  if (nbWinJ2 == 3) then
    isFinish = 1;
  end
end

function choixCardBot()
  isCorrect = 0;
  while isCorrect == 0 do
    rand = math.random(1,5)
    if (rand == 1 and nbCatapultBot > 0) then
      cardJ2 = 'CT';
      isCorrect = 1;
    end
    if (rand == 2 and nbCavalierBot > 0) then
      cardJ2 = 'C';
      isCorrect = 1;
    end
    if (rand == 3 and nbArcherBot > 0) then
      cardJ2 = 'A';
      isCorrect = 1;
    end
    if (rand == 4 and nbLancerBot > 0) then
      cardJ2 = 'L';
      isCorrect = 1;
    end
    if (rand == 5 and nbMassierBot > 0) then
      cardJ2 = 'M';
      isCorrect = 1;
    end
  end
end