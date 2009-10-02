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
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.NullResource;

	public class TesterLayoutTargetSprite extends Sprite implements ILayoutContext
	{
		// ILayoutTarget
		//
		
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		public function get view():DisplayObject
		{
			return this;
		}
		
		public function get container():DisplayObjectContainer
		{
			return this;
		}
		
		public function get firstChildIndex():uint
		{
			return 0;
		}
		
		public function get layoutRenderer():ILayoutRenderer
		{
			return null;
		}
		
		public function set layoutRenderer(value:ILayoutRenderer):void
		{
		}
		
		public function get intrinsicWidth():Number
		{
			return _intrinsicWidth;
		}
		
		public function get intrinsicHeight():Number
		{
			return _intrinsicHeight;
		}
		
		public function updateIntrinsicDimensions():void
		{
		}
		
		public function get calculatedWidth():Number
		{
			return _calculatedWidth;
		}
		
		public function set calculatedWidth(value:Number):void
		{
			_calculatedWidth = value;
		}
		
		public function get calculatedHeight():Number
		{
			return _calculatedHeight;
		}
		
		public function set calculatedHeight(value:Number):void
		{
			_calculatedHeight = value;
		}
		
		public function get projectedWidth():Number
		{
			return _projectedWidth;
		}
		
		public function set projectedWidth(value:Number):void
		{
			_projectedWidth = value;
		}
		
		public function get projectedHeight():Number
		{
			return _projectedHeight;
		}
		
		public function set projectedHeight(value:Number):void
		{
			_projectedHeight = value;
		}
		
		//  Public API
		//
		
		public function setIntrinsicDimensions(width:Number, height:Number):void
		{
			graphics.clear();
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0,0,width,height);
			graphics.endFill();
			
			dispatchEvent
				( new DimensionChangeEvent
					( _intrinsicWidth
					, _intrinsicHeight
					, _intrinsicWidth = width
					, _intrinsicHeight = height
					)
				);	
		}
		
		private var _metadata:Metadata = new Metadata();
		
		private var _layoutRenderer:ILayoutRenderer;
		
		private var _intrinsicWidth:Number;
		private var _intrinsicHeight:Number;
		
		private var _calculatedWidth:Number;
		private var _calculatedHeight:Number;
		
		private var _projectedWidth:Number;
		private var _projectedHeight:Number;
		
	}
}