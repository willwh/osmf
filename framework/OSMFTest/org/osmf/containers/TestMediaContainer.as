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
package org.osmf.containers
{
	import flash.display.Sprite;
	import flash.errors.IllegalOperationError;
	
	import flexunit.framework.TestCase;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.TesterSprite;
	import org.osmf.layout.VerticalAlign;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectFacet;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.DynamicMediaElement;

	public class TestMediaContainer extends TestCase
	{
		public function constructContainer():MediaContainer
		{
			return new MediaContainer();
		}
		
		public function testContainerElements():void
		{
			var parent:MediaContainer = constructContainer();
			parent.backgroundColor = 0xff0000;
			parent.backgroundAlpha = 1;
			parent.clipChildren = true;
			
			var element1:DynamicMediaElement = new DynamicMediaElement();
			var element2:DynamicMediaElement = new DynamicMediaElement();
			
			assertNotNull(parent);
			assertFalse(parent.containsMediaElement(element1));
			assertFalse(parent.containsMediaElement(element2));
			
			parent.addMediaElement(element1);
			assertTrue(parent.containsMediaElement(element1));
			
			parent.addMediaElement(element2);
			assertTrue(parent.containsMediaElement(element2));
			
			assertTrue(element1 == parent.removeMediaElement(element1));
			assertFalse(parent.containsMediaElement(element1));
			
			var error:Error;
			try
			{
				parent.removeMediaElement(element1);
			}
			catch(e:Error)
			{
				error = e;
			}
			
			assertNotNull(error);
			assertTrue(error is IllegalOperationError);
		}
		
		public function testContainerScaleAndAlign():void
		{
			// Child
			
			var mediaElement:DynamicMediaElement = new DynamicMediaElement();
			
			setElementId(mediaElement.metadata,"mediaElement");
			
			var viewSprite:Sprite = new TesterSprite();
			var viewTrait:DisplayObjectTrait = new DisplayObjectTrait(viewSprite, 486, 60);
			mediaElement.doAddTrait(MediaTraitType.DISPLAY_OBJECT, viewTrait);
			var layout:LayoutRendererProperties = new LayoutRendererProperties(mediaElement);
			layout.scaleMode = ScaleMode.NONE;
			layout.verticalAlign = VerticalAlign.MIDDLE;
			layout.horizontalAlign = HorizontalAlign.CENTER;
			
			var container:MediaContainer = constructContainer();
			container.width = 800;
			container.height = 80;
			
			container.addMediaElement(mediaElement);
			
			container.validateNow();
			
			assertEquals(486, viewSprite.width);
			assertEquals(60, viewSprite.height);
			
			assertEquals(800/2 - 486/2, viewSprite.x);
			assertEquals(80/2 - 60/2, viewSprite.y);
		}
		
		public function testContainerAttributes():void
		{
			var container:MediaContainer = constructContainer();
			container.width = 500;
			container.height = 400;
			
			assertEquals(NaN,container.backgroundColor);
			assertEquals(NaN,container.backgroundAlpha);
			
			container.backgroundColor = 0xFF00FF;
			assertEquals(0xFF00FF, container.backgroundColor);
			
			container.backgroundAlpha = 0.5;
			assertEquals(0.5, container.backgroundAlpha);
			
			assertFalse(container.clipChildren);
			container.clipChildren = true;
			assertTrue(container.clipChildren);
			
			container.validateNow();
			assertEquals(500, container.width);
			assertEquals(400, container.height);
		}

		private function setElementId(target:Metadata, id:String):void
		{
			target.addFacet(new ObjectFacet(MetadataNamespaces.ELEMENT_ID, id));
		}
	}
}