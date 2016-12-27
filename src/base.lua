local function selfmetatable (T) return setmetatable(T, T) end

local function init (D, inst, ...)
	if D.__source__ then
		D.__init__(D.__source__, inst, ...)
	else
		D.__init__(inst, ...)
	end

	return inst
end

local function new (D, ...)
	return init(D, selfmetatable { __index = D.fn }, ...)
end

local Base = selfmetatable { fn = {} }

function Base:derive (context)
	local Derivative = selfmetatable {
		fn = selfmetatable { __index = self.fn },
		__call = new,
		__index = self,
		__source__ = self ~= Base and function (inst, ...) init(self, inst, ...) end,
	}

	Derivative.__init__ = context(Derivative.fn, Derivative)

	return Derivative
end

return Base
