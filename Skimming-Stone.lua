--////////////////////////
-- Skimming Stone
-- v0.8 @xxiangcoding
--
-- plug in your typing keyboard.
-- turn norns into a lake to
-- ......skim stone......
-- 
-- K2: clear the triggered char
-- K3: toggle the write mode
-- E1: change the type(tone preset)
-- E2: change the stone (brightness)
-- E3: change the noise (dither)
--
-- BLANKSPACE: change chords
--////////////////////////

engine.name = "Skimming_Stone"

s = require "sequins"
keycodes = include("lib/keycodes")
keymap = include("lib/keymap")

local keyboard = hid.connect()

function init()
    start_note = 50
    chord_lib = s{ s{0, 2, 5, 8, 12, 14, 17, -12, -10, -7}, s{0, 3, 6, 9, 12, 15, 18, -12, -9, -6}, s{0, 1, 5, 8, 12, 13, 17, -12, -11, -7}}
    chord = s{0, 2, 5, 8, 12, 14, 17, -12, -10, -7}
    dither = 4
    words = {}
    stone = 26
    stone_trans = 0.37
    tog_add = false

    params:add_option("preset", "Stone type", keymap.types, 1)
    current_keymap_name = keymap.types[params:get("preset")]
    current_keymap = keymap[current_keymap_name]
    redraw()
end

function redraw()
    screen.clear()
    screen.level(2)
    screen.aa(0)
    screen.font_face(1)
    screen.font_size(8)
    screen.move(5, 12)
    screen.text("Skimming")
    screen.move(9, 19)
    screen.text("Stone")
    --screen.level(1)
    screen.move(110, 12)
    screen.text_center("type")
    screen.move(110, 19)
    screen.text_center(current_keymap_name)


    if #words == 0 then
        if tog_add == false then
            screen.level(8)
            screen.font_face(1)
            screen.font_size(8)
            screen.move(18, 33)
            screen.text("[ E M P T Y ]")
            screen.level(1)       
            screen.move(28, 44)
            screen.text("mark some stone")
            screen.move(37, 52)
            screen.text("||")
            screen.move(86, 52)
            screen.text("o")
        end
    else
        for i = 1, #words do
            screen.level(15)
            screen.aa(1)
            screen.font_face(18)
            screen.font_size(18)
            screen.move(2+ i*12, 44-2*i)
            screen.text(words[i])
        end
    end

    screen.move(28, 60)
    screen.aa(0)
    screen.font_face(0)
    screen.font_size(8)
    if tog_add then
        screen.level(12)
        screen.text("mark")
    else
        screen.level(3)
        screen.text("mark")
    end

    screen.move(0, 60)
    screen.level(2)
    screen.text("clear")

    screen.level(math.floor((30 - stone) / 2))
    screen.move(77, 60)
    screen.text("stone")

    screen.level(math.floor(dither / 2))
    screen.move(106, 60)
    screen.text("noise")

    screen.update()
end

function key(n,z)
    if n == 3 and z == 1 then
        tog_add = not tog_add
    end
    if n == 2 and z == 1 then
        words = {}
    end
    
    redraw()
end

function enc(n,d)
    if n == 3 then
        dither = util.clamp(dither + d/3.0, 0.0, 30.0)
    end

    if n == 2 then
        stone = util.clamp(stone - d/3.0, 0.0, 30.0)
        stone_trans = (stone / 30.0) - 0.5
    end
    if n == 1 then
        params:delta("preset", util.clamp(d, -1, 1))
        current_keymap_name = keymap.types[params:get("preset")]
        current_keymap = keymap[current_keymap_name]
    end

    redraw()
end

function add_word(word)
    table.insert(words, word)
    if #words > 8 then
        table.remove(words, 1)
    end
    redraw()
end

function find_char(char)
    for i=1, #words do
        if words[i] == char then
            return true
        end
    end
    return false
end

function note_key(char)
    local engines = {
        da = engine.da,
        ka = engine.ka,
        yea = engine.yea,
        re = engine.re,
        dong = engine.dong,
        guang = engine.guang
    }

    local engine_func = engines[keycodes.engine[char]]
    if engine_func then
        if engine_func == engine.dong then
            local param_prefix = char..(find_char(char) and "S_" or "_")
            note = start_note + chord[keycodes.pos[char]]
            engine_func(midi_to_hz(note), dither, stone_trans, current_keymap[param_prefix.."m1"], current_keymap[param_prefix.."m2"], kick_s_control(current_keymap[param_prefix.."rls"]), current_keymap[param_prefix.."pan"])
            print(midi_to_hz(note), dither, stone_trans, current_keymap[param_prefix.."m1"], current_keymap[param_prefix.."m2"], kick_s_control(current_keymap[param_prefix.."rls"]), current_keymap[param_prefix.."pan"])
        else
            local param_prefix = char..(find_char(char) and "S_" or "_")
            note = start_note + chord[keycodes.pos[char]]
            engine_func(midi_to_hz(note), dither, stone_trans, current_keymap[param_prefix.."m1"], current_keymap[param_prefix.."m2"], s_control(current_keymap[param_prefix.."rls"]), current_keymap[param_prefix.."pan"])
            print(midi_to_hz(note), dither, stone_trans, current_keymap[param_prefix.."m1"], current_keymap[param_prefix.."m2"], s_control(current_keymap[param_prefix.."rls"]), current_keymap[param_prefix.."pan"])
        end
    end
end

-- function to trigger sounds by keys
function get_key(code, val, shift)
    if keycodes.keys[code] ~= nil and val == 1 then
        return keycodes.keys[code]
    end
end


function keyboard.event(type, code, val)
    --local menu = norns.menu.status()
    -- ' '
    if val == 1 then

        local key = keycodes.soundkeys[code]
        current_keymap_name = keymap.types[params:get("preset")]
        current_keymap = keymap[current_keymap_name]

        -- blankspace change chord
        if (code == hid.codes.KEY_SPACE) then
            note = start_note
            if tog_add then
                add_word(' ')
            end
            engine.kong(midi_to_hz(note))
            change_chord()
            
        -- delete
        elseif (code == hid.codes.KEY_BACKSPACE) then
            if #words > 0 then
                table.remove(words, #words)
                redraw()
            end

        -- sound making keys
        elseif key then
            local state = 0
            if tog_add then
                add_word(key)
            end
            note_key(key)
        end
    end
end

function s_control(numb)
    return util.clamp(numb + stone_trans, 0.01, 2.0)
end

function kick_s_control(numb)
    return util.clamp(numb - stone_trans, 0.01, 2.0)
end

function change_chord()
    start_note = 50 + math.random(7)*2 - math.random(5)
    if math.random(3) == 1 then
        chord = chord_lib[math.random(#chord_lib)]
    end
    
end

function midi_to_hz(note)
    return (440 / 32) * (2 ^ ((note - 9) / 12))
end