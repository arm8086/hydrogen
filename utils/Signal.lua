--[[
BetterSignal by baum1000000

API:
BetterSignal.new() --> new Signal
BetterSignal:Connect(func: function) --> new Connection
BetterSignal:Once(func: function) --> new Connection that only fires once
BetterSignal:Wait() --> waits until fired (yields)
BetterSignal:Fire(...: any) --> fires all Connections

Connection:Disconnect() --> Disconnects a connection
]]--

local HttpsService = game:GetService("HttpService")

local BetterSignal = {}
BetterSignal.ClassName = "LuaScriptSignal"
BetterSignal.__index = BetterSignal

local function IsFunction(func)
	if typeof(func) ~= "function" then
		error(string.format("invalid argument. function expected got %s", typeof(func)))
	end
end

function BetterSignal.new()
	return setmetatable({
		_connections = {},
	}, BetterSignal)
end

function BetterSignal:Once(func)
	IsFunction(func)
	
	local once = nil
	
	once = self:Connect(function(...)
		once:Disconnect()
		
		func(...)
	end)
	
	return once
end

function BetterSignal:Connect(func)
	IsFunction(func)
	
	local connection = {
		_name = HttpsService:GenerateGUID(),
		_func = func,
		_connected = true,
	}
	
	self._connections[connection._name] = connection
	
	function connection:Disconnect()
		connection._connected = false
	end
	
	connection.disconnect = connection.Disconnect
	
	return connection
end

function BetterSignal:Wait()
	local yield = coroutine.running()
	
	self:Once(function(...)
		task.spawn(yield, ...)
	end)
	
	return coroutine.yield()
end

function BetterSignal:Fire(...: any)
	for i, connection in pairs(self._connections) do
		if connection._connected then
			IsFunction(connection._func)

			connection._func(...)
		else
			local index = table.find(self._connections, connection._name)
			
			table.remove(self._connections, index)
		end
	end
end

BetterSignal.New = BetterSignal.new
BetterSignal.connect = BetterSignal.Connect
BetterSignal.wait = BetterSignal.Wait
BetterSignal.fire = BetterSignal.Fire
BetterSignal.once = BetterSignal.Once

return BetterSignal
