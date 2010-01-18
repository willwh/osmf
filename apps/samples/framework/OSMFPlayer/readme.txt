The OSMFPlayer sample defines an application that can be embedded on a webpage in order to play back media. It contains a control bar that manages the various supported aspects of the media.

Features:

* SWF preloading progress bar,
* Loading (url parameter can be passed to the SWF, and an Eject button supports manual url entry),
* Play state (play, pause, stop),
* Seeking,
* Volume (increase, decrease)
* Elapsed and remaining play time,
* Multiple Bitrate (toggling between automatic and manual mode),
* Control bar hiding (toggleable, autoHideControlBar parameter can be passed to the SWF),
* Full screen (toggleable),
* Background fill (backgroundColor parameter can be passed to the SWF),
* Debug support (see WebPlayerDebugConsole project for more info),
* Media support for video (streaming, progressive, mbr, live), audio (progressive, streaming), images, SWF, and F4M.

Usage:

The project's html-template\index.template.html file shows how the produced SWF can be embedded (using SWFObject), as well as the properties that can be set on the player SWF.
