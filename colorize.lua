settings = {}

Colorizer = class(function(acc)
end)

function Colorizer:Init()

  settings= Settings()
  settings:Init()
  
end

--this function colorize row in main table for dark theme of QUIK
function Colorizer:colorize_row_dark_theme(t, row, working)
  
  local b_color = RGB(27, 27, 27)         --background color
  local sel_b_color = RGB(30, 30, 30)     --background color in selected row
  
  if working == true then
    --b_color = RGB(30, 30, 30)  --green 
    f_color     = RGB(110, 180, 110)      --font color in unselected row
    sel_f_color = RGB(110, 180, 110)      --font color in selected row
  else
    --b_color = RGB(20, 20, 20)  --red 
    f_color     = RGB(230, 100, 100)
    sel_f_color = RGB(230, 100, 100) 
  end
  
  SetColor(t.t_id, row, QTABLE_NO_INDEX, b_color, f_color, sel_b_color, sel_f_color)
  
end

--this function colorize row in main table for light theme QUIK
function Colorizer:colorize_row_light_theme(t, row, working)
  
  local f_color = 0
  local sel_b_color = RGB(255, 255, 255)    --background color in selected row
  local sel_f_color = RGB(0, 0, 0)          --font color in selected row

  if working == true then
    b_color = RGB(230, 255, 230)  --green
  else
    b_color = RGB(255, 230, 230)  --red
  end
  
  SetColor(t.t_id, row, QTABLE_NO_INDEX, b_color, f_color, sel_b_color, sel_f_color)
  
end

--this function colorize row in main table
--Params
--  t - in - main table of robot
--  row - in - number - number of row in main table

function Colorizer:colorize_row(t, row, working)

	if settings.dark_theme then
		self:colorize_row_dark_theme(t, row, working)
	else
		self:colorize_row_light_theme(t, row, working)
	end
	
end
