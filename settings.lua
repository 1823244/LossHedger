Settings = class(function(acc)
end)
function Settings:Init()

	self.dark_theme = true
	
	--SPOT client
	self.main_client_code = '11154'
	self.secondary_client_code = '11154'
	
	--FORTS client
	self.main_client_code = '43391M3'
	self.secondary_client_code = '45582G7'

	--SPOT depo --окно ввода заявки на споте, поле Торговый счет (вверху посередине)
	self.main_depo_account = 'L01-00000F00'	--for MMVB		--example: 'NL0011100043' 
	self.secondary_depo_account = 'L01-00000F00'

	--FORTS depo --окно ввода заявки на споте, поле Торговый счет (вверху посередине)
	self.main_forts_account = ''
	self.secondary_forts_account = ''
	
	--SELT (CETS) depo --окно ввода заявки на споте, поле Торговый счет (вверху посередине)
	self.main_selt_account = 'MB0139600999'
	self.secondary_selt_account = 'MB0139600999'
	

end