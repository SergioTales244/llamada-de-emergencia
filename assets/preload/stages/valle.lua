--- CAMERA TWEEN --------------------------------
--[[ easing formulas by robert penner http://www.robertpenner.com/easing ]] local sin, cos, pi, sqrt, abs, asin =
    math.sin, math.cos, math.pi, math.sqrt, math.abs, math.asin
local eases = {
    ["linear"] = function(t, b, c, d)
        return c * t / d + b
    end,

    ["quadin"] = function(t, b, c, d)
        t = t / d
        return c * t ^ 2 + b
    end,
    ["quadout"] = function(t, b, c, d)
        t = t / d
        return -c * t * (t - 2) + b
    end,
    ["quadinout"] = function(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t ^ 2 + b
        else
            return -c / 2 * ((t - 1) * (t - 3) - 1) + b
        end
    end,

    ["cubein"] = function(t, b, c, d)
        t = t / d
        return c * t ^ 3 + b
    end,
    ["cubeout"] = function(t, b, c, d)
        t = t / d - 1
        return c * (t ^ 3 + 1) + b
    end,
    ["cubeinout"] = function(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t ^ 3 + b
        else
            t = t - 2
            return c / 2 * (t ^ 3 + 2) + b
        end
    end,

    ["quartin"] = function(t, b, c, d)
        t = t / d
        return c * t ^ 4 + b
    end,
    ["quartout"] = function(t, b, c, d)
        t = t / d - 1
        return -c * (t ^ 4 - 1) + b
    end,
    ["quartinout"] = function(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t ^ 4 + b
        else
            t = t - 2
            return -c / 2 * (t ^ 4 - 2) + b
        end
    end,

    ["quintin"] = function(t, b, c, d)
        t = t / d
        return c * t ^ 5 + b
    end,
    ["quintout"] = function(t, b, c, d)
        t = t / d - 1
        return c * (t ^ 5 + 1) + b
    end,
    ["quintinout"] = function(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return c / 2 * t ^ 5 + b
        else
            t = t - 2
            return c / 2 * (t ^ 5 + 2) + b
        end
    end,

    ["sinein"] = function(t, b, c, d)
        return -c * cos(t / d * (pi / 2)) + c + b
    end,
    ["sineout"] = function(t, b, c, d)
        return c * sin(t / d * (pi / 2)) + b
    end,
    ["sineinout"] = function(t, b, c, d)
        return -c / 2 * (cos(pi * t / d) - 1) + b
    end,

    ["expoin"] = function(t, b, c, d)
        if t == 0 then
            return b
        else
            return c * 2 ^ (10 * (t / d - 1)) + b - c * 0.001
        end
    end,
    ["expoout"] = function(t, b, c, d)
        if t == d then
            return b + c
        else
            return c * 1.001 * (-(2 ^ (-10 * t / d)) + 1) + b
        end
    end,
    ["expoinout"] = function(t, b, c, d)
        if t == 0 then
            return b
        end
        if t == d then
            return b + c
        end
        t = t / d * 2
        if t < 1 then
            return c / 2 * 2 ^ (10 * (t - 1)) + b - c * 0.0005
        else
            t = t - 1
            return c / 2 * 1.0005 * (-(2 ^ (-10 * t)) + 2) + b
        end
    end,

    ["circin"] = function(t, b, c, d)
        t = t / d
        return (-c * (sqrt(1 - t ^ 2) - 1) + b)
    end,
    ["circout"] = function(t, b, c, d)
        t = t / d - 1
        return (c * sqrt(1 - t ^ 2) + b)
    end,
    ["circinout"] = function(t, b, c, d)
        t = t / d * 2
        if t < 1 then
            return -c / 2 * (sqrt(1 - t * t) - 1) + b
        else
            t = t - 2
            return c / 2 * (sqrt(1 - t * t) + 1) + b
        end
    end
}
local tweens = {{}, {}}

--

function tween_property(property, goal, duration, ease)
    ease = ease:lower()
    if eases[ease] then
        local start = getProperty(property)
        if start then
            tweens[1][property] = {os.clock() + duration, start, goal - start, duration, ease}
        end
    end
end

function get_tween_value(tag)
    local tween = tweens[2][tag]
    if tween then
        return tween[1]
    end
end
function tween_value(tag, start, goal, duration, ease)
    ease = ease:lower()
    if eases[ease] then
        tweens[2][tag] = {start, os.clock() + duration, start, goal - start, duration, ease}
    end
end

function update_tweens()
    for property, tween in pairs(tweens[1]) do
        if os.clock() <= tween[1] then
            setProperty(property, eases[tween[5]](tween[4] - (tween[1] - os.clock()), tween[2], tween[3], tween[4]))
        else
            tweens[1][property] = nil
        end
    end
    for tag, tween in pairs(tweens[2]) do
        if os.clock() <= tween[2] then
            tween[1] = eases[tween[6]](tween[5] - (tween[2] - os.clock()), tween[3], tween[4], tween[5])
        else
            tweens[2][tag] = nil
        end
    end
end

--

--[[

function onUpdatePost()
	update_tweens()
	
	-- other code
end

]]

function onCreate()
    ----------------------------------------------------------------
    setPropertyFromClass('GameOverSubstate', 'deathSoundName', 'muerte');
    setPropertyFromClass('GameOverSubstate', 'characterName', 'goku');


    makeLuaSprite('barriba', '', -200, -30) -- -30
    makeGraphic('barriba', 2000, 100, '000000')
    addLuaSprite('barriba', false)
    setScrollFactor('barriba', 0, 0)

    setObjectCamera('barriba', 'hud')

    makeLuaSprite('babajo', '', -200, 650) ---650
    makeGraphic('babajo', 2000, 100, '000000')
    addLuaSprite('babajo', false)

    setScrollFactor('babajo', 0, 0)
    setObjectCamera('babajo', 'hud')
    ---
    makeLuaSprite('radar', 'radar', 1150, 600)
    if getPropertyFromClass("ClientPrefs", "downScroll") then
        setProperty('radar.y', 0)
    end
    setProperty('radar.antialiasing', true)
    scaleObject('radar', 0.07, 0.07);
    setObjectCamera('radar', 'other')
    scaleObject('timeTxt', 0.07, 0.07);
    addLuaSprite('radar', true)

    ---
    makeLuaSprite('sky', 'valle/blackgokubg', -90, 0)
    scaleObject('sky', 1, 1);
    setScrollFactor('sky', 0.3, 0.3)
    addLuaSprite('sky', false)
    -- 
    local timeTxt = math.toTime(songPos / 1000)
    makeLuaText("time", timeTxt)
    setTextSize("time", 22)
    addLuaText("time")

end

function onCreatePost()
    setProperty('camZooming', true);

    setTimeBarColors('ffcc66', '87a3ad');
    setProperty('gf.visible', false)
    setTextFont("scoreTxt", 'PhantomMuff_Full_Letters_1.1.5.ttf')
    setProperty("scoreTxt.antialiasing", true)
    ----------------------------------------------------------------
    addHaxeLibrary('Paths')
    addHaxeLibrary('OverlayShader')
    addHaxeLibrary('ColorSwap')
    addHaxeLibrary('WiggleEffectType', 'WiggleEffect')
    addHaxeLibrary('BGSprite')
    addHaxeLibrary('Conductor')
    addHaxeLibrary('BlendMode', 'openfl.display')

    runHaxeCode([[
	coolors = new ColorSwap();
	if (!ClientPrefs.lowQuality) {
		game.getLuaObject('sky').shader = coolors.shader;

	} else {
		game.boyfriend.shader = coolors.shader;
		game.dad.shader = coolors.shader;
		game.gf.shader = coolors.shader;
		game.iconP1.shader = coolors.shader;
		game.iconP2.shader = coolors.shader;
		game.healthBar.shader = coolors.shader;
	}
				]])

end

function onUpdatePost(elapsed)
    setScrollFactor('dad', 1.5, 1.5)

    update_tweens()
    if get_tween_value('dadZoom') then
        setProperty('defaultCamZoom', get_tween_value('dadZoom'))
    else
        if get_tween_value('bfZoom') then
            setProperty('defaultCamZoom', get_tween_value('bfZoom'))
        end
    end
end
function onMoveCamera(any)
    if any == 'dad' then

        tween_value('dadZoom', getProperty('defaultCamZoom'), 0.9, 1, 'cubein')
    else
        if any == 'boyfriend' then

            tween_value('dadZoom', getProperty('defaultCamZoom'), 1, .5, 'cubeout')

        end
    end
end
