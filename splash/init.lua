local splashlib = {
  _VERSION     = "v1.2.0",
  _DESCRIPTION = "a 0.10.1 splash",
  _URL         = "https://github.com/love2d-community/splashes",
  _LICENSE     = [[Copyright (c) 2016 love-community members (as per git commits in repository above)

This software is provided 'as-is', without any express or implied
warranty. In no event will the authors be held liable for any damages
arising from the use of this software.

Permission is granted to anyone to use this software for any purpose,
including commercial applications, and to alter it and redistribute it
freely, subject to the following restrictions:

1. The origin of this software must not be misrepresented; you must not
   claim that you wrote the original software. If you use this software
   in a product, an acknowledgement in the product documentation would be
   appreciated but is not required.
2. Altered source versions must be plainly marked as such, and must not be
   misrepresented as being the original software.
3. This notice may not be removed or altered from any source distribution.

The font used in this splash is "Handy Andy" by www.andrzejgdula.com]]
}

local current_module = (...):gsub("%.init$", "")
local current_folder = current_module:gsub("%.", "/")

local timer = require(current_module .. ".timer")

local colors = {
  bg =     {.42, .75, .89},
  white =  {  1,   1,   1},
  blue =   {.15, .67, .88},
  pink =   {.91, .29,  .6},
  shadow = {0, 0, 0, .33},
}

local konamiCode = {"up", "up", "down", "down", "left", "right", "left", "right"}
local userInput = {}

function splashlib.new(init)
  init = init or {}
  local self = {}
  local width, height = love.graphics.getDimensions()

  self.background = init.background == nil and colors.bg or init.background
  self.delay_before = init.delay_before or 0.1
  self.delay_after = init.delay_after or 2.6

  self.canvas = love.graphics.newCanvas()

  self.elapsed = 0
  self.alpha = 1

  self.text = {
    obj   = love.graphics.newText(love.graphics.newFont(current_folder .. "/handy-andy.otf", 24*(height/600)), "USE IT AT YOUR OWN RISK\n\nThis Port Uses your Steam Data on Non Steam Software\n\nTHIS PORT  IS NOT AFFILIATED WITH PORTMASTER\n\nI (Damian) am not liable for account lost\n\nEnter the Konami Code to continue\n\nup, up down, down, left, right, left, right"),
    alpha = 1
  }

  self.text.width, self.text.height = self.text.obj:getDimensions()

  self.done = false

  self.draw = splashlib.draw
  self.update = splashlib.update
  self.keypressed = splashlib.keypressed
  self.gamepadpressed = splashlib.gamepadpressed

  return self
end

function splashlib:draw()
  local width, height = love.graphics.getDimensions()
  local scale_factor = height / 600  -- Calculate scale factor based on reference height of 600 pixels

  -- Clear background if necessary
  if self.background then
    love.graphics.clear(self.background)
  end

  love.graphics.setColor(1, 1, 1, self.alpha)
  love.graphics.draw(self.canvas, 0, 0)

  -- Draw user agreement text
  love.graphics.setColor(1, 1, 1, self.text.alpha)
  love.graphics.draw(
    self.text.obj,
    (width / 2) - (self.text.width / 2),
    height / 2 - (self.text.height / 2)
  )
end

function splashlib:update(dt)
  timer.update(dt)
  self.elapsed = self.elapsed + dt
end

function splashlib:keypressed(key)
  if self.done then return end
  table.insert(userInput, key)
  if #userInput > #konamiCode then
    table.remove(userInput, 1)
  end

  if #userInput == #konamiCode or self:keypressed("x") then
    local correct = true
    for i = 1, #konamiCode do
      if userInput[i] ~= konamiCode[i] then
        correct = false
        break
      end
    end

    if correct then
      self.done = true
    end
  end
end

function splashlib:gamepadpressed(button)
  local mapping = {
    dpup = "up",
    dpdown = "down",
    dpleft = "left",
    dpright = "right",
    a = "a",
    b = "b"
  }
  if mapping[button] then
    self:keypressed(mapping[button])
  end
end

setmetatable(splashlib, { __call = function(self, ...) return self.new(...) end })

return splashlib