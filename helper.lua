Helper = class(function(acc)
end)

function Helper:Init()
  
end

--возвращает дату сделки в строковом формате '06.11.2016'
function Helper:get_trade_date(trade)

  local z = ''
  
  local day = ''
  
  if trade.datetime.day<10 then 
    z = '0' 
  else
    z = ''
  end
  day = z..tostring(trade.datetime.day)
   
  local month = ''
  
  if trade.datetime.month<10 then 
    z = '0' 
  else
    z = ''
  end
  month = z..tostring(trade.datetime.month)

  return day..'.'..month..'.'..tostring(trade.datetime.year)
end

--возвращает дату сделки в строковом формате SQL '2016-11-06' (для правильной сортировки в таблицах)
function Helper:get_trade_date_sql(trade)

  local z = ''
  
  local day = ''
  
  if trade.datetime.day<10 then 
    z = '0' 
  else
    z = ''
  end
  day = z..tostring(trade.datetime.day)
   
  local month = ''
  
  if trade.datetime.month<10 then 
    z = '0' 
  else
    z = ''
  end
  month = z..tostring(trade.datetime.month)

  return tostring(trade.datetime.year)..'-'..month..'-'..day
end

--возвращает время сделки в строковом формате '10:26:13'
function Helper:get_trade_time(trade)
  
  local z = ''
  
  local hour = ''
  
  if trade.datetime.hour<10 then 
    z = '0' 
  else
    z = ''
  end
  hour = z..tostring(trade.datetime.hour)
   
  local min = ''
  
  if trade.datetime.min<10 then 
    z = '0' 
  else
    z = ''
  end
  min = z..tostring(trade.datetime.min)

  local sec = ''
  
  if trade.datetime.sec<10 then 
    z = '0' 
  else
    z = ''
  end
  sec = z..tostring(trade.datetime.sec)
  
  return hour..':'..min..':'..sec
end



--обертка, чтобы с гарантией получить число
function Helper:getQtyClose(t,row)
  local res = false
  local val = nil
  res, val = check_nil(t, row, 'qtyClose')
  if res == true then
	return 0
  end
  return val  
end

--обертка, чтобы с гарантией получить число
function Helper:getQuantity(t,row)
  local res = false
  local val = nil
  res, val = check_nil(t, row, 'quantity')
  if res == true then
	return 0
  end
  return val  
end

--обертка, чтобы с гарантией получить число
--параметры
--	t - in - таблица робота
--	row - in - number - номер строки таблицы
function Helper:getPriceClose(t,row)
  local res = false
  local val = nil
  res, val = check_nil(t, row, 'priceClose')
  if res == true then
	return 0
  end
  return val  
end

--обертка, чтобы с гарантией получить число
function Helper:getPriceOpen(t,row)
  local res = false
  local val = nil
  res, val = check_nil(t, row, 'priceOpen')
  if res == true then
	return 0
  end
  return val
end

function check_nil(t, row, column)
  if t == nil then
	return true, nil
  end
  local cell = t:GetValue(row, column)
  if cell == nil then
    return true, nil
  end
  local val = tonumber(cell.image)
  if val == nil then
    return true, nil
  end
  return false, val
end



--записывает текст запроса в файл. нужна для отладки
function Helper:save_sql_to_file(sql, filename)
   -- Пытается открыть файл в режиме "чтения/записи"
   f = io.open(getScriptPath().."\\"..filename,"r+");
   -- Если файл не существует
   if f == nil then 
      -- Создает файл в режиме "записи"
      f = io.open(getScriptPath().."\\"..filename,"w"); 
      -- Закрывает файл
      --f:close();
      -- Открывает уже существующий файл в режиме "чтения/записи"
      --f = io.open(getScriptPath().."\\sql.txt","r+");
   end;
   -- Записывает в файл 2 строки
   --f:write("Line1\nLine2"); -- "\n" признак конца строки
   
   f:write(sql); -- "\n" признак конца строки
   
   
   -- Сохраняет изменения в файле
   f:flush();
   -- Встает в начало файла 
      -- 1-ым параметром задается относительно чего будет смещение: "set" - начало, "cur" - текущая позиция, "end" - конец файла
      -- 2-ым параметром задается смещение
   --f:seek("set",0);
   -- Перебирает строки файла, выводит их содержимое в сообщениях
   --for line in f:lines() do message(tostring(line));end
   -- Закрывает файл
   f:close();
end



