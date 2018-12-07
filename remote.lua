local http = libs.http;
local keyboard = libs.keyboard;
local script = libs.script;
local sndcard_index = 1;
local last_volume = 0;
local log = libs.log;
local volume_step = 5;

local launched = 0;

function launch_if_not()
	 -- profile with about:config setted as
	 -- browser.link.open_newwindow.restriction setted at 0
	 -- browser.link.open_newwindow setted at 0
	 ff_options = string.format("--profile %s", settings.ff_profile)
	 if launched == 0 then
	    log.info(string.format("firefox %s ", ff_options))
	    os.start(string.format("firefox %s", ff_options))
	    launched = 1
	 end
end

function openChaine(url)
	 launch_if_not()
	 log.info(url)
	 os.open(url)
end

function get_volume()
	log.info(string.format("load soundcard index %d", sndcard_index))
	result = script.shell(string.format("amixer -c %d get Master", sndcard_index));
	volume = tonumber(string.match(result, '(%d+)%%'));
	log.info(string.format("volume %d", volume))
	return volume;
end

function set_volume(value)
	log.info(string.format("set volume to %d%%", volume))
	os.script(string.format("amixer -c %d sset Master %d%%", sndcard_index, math.round(value)));
end

function mute()
	last_volume = get_volume();
	set_volume(0);
end

function unmute()
	set_volume(last_volume);
	last_volume = 0;
end


--@help Lower system volume
actions.volume_down = function()
	volume = get_volume();
	if volume > 0 then
		last_volume = volume;
		set_volume(math.max(0, last_volume - volume_step));
	end
end

--@help Mute system volume
actions.volume_mute = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		mute();
	end
end

--@help Raise system volume
actions.volume_up = function()
	volume = get_volume();
	if volume <= 0 then
		unmute();
	else
		last_volume = volume;
		set_volume(math.min(100, last_volume + volume_step));
	end
end

--@help close

actions.close = function()
	keyboard.stroke("control", "W");
	launched = 0
end


--@help Open France 2
actions.france2 = function()
	openChaine("https://www.france.tv/france-2/direct.html");
end

--@help Open France 2
actions.france3 = function()
	openChaine("https://www.france.tv/france-3/direct.html");
end

--@help Open France 2
actions.france4 = function()
	openChaine("https://www.france.tv/france-4/direct.html");
end

--@help Open France 2
actions.france5 = function()
	openChaine("https://www.france.tv/france-5/direct.html");
end

--@help Open France O
actions.franceO = function()
	openChaine("https://www.france.tv/france-o/direct.html");
end

--@help Open France O
actions.arte = function()
	openChaine("https://www.arte.tv/fr/direct/");
end

--@help Open France O
actions.tmc = function()
	openChaine("https://www.tf1.fr/tmc/direct");
end

--@help Open France O
actions.tf1 = function()
	openChaine("https://www.tf1.fr/tf1/direct");
end
