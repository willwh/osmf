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
	import org.osmf.metadata.MetadataUtils;

	/**
	 * Dispatched when a layout element's intrinsic width and height changed.
	 * 
	 * @eventType org.osmf.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionChangeEvent")]
	
	/**
	 * LayoutContextSprite defines a Sprite based ILayoutContext implementation.
	 */	
	public class LayoutContextSprite extends Sprite implements ILayoutContext
	{
		/**
		 * Constructor
		 * 
		 * @param metadata The metadata that an ILayoutRenderer may be using on calculating
		 * a layout using this context.
		 */		
		public function LayoutContextSprite(metadata:Metadata=null)
		{
			_metadata = metadata || new Metadata();
		}
		
		// ILayoutTarget
		
		/**
		 * @inheritDoc
		 */
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		/**
		 * A reference to this instance.
		 * 
		 * @inheritDoc
		 */
		public function get view():DisplayObject
		{
			return this;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicWidth():Number
		{
			return _intrinsicWidth;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicHeight():Number
		{
			return _intrinsicHeight;
		}
		
		public function updateIntrinsicDimensions():void
		{
			updateIntrinsicWidth();
			updateIntrinsicHeight();
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get layoutRenderer():ILayoutRenderer
		{
			return _renderer;
		}

		public function set layoutRenderer(value:ILayoutRenderer):void
		{
			_renderer = value;
			_renderer.context = this;
		}
				
		/**
		 * A reference to this instance.
		 * 
		 * @inheritDoc
		 */
		public function get container():DisplayObjectContainer
		{
			return this;
		}
		
		/**
		 * Returns 0, for this context has no children other than the ones placed on
		 * it by the layout renderer.
		 * 
		 * @inheritDoc
		 */		
		public function get firstChildIndex():uint
		{
			return 0;
		}
		
		public function set calculatedWidth(value:Number):void
		{
			_calculatedWidth = value;
			updateIntrinsicWidth();
		}
		public function get calculatedWidth():Number
		{
			return _calculatedWidth;
		}
		
		public function set calculatedHeight(value:Number):void
		{
			_calculatedHeight = value;	
			updateIntrinsicHeight();
		}
		public function get calculatedHeight():Number
		{
			return _calculatedHeight;
		}
		
		public function set projectedWidth(value:Number):void
		{
			_projectedWidth = value;
		}
		public function get projectedWidth():Number
		{
			return _projectedWidth;
		}
		
		public function set projectedHeight(value:Number):void
		{
			_projectedHeight = value;	
			updateIntrinsicHeight();
		}
		public function get projectedHeight():Number
		{
			return _projectedHeight;
		}
		
		
		// Overrides
		//
		
		override public function set width(value:Number):void
		{
			if (_width != value)
			{
				_width = value;
				updateIntrinsicWidth();
			}
		}
		override public function get width():Number
		{
			return _width;
		}
		
		override public function set height(value:Number):void
		{
			if (_height != value)
			{
				_height = value;
				updateIntrinsicHeight();
			}
		}
		override public function get height():Number
		{
			return _height;
		}
		
		// Internals
		//
		
		private function updateIntrinsicWidth():void
		{
			var newIntrinsicWidth:Number = getBounds(this).width;
					
			if (newIntrinsicWidth != _intrinsicWidth)
			{
				var event:DimensionChangeEvent
						= new DimensionChangeEvent
							( _intrinsicWidth	, _intrinsicHeight
							, newIntrinsicWidth	, _intrinsicHeight
							);
							
				_intrinsicWidth = newIntrinsicWidth;
				dispatchEvent(event);
			}
		}
		
		private function updateIntrinsicHeight():void
		{
			var newIntrinsicHeight:Number = getBounds(this).height;
			
			if (newIntrinsicHeight != _intrinsicHeight)
			{
				var event:DimensionChangeEvent
						= new DimensionChangeEvent
							( _intrinsicWidth	, _intrinsicHeight
							, _intrinsicWidth	, newIntrinsicHeight
							);
							
				_intrinsicHeight = newIntrinsicHeight;
				dispatchEvent(event);
			}
		}
		
		private var _metadata:Metadata;
		private var _renderer:ILayoutRenderer;
		
		private var _intrinsicWidth:Number;
		private var _intrinsicHeight:Number;
		
		private var _calculatedWidth:Number;
		private var _calculatedHeight:Number;
		
		private var _projectedWidth:Number;
		private var _projectedHeight:Number;
		
		private var _width:Number;
		private var _height:Number;
		
	}
}