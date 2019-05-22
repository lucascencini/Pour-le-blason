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

----------------------------------------------------------------
---------------------- Variable Menu ---------------------------
----------------------------------------------------------------
local imgBtnJouerN = love.graphics.newImage("menu/Bouton/btnJouerN.png")
local imgBtnJouerA = love.graphics.newImage("menu/Bouton/btnJouerA.png")
local imgBtnDeckN = love.graphics.newImage("menu/Bouton/btnDeckN.png")
local imgBtnDeckA = love.graphics.newImage("menu/Bouton/btnDeckA.png")
local imgBtnExitN = love.graphics.newImage("menu/Bouton/btnExitN.png")
local imgBtnExitA = love.graphics.newImage("menu/Bouton/btnExitA.png")

----------------------------------------------------------------
------------------- Variable Collection ------------------------
----------------------------------------------------------------
-- Variable Deck
local nbCarte = 9; -- Nombre de carte dans un deck
local nbCarteDeck = 0; -- Nombre de carte dans le deck du joueur
local nbExemplaireMax = 4; -- Nombre max d'exemplaire par carte
local nbCavalier = 0; -- Nombre d'exemplaire de cavalier
local nbLancier = 0; -- Nombre d'exemplaire de lancier
local nbCatapulte = 0; -- Nombre d'exemplaire de catapulte
local nbArcher = 0; -- Nombre d'exemplaire de archer
local nbMassier = 0; -- Nombre d'exemplaire de massier

-- Variable Jouer
local imgDrawFight = 0;
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
local nbWinJ2 = 0; -- Nombre de bataille gagner par le j1
local isFinish = 0; -- Etat de la partie
local setBattle = 0; -- Etat de la partie
local quitter = 0;

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

-- Fond
local imgFond = love.graphics.newImage("collection/fond/arene.jpg")
local imgMenu = love.graphics.newImage("menu/fond.png")

-- Image des cartes
local imgCatapulte = love.graphics.newImage("collection/Carte/Catapulte.png")
local imgCavalier = love.graphics.newImage("collection/Carte/Cavalier.png")
local imgLancier = love.graphics.newImage("collection/Carte/Lancier.png")
local imgArcher= love.graphics.newImage("collection/Carte/Archer.png")
local imgMassier = love.graphics.newImage("collection/Carte/Massier.png")

-- Image des fleches
local imgFlecheN = love.graphics.newImage("collection/Fond/flecheN.png")
local imgFlecheV = love.graphics.newImage("collection/Fond/flecheV.png")
local imgFlecheR = love.graphics.newImage("collection/Fond/flecheR.png")

-- Image des boutons
local imgBtnPlusR = love.graphics.newImage("collection/Bouton/plusR.png")
local imgBtnPlus = love.graphics.newImage("collection/Bouton/plus.png")
local imgBtnMoinsR = love.graphics.newImage("collection/Bouton/minusR.png")
local imgBtnMoins = love.graphics.newImage("collection/Bouton/minus.png")
local imgBtnRetour = love.graphics.newImage("collection/Bouton/retour.png")
local imgBtnRetourB = love.graphics.newImage("collection/Bouton/retourB.png")

-- Image écran jouer
local imgDos = love.graphics.newImage("jouer/dos.png")
local imgCroix = love.graphics.newImage("jouer/croix.png")
local imgFight = love.graphics.newImage("jouer/fight.png")
local imgBanniereV = love.graphics.newImage("jouer/banniereV.png")
local imgBanniereR = love.graphics.newImage("jouer/banniereR.png")
local imgDefaite = love.graphics.newImage("jouer/defaite.png")
local imgVictoire = love.graphics.newImage("jouer/victoire.png")
local imgDefaiteFond = love.graphics.newImage("jouer/defaite_fond.png")
local imgVictoireFond = love.graphics.newImage("jouer/victoire_fond.png")

function love.load()
  love.window.setFullscreen(true)
  love.window.setTitle("Pour le Blason")
end

function love.update(dt)
  mouse.x, mouse.y = love.mouse.getPosition()
  if ((ecran_courant == "Jouer") and (setBattle == 0)) then
    setDeck()
    setBattle = 1
  end
end

