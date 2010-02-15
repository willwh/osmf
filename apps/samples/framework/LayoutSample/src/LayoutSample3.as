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

package
{
	import flash.display.Sprite;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.layout.HorizontalAlign;
	import org.osmf.layout.LayoutMode;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutRendererProperties;
	import org.osmf.layout.LayoutTargetSprite;

	[SWF(backgroundColor="0x000000", frameRate="25", width="640", height="360")]
	public class LayoutSample3 extends Sprite
	{
		public function LayoutSample3()
		{
			// Construct a layout renderer:
			var renderer:LayoutRenderer = new LayoutRenderer();
			
			// Add some targets to the renderer:
			renderer.addTarget(constructBall(0xC89B41));
			renderer.addTarget(constructBall(0xA16B2B));
			var ball3:LayoutTargetSprite = constructBall(0x77312B);
			renderer.addTarget(ball3);
			
			// Set some extra layout properties on ball3: since it got
			// added to a renderer without any layout properties set,
			// it is now defaulting to 100% width and height, letterbox
			// scaled, and centering. Let's change this:
			var ball3Layout:LayoutRendererProperties = new LayoutRendererProperties(ball3);
			ball3Layout.percentWidth = 100;
			ball3Layout.percentHeight = 50;
			ball3Layout.scaleMode = ScaleMode.STRETCH;
			
			// Construct a layout target sprite that the renderer
			// can use as its container:
			var container:LayoutTargetSprite = new LayoutTargetSprite();
			container.width = 640;
			container.height = 360;
			renderer.container = container;
			addChild(container);
			
			// Set the container to operate in VERTICAL layoutMode:
			var containerLayout:LayoutRendererProperties = new LayoutRendererProperties(container);
			containerLayout.layoutMode = LayoutMode.VERTICAL;
			containerLayout.horizontalAlign = HorizontalAlign.CENTER;
			
			// Add a child container/renderer pair, and add targets
			// to it too:
			var renderer2:LayoutRenderer = new LayoutRenderer();
			renderer2.addTarget(constructBall(0x1C2331));
			renderer2.addTarget(constructBall(0x152C52));
			
			var container2:LayoutTargetSprite = new LayoutTargetSprite();
			var container2Layout:LayoutRendererProperties = new LayoutRendererProperties(container2);
			container2Layout.layoutMode = LayoutMode.HORIZONTAL;
			container2Layout.horizontalAlign = HorizontalAlign.CENTER;
			// By default, items appear in the order that they were added to
			// the renderer. By setting an we override the order: 
			container2Layout.index = -1;
			renderer2.container = container2;
			renderer.addTarget(container2);
			
		}
		
		private function constructBall(color:uint):LayoutTargetSprite
		{
			// Construct a layout target sprite (a Sprite that implements
			// the ILayoutTarget interface):
			var result:LayoutTargetSprite = new LayoutTargetSprite();
			
			// Draw a circle: 
			result.graphics.beginFill(color);
			result.graphics.drawCircle(100,100,100);
			result.graphics.endFill();
			
			return result;
		}
	}
}