--////////////////////////
-- Skimming Stone
-- v0.5 @xxiangcoding
-- 
-- plug in your typing keyboard.
-- turn norns into a lake to
-- ......skim stone......
-- 
-- K2: clear the triggered char
-- K3: toggle the write mode
--
-- E2: change the stone (brightness)
-- E3: change the noise (dither)
--
-- BLANKSPACE: change chords
--////////////////////////

engine.name = "Skimming_Stone"

s = require "sequins"

local keyboard = hid.connect()

function init()
    start_note = 50
    chord_lib = s{ s{0, 2, 5, 8, 12, 14}, s{0, 3, 6, 9, 12, 15}, s{0, 1, 5, 8, 12, 13}}
    chord = s{0, 2, 5, 8, 12, 14}
    dither = 4
    words = {}
    stone = 26
    stone_trans = 0.37
    tog_add = false
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
    screen.move(96, 12)
    screen.text("24.01")
    screen.move(93, 19)
    screen.text("xxiang.")


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

function add_word(word)
    table.insert(words, word)
    if #words > 8 then
        table.remove(words, 1)
    end
    redraw()
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

    redraw()
end



-- keyboard
local keycodes = {}
keycodes.keys = {
    [hid.codes.KEY_Q] = "Q",
    [hid.codes.KEY_W] = "W",
    [hid.codes.KEY_E] = "E",
    [hid.codes.KEY_R] = "R",
    [hid.codes.KEY_T] = "T",
    [hid.codes.KEY_Y] = "Y",
    [hid.codes.KEY_U] = "U",
    [hid.codes.KEY_I] = "I",
    [hid.codes.KEY_O] = "O",
    [hid.codes.KEY_P] = "P",
    [hid.codes.KEY_A] = "A",
    [hid.codes.KEY_S] = "S",
    [hid.codes.KEY_D] = "D",
    [hid.codes.KEY_F] = "F",
    [hid.codes.KEY_G] = "G",
    [hid.codes.KEY_H] = "H",
    [hid.codes.KEY_J] = "J",
    [hid.codes.KEY_K] = "K",
    [hid.codes.KEY_L] = "L",
    [hid.codes.KEY_SEMICOLON] = ":",
    [hid.codes.KEY_Z] = "Z",
    [hid.codes.KEY_X] = "X",
    [hid.codes.KEY_C] = "C",
    [hid.codes.KEY_V] = "V",
    [hid.codes.KEY_B] = "B",
    [hid.codes.KEY_N] = "N",
    [hid.codes.KEY_M] = "M",
    [hid.codes.KEY_COMMA] = ",",
    [hid.codes.KEY_DOT] = ".",
    [hid.codes.KEY_SLASH] = "?",
    [hid.codes.KEY_SPACE] = " ",
    [hid.codes.KEY_BACKSPACE] = "Backspace",
}  

local function get_key(code, val, shift)
    if keycodes.keys[code] ~= nil and val == 1 then
        return keycodes.keys[code]
    end
end

