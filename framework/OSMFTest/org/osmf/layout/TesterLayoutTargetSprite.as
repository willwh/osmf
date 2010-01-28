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
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.ExternalProperty;

	public class TesterLayoutTargetSprite extends Sprite implements ILayoutTarget
	{
		// ILayoutTarget
		//
		
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		public function get layoutRenderer():LayoutRenderer
		{
			return _layoutRenderer.value as LayoutRenderer;
		}
		
		public function get parentLayoutRenderer():LayoutRenderer
		{
			return _parentLayoutRenderer.value as LayoutRenderer;
		}
		
		public function get mediaWidth():Number
		{
			return _mediaWidth;
		}
		
		public function get mediaHeight():Number
		{
			return _mediaHeight;
		}
		
		public function measureMedia():void
		{
			//
		}
		
		public function updateMediaDisplay(availableWidth:Number, availableHeight:Number):void
		{
			width = availableWidth;
			height = availableHeight;
		}
		
		//  Public API
		//
		
		public function TesterLayoutTargetSprite()
		{
			_layoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE);
			_parentLayoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE);
			
			super();
		}
		
		public function setIntrinsicDimensions(width:Number, height:Number):void
		{
			graphics.clear();
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, width, height);
			graphics.endFill();
			
			dispatchEvent
				( new DisplayObjectEvent
					( DisplayObjectEvent.MEDIA_SIZE_CHANGE, false, false
					, null, null
					, _mediaWidth
					, _mediaHeight
					, _mediaWidth = width
					, _mediaHeight = height
					)
				);	
		}
		
		private var _metadata:Metadata = new Metadata();
		
		private var _layoutRenderer:ExternalProperty;
		private var _parentLayoutRenderer:ExternalProperty;
		
		private var _mediaWidth:Number;
		private var _mediaHeight:Number;
		
	}
}