------------------------------------------------------------------------
-- Read settings to get size factors.

local function getSizeFactor(sizeString)
	if sizeString == "3x3" then
		return 1
	elseif sizeString == "2x2" then
		return 0.667
	elseif sizeString == "1x1" then
		return 0.333
	else
		error("Invalid size string: " .. sizeString)
	end
end

local transmitterSizeString = settings.startup["SimpleRadioTowers-transmitter-size"].value
local receiverSizeString = settings.startup["SimpleRadioTowers-receiver-size"].value

local transmitterSizeFactor = getSizeFactor(transmitterSizeString)
local receiverSizeFactor = getSizeFactor(receiverSizeString)

local function scaleBoundingBox(box, sizeFactor)
	if sizeFactor == 1 then
		return box
	end
	return {
		{box[1][1] * sizeFactor, box[1][2] * sizeFactor},
		{box[2][1] * sizeFactor, box[2][2] * sizeFactor},
	}
end

------------------------------------------------------------------------
-- Change images and shadows for the receiver and transmitter entities.
-- Also change collision boxes and wire connection points to match the new sprites.

local senderSprite = "__SimpleRadioTowers__/graphics/transmitter.png"
local senderShadowSprite = "__SimpleRadioTowers__/graphics/transmitter-shadow.png"
local receiverSprite = "__SimpleRadioTowers__/graphics/receiver.png"
local receiverShadowSprite = "__SimpleRadioTowers__/graphics/receiver-shadow.png"

data.raw.roboport["aai-signal-sender"].base_animation = {
	layers = {
		{
			filename = senderSprite,
			priority = "high",
			width = 287,
			height = 753,
			frame_count = 1,
			line_length = 1,
			shift = util.by_pixel(12 * transmitterSizeFactor, -134 * transmitterSizeFactor),
			scale = 0.5 * transmitterSizeFactor,
			animation_speed = 1,
		},
		{
			draw_as_shadow = true,
			filename = senderShadowSprite,
			priority = "high",
			width = 796,
			height = 240,
			frame_count = 1,
			line_length = 1,
			shift = util.by_pixel(197 * transmitterSizeFactor, 19 * transmitterSizeFactor),
			scale = 0.5 * transmitterSizeFactor,
			animation_speed = 1,
		},
	},
}
data.raw.roboport["aai-signal-sender"].collision_box = scaleBoundingBox({{-1.5, -1.3}, {1.5, 1.3}}, transmitterSizeFactor)
data.raw.roboport["aai-signal-sender"].selection_box = scaleBoundingBox({{-1.5, -1.5}, {1.5, 1.5}}, transmitterSizeFactor)
data.raw.roboport["aai-signal-sender"].drawing_box = scaleBoundingBox({{-2, -9}, {7, 1.5}}, transmitterSizeFactor)
local wirePos = {
	red = { 1.2 * transmitterSizeFactor, -0.7 * transmitterSizeFactor },
	green = { -0.2 * transmitterSizeFactor, 0.6 * transmitterSizeFactor },
}
data.raw.roboport["aai-signal-sender"].circuit_wire_connection_point = {
	wire = wirePos,
	shadow = wirePos,
}

data.raw.roboport["aai-signal-receiver"].base_animation = {
	layers = {
		{
			filename = receiverSprite,
			priority = "high",
			width = 221,
			height = 711,
			frame_count = 1,
			line_length = 1,
			shift = util.by_pixel(-2 * receiverSizeFactor, -121 * receiverSizeFactor),
			scale = 0.5 * receiverSizeFactor,
			animation_speed = 1,
		},
		{
			draw_as_shadow = true,
			filename = receiverShadowSprite,
			priority = "high",
			width = 637,
			height = 155,
			frame_count = 1,
			line_length = 1,
			shift = util.by_pixel(180 * receiverSizeFactor, -12 * receiverSizeFactor),
			scale = 0.5 * receiverSizeFactor,
			animation_speed = 1,
		},
	},
}
data.raw.roboport["aai-signal-receiver"].collision_box = scaleBoundingBox({{-1.5, -1.3}, {1.5, 1.3}}, receiverSizeFactor)
data.raw.roboport["aai-signal-receiver"].selection_box = scaleBoundingBox({{-1.5, -1.5}, {1.5, 1.5}}, receiverSizeFactor)
data.raw.roboport["aai-signal-receiver"].drawing_box = scaleBoundingBox({{-2, -9}, {7, 1.5}}, receiverSizeFactor)
local receiverWirePos = {
	red = { -0.6 * receiverSizeFactor, -0.2 * receiverSizeFactor },
	green = { 0.7 * receiverSizeFactor, 0 * receiverSizeFactor },
}
data.raw.roboport["aai-signal-receiver"].circuit_wire_connection_point = {
	wire = receiverWirePos,
	shadow = receiverWirePos,
}

