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
package org.osmf.composition
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.displayObjectTrait;
	import org.osmf.utils.DynamicMediaElement;

	public class TestSerialdisplayObjectTrait extends TestCase
	{
		public function testSerialdisplayObjectTrait():void
		{
			var serial:SerialElement = new SerialElement();
			
			var me1:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.DISPLAY_OBJECTABLE] );
			var me1Sprite:Sprite = new Sprite();
			me1Sprite.graphics.drawRect(0,0,100,100);
			displayObjectTrait(me1.getTrait(MediaTraitType.DISPLAY_OBJECTABLE)).view = me1Sprite;
			
			var me2:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.DISPLAY_OBJECTABLE] );
			var me2Sprite:Sprite = new Sprite();
			me2Sprite.graphics.drawRect(0,0,200,200);
			displayObjectTrait(me2.getTrait(MediaTraitType.DISPLAY_OBJECTABLE)).view = me2Sprite;
			
			var me3:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.DISPLAY_OBJECTABLE] );
			var me3Sprite:Sprite = new Sprite();
			me3Sprite.graphics.drawRect(0,0,300,300);
			displayObjectTrait(me3.getTrait(MediaTraitType.DISPLAY_OBJECTABLE)).view = me3Sprite;
			
			serial.addChild(me1);
			serial.addChild(me2);
			
			var svt:SerialdisplayObjectTrait = serial.getTrait(MediaTraitType.DISPLAY_OBJECTABLE) as SerialViewableTrait;
			assertNotNull(svt);
			
			svt.layoutRenderer.validateNow();
			assertEquals(100, svt.width);
			assertEquals(100, svt.height);
			
			// Making me1 go to a container should change the dimension:
			var region:MediaContainer = new MediaContainer();
			me1.container = region;
			
			// With me1 out, we should be 0x0 - our view being ignored.
			svt.layoutRenderer.validateNow();
			assertEquals(0, svt.width);
			assertEquals(0, svt.height);
			
			// Removing the facet should restore our dimensions:
			me1.container = null;
			
			svt.layoutRenderer.validateNow();
			assertEquals(100, svt.width);
			assertEquals(100, svt.height);
			
			me3.container = region;
			serial.addChild(me3);
			
			// Poor man's way of changing the active child:
			serial.removeChild(me1);
			serial.removeChild(me2);
			
			svt.layoutRenderer.validateNow();
			assertEquals(0, svt.width);
			assertEquals(0, svt.height);
		}
	}
}