TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)


local PlayerInventory, GangInventoryItem, GangInventoryWeapon, PlayerWeapon = {}, {}, {}, {}

local mainMenu = RageUI.CreateMenu("~b~Stockage", "Quel actions voulez vous faire")
local PutMenu = RageUI.CreateSubMenu(mainMenu,"~b~Inventory", "Choisissez l'objet à déposer")
local GetMenu = RageUI.CreateSubMenu(mainMenu,"~b~Coffre", "Choisissez l'objet à prendre")


local open = false

mainMenu:DisplayGlare(false)
mainMenu.Closed = function()
    open = false
end

all_items = {}

function KeyCoffreunicorn(TextEntry, ExampleText, MaxStringLenght)

    AddTextEntry('FMMC_KEY_TIP1', TextEntry) 
    
    blockinput = true 
    DisplayOnscreenKeyboard(1, "FMMC_KEY_TIP1", "Somme", ExampleText, "", "", "", MaxStringLenght) 
    while UpdateOnscreenKeyboard() ~= 1 and UpdateOnscreenKeyboard() ~= 2 do 
        Citizen.Wait(0)
    end 
         
    if UpdateOnscreenKeyboard() ~= 2 then
        local result = GetOnscreenKeyboardResult()
        Citizen.Wait(500) 
        blockinput = false
        return result 
    else
        Citizen.Wait(500) 
        blockinput = false 
        return nil 
    end
end

    
function Coffreunicorn() 
    if open then 
		open = false
		RageUI.Visible(mainMenu, false)
		return
	else
		open = true 
		RageUI.Visible(mainMenu, true)
		CreateThread(function()
		while open do 
        RageUI.IsVisible(mainMenu, function()
            RageUI.Button("Prendre un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getStockunicorn()
            end},GetMenu);

            RageUI.Button("Déposer un objet", " ", {RightLabel = "→"}, true, {onSelected = function()
                getInventoryunicorn()
            end},PutMenu);

            

        end)

        RageUI.IsVisible(GetMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                    local count = KeyCoffreunicorn("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    if count <= v.nb then
                        TriggerServerEvent("unicorn:takeStockItems",v.item, count)
                    else
                        ESX.ShowNotification("~r~Vous n'en avez pas assez sur vous")
                    end
                    getStockunicorn()
                end});
            end

        end)

        RageUI.IsVisible(PutMenu, function()
            
            for k,v in pairs(all_items) do
                RageUI.Button(v.label, " ", {RightLabel = "~g~x"..v.nb}, true, {onSelected = function()
                    local count = KeyCoffreunicorn("Combien voulez vous en déposer",nil,4)
                    count = tonumber(count)
                    TriggerServerEvent("unicorn:putStockItems",v.item, count)
                    getInventoryunicorn()
                end});
            end
        end)



        Wait(0)
    end
 end)
 end
 end



function getInventoryunicorn()
    ESX.TriggerServerCallback('unicorn:playerinventory', function(inventory)               
                
        all_items = inventory
        
    end)
end

function getStockunicorn()
    ESX.TriggerServerCallback('unicorn:getStockItems', function(inventory)               
                
        all_items = inventory

    end)
end


Citizen.CreateThread(function()
    while true do
		local wait = 750
		if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then 
				for k in pairs(Config.Position.CoffreUnicorn) do
				local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
				local pos = Config.Position.CoffreUnicorn
				local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, pos[k].x, pos[k].y, pos[k].z)

				if dist <= Config.MarkerDistance then
					wait = 0
					DrawMarker(Config.MarkerType, pos[k].x, pos[k].y, pos[k].z, 0.0, 0.0, 0.0, 0.0,0.0,0.0, Config.MarkerSizeLargeur, Config.MarkerSizeEpaisseur, Config.MarkerSizeHauteur, Config.MarkerColorR, Config.MarkerColorG, Config.MarkerColorB, Config.MarkerOpacite, Config.MarkerSaute, true, p19, Config.MarkerTourne)  
				end

				if dist <= 2.0 then
					wait = 0
					Visual.Subtitle(Config.TextCoffre, 1)
					if IsControlJustPressed(1,51) then
						Coffreunicorn()
					end
				end
			end
		end
    Citizen.Wait(wait)
    end
end)