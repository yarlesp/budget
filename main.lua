-- budget tracker

require "charts"
require "budget"
require "transaction"
require "tag"
require "util"
require "main_window"

function love.load()
  love.window.setMode(1024, 768)
  loveframes = require("loveframes")
  
  -- initial state, choose a budget to load
  loveframes.SetState("choose")
  
  local choose_frame = loveframes.Create("frame")
  choose_frame:SetName("Choose Budget to load")
  choose_frame:SetSize(400, 200)
  choose_frame:SetState("choose")
  choose_frame:SetDraggable(false):ShowCloseButton(false):SetAlwaysOnTop(true):CenterX():CenterY()
  
  local new_budget_input = loveframes.Create("textinput", choose_frame)
  new_budget_input:SetPos(5, 30)
  new_budget_input:SetWidth(100)
  new_budget_input:SetState("choose")
  
  local new_budget_button = loveframes.Create("button", choose_frame)
  new_budget_button:SetText("New Budget")
  new_budget_button:SetPos(110, 30)
  new_budget_button:SetState("choose")
  new_budget_button.OnClick = 
    function()
      main_window.load( budget.new{ name = new_budget_input:GetText(), fixed = {}  } )
    end
  
  -- load old budget
  local load_budget_button = loveframes.Create("button", choose_frame)
  load_budget_button:SetText("Load Budget")
  load_budget_button:SetPos(195, 30)
  load_budget_button:SetState("choose")
  load_budget_button.OnClick = 
    function()
      local b = util.load_table(new_budget_input:GetText())
      main_window.load( budget.new_from_file(b) )
    end
end

function love.update(dt)
  loveframes.update(dt)
end

function love.draw()
  loveframes.draw()
end
 
function love.mousepressed(x, y, button)
  loveframes.mousepressed(x, y, button)
end
 
function love.mousereleased(x, y, button)
  loveframes.mousereleased(x, y, button)
end
 
function love.keypressed(key, unicode)
  loveframes.keypressed(key, unicode)
end
 
function love.keyreleased(key)
  loveframes.keyreleased(key)
end

function love.textinput(text)
   loveframes.textinput(text)
end