------------------------------------------------------------------------
-- Change sounds

data.raw.roboport["aai-signal-sender"].open_door_trigger_effect = nil
data.raw.roboport["aai-signal-sender"].close_door_trigger_effect = nil
data.raw.roboport["aai-signal-sender"].build_sound = data.raw.radar.radar.build_sound
data.raw.roboport["aai-signal-sender"].working_sound = data.raw.radar.radar.working_sound

data.raw.roboport["aai-signal-receiver"].open_door_trigger_effect = nil
data.raw.roboport["aai-signal-receiver"].close_door_trigger_effect = nil
data.raw.roboport["aai-signal-receiver"].build_sound = data.raw.radar.radar.build_sound
data.raw.roboport["aai-signal-receiver"].working_sound = data.raw.radar.radar.working_sound

------------------------------------------------------------------------
-- Change icons for items.

data.raw.item["aai-signal-sender"].icon = "__SimpleRadioTowers__/graphics/transmitter-item.png"
data.raw.item["aai-signal-sender"].icon_size = 64
data.raw.item["aai-signal-sender"].icon_mipmaps = 4

data.raw.item["aai-signal-receiver"].icon = "__SimpleRadioTowers__/graphics/receiver-item.png"
data.raw.item["aai-signal-receiver"].icon_size = 64
data.raw.item["aai-signal-receiver"].icon_mipmaps = 4

------------------------------------------------------------------------
-- Change technology

-- Tech icon
data.raw.technology["aai-signal-transmission"].icon = "__SimpleRadioTowers__/graphics/radio-tech.png"
data.raw.technology["aai-signal-transmission"].icon_size = 256
data.raw.technology["aai-signal-transmission"].icon_mipmaps = 2

data.raw.technology["aai-signal-transmission"].prerequisites = {"circuit-network"}

-- Copy costs from circuit-network
data.raw.technology["aai-signal-transmission"].unit = data.raw.technology["circuit-network"].unit

-- Put it after circuit-network in the tech list
data.raw.technology["aai-signal-transmission"].order = data.raw.technology["circuit-network"].order .. "aaa"

------------------------------------------------------------------------
-- Change energy consumption

-- For comparison, a vanilla radar uses 300kW.
-- A radio transmitter can transmit over arbitrary distance, more than the vanilla radar, so make it consume a bit more power.
data.raw.roboport["aai-signal-sender"].energy_usage = "500kW"
-- A radio receiver logically doesn't need much power.
data.raw.roboport["aai-signal-receiver"].energy_usage = "100kW"

------------------------------------------------------------------------
-- Change recipes

if mods["IndustrialRevolution3"] then
	data.raw.recipe["aai-signal-sender"].ingredients = {
		{"copper-coil", 4},
		{"iron-beam", 16},
		{"iron-stick", 16},
		{"copper-cable-heavy", 4},
	}
	data.raw.recipe["aai-signal-receiver"].ingredients = {
		{"copper-coil", 2},
		{"iron-beam", 12},
		{"iron-stick", 12},
		{"copper-cable-heavy", 2},
	}
else
	data.raw.recipe["aai-signal-sender"].ingredients = {
		{"electronic-circuit", 2},
		{"iron-stick", 32},
		{"iron-plate", 16},
		{"copper-cable", 8},
	}
	data.raw.recipe["aai-signal-receiver"].ingredients = {
		{"electronic-circuit", 2},
		{"iron-stick", 16},
		{"iron-plate", 8},
		{"copper-cable", 8},
	}
end

------------------------------------------------------------------------
-- Make them military targets, same as radar.

data.raw.roboport["aai-signal-receiver"].is_military_target = true
data.raw.roboport["aai-signal-sender"].is_military_target = true