function love.draw()
  if (ecran_courant == "Menu") then
    drawMenu()
    changeBtn();
  end
  if (ecran_courant == "Collection") then
    drawCollection()
    drawBtnArcher();
    drawBtnCatapulte();
    drawBtnCavalier();
    drawBtnMassier();
    drawBtnLancier();
    changeArrow();
  end
  if (ecran_courant == "Jouer") then
    drawJouer()
    drawBanniere()
    if (isFinish == 1) then
      if (nbWinJ2 == 3) then
        love.graphics.draw(imgDefaiteFond, 0, 0, 0, 0.8);
        love.graphics.draw(imgDefaite, 292, 130);
        quitter = 1;
      else
        love.graphics.draw(imgVictoireFond, 0, 0);
        love.graphics.draw(imgVictoire, 292, 130);
        quitter = 1;
      end
    end
  end
    love.graphics.print("X" .. mouse.x .. "Y" .. mouse.y .. "Deck" .. nbCarteDeck .. "ecran" .. ecran_courant)
end

function love.mousepressed(mx, my, button)
  -- MousePressed Menu
  if ((button == 1) and (ecran_courant == "Menu")) then
    -- Vérifie si zone Jouer
    if ((mouse.x >= 560 and mouse.x <= 960) and (mouse.y >= 130 and mouse.y <= 330) and (nbCarteDeck > 8)) then
      ecran_courant = "Jouer";
    end
    -- Vérifie si zone Deck
    if ((mouse.x >= 540 and mouse.x <= 975) and (mouse.y >= 370 and mouse.y <= 500)) then
      ecran_courant = "Collection";
    end
    -- Vérifie si zone Quitter
    if ((mouse.x >= 570 and mouse.x <= 950) and (mouse.y >= 565 and mouse.y <= 680)) then
      love.event.quit();
    end
  end
  
  -- MousePressed Collection
  if ((button == 1) and (ecran_courant == "Collection")) then
    if ((mouse.x >= 10 and mouse.x <= 140) and (mouse.y >= 730 and mouse.y <= 860)) then
      ecran_courant = "Menu";
    end
    -- Vérifie si zone cavalier
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 376 and mouse.y <= 436) and (nbCavalier < nbExemplaireMax) and (          nbCarteDeck < nbCarte)) then
      nbCavalier = nbCavalier + 1;
      nbCarteDeck = nbCarteDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 436 and mouse.y <= 496) and (nbCavalier > 0)) then
      nbCavalier = nbCavalier - 1;
      nbCarteDeck = nbCarteDeck - 1;
    end
    -- Vérifie si zone catapulte
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 203 and mouse.y <= 263) and (nbCatapulte < nbExemplaireMax) and (         nbCarteDeck < nbCarte)) then
      nbCatapulte = nbCatapulte + 1;
      nbCarteDeck = nbCarteDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 263 and mouse.y <= 323) and (nbCatapulte > 0)) then
      nbCatapulte = nbCatapulte - 1;
      nbCarteDeck = nbCarteDeck - 1;
    end
    -- Vérifie si zone archer
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 30 and mouse.y <= 90) and (nbArcher < nbExemplaireMax) and (nbCarteDeck < nbCarte)) then
      nbArcher = nbArcher + 1;
      nbCarteDeck = nbCarteDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 90 and mouse.y <= 150) and (nbArcher > 0)) then
      nbArcher = nbArcher - 1;
      nbCarteDeck = nbCarteDeck - 1;
    end
    -- Vérifie si zone massier
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 559 and mouse.y <= 619) and (nbMassier < nbExemplaireMax) and (nbCarteDeck < nbCarte)) then
      nbMassier = nbMassier + 1;
      nbCarteDeck = nbCarteDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 619 and mouse.y <= 679) and (nbMassier > 0)) then
      nbMassier = nbMassier - 1;
      nbCarteDeck = nbCarteDeck - 1;
    end
    -- Vérifie si zone lancier
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 722 and mouse.y <= 782) and (nbLancier < nbExemplaireMax) and (nbCarteDeck < nbCarte)) then
      nbLancier = nbLancier + 1;
      nbCarteDeck = nbCarteDeck + 1;
    end
    if ((mouse.x >= 1070 and mouse.x <= 1130) and (mouse.y >= 782 and mouse.y <= 842) and (nbLancier > 0)) then
      nbLancier = nbLancier - 1;
      nbCarteDeck = nbCarteDeck - 1;
    end
  end
  
  -- MousePressed Jouer
  if ((button == 1) and (ecran_courant == "Jouer")) then
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
    if ((mouse.x >= 0 and mouse.x <= 1600) and (mouse.y >= 0 and mouse.y <= 900) and (quitter == 1) ) then
      imgDrawFight = 0;
      deckBotIsSet = 0;
      nbCavalierBot = 0; 
      nbLancierBot = 0; 
      nbCatapulteBot = 0; 
      nbArcherBot = 0; 
      nbMassierBot = 0; 

      nbCavalierInGame = 0; 
      nbLancierInGame = 0; 
      nbCatapulteInGame = 0; 
      nbArcherInGame = 0; 
      nbMassierInGame = 0; 

      carteJ1 = 0;
      carteJ2 = 0;

      nbWinJ1 = 0; 
      nbWinJ2 = 0; 
      isFinish = 0; 
      setBattle = 0; 
      quitter = 0;
      ecran_courant = "Menu";
    end
  end  
