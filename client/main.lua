local resultReceived = false
local p = nil

RegisterNUICallback('callback', function(data, cb)
    SetNuiFocus(false, false)
    resultReceived = true
    if data.success then
        p:resolve(true)
    else
        p:resolve(false)
    end
    p = nil
    cb('ok')
end)


local function hacking(cb, dif, timer)
    resultReceived = false
    p = promise.new()
    SendNUIMessage({
        action = 'open',
        difficulty = dif,
        timer = timer,
    })
    SetNuiFocus(true, true)
    local result = Citizen.Await(p)
    cb(result)
end

exports("hacking", hacking)

RegisterCommand('ddr', function(source, args)
    exports['ddr']:hacking(function(success)
        if success then
            print("success")
		else
			print("fail")
		end
    end, 'hard', 30) -- level (easy, medium, hard) | timer in sec
end)