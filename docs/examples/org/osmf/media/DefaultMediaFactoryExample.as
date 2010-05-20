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
	
	import org.osmf.containers.MediaContainer;

	/**
	 * This example demonstrates how to manually use the DefaultMediaFactory
	 * class to instantiate a video element.
	 */	
	public class DefaultMediaFactoryExample extends Sprite
	{
		public function DefaultMediaFactoryExample()
		{
			// Construct a default media factory:
			var factory:DefaultMediaFactory = new DefaultMediaFactory();
			
			// Request the factory to create a media element that matches the passed URL:
			var media:MediaElement = factory.createMediaElement(new URLResource("http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv"));
			
			// Add a media container, and player to have the constructed VideoElement
			// play back:  
			var mediaContainer:MediaContainer = new MediaContainer();
			addChild(mediaContainer);
			mediaContainer.width = 640;
			mediaContainer.height = 500;
			mediaContainer.addMediaElement(media);
			new MediaPlayer(media);
		}
		
	}
}