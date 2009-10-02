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
	
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.media.URLResource;
	import org.osmf.netmocker.MockNetLoader;
	import org.osmf.traits.ILoadable;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SpatialTrait;
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
			(element.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();	
			(element2.getTrait(MediaTraitType.LOADABLE) as ILoadable).load();	
						
			var view:DisplayObject = (element.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;
			var view2:DisplayObject = (element2.getTrait(MediaTraitType.VIEWABLE) as IViewable).view;
			
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
			
			//Make sure the width and height are differrent than the available.
			view2.width = 80;
			view2.height = 80;
			
			sprite.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, onDimensions);
			
			var dimsChanged:Boolean = false;
			
			function onDimensions(event:DimensionChangeEvent):void
			{
				assertFalse(dimsChanged); //call only once
				assertEquals(event.newHeight, 40);
				assertEquals(event.newWidth, 40);
				dimsChanged = true;
			}
			
			sprite.element = element2;
			assertEquals(sprite.element, element2);
			
			//These don't take since the video class throws out the changes to width and height.			
			assertEquals(w, view2.width);
			assertEquals(h, view2.height);
			
			(element2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait).setDimensions( 40, 40);
			
			assertTrue(dimsChanged);			
				
			sprite.element = null;
			
			//Ensure we don't fire again.	
			(element2.getTrait(MediaTraitType.SPATIAL) as SpatialTrait).setDimensions( 40, 40);		
		}
		
		
		
		
	}
}