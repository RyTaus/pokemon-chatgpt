Utils = {}

-- Shifts bits of 'value', 'n' bits to the left
function Utils.bit_lshift(value, n)
	return math.floor(value) * (2 ^ n)
end

-- Shifts bits of 'value', 'n' bits to the right
function Utils.bit_rshift(value, n)
	return math.floor(value / (2 ^ n))
end

-- gets bits from least significant to most
function Utils.getbits(value, startIndex, numBits)
	return math.floor(Utils.bit_rshift(value, startIndex) % Utils.bit_lshift(1, numBits))
end

-- Goal is to change from little to big endian, or vice-versa. Likely a better way to do this
function Utils.reverseEndian32(value)
	local a = Utils.bit_and(value, 0xFF000000)
	local b = Utils.bit_and(value, 0x00FF0000)
	local c = Utils.bit_and(value, 0x0000FF00)
	local d = Utils.bit_and(value, 0x000000FF)
	return Utils.bit_lshift(d, 24) + Utils.bit_lshift(c, 8) + Utils.bit_rshift(b, 8) + Utils.bit_rshift(a, 24)
end

function Utils.inlineIf(condition, T, F)
	if condition then return T else return F end
end