Citizen.CreateThread(function()
	while ESX == nil do
		TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
		Citizen.Wait(10)
    end
    while ESX.GetPlayerData().job == nil do
		Citizen.Wait(10)
    end
    if ESX.IsPlayerLoaded() then

		ESX.PlayerData = ESX.GetPlayerData()

    end
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
	ESX.PlayerData = xPlayer
end)


RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
	ESX.PlayerData.job = job
end)

-- Function --

function VestaireUnicorn()

  local model = GetEntityModel(GetPlayerPed(-1))

  TriggerEvent('skinchanger:getSkin', function(skin)

      if model == GetHashKey("mp_m_freemode_01") then

          clothesSkin = {

            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 13, ['tshirt_2'] = 0,
            ['torso_1'] = 13, ['torso_2'] = 0,
            ['arms'] = 11,
            ['pants_1'] = 26, ['pants_2'] = 0,
            ['shoes_1'] = 36, ['shoes_2'] = 0,

          }

      else

          clothesSkin = {

            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 23,['tshirt_2'] = 4,
            ['torso_1'] = 52, ['torso_2'] = 0,
            ['arms'] = 5, ['arms_2'] = 0,
            ['pants_1'] = 36, ['pants_2'] = 0,
            ['shoes_1'] = 42, ['shoes_2'] = 1,

          }

      end

      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

  end)

end

function VestaireUnicornDanse()

  local model = GetEntityModel(GetPlayerPed(-1))

  TriggerEvent('skinchanger:getSkin', function(skin)

      if model == GetHashKey("mp_m_freemode_01") then

          clothesSkin = {

            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 13, ['tshirt_2'] = 0,
            ['torso_1'] = 13, ['torso_2'] = 0,
            ['arms'] = 11,
            ['pants_1'] = 26, ['pants_2'] = 0,
            ['shoes_1'] = 36, ['shoes_2'] = 0,

          }

      else

          clothesSkin = {

            ['bags_1'] = 0, ['bags_2'] = 0,
            ['tshirt_1'] = 23,['tshirt_2'] = 4,
            ['torso_1'] = 52, ['torso_2'] = 0,
            ['arms'] = 5, ['arms_2'] = 0,
            ['pants_1'] = 36, ['pants_2'] = 0,
            ['shoes_1'] = 42, ['shoes_2'] = 1,

          }

      end

      TriggerEvent('skinchanger:loadClothes', skin, clothesSkin)

  end)

end



function vcivil()

ESX.TriggerServerCallback('esx_skin:getPlayerSkin', function(skin, jobSkin)

TriggerEvent('skinchanger:loadSkin', skin)

end)

end

-- MENU FUNCTION --

local open = false 
local mainMenu6 = RageUI.CreateMenu('~b~Vestaire', '~b~Ouverture du casier..')
mainMenu6.Display.Header = true 
mainMenu6.Closed = function()
  open = false
end

function OpenVestiaire()
     if open then 
         open = false
         RageUI.Visible(mainMenu6, false)
         return
     else
         open = true 
         RageUI.Visible(mainMenu6, true)
         CreateThread(function()
         while open do 
            RageUI.IsVisible(mainMenu6,function() 

              RageUI.Separator("↓ ~y~   Vestiaire  ~s~↓")

              RageUI.Button("Mettre sa tenue : ~r~Civile", nil, {RightLabel = "→→"}, true , {
                onSelected = function()
                    vcivil()
                  end
                })	

                RageUI.Separator("~r~↓ Tenue Dispo ↓")
                
                RageUI.Button("Mettre sa tenue : ~g~BARMAN", nil, {RightLabel = "→→"}, true , {
                  onSelected = function()
                    VestaireUnicorn()
                    end
                  })	

                  RageUI.Button("Mettre sa tenue : ~g~DANSE", nil, {RightLabel = "→→"}, true , {
                    onSelected = function()
                      VestaireUnicornDanse()
                      end
                    })	
            
            end)
          Wait(0)
         end
      end)
   end
end

----OUVRIR LE MENU------------

local position = {
	{x = 99.41, y = -1311.65, z = 29.26}
}

Citizen.CreateThread(function()
    while true do

      local wait = 750

        for k in pairs(position) do
        if ESX.PlayerData.job and ESX.PlayerData.job.name == 'unicorn' then 
            local plyCoords = GetEntityCoords(GetPlayerPed(-1), false)
            local dist = Vdist(plyCoords.x, plyCoords.y, plyCoords.z, position[k].x, position[k].y, position[k].z)

            if dist <= 5.0 then
            wait = 0
            DrawMarker(22, 99.41, -1311.65, 29.26, 0.0, 0.0, 0.0, 0.0,0.0,0.0, 0.3, 0.3, 0.3, 3, 169, 244, 255, true, true, p19, true)  

        
            if dist <= 1.0 then
               wait = 0
                Visual.Subtitle("Appuyer sur ~b~[E]~s~ pour intéragir", 1) 
                if IsControlJustPressed(1,51) then
                  OpenVestiaire()
            end
        end
    end
    end
    Citizen.Wait(wait)
    end
end
end)


