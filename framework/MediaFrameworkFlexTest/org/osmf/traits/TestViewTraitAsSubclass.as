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
package org.osmf.traits
{
	import flash.display.Sprite;
	
	import org.osmf.events.ViewEvent;
	import org.osmf.utils.DynamicViewTrait;

	public class TestViewTraitAsSubclass extends TestViewTrait
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new DynamicViewTrait(args.length > 0 ? args[0] : null, args.length > 1 ? args[1] : 0, args.length > 2 ? args[2] : 0);
		}
		
		override public function testView():void
		{
			super.testView();
			
			var dynamicViewTrait:DynamicViewTrait = viewTrait as DynamicViewTrait;
			
			dynamicViewTrait.addEventListener(ViewEvent.VIEW_CHANGE, eventCatcher);

			assertNull(dynamicViewTrait.view);
			
			var displayObject1:Sprite = new Sprite();
			var displayObject2:Sprite = new Sprite();			
			
			dynamicViewTrait.view = displayObject1;
			assertTrue(dynamicViewTrait.view == displayObject1);
			
			dynamicViewTrait.view = displayObject2;
			assertTrue(dynamicViewTrait.view == displayObject2);
			
			// Should not cause a change event:
			dynamicViewTrait.view = displayObject2;
			
			var vce:ViewEvent;
			
			assertTrue(events.length == 2);
			
			vce = events[0] as ViewEvent;
			assertNotNull(vce);
			assertTrue(vce.type == ViewEvent.VIEW_CHANGE);
			assertTrue(vce.oldView == null);
			assertTrue(vce.newView == displayObject1);
			
			vce = events[1] as ViewEvent;
			assertNotNull(vce);
			assertTrue(vce.type == ViewEvent.VIEW_CHANGE);
			assertTrue(vce.oldView == displayObject1);
			assertTrue(vce.newView == displayObject2);
		}
		
		override public function testMediaDimensions():void
		{
			super.testMediaDimensions();
			
			var dynamicViewTrait:DynamicViewTrait = viewTrait as DynamicViewTrait;
			
			dynamicViewTrait.addEventListener(ViewEvent.MEDIA_SIZE_CHANGE, eventCatcher);
			
			// Should not cause a change event:
			dynamicViewTrait.setSize(0, 0);
			
			assertTrue(events.length == 0);
			
			dynamicViewTrait.setSize(30, 60);
			
			assertTrue(events.length == 1);
			
			var dce:ViewEvent = events[0] as ViewEvent;
			assertNotNull(dce);
			assertTrue(dce.type == ViewEvent.MEDIA_SIZE_CHANGE);
			assertTrue(dce.oldWidth == 0);
			assertTrue(dce.oldHeight == 0);
			assertTrue(dce.newWidth == 30);
			assertTrue(dce.newHeight == 60);
		}
	}
}