function keyboard.event(type, code, val)
    local menu = norns.menu.status()
    -- ' '
    if (code == hid.codes.KEY_SPACE) and (val == 1) then
        note = start_note
        if tog_add then
            add_word(' ')
        end
        engine.kong(midi_to_hz(note))
        change_chord()

    -- 'waz', 'p;.'
    elseif (code == hid.codes.KEY_W) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('W')
        end
        
        if find_char('W') then
            note = start_note + chord[6]
            engine.da(midi_to_hz(note), dither, 1.2, 0.1, s_control(0.8), -0.4, stone_trans)
        else
            note = start_note + chord[6]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_A) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('A')
        end
        
        if find_char('A') then
            note = start_note + chord[5]
            engine.da(midi_to_hz(note), dither, 1.2, 0.2, s_control(1.2), -0.8, stone_trans)
        else
            note = start_note + chord[5]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end
        

    elseif (code == hid.codes.KEY_Z) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('Z')
        end

        if find_char('Z') then
            note = start_note + chord[4]
            engine.da(midi_to_hz(note), dither, 1.0, 0.3, s_control(1.0), -0.2, stone_trans)
        else
            note = start_note + chord[4]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_P) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('P')
        end

        if find_char('P') then
            note = start_note + chord[6]
            engine.da(midi_to_hz(note), dither, 0.6, 0.25, s_control(0.2), 0.2, stone_trans)
        else
            note = start_note + chord[6]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_SEMICOLON) and (val == 1) then
        local state = 0
        if tog_add then
            add_word(':')
        end
        
        if find_char(':') then
            note = start_note + chord[5]
            engine.da(midi_to_hz(note), dither, 0.5, 0.1, s_control(0.5), 0.7, stone_trans)
        else
            note = start_note + chord[5]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end
        
    elseif (code == hid.codes.KEY_DOT) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('.')
        end

        if find_char('.') then
            note = start_note + chord[4]
            engine.da(midi_to_hz(note), dither, 1.6, 0.25, s_control(0.8), 0.6, stone_trans)
        else
            note = start_note + chord[4]
            engine.da(midi_to_hz(note), dither, 0.8, 0, s_control(1.2), 0, stone_trans)
        end

    --'esx', 'ol,'
    elseif (code == hid.codes.KEY_E) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('E')
        end
        
        if find_char('E') then
            note = start_note + chord[5]
            engine.ka(midi_to_hz(note), dither, 60, 50, s_control(0.7), -0.2, stone_trans)
        else
            note = start_note + chord[5]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_S) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('S')
        end

        if find_char('S') then
            note = start_note + chord[4]
            engine.ka(midi_to_hz(note), dither, 122, 17, s_control(0.2), -0.5, stone_trans)
        else
            note = start_note + chord[4]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_X) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('X')
        end

        if find_char('X') then
            note = start_note + chord[3]
            engine.ka(midi_to_hz(note), dither, 144, 330, s_control(0.5), -0.4, stone_trans)
        else
            note = start_note + chord[3]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_O) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('O')
        end

        if find_char('O') then
            note = start_note + chord[5]
            engine.ka(midi_to_hz(note), dither, 40, 20, s_control(1.2), 0.3, stone_trans)
        else
            note = start_note + chord[5]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_L) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('L')
        end

        if find_char('L') then
            note = start_note + chord[4]
            engine.ka(midi_to_hz(note), dither, 40, 220, s_control(0.6), 0.4, stone_trans)
        else
            note = start_note + chord[4]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_COMMA) and (val == 1) then
        local state = 0
        if tog_add then
            add_word(',')
        end

        if find_char(',') then
            note = start_note + chord[3]
            engine.ka(midi_to_hz(note), dither, 240, 20, s_control(0.18), 0.7, stone_trans)
        else
            note = start_note + chord[3]
            engine.ka(midi_to_hz(note), dither, 0.02, 0, s_control(1.2), 0, stone_trans)
        end

        --'rdc', 'ikm'
    elseif (code == hid.codes.KEY_R) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('R')
        end

        if find_char('R') then
            note = start_note + chord[4]
            engine.yea(midi_to_hz(note), dither, 1600, 3635, 0.46, s_control(0.16), -0.2, stone_trans)
        else
            note = start_note + chord[4]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_D) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('D')
        end

        if find_char('D') then
            note = start_note + chord[3]
            engine.yea(midi_to_hz(note), dither, 532, 1300, 0.06, s_control(1.26), -0.4, stone_trans)
        else
            note = start_note + chord[3]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_C) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('C')
        end

        if find_char('C') then
            note = start_note + chord[2]
            engine.yea(midi_to_hz(note), dither, 390, 1878, 0.14, s_control(0.86), -0.4, stone_trans)
        else
            note = start_note + chord[2]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_I) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('I')
        end

        if find_char('I') then
            note = start_note + chord[4]
            engine.yea(midi_to_hz(note), dither, 1400, 2859, 0.66, s_control(0.06), 0.4, stone_trans)
        else
            note = start_note + chord[4]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_K) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('K')
        end

        if find_char('K') then
            note = start_note + chord[3]
            engine.yea(midi_to_hz(note), dither, 1600, 259, 0.36, s_control(0.36), 0.6, stone_trans)
        else
            note = start_note + chord[3]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_M) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('M')
        end

        if find_char('M') then
            note = start_note + chord[2]
            engine.yea(midi_to_hz(note), dither, 832, 859, 0.06, s_control(0.46), 0.1, stone_trans)
        else
            note = start_note + chord[2]
            engine.yea(midi_to_hz(note), dither, 0, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    --'tfv', 'ujn'
    elseif (code == hid.codes.KEY_T) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('T')
        end

        if find_char('T') then
            note = start_note + chord[3]
            engine.re(midi_to_hz(note), dither, 1.0, 0.01, s_control(1.4), 0.0, stone_trans)
        else
            note = start_note + chord[3]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_F) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('F')
        end

        if find_char('F') then
            note = start_note + chord[2]
            engine.re(midi_to_hz(note), dither, 1.0, 0.14, s_control(0.2), -0.6, stone_trans)
        else
            note = start_note + chord[2]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_V) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('V')
        end

        if find_char('V') then
            note = start_note + chord[1]
            engine.re(midi_to_hz(note), dither, 4.0, 0.4, s_control(0.1), 0.0, stone_trans)
        else
            note = start_note + chord[1]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_U) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('U')
        end

        if find_char('U') then
            note = start_note + chord[3]
            engine.re(midi_to_hz(note), dither, 2.0, 0.1, s_control(0.01), 0.6, stone_trans)
        else
            note = start_note + chord[3]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_J) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('J')
        end

        if find_char('J') then
            note = start_note + chord[2]
            engine.re(midi_to_hz(note), dither, 1.4, 0.1, s_control(1.5), -0.2, stone_trans)
        else
            note = start_note + chord[2]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_N) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('N')
        end

        if find_char('N') then
            note = start_note + chord[1]
            engine.re(midi_to_hz(note), dither, 0.1, 0.8, s_control(0.08), 0.2, stone_trans)
        else
            note = start_note + chord[1]
            engine.re(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    --'gbhy'
    elseif (code == hid.codes.KEY_G) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('G')
        end

        if find_char('G') then
            note = start_note + chord[1]
            print(midi_to_hz(note))
            engine.dong(midi_to_hz(note-12), dither, 2.0, 0.2, kick_s_control(0.4), -0.4, stone_trans)
        else
            note = start_note + chord[1]
            engine.dong(midi_to_hz(note-12), dither, 0.3, 0.1, kick_s_control(0.8), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_B) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('B')
        end

        if find_char('B') then
            note = start_note + chord[2]
            print(midi_to_hz(note))
            engine.dong(midi_to_hz(note-12), dither, 4.4, 0.6, kick_s_control(1.0), 0, stone_trans)
        else
            note = start_note + chord[2]
            engine.dong(midi_to_hz(note-12), dither, 0.3, 0.1, kick_s_control(0.8), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_H) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('H')
        end

        if find_char('H') then
            note = start_note + chord[3]
            print(midi_to_hz(note))
            engine.dong(midi_to_hz(note-12), dither, 1.6, 0.1, kick_s_control(0.2), 0.4, stone_trans)
        else
            note = start_note + chord[3]
            engine.dong(midi_to_hz(note-12), dither, 0.3, 0.1, kick_s_control(0.8), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_Y) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('Y')
        end

        if find_char('Y') then
            note = start_note + chord[4]
            print(midi_to_hz(note))
            engine.dong(midi_to_hz(note-12), dither, 5.0, 0.5, kick_s_control(1.2), 0, stone_trans)
        else
            note = start_note + chord[4]
            engine.dong(midi_to_hz(note-12), dither, 0.3, 0.1, kick_s_control(0.8), 0, stone_trans)
        end

        -- 'q?'
    elseif (code == hid.codes.KEY_Q) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('Q')
        end
        
        if find_char('Q') then
            note = start_note + chord[3] + 12
            engine.guang(midi_to_hz(note), dither, 1.1, 0.8, s_control(1.2), -0.7, stone_trans)
        else
            note = start_note + chord[3] + 12
            engine.guang(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    elseif (code == hid.codes.KEY_SLASH) and (val == 1) then
        local state = 0
        if tog_add then
            add_word('?')
        end
        
        if find_char('?') then
            note = start_note + chord[5]
            engine.guang(midi_to_hz(note), dither, 0.4, 0.1, s_control(1.7), 0.7, stone_trans)
        else
            note = start_note + chord[5]
            engine.guang(midi_to_hz(note), dither, 0, 0.01, s_control(1.2), 0, stone_trans)
        end

    -- delete
    elseif (code == hid.codes.KEY_BACKSPACE) and (val == 1) then
        if #words > 0 then
            table.remove(words, #words)
            redraw()
        end
    end

end

function s_control(numb)
    return util.clamp(numb + stone_trans, 0.01, 2.0)
end

function kick_s_control(numb)
    return util.clamp(numb - stone_trans, 0.01, 2.0)
end

function find_char(char)
    for i=1, #words do
        if words[i] == char then
            return true
        end
    end
    return false
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




