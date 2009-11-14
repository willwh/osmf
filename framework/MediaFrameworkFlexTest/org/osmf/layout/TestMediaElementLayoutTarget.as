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
package org.osmf.layout
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.ViewChangeEvent;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.traits.SpatialTrait;
	import org.osmf.traits.ViewableTrait;
	import org.osmf.utils.DynamicMediaElement;

	public class TestMediaElementLayoutTarget extends TestCase
	{
		public function testMediaElementLayoutTarget():void
		{
			assertTrue(throws(function():void{MediaElementLayoutTarget.getInstance(null);}));
			
			var me:MediaElement = new MediaElement();
			var melt:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(me);
			
			melt.updateIntrinsicDimensions();
			
			assertNull(melt.view);
			assertEquals(melt.metadata, me.metadata);
			assertNull(melt.container);
			assertEquals(NaN, melt.calculatedWidth);
			assertEquals(NaN, melt.calculatedHeight);
			assertEquals(NaN, melt.projectedWidth);
			assertEquals(NaN, melt.projectedHeight);
			assertEquals(0, melt.firstChildIndex);
		}
		
		public function testMediaElementLayoutTargetWithViewable():void
		{
			var me:MediaElement = new DynamicMediaElement([MediaTraitType.VIEWABLE, MediaTraitType.SPATIAL]);
			
			var sprite:Sprite = new Sprite();
			var viewable:ViewableTrait
				= ViewableTrait(me.getTrait(MediaTraitType.VIEWABLE));
			viewable.view = sprite;
			
			var spatial:SpatialTrait
				= SpatialTrait(me.getTrait(MediaTraitType.SPATIAL));
			spatial.setDimensions(100,200); 
			
			var lt:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(me);
			
			lt.updateIntrinsicDimensions();
			
			assertEquals(lt.metadata, me.metadata);
			assertEquals(lt.view, sprite);
			assertEquals(lt.intrinsicWidth, 100);
			assertEquals(lt.intrinsicHeight, 200); 
			assertNull(lt.container);
			assertFalse(isNaN(lt.firstChildIndex));
			
			var renderer:ILayoutRenderer = new DefaultLayoutRenderer();
			lt.layoutRenderer = renderer;
			
			// Without a context, the renderer cannot stick:
			assertNull(lt.layoutRenderer);
				
			var lastEvent:Event;
			var eventCounter:int = 0;
			
			function onEvent(event:Event):void
			{
				lastEvent = event;
				eventCounter++;
			}
			
			lt.addEventListener(DimensionEvent.DIMENSION_CHANGE, onEvent);
			lt.addEventListener(ViewChangeEvent.VIEW_CHANGE, onEvent);
			
			var sprite2:Sprite = new Sprite();
			viewable.view = sprite2;
			
			assertEquals(1, eventCounter);
			var vce:ViewChangeEvent = lastEvent as ViewChangeEvent;
			assertNotNull(vce);
			assertEquals(vce.oldView, sprite);
			assertEquals(vce.newView, sprite2);
			
			spatial.setDimensions(300,400);
			
			assertEquals(2, eventCounter);
			var dce:DimensionEvent = lastEvent as DimensionEvent;
			assertNotNull(dce);
			assertEquals(dce.oldWidth, 100);
			assertEquals(dce.oldHeight, 200);
			assertEquals(dce.newWidth, 300);
			assertEquals(dce.newHeight, 400);
		}
		
		public function testSingletonConstruction():void
		{
			var mediaElement:MediaElement = new MediaElement();
			
			var check:Boolean;
			try
			{
				new MediaElementLayoutTarget(null,null);
			}
			catch(e:Error)
			{
				check = true;
			}
			
			assertTrue(check);
			
			var melt:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(mediaElement);
			
			assertNotNull(melt);
			
			assertEquals(melt, MediaElementLayoutTarget.getInstance(mediaElement));
			assertEquals(melt, MediaElementLayoutTarget.getInstance(mediaElement));
		}
		
		private function throws(f:Function):Boolean
		{
			var result:Boolean;
			
			try
			{
				f();
			}
			catch(e:Error)
			{
				result = true;
			}
			
			return result;
		}
	}
}