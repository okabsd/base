local Map = require 'base' : derive(function (fn)
	function fn:has (key)
		return rawget(self.data, key) ~= nil
	end

	function fn:get (key)
		return rawget(self.data, key)
	end

	function fn:set (key, value)
		rawset(self.data, key, value)
	end

	function fn:size ()
		local sz = 0

		for _, _ in pairs(self.data) do sz = sz + 1 end

		return sz
	end

	return function (self)
		self.data = {}
	end
end)

local WeakMap = Map:derive(function ()
	return function (source, self, mode)
		source(self)
		setmetatable(self.data, { __mode = mode or 'k' })
	end
end)

local map = Map()
map:set('a', 1)
map:set('b', 2)
print(map:has('a'), map:get('b'), map:has('c')) -- true, 2, false

local wmap = WeakMap()
wmap:set(map, {})
print(wmap:has(map), wmap:size()) -- true, 1
map = nil
collectgarbage() -- Force GC
print(wmap:size()) -- 0
