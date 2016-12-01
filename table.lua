--operations with main table

MainTable = class(function(acc)
end)

function MainTable:Init()
  self.t = nil --ID of table
end


 
--clean main table
function MainTable:clearTable()

  for row = self.t:GetSize(self.t.t_id), 1, -1 do
    DeleteRow(self.t.t_id, row)
  end  
  
end

-- SHOW MAIN TABLE

--show main table on screen
function MainTable:showTable()

  self.t:Show()
  
end

--creates main table
function MainTable:createTable(caption)

  -- create instance of table
  local t = QTable.new()
  if not t then
    message("error!", 3)
    return
  else
    --message("table with id = " ..t.t_id .. " created", 1)
  end
  
  t:AddColumn("p_account",    QTABLE_STRING_TYPE, 7) --p_ from primary
  t:AddColumn("p_sec_code",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("p_class_code",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("p_date",    QTABLE_STRING_TYPE, 12)
  t:AddColumn("p_time",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("p_operation",    QTABLE_STRING_TYPE, 5)
  t:AddColumn("p_qty",    QTABLE_DOUBLE_TYPE, 8)
  t:AddColumn("p_price",    QTABLE_DOUBLE_TYPE, 10)
  t:AddColumn("p_value",    QTABLE_DOUBLE_TYPE, 10)
  t:AddColumn("p_comment",    QTABLE_STRING_TYPE, 10)
  
  t:AddColumn("----------",    QTABLE_STRING_TYPE, 10)
  
  t:AddColumn("s_account",    QTABLE_STRING_TYPE, 7) --s_ from secondary
  t:AddColumn("s_sec_code",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("s_class_code",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("s_date",    QTABLE_STRING_TYPE, 12)
  t:AddColumn("s_time",    QTABLE_STRING_TYPE, 10)
  t:AddColumn("s_operation",    QTABLE_STRING_TYPE, 5)
  t:AddColumn("s_qty",    QTABLE_DOUBLE_TYPE, 8)
  t:AddColumn("s_price",    QTABLE_DOUBLE_TYPE, 10)
  t:AddColumn("s_value",    QTABLE_DOUBLE_TYPE, 10)
  t:AddColumn("s_comment",    QTABLE_STRING_TYPE, 10)
  
  
  t:SetCaption(caption)
  
  return t
  
end

function MainTable:createOwnTable(caption)
	local t = self:createTable(caption)
	self.t = t
end



