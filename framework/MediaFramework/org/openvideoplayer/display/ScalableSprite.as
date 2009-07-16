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
package org.openvideoplayer.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	 
	 /**
	 * ScalableSprite provides a basic DisplayObject based display container for MediaElements.  It contains the basic logic for 
	 * laying out content based on one of the scaleModes.  It will center content if scale more is set to NONE.  See ScaleMode for 
	 * more information on the various scale modes supported.
	 */
	public class ScalableSprite extends Sprite
	{
		/**
		 * Constructor.
		 */
		public function ScalableSprite()
		{
			super();	
			_scaleMode = ScaleMode.LETTERBOX;
		}
						
		/**
		 * The scaleMode property describes different ways of laying out the media content within a this sprite.
		 * There are four modes available, NONE, STRETCH, LETTERBOX and CROP, which are used by the MediaElementSprite. 
		 * See ScaleMode.as for usage examples.
		 */ 			
		public function get scaleMode():ScaleMode
		{
			return _scaleMode;
		}
		
		public function set scaleMode(value:ScaleMode):void
		{
			if(_scaleMode != value)
			{				
				_scaleMode = value;
				updateView(availableWidth, availableHeight);
			}
		}	
	
		/**
		 * This will change the width and height of this container, and relayout the contents.  This method is usually called in response to a 
		 * stage resize or a component resize. This is similar to setting the width and height. 
		 */ 					
		public function setAvailableSize(width:Number, height:Number):void
		{			
			availableWidth = width;
			availableHeight = height;
			updateView(availableWidth, availableHeight);			
		}
		
		/**
		 * Sets the width of this sprite, and updates the layout of the contents.
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
		 * The DisplayObject to be laid out by this container. Sets the initial instrinsicSize of the
		 * view based off of the current measured width and height of the view.
		 */
		public function set view(value:DisplayObject):void
		{
			if (_view)
			{
				removeChild(_view);
			}
			_view = value;
			if (_view)
			{
				addChild(_view);				
				instrinsicWidth = _view.width / _view.scaleX;
				instrinsicHeight = _view.height / _view.scaleY;				
			}
			updateView(availableWidth, availableHeight);			
		}
	
		public function get view():DisplayObject
		{
			return _view;
		}
		
		/**
		 * Updates the prefered size of the view.  This will trigger a layout of the view inside the container.
		 * The intrinsicSize is a preferred size and is not guaranteed unless the scale mode is set to NONE.
		 * See Scale mode for more information on how intrinsic size and avaiable size are used.
		 */
		public function setIntrinsicSize(width:Number, height:Number):void
		{
			instrinsicWidth = width;
			instrinsicHeight = height;
			updateView(availableWidth, availableHeight);
		}
						
		private function updateView(width:Number, height:Number):void
		{			
			if (_view && !isNaN(availableWidth) && !isNaN(availableHeight))						
			{
				var size:Point = _scaleMode.getScaledSize(width, height, instrinsicWidth, instrinsicHeight);		
							
				_view.width = size.x;
				_view.height = size.y;				 
				_view.x = (width - size.x)/2;
				_view.y = (height - size.y)/2;				
			}
		}
				
		private var _view:DisplayObject;
		private var availableWidth:Number = NaN;
		private var availableHeight:Number = NaN;
		private var instrinsicWidth:Number = NaN;
		private var instrinsicHeight:Number = NaN;				
		private var _scaleMode:ScaleMode;		
		
		
	}
}