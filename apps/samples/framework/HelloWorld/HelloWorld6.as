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
	
	import org.openvideoplayer.display.MediaElementSprite;
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.net.NetLoader;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.IPlayable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.URL;
	import org.openvideoplayer.video.VideoElement;

	/**
	 * Variation on HelloWorld, using MediaElementSprite
	 * rather than MediaPlayerSprite.
	 **/
	[SWF(width="640", height="352")]
	public class HelloWorld6 extends Sprite
	{
		public function HelloWorld6()
		{
 			var sprite:MediaElementSprite = new MediaElementSprite();
			addChild(sprite);
			
			sprite.element = new VideoElement
				( new NetLoader
				, new URLResource(new URL(REMOTE_PROGRESSIVE))
				);
			
			var loadable:ILoadable = sprite.element.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadable.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);
			loadable.load();
			
			function onLoaded(event:LoadableStateChangeEvent):void
			{
				if (event.newState == LoadState.LOADED)
				{
					loadable.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoaded);
					
					var playable:IPlayable = sprite.element.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					playable.play();
				}
			}
		}
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
	}
}
