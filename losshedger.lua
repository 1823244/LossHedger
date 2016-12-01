

--local sqlite3 = require("lsqlite3")
--эта dll нужна дл€ работы с битовыми флагами сделок. там зашито направление buy/sell
local bit = require"bit"

--пример из учебника по QLUA
dofile (getScriptPath() .. "\\quik_table_wrapper.lua")
--классы
dofile (getScriptPath() .. "\\class.lua")
dofile (getScriptPath() .. "\\helper.lua")
dofile (getScriptPath() .. "\\settings.lua")
dofile (getScriptPath() .. "\\table.lua")
dofile (getScriptPath() .. "\\transactions.lua")
dofile (getScriptPath() .. "\\colorize.lua")

-- классы
settings={}
helper={}
maintable={} --maintable.t - главна€ таблица робота
transactions={}
colorizer={}

is_run = true
working = false

--таблица, в которой будем хранить »ƒ сделок, которые уже обработаны в OnTrade()
--проблема в том, что OnTrade() вызываетс€ более одного раза при создании сделки в терминале,
--поэтому надо провер€ть, что мы сделку уже обработали, чтобы не получить дубль в истории.
local processedDeals = {}



--add primary trade to table
--params
--	trade - in - table - trade from OnTrade
function add_prim_trade(trade)
	local row = maintable.t:AddLine()
	maintable.t:SetValue(row, "p_account",    trade.client_code)
	maintable.t:SetValue(row, "p_sec_code",    trade.sec_code)
	maintable.t:SetValue(row, "p_class_code",    trade.class_code)
	maintable.t:SetValue(row, "p_date",    helper:get_trade_date_sql(trade))
	maintable.t:SetValue(row, "p_time",    helper:get_trade_time(trade))
	maintable.t:SetValue(row, "p_operation",    helper:what_is_the_direction(trade))
	maintable.t:SetValue(row, "p_qty",    trade.qty)
	maintable.t:SetValue(row, "p_price",    trade.price)
	maintable.t:SetValue(row, "p_value",    trade.value)
	
	maintable.t:SetValue(row, "p_comment",    helper:get_deal_comment(trade.brokerref))
	
end

--add secondary trade to table
--params
--	trade - in - table - trade from OnTrade
function add_sec_trade(trade)
	local row = maintable.t:AddLine()
	maintable.t:SetValue(row, "s_account",    trade.client_code)
	maintable.t:SetValue(row, "s_sec_code",    trade.sec_code)
	maintable.t:SetValue(row, "s_class_code",    trade.class_code)
	maintable.t:SetValue(row, "s_date",    helper:get_trade_date_sql(trade))
	maintable.t:SetValue(row, "s_time",    helper:get_trade_time(trade))
	maintable.t:SetValue(row, "s_operation",    helper:what_is_the_direction(trade))
	maintable.t:SetValue(row, "s_qty",    trade.qty)
	maintable.t:SetValue(row, "s_price",    trade.price)
	maintable.t:SetValue(row, "s_value",    trade.value)
	maintable.t:SetValue(row, "s_comment",    helper:get_deal_comment(trade.brokerref))
end


-- обработчики событий ----

function OnInit(s)

	helper= Helper()
	helper:Init()
	
	settings= Settings()
	settings:Init()

	maintable= MainTable()
	maintable:Init()
  
	transactions= Transactions()
	transactions:Init()
	
	colorizer= Colorizer()
	Colorizer:Init()

	--create and show table
	maintable:createOwnTable("LOSS HEDGER")
	maintable:showTable()
	
	local row = maintable.t:AddLine()
	maintable.t:SetValue(row, "p_account",    'START')
	maintable.t:SetValue(row, "p_sec_code",    'STOP')
	
	colorizer:colorize_row(maintable.t, 1, working)
end

function DestroyTables()
	is_run = false
	DestroyTable(maintable.t.t_id)
end


function OnStop(s)
  DestroyTables()
  is_run = false
  return 1000
end