end


----------------------------------------------------------------
---------------------- Function Menu ---------------------------
----------------------------------------------------------------
function drawMenu()
  love.graphics.draw(imgMenu, 0, 0);
  love.graphics.draw(imgBtnJouerN, 500, 100, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnDeckN, 500, 300, 0, 0.8, 0.8)
  love.graphics.draw(imgBtnExitN, 500, 500, 0, 0.8, 0.8)
end

function changeBtn()
  -- Vérifie si zone Jouer
  if ((mouse.x >= 560 and mouse.x <= 960) and (mouse.y >= 130 and mouse.y <= 330)) then
    love.graphics.draw(imgBtnJouerA, 500, 100, 0, 0.8, 0.8)
  end
  -- Vérifie si zone Deck
  if ((mouse.x >= 540 and mouse.x <= 975) and (mouse.y >= 370 and mouse.y <= 500)) then
    love.graphics.draw(imgBtnDeckA, 500, 300, 0, 0.8, 0.8)
  end
  -- Vérifie si zone Quitter
  if ((mouse.x >= 570 and mouse.x <= 950) and (mouse.y >= 565 and mouse.y <= 680)) then
    love.graphics.draw(imgBtnExitA, 500, 500, 0, 0.8, 0.8)
  end
end

----------------------------------------------------------------
------------------- Function Collection ------------------------
----------------------------------------------------------------

function changeArrow()
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
  
  -- Vérifie si zone retour
  if ((mouse.x >= 10 and mouse.x <= 140) and (mouse.y >= 730 and mouse.y <= 860)) then
    love.graphics.draw(imgBtnRetourB, 10, 730, 0, 0.2);
  end
end

function drawCollection()
  -- On sauvegarde les paramètres d'affichage
  love.graphics.push()
  -- On double les pixels
  love.graphics.scale(1,1)

  width = imgMenu:getWidth()
  height = imgMenu:getHeight()

  love.graphics.draw(imgFond, 0, 0, math.rad(0), 2, 2, width / 2, height / 2)
  
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
  drawBtnCatapulte();
  drawBtnCavalier();
  drawBtnMassier();
  drawBtnLancier();
  love.graphics.draw(imgBtnRetour, 10, 730, 0, 0.2)
  
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

function drawBtnCatapulte()
    if (nbCarteDeck == nbCarte) then
    love.graphics.draw(imgBtnPlus, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  elseif (nbCatapulte == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoins, 1070, 263, 0, 0.5)
  elseif (nbCatapulte == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 203, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 263, 0, 0.5)
  end
end

function drawBtnArcher()
  if (nbCarteDeck == nbCarte) then
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
  if (nbCarteDeck == nbCarte) then
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
  if (nbCarteDeck == nbCarte) then
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

function drawBtnLancier()
  if (nbCarteDeck == nbCarte) then
    love.graphics.draw(imgBtnPlus, 1070, 722, 0, 0.5)
    love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  elseif (nbLancier == 0) then
    love.graphics.draw(imgBtnPlusR, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoins, 1070, 782, 0, 0.5)
  elseif (nbLancier == 4) then
    love.graphics.draw(imgBtnPlus, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  else 
    love.graphics.draw(imgBtnPlusR, 1070, 722, 0, 0.5)
  love.graphics.draw(imgBtnMoinsR, 1070, 782, 0, 0.5)
  end
end

----------------------------------------------------------------
---------------------- Function Jouer --------------------------
----------------------------------------------------------------
function setDeck()
  nbCavalierInGame = nbCavalier;
  nbArcherInGame = nbArcher;
  nbCatapulteInGame = nbCatapulte;
  nbLancierInGame = nbLancier;
  nbMassierInGame = nbMassier;
  
  if (deckBotIsSet == 0) then
    carteInDeck = 0;
    while carteInDeck < 10  do
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
  love.graphics.draw(imgFond, 0, 0, math.rad(0), 2, 2, width / 2, height / 2)
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