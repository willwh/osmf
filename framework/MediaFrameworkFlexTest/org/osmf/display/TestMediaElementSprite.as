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
package org.osmf.display
{
	import flash.display.DisplayObject;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.ViewEvent;
	import org.osmf.media.URLResource;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.traits.LoadTrait;
	import org.osmf.traits.ViewTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.URL;
	import org.osmf.video.VideoElement;
	import org.osmf.utils.URL;

	public class TestMediaElementSprite extends TestCase
	{
		public function testView():void
		{
			var sprite:MediaElementSprite = new MediaElementSprite();
			var element:VideoElement = new VideoElement(new MockNetLoader(), new URLResource(new URL("http://example.com/")));
			var element2:VideoElement = new VideoElement(new MockNetLoader(), new URLResource(new URL("http://example.com/")));
			
			sprite.element = element;
			(element.getTrait(MediaTraitType.LOAD) as LoadTrait).load();	
			(element2.getTrait(MediaTraitType.LOAD) as LoadTrait).load();	
						
			var view:DisplayObject = (element.getTrait(MediaTraitType.VIEW) as ViewTrait).view;
			var view2:DisplayObject = (element2.getTrait(MediaTraitType.VIEW) as ViewTrait).view;
			
			var w:Number = 300;
			var h:Number = 225;
			sprite.setAvailableSize(w, h);
			
			assertEquals(w, view.width);
			assertEquals(h, view.height);
			
			w = 500;
			h = 375;
			sprite.setAvailableSize(w, h);
			
			assertEquals(w, view.width);
			assertEquals(h, view.height);	
			
			// Make sure the width and height are differrent than the available.
			view2.width = 80;
			view2.height = 80;
			
			sprite.addEventListener(ViewEvent.MEDIA_SIZE_CHANGE, onMediaSize);
			
			var dimsChanged:Boolean = false;
			
			function onMediaSize(event:ViewEvent):void
			{
				assertFalse(dimsChanged); //call only once
				assertEquals(event.newHeight, 40);
				assertEquals(event.newWidth, 40);
				dimsChanged = true;
			}
			
			sprite.element = element2;
			assertEquals(sprite.element, element2);
			
			// These don't take since the video class throws out the changes to width and height.			
			assertEquals(w, view2.width);
			assertEquals(h, view2.height);
		}
	}
}