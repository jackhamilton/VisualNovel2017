---------------------------------------------------------------------------------
--
-- menu.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )
local widget = require("widget")

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

local background = display.newImageRect("samplebackground.png", display.contentHeight*2, display.contentWidth*2)
local menuBar = display.newImageRect("menuBar.png", display.contentHeight*2, display.contentWidth*2)

--Function to start the game. Called by startButton.
local function startGame(event)
   composer.gotoScene("game", {effect = "fade", time = 800})
end

--Likewise in all the following functions.
local function exitGame(event)
   native.requestExit()
end

local function loadGame(event)
end

local function options(event)
end
--End of button functions block.

--Note: Make button images to achieve increased size consistency and better fx
local startButton = widget.newButton( {
      id = "start",
      label = "Start",
      fontSize = 60,
      width = 160,
      height = 80,
      onRelease = startGame,
      labelColor = { default = {0,0,0}, over = {255, 255, 255, 0.5}},
})
local loadButton = widget.newButton( {
      id = "load",
      label = "Load",
      fontSize = 60,
      width = 160,
      height = 80,
      onRelease = loadGame,
      labelColor = { default = {0,0,0}, over = {255, 255, 255, 0.5}},
})
local optionsButton = widget.newButton( {
      id = "options",
      label = "Options",
      fontSize = 60,
      width = 160,
      height = 80,
      onRelease = options,
      labelColor = { default = {0,0,0}, over = {255, 255, 255, 0.5}},
})
local exitButton = widget.newButton( {
      id = "exit",
      label = "Exit",
      fontSize = 60,
      width = 160,
      height = 80,
      onRelease = exitGame,
      labelColor = { default = {0,0,0}, over = {255, 255, 255, 0.5}},
})

function scene:create( event )
   local sceneGroup = self.view

   -- Called when the scene's view does not exist
   --
   -- INSERT code here to initialize the scene
   -- e.g. add display objects to 'sceneGroup', add touch listeners, etc

   sceneGroup:insert(background)
   sceneGroup:insert(menuBar)
   sceneGroup:insert(startButton)
   sceneGroup:insert(exitButton)
   sceneGroup:insert(loadButton)
   sceneGroup:insert(optionsButton)

end

function scene:show( event )
   local sceneGroup = self.view
   local phase = event.phase

   if phase == "will" then
      -- Called when the scene is still off screen and is about to move on screen
      background.x = display.contentCenterX
      background.y = display.contentCenterY
      menuBar.x = display.contentCenterX
      menuBar.y = display.contentCenterY
      startButton.x = display.contentCenterX - 275
      startButton.y = display.contentHeight - 176
      loadButton.x = display.contentCenterX - 100
      loadButton.y = display.contentHeight - 176
      optionsButton.x = display.contentCenterX + 110
      optionsButton.y = display.contentHeight - 176
      exitButton.x = display.contentCenterX + 305
      exitButton.y = display.contentHeight - 176

   elseif phase == "did" then
      -- Called when the scene is now on screen
      --
      -- INSERT code here to make the scene come alive
      -- e.g. start timers, begin animation, play audio, etc

      -- we obtain the object by id from the scene's object hierarchy

   end
end

function scene:hide( event )
   local sceneGroup = self.view
   local phase = event.phase

   if event.phase == "will" then
      -- Called when the scene is on screen and is about to move off screen
      --
      -- INSERT code here to pause the scene
      -- e.g. stop timers, stop animation, unload sounds, etc.)
   elseif phase == "did" then
      -- Called when the scene is now off screen
   end
end


function scene:destroy( event )
   local sceneGroup = self.view

   -- Called prior to the removal of scene's "view" (sceneGroup)
   --
   -- INSERT code here to cleanup the scene
   -- e.g. remove display objects, remove touch listeners, save state, etc
   sceneGroup:remove(background)
   sceneGroup:remove(menuBar)
   sceneGroup:remove(startButton)
   sceneGroup:remove(exitButton)
   sceneGroup:remove(loadButton)
   sceneGroup:remove(optionsButton)

end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

---------------------------------------------------------------------------------

return scene
