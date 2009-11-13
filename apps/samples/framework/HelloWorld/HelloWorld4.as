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
	
	import org.osmf.events.LoadableStateChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.media.URLResource;
	import org.osmf.net.NetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IPlayable;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.LoadState;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;

	/**
	 * Variation on HelloWorld, using MediaElement + IViewable
	 * rather than MediaPlayerSprite.
	 **/
	[SWF(width="640", height="352")]
	public class HelloWorld4 extends Sprite
	{
		public function HelloWorld4()
		{
			var element:MediaElement = new VideoElement
				( new NetLoader
				, new URLResource(new URL(REMOTE_PROGRESSIVE))
				);
			
			var loadable:ILoadable = element.getTrait(MediaTraitType.LOADABLE) as ILoadable;
			loadable.addEventListener(LoadableStateChangeEvent.LOAD_STATE_CHANGE, onReady);
			loadable.load();
			
			function onReady(event:LoadableStateChangeEvent):void
			{
				if (event.loadState == LoadState.READY)
				{
					loadable.removeEventListener(LoadableStateChangeEvent.LOAD_STATE_CHANGE, onReady);
					
					var playable:IPlayable = element.getTrait(MediaTraitType.PLAYABLE) as IPlayable;
					playable.play();
					
					var viewable:IViewable = element.getTrait(MediaTraitType.VIEWABLE) as IViewable;
					addChild(viewable.view);
				}
			}
		}
		
		private static const REMOTE_PROGRESSIVE:String
			= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
	}
}
