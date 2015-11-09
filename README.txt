README.txt
_____________________________

1. Information for server owners
_____________________________

You can edit the configuration of this addon in the configuration file "sh_config_values.lua", located in "lua/excl_mapvote/". 
	Use a simple text editor, such as Notepad++ or Sublime Text, to edit the configuration values.

To add map icons, put a 256x256 .png file in "materials/excl_mapvote/maps/" with the same name as the map (without .bsp). 
    Example filename in proper location: "materials/excl_mapvote/maps/gm_flatgrass.png".

To add maps to the votemap system, edit the list of maps in excl_mapvote.txt using a simple text editor such as Notepad++ or Sublime Text.
	The excl_mapvote.txt file must be located in the "garrysmod/data/" folder, and should have 1 mapname (without .bsp) per line.


If you like this script, please rate it 5 stars on CoderHire.net
	This will increase my motivation to keep improving it, and help sales. 

__________________________

2. Information for developers
__________________________

Hooks that you may use are:
- EXCL_MAPVOTE.DoFinish (args: string Winner), this hook is called right after the voting is done.
- EXCL_MAPVOTE.Finish (args: string Winner), this hook is called 4 seconds after the voting is done. Do map changes, extentions, etc. here.
- EXCL_MAPVOTE.Start, this hook is called when voting starts.

To add special compatability stuff for your own gamemode, check out the sv_compat.lua file in lua/excl_mapvote/.

To prevent a changelevel from running, set EXCL_MAPVOTE.SupressChange to true in either the DoFinish or Finish hook. This change is reverted after a single mapchange 
is supressed.

To implement your own maploader (for when you want to use MySQL, MongoDB, an API, etc...), change the maploader config option in the configuration values file. 
Load your own maploader under an if-statement. Your implementation should populate a table at EXCL_MAPVOTE.MapSelection with a maximum (no more) of 8 key-value integer 
pairs (this means, each key is a number and each value is the name of the map that can be voted for). 
Check sv_load.lua to see how the default (filesystem) maplist-loader is implemented. This may be helpful when making your own. 