function OnTrade(trade)
	
	if working == false then 
		return
	end
	
	
	--проверить, что сделка еще не обработана
	if helper:deal_is_not_processed(trade.trade_num, processedDeals)==true then

		local comment = helper:get_deal_comment(trade.brokerref)
		
		if comment == 'second' then
			add_sec_trade(trade)
		else
		
			--message(trade.trade_num)
			
			add_prim_trade(trade)
			
			local new_oper = ''
			if helper:what_is_the_direction(trade) == 'sell' then
				new_oper = 'B'
			else
				new_oper = 'S'
			end
			local depo = 'NL0011100043'
			
			--get price
			
			
			local minStepPrice = getParamEx(trade.class_code, trade.sec_code, "SEC_PRICE_STEP").param_value + 0
			--local STEPPRICET = getParamEx(trade.class_code, trade.sec_code, "STEPPRICET").param_value + 0
			  if minStepPrice == nil or tonumber(minStepPrice) == 0 then
				message("\208\157\208\181\209\130 \208\188\208\184\208\189\208\184\208\188\208\176\208\187\209\140\208\189\208\190\208\179\208\190 \209\136\208\176\208\179\208\176 \209\134\208\181\208\189\209\139 \208\178 \208\154\208\178\208\184\208\186\208\181. \208\148\208\190\208\177\208\176\208\178\209\140\209\130\208\181 \208\181\208\179\208\190 \208\178 \209\130\208\176\208\177\208\187\208\184\209\134\209\131 \208\184\208\189\209\129\209\130\209\128\209\131\208\188\208\181\208\189\209\130\208\190\208\178", 2)
				return
			  end
			  local lotSize = getParamEx(trade.class_code, trade.sec_code, "LOTSIZE").param_value + 0
			  if lotSize == nil or tonumber(lotSize) == 0 then
				message("\208\157\208\181\209\130 \209\128\208\176\208\183\208\188\208\181\209\128\208\176 \208\187\208\190\209\130\208\176 \208\178 \208\154\208\178\208\184\208\186\208\181. \208\148\208\190\208\177\208\176\208\178\209\140\209\130\208\181 \208\181\208\179\208\190 \208\178 \209\130\208\176\208\177\208\187\208\184\209\134\209\131 \208\184\208\189\209\129\209\130\209\128\209\131\208\188\208\181\208\189\209\130\208\190\208\178", 2)
				return
			  end
			  
			  local last = getParamEx(trade.class_code, trade.sec_code, "LAST").param_value + 0
			  --message(last)
			
			local price = 0
			if new_oper == 'B' then
				price = tonumber(last) + 60 * minStepPrice
			else
				price = tonumber(last) - 60 * minStepPrice
			end
			transactions:order(trade.sec_code, trade.class_code, new_oper, trade.client_code, depo, price, trade.qty*2, 'second')
			
		end
		
		
		
	end

end

-- +----------------------------------------------------+
--                  MAIN
-- +----------------------------------------------------+

-- функци€ обратного вызова дл€ обработки событий в таблице. вызываетс€ из main()
--(или, другими словами, обработчик клика по таблице робота)
--параметры:
--  t_id - хэндл таблицы, полученный функцией AllocTable()
--  msg - тип событи€, происшедшего в таблице
--  par1 и par2 Ц значени€ параметров определ€ютс€ типом сообщени€ msg, 
--
--функци€ должна располагатьс€ перед main(), иначе - скрипт не останавливаетс€ при закрытии окна
local f_cb = function( t_id,  msg,  par1, par2)
  
  if (msg==QTABLE_CLOSE)  then
    DestroyTables()
    is_run = false
  end
  
  --обработка клика
	--QLUA GetCell
	--‘ункци€ возвращает таблицу, содержащую данные из €чейки в строке с ключом Ђkeyї, кодом колонки Ђcodeї в таблице Ђt_idї. 
	--‘ормат вызова: 
	--TABLE GetCell(NUMBER t_id, NUMBER key, NUMBER code)
	--ѕараметры таблицы: 
	--image Ц строковое представление значени€ в €чейке, 
	--value Ц числовое значение €чейки.
	--≈сли входные параметры были заданы ошибочно, то возвращаетс€ Ђnilї.  
	
	--при этом par1 содержит номер строки, par2 Ц номер колонки, 

	x=GetCell(maintable.t.t_id, par1, par2) 
  
	if (msg==QTABLE_LBUTTONDBLCLK) then
		--message(x["image"]) --текст €чейки
		--message("QTABLE_LBUTTONDBLCLK")
		if x["image"] == 'START' then
			if working == false then
				working = true
			end
		end
		if x["image"] == 'STOP' then
			if working == true then
				working = false
			end
		end
		
		colorizer:colorize_row(maintable.t, 1, working)
		
	elseif msg==QTABLE_VKEY then
		--message(par2)
		if par2 == 27 then
			DestroyTables()
		end
	end  

end 


-- основна€ функци€ робота. здесь обновл€етс€ котировка и рассчитываетс€ прибыль
function main()

  --установим обработчик событий таблицы робота
  SetTableNotificationCallback (maintable.t.t_id, f_cb)
  
  while is_run do  
    sleep(50)
  end
  
end
