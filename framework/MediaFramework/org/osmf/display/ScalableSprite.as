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
package org.osmf.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	 
	 /**
	 * <code>ScalableSprite</code> provides a basic <code>DisplayObject</code> based display container for <code>MediaElement</code> objects.  
	 * It contains the basic logic for laying out content based on a <code>scaleMode</code>.
	 * Setting <code>scaleMode</code> to <code>NONE</code> centers the content.
     * @see org.osmf.display.ScaleMode
	 */
	public class ScalableSprite extends Sprite
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function ScalableSprite()
		{
			super();
			
			_scaleMode = ScaleMode.LETTERBOX;
		}
						
		/**
		 * The <code>scaleMode</code> property describes different ways of laying out the media content within a this sprite.
		 * <code>scaleMode</code> can be set to <code>none</code>, <code>straetch</code>, <code>letterbox</code> or <code>zoom</code>.
		 * <code>MediaElementSprite</code> uses the value to calculate the layout.
		 * @see org.osmf.display.ScaleMode for usage examples.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 			
		public function get scaleMode():String
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:String):void
		{
			if(_scaleMode != value)
			{				
				_scaleMode = value;
				updateView(availableWidth, availableHeight);
			}
		}	
	
		/**
		 * Changes the width and height of this container, and updates the layout of the contents.  This method is usually called in response to a 
		 * stage resize or a component resize. This is similar to setting the width and height.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 					
		public function setAvailableSize(width:Number, height:Number):void
		{			
			availableWidth = width;
			availableHeight = height;
			updateView(availableWidth, availableHeight);			
		}
		
		/**
		 * Sets the width of this sprite, and updates the layout of the contents.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		override public function set width(value:Number):void
		{
			availableWidth = value;
			updateView(availableWidth, availableHeight);				
		}
		
		override public function get width():Number
		{
			return availableWidth;	
		}	
		
		/**
		 * Sets the height of this sprite, and updates the layout of the contents.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		override public function set height(value:Number):void
		{
			availableHeight = value;
			updateView(availableWidth, availableHeight);					
		}
		
		override public function get height():Number
		{
			return availableHeight;	
		}		
		
		/**
		 * The <code>DisplayObject</code> to be laid out by this container. Sets the initial <code>intrinsicSize</code> of the
		 * view based on the current measured width and height of the view.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function set view(value:DisplayObject):void
		{
			if (_view)
			{
				if (contains(_view))
				{
					removeChild(_view);
				}
			}
			_view = value;
			if (_view)
			{
				addChild(_view);				
				intrinsicWidth = _view.width / _view.scaleX;
				intrinsicHeight = _view.height / _view.scaleY;				
			}
			updateView(availableWidth, availableHeight);			
		}
	
		public function get view():DisplayObject
		{
			return _view;
		}
		
		/**
		 * Sets the preferred size of the view, and updates the layout of the view inside the container
		 * The <code>intrinsicSize</code> is a preferred size and is not guaranteed unless <code>scaleMode</code> is set to <code>NONE</code>.
		 * For more information on how <code>intrinsicSize</code> and the size of the container interact: 
		 * @see org.osmf.display.ScaleMode
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function setIntrinsicSize(width:Number, height:Number):void
		{
			intrinsicWidth = width;
			intrinsicHeight = height;
			updateView(availableWidth, availableHeight);
		}
						
		private function updateView(width:Number, height:Number):void
		{			
			if (_view && !isNaN(availableWidth) && !isNaN(availableHeight))						
			{
				var size:Point = ScaleModeUtils.getScaledSize(_scaleMode, width, height, intrinsicWidth, intrinsicHeight);		
							
				_view.width = size.x;
				_view.height = size.y;				 
				_view.x = (width - size.x)/2;
				_view.y = (height - size.y)/2;				
			}
		}
				
		private var _view:DisplayObject;
		private var availableWidth:Number = NaN;
		private var availableHeight:Number = NaN;
		private var intrinsicWidth:Number = NaN;
		private var intrinsicHeight:Number = NaN;				
		private var _scaleMode:String; // ScaleMode
	}
}