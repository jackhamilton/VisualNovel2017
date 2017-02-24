---------------------------------------------------------------------------------
--
-- game.lua
--
---------------------------------------------------------------------------------

local sceneName = ...

local composer = require( "composer" )

-- Load scene with same root filename as this file
local scene = composer.newScene( sceneName )

---------------------------------------------------------------------------------

local nextSceneButton

local background = display.newImageRect("samplebackground2.png", display.contentHeight*2, display.contentWidth*2)
local textBox = display.newImageRect("textBox.png", display.contentHeight*2, display.contentWidth*2)
local displayText = display.newText({
      text = "",
      x = display.contentCenterX - 60,
      y = display.contentCenterY + 300,
      width = display.contentWidth*3 - 200,
      fontSize = 42,
      align = "left",
})

local scriptLineNumber = 1;
local currentScript = system.pathForFile("scripts\\main.vns")
local currentScriptLines
local inQuote = false

-- Checks if a file exists
function scriptExists()
   local f = io.open(currentScript)
   if f then
      f:close()
   end
   return f ~= nil
end

-- Read the currentScript into a table called currentScriptLines
function readScript()
   if not scriptExists() then
      return {}
   end
   lines = {}
   for line in io.lines(currentScript) do
      if line ~= nil and line ~= "" then
         lines[#lines + 1] = line
      end
   end
   currentScriptLines = lines
   return lines
end

-- Feeds command lines into processCommand(), then calls readScriptText on the first line containing a quote
-- (escaped or unescaped - if there is a quote, that means it's a script line). Then it terminates.
function nextScriptLine()
   local foundLine = false
   while (not foundLine) do
      if (#currentScriptLines > scriptLineNumber) then
         if (not string.match(currentScriptLines[scriptLineNumber], "\"")) then
            processCommand(currentScriptLines[scriptLineNumber])
            scriptLineNumber = scriptLineNumber + 1
         else
            readScriptText(currentScriptLines[scriptLineNumber], "")
            scriptLineNumber = scriptLineNumber + 1
            foundLine = true
            return true
         end
      else
         foundLine = true
         print("Reached end of script.")
         return false
      end
   end
end

-- TODO: implement the "who's speaking" tags. This should be done by adding
-- characters found while not "inQuote" to a "speaker" string that is displayed
-- elsewhere.

-- Takes the fact that it's been called on [line] as assurance that currentScriptLine points to a script line.
-- It then reads up until a closing quotation is found. Builder is only for recursion purposes, always have
-- it be empty when calling the function manually.
function readScriptText(line, builder)
   -- Account for the fact that quotes can be escaped
   local returnStr = builder
   local skipNext = false
   for i = 1, #line do
      if not skipNext then
         local c = line:sub(i,i)
         -- If the character is a quote and it's not been escaped, flip the inQuote var.
         if (c == "\"" and
             not (i ~= 1 and string.match(line:sub(i-1,i-1), "\\"))) then
            inQuote = not inQuote
         else
            -- Remove the escape character from escaped quotes
            if (c == "\\" and
                not (i + 1 >= #line and string.match(line:sub(i+1,i+1), "\""))) then
               skipNext = true
               returnStr = returnStr .. "\""
            else
               returnStr = returnStr .. c
            end
         end
      else
         skipNext = false;
      end
   end
   if (inQuote) then
      line = currentScriptLines[scriptLineNumber]
      scriptLineNumber = scriptLineNumber + 1
      readScriptText(line, returnStr)
   else
      print(returnStr)
      displayText.text = returnStr
   end
end

--Is fed the command parts of the script. Executes them.
function processCommand(line)

end

--Listener function to trigger next script line.
function callNextScriptLine(event)
   if event.phase == "ended" then
      nextScriptLine()
   end
end

function scene:create( event )
    local sceneGroup = self.view

    -- Called when the scene's view does not exist
    --
    -- INSERT code here to initialize the scene
    -- e.g. add display objects to 'sceneGroup', add touch listeners, etc
    sceneGroup:insert(background)
    sceneGroup:insert(textBox)
    sceneGroup:insert(displayText)

end

function scene:show( event )
    local sceneGroup = self.view
    local phase = event.phase

    if phase == "will" then
       -- Called when the scene is still off screen and is about to move on screen
       background.x = display.contentCenterX
       background.y = display.contentCenterY
       textBox.x = display.contentCenterX
       textBox.y = display.contentCenterY
       currentScriptLines = readScript()
       nextScriptLine()

    elseif phase == "did" then
        -- Called when the scene is now on screen
        --
        -- INSERT code here to make the scene come alive
        -- e.g. start timers, begin animation, play audio, etc

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
    sceneGroup:remove(textBox)
    sceneGroup:remove(background)
    sceneGroup:remove(displayText)
    background:removeEventListener( "touch", callNextScriptLine )
    textBox:removeEventListener( "touch", callNextScriptLine )
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
background:addEventListener( "touch", callNextScriptLine )
textBox:addEventListener( "touch", callNextScriptLine )

---------------------------------------------------------------------------------

return scene