--функция возвращает true, если бит [index] установлен в 1 (взято из примеров some_callbacks.lua)
--пример вызова для определения направления
--if bit_set(flags, 2) then
--		t["sell"]=1
--	else
--		t["buy"] = 1
--	end
--
function Helper:bit_set( flags, index )
  local n=1
  n=bit.lshift(1, index)
  if bit.band(flags, n) ~=0 then
    return true
  else
    return false
  end
end

--выполняет округление с заданной точностью
--math.round(3.27893, 2) -- должно вернуть 3.28
function Helper:math_round(num, idp)
  local mult = 10^(idp or 0)
  return math.floor(num * mult + 0.5) / mult
end
 



--возвращает цену для колонки "Цена закрытия"
--Параметры
--  par_t - in - table - т.к. может быть открыта не только основная таблица, а еще таблица деталей, то пришлось добавить параметр
--  row - вх - число - номер строки в таблице робота
function Helper:get_priceClose(par_t, row)

  local priceClose = 0
  local class_code = par_t:GetValue(row,'classCode').image
  local sec_code = par_t:GetValue(row,'secCode').image
  
  if par_t:GetValue(row,'operation').image == 'buy' then
    priceClose = getParamEx (class_code, sec_code, 'bid').param_value
    
  elseif par_t:GetValue(row,'operation').image == 'sell' then
    priceClose = getParamEx (class_code, sec_code, 'offer').param_value
    
  end

  --после завершения торгов биды и офферы будут равны нулю, поэтому берем last
  if priceClose == nil or priceClose == 0 then
    priceClose = getParamEx (class_code, sec_code, 'last').param_value
  end
  --если нет last, попробуем получить close
  if priceClose == nil or priceClose == 0 then
    priceClose = getParamEx (class_code, sec_code, 'close').param_value
  end

  --округление
  --priceClose = math.ceil(priceClose*10000)/10000
  priceClose = self:math_round(priceClose, 4)
  
  return priceClose

end


--вычисляет количество дней между датами. пока без учета високосных лет
--Параметры
--	startDate- вх - дата - формат даты: 2016-05-28 (т.к. как в SQL)
function Helper:days_in_position(startDate, endDate)

	local y1 = tonumber(string.sub(startDate,1,4))
	local m1 = tonumber(string.sub(startDate,6,7))
	local d1 = tonumber(string.sub(startDate,9,10))

	local y2 = tonumber(string.sub(endDate,1,4))
	local m2 = tonumber(string.sub(endDate,6,7))
	local d2 = tonumber(string.sub(endDate,9,10))

	
	
	--http://bot4sale.ru/blog-menu/qlua/spisok-statej/368-lua-time.html
	
	datetime1 = { year = y1,
                   month = m1,
                   day = d1
                  }

	seconds1 = os.time(datetime1)
	--message(tostring(seconds1))	
	
	datetime2 = { year = y2,
                   month = m2,
                   day = d2
                  }

	seconds2 = os.time(datetime2)
	
	--message(tostring(  (seconds2-seconds1)/86400  ))
	
	if seconds1==nil or seconds2==nil then 
	return 0
	end
	
	return (tonumber(seconds2)-tonumber(seconds1))/86400
	
end

--определим направление сделки
function Helper:what_is_the_direction(trade)
    if self:bit_set(trade.flags, 2) then
      return 'sell'
    else
      return 'buy'
    end
end

--checks whether deal is processed with FIFO or not
--Params:
--  num - deal number (micex)
--Returns
--  "true" if deal is not processed with FIFO
function Helper:deal_is_not_processed(num, processedDeals)
  for key, value in pairs(processedDeals) do
    --message(key)
    --message(value)
    if value == num then
      --if deal is in the table then it was processed. ret false
      return false
    end
  end
  --add deal number into the table
  table.insert(processedDeals, num)
  
  return true
end

--вытаскивает комментарий из сделки, без служебного префикса
--Параметры
--	brokerref - in - string - комментарий из сделки
function Helper:get_deal_comment(brokerref)
	local comment = ''
	--бывают комменты вроде этого "72995FX/", именно этот пишется самим брокером на валютном рынке при простой покупке
	local j = string.find(brokerref, '/')
	if j ~= nil then
		--если следом идет еще один слэш, то после него будет коммент
		if string.sub(brokerref, j+1, j+1)=='/' then
			comment = string.sub(brokerref, j+2)
		else
			--если слэш всего один, то это служебный коммент брокера, он нам не нужен
			--вернем пустую строку
		end
	end
	return comment
end