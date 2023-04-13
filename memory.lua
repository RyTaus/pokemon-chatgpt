Memory = {}

function Memory.splitDomainAndAddress(addr)
	local memdomain = addr >> 24
	local splitaddr = addr & 0xFFFFFF
	if memdomain == 0 then
		return "BIOS", splitaddr
	elseif memdomain == 2 then
		return "EWRAM", splitaddr
	elseif memdomain == 3 then
		return "IWRAM", splitaddr
	elseif memdomain == 8 then
		return "ROM", splitaddr
	end
	return nil, addr
end

Memory.read8 = function(addr)
	local m, a = Memory.splitDomainAndAddress(addr)
	return memory.read_u8(a, m)
end
Memory.read16 = function(addr)
	local m, a = Memory.splitDomainAndAddress(addr)
	return memory.read_u16_le(a, m)
end
Memory.read32 = function(addr)
	local m, a = Memory.splitDomainAndAddress(addr)
	return memory.read_u32_le(a, m)
end

function Memory.readbyte(addr)
	return Memory.read8(addr)
end
function Memory.readword(addr)
	return Memory.read16(addr)
end
function Memory.readdword(addr)
	return Memory.read32(addr)
end
