/*****************************************************
*  
*  Copyright 2010 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2010 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/

package org.osmf.media
{
	import flash.display.Sprite;
	
	import org.osmf.events.MediaFactoryEvent;

	/**
	 * This sample demonstrates how MediaFactory can be used to load a plug-in. Note
	 * that the sample uses a mock-up plug-in URL.
	 */
	public class MediaFactoryExample extends Sprite
	{
		public function MediaFactoryExample()
		{
			// Construct a media factory, and listen to its plug-in related events:
			var factory:MediaFactory = new MediaFactory();
			factory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD, onPluginLoaded);
			factory.addEventListener(MediaFactoryEvent.PLUGIN_LOAD_ERROR, onPluginLoadError);
			
			// Instruct the factory to load the plug-in at the given url:
			factory.loadPlugin(new URLResource("http://myinvalidurl.com/foo.swf"));		
		}
	
		private function onPluginLoaded(event:MediaFactoryEvent):void
		{
			// Use the factory to create a media-element related to the plugin:
			var factory:MediaFactory = event.target as MediaFactory;
			factory.createMediaElement(new URLResource("http://myinvalidurl.com/content"));
		}
		
		private function onPluginLoadError(event:MediaFactoryEvent):void
		{
			// Handle plug-in loading failure:
			trace("Plugin failed to load.");	
		}	
	}
}