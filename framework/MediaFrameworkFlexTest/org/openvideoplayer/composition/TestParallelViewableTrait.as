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
package org.openvideoplayer.composition
{
	import flash.display.Sprite;
	
	import flexunit.framework.TestCase;
	
	import org.openvideoplayer.gateways.RegionSprite;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.ViewableTrait;
	import org.openvideoplayer.utils.DynamicMediaElement;

	public class TestParallelViewableTrait extends TestCase
	{
		public function testParallelViewableTrait():void
		{
			var parallel:ParallelElement = new ParallelElement();
			
			var me1:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.VIEWABLE] );
			var me1Sprite:Sprite = new Sprite();
			me1Sprite.graphics.drawRect(0,0,100,100);
			ViewableTrait(me1.getTrait(MediaTraitType.VIEWABLE)).view = me1Sprite;
			
			var me2:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.VIEWABLE] );
			var me2Sprite:Sprite = new Sprite();
			me2Sprite.graphics.drawRect(0,0,200,200);
			ViewableTrait(me2.getTrait(MediaTraitType.VIEWABLE)).view = me2Sprite;
			
			var region2:RegionSprite = new RegionSprite();
			me2.gateway = region2;
			
			var me3:DynamicMediaElement = new DynamicMediaElement( [MediaTraitType.VIEWABLE] );
			var me3Sprite:Sprite = new Sprite();
			me3Sprite.graphics.drawRect(0,0,300,300);
			ViewableTrait(me3.getTrait(MediaTraitType.VIEWABLE)).view = me3Sprite;
			
			parallel.addChild(me1);
			parallel.addChild(me2);
			parallel.addChild(me3);
			
			var pvt:ParallelViewableTrait
				= parallel.getTrait(MediaTraitType.VIEWABLE) 
				as ParallelViewableTrait;
				
			assertNotNull(pvt);
			
			pvt.layoutRenderer.validateNow();
			assertEquals(300, pvt.width);
			assertEquals(300, pvt.height);
			
			var region3:RegionSprite = new RegionSprite();
			
			// Assigning me3 to a region should result in its size changing:
			me3.gateway = region3;
			
			pvt.layoutRenderer.validateNow();
			assertEquals(100, pvt.width);
			assertEquals(100, pvt.height);
			
			me2.gateway = null;
			
			pvt.layoutRenderer.validateNow();
			assertEquals(200, pvt.width);
			assertEquals(200, pvt.height);
			
			me3.gateway = null;
			
			pvt.layoutRenderer.validateNow();
			assertEquals(300, pvt.width);
			assertEquals(300, pvt.height);
		}
	}
}