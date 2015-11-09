--##
--##   CONFIGURATION FILE
--##   __________________
--##
--##   You can configurate the addon here. Most options should be given as a string (text in quotes), boolean (true or false) or float (1.0, 1.5, 2.0, 2.5 ...etc).
--##   Each parameter is explained, please read what it does before changing it to avoid unwanted results.
--##

-- Title of the mapvote frame. I disrecommend changing this.
EXCL_MAPVOTE.Title 					= "MAPVOTE"

-- Table of facts
EXCL_MAPVOTE.RandomFacts 			= {
	"The owner of this server did not set up any custom facts.",
	"You can click a tile to vote.",
	"Avatars in tiles can stack."
}

-- Switch between square and circle themes.
EXCL_MAPVOTE.IsCircular 			= false

-- Set whether the image inside circles or squares should popup with the shape...blah. This effect is hard to explain, please try playing with it to see what it does.
EXCL_MAPVOTE.UseInnerZoomEffect 	= true

-- The speed of all effects
EXCL_MAPVOTE.EffectSpeed			= 5.0

-- Vote time in seconds
EXCL_MAPVOTE.VoteTime				= 30.0 --seconds

-- Use the 'ripple' effect when clicking a tile
EXCL_MAPVOTE.UseRippleEffect 		= true

-- How much should the tile be 'amplified' when it is hovered by the cursor?
EXCL_MAPVOTE.HoverAmplification		= 1.1

-- Toggle development mode (shows FPS, avatars disappear on click, etc...)
EXCL_MAPVOTE.DeveloperMode			= false

-- Where do we load our map list from? Default: "fs" (filesystem).
EXCL_MAPVOTE.MapLoader				= "fs";

-- What percentage of players is needed to start the mapvote by !mapvote command?
EXCL_MAPVOTE.PlayerPercentage		= 65/100;

-- The time that has to pass before people can vote to start th emapvote using the !mapvote command. Use this to prevent assholes from typing rtv right after the map changes.
EXCL_MAPVOTE.ForceVoteWaitTime		= 10; --seconds

-- URL to fetch icons from. Replace where the mapname should go with %s. Ideally, the icons on this URL are 222x222 pixels.
EXCL_MAPVOTE.IconsURL				= nil; -- Example value: "http://image.www.gametracker.com/images/maps/160x120/garrysmod/%s.jpg"

-- Allow extend current map?
EXCL_MAPVOTE.AllowExtend			= true;