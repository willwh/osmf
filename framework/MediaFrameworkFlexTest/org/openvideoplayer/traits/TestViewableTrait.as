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
package org.openvideoplayer.traits
{
	import org.openvideoplayer.events.ViewChangeEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	public class TestViewableTrait extends TestIViewable
	{
		override protected function createInterfaceObject(... args):Object
		{
			return new ViewableTrait();
		}
		
		public function testViewAssignment():void
		{
			viewable.addEventListener(ViewChangeEvent.VIEW_CHANGE,eventCatcher);

			assertNull(viewable.view);
			
			var displayObject1:DisplayObject = new Sprite();
			var displayObject2:DisplayObject = new Sprite();			
			
			viewableTraitBase.view = displayObject1;
			assertTrue(viewable.view == displayObject1);
			
			viewableTraitBase.view = displayObject2;
			assertTrue(viewable.view == displayObject2);
			
			// Should not cause a change event:
			viewableTraitBase.view = displayObject2;
			
			var vce:ViewChangeEvent;
			
			assertTrue(events.length == 2);
			
			vce = events[0] as ViewChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldView == null);
			assertTrue(vce.newView == displayObject1);
			
			vce = events[1] as ViewChangeEvent;
			assertNotNull(vce);
			assertTrue(vce.oldView == displayObject1);
			assertTrue(vce.newView == displayObject2);
		}
		
		// Utils
		//
		
		protected function get viewableTraitBase():ViewableTrait
		{
			return viewable as ViewableTrait;
		}
		
	}
}