/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The contents of this file are subject to the Mozilla Public License
*  Version 1.1 (the "License"); you may not use this file except in
*  compliance with the License. You may obtain a copy of the License at
*  http://www.mozilla.org/MPL/
*   
*  Software distributed under the License is distributed on an "AS IS"
*  basis, WITHOUT WARRANTY OF ANY KIND, either express or implied. See the
*  License for the specific language governing rights and limitations
*  under the License.
*   
*  
*  The Initial Developer of the Original Code is Adobe Systems Incorporated.
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2009 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package
{
	import flash.display.Sprite;
	
	import org.osmf.display.MediaPlayerSprite;
	import org.osmf.elements.VideoElement;
	import org.osmf.media.URLResource;

	/**
	 * The simplest OSMF application possible.
	 * 
	 * The metadata sets the SWF size to match that of the video.
	 **/
	[SWF(width="640", height="352")]
	public class HelloWorld extends Sprite
	{
		public function HelloWorld()
		{
			// Create the Sprite class that holds our MediaPlayer.
 			var sprite:MediaPlayerSprite = new MediaPlayerSprite();
			addChild(sprite);

			// Create the resource to play.
			var resource:URLResource = new URLResource("http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv");
			
			// Create the MediaElement and set it on the MediaPlayer.  Because
			// autoPlay defaults to true, playback begins immediately.
			sprite.mediaElement = new VideoElement(resource);
		}
	}
}
