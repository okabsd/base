local Base = require 'base'

local Map = Base:derive(function (_, self)
    self.data = {}
end)

function Map.fn:set (k, v)
    rawset(self.data, k, v)
end

function Map.fn:get (k)
    return rawget(self.data, k)
end

function Map.fn:has (k)
    return rawget(self.data, k) ~= nil
end

function Map.fn:size ()
    local s = 0
    for _, _ in pairs(self.data) do
	s = s + 1
    end
    return s
end

local WeakMap = Map:derive(function (source, self, t)
    source(self)
    setmetatable(self.data, { __mode = t or 'k' })
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
