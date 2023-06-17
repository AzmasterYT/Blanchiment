ESX = exports['es_extended']:getSharedObject()

local executionZone = vector3(-53.869312, -1213.192139, 28.666990)

function GetTime()
    local date = os.date('*t')
    if date.day < 10 then date.day = '0' .. tostring(date.day) end
    if date.month < 10 then date.month = '0' .. tostring(date.month) end
    if date.hour < 10 then date.hour = '0' .. tostring(date.hour) end
    if date.min < 10 then date.min = '0' .. tostring(date.min) end
    if date.sec < 10 then date.sec = '0' .. tostring(date.sec) end
    local date = date.day .. "/" .. date.month .. "/" .. date.year .. " - " .. date.hour .. " heures " .. date.min .. " minutes " .. date.sec .. " secondes"
    return date
end

function SendLogs(Color, Title, Description,webhook)
	PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
		 username = Blanchi.Logs.Name, 
		 embeds = {{
			  ["color"] = Color, 
			  ["author"] = {
				["name"] = Blanchi.Logs.Name
			  },
			  ["title"] = Title,
			  ["description"] = "".. Description .."",
			  ["footer"] = {
				   ["text"] = GetTime(),
				   ["icon_url"] = Blanchi.Logs.Logo,
			  },
		 }}, 
		 avatar_url = Blanchi.Logs.Logo
	}), { 
		 ['Content-Type'] = 'application/json' 
	})
end




RegisterNetEvent("ExodeRP:Blanchiment")
AddEventHandler("ExodeRP:Blanchiment",function(ArgentSale, Argent)
	local _src = source
	local xPlayers = ESX.GetPlayerFromId(_src)
	local PlayerPed = GetPlayerPed(_src)
	Taxe = Blanchi.Pourcent.Pourcentage


	local playerPosition = GetEntityCoords(PlayerPed)
	local dist = #(executionZone-playerPosition)
	if dist <= 2.0 then
		ArgentSale = ESX.Math.Round(tonumber(ArgentSale))
	pourcentage = ArgentSale * Taxe
	Total = ESX.Math.Round(tonumber(pourcentage))

	if ArgentSale > 0 and xPlayers.getAccount('black_money').money >= ArgentSale then

		xPlayers.removeAccountMoney('black_money', ArgentSale)

		print("Bien joué"..Total.."Sale"..ArgentSale)
		TriggerClientEvent('ox_lib:notify', source, {
			title = 'Argent blanchie',
			description = 'Tu viens de blanchir '..Total,
			type = 'success'
		})
		xPlayers.addMoney(Total)

		SendLogs(3447003, 'Blanchiment d\'argent', GetPlayerName(source).. ' vient de blanchire pour un total de '..Total..'$', Blanchi.Logs.Link)



	else


		TriggerClientEvent('ox_lib:notify', source, {
		title = 'Erreur',
		description = 'Tu n\'as pas assez d\'argent sale/Montant invalide',
		position = 'top',
    	style = {
        backgroundColor = '#141517',
        color = '#C1C2C5',
        ['.description'] = {
          color = '#909296'
        }
    },
    icon = 'ban',
    iconColor = '#C53030'
	})
	end
	else 
		DropPlayer(_src, 'Pourquoi tu cheat fdp')
	end

    --local GetArgentSale = xPlayers.getAccount('black_money').money

	

end)


