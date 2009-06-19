/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.display
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	 
	 /**
	 * ScalableSprite provides a basic Sprite based display container for mediaElements.  It contains the basic logic for 
	 * laying out content based on one of the scaleModes.
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
		 * The setAvailableSize method will size the content of this Mediaelement to match the width and height specified.  This method
		 * is usually called in response to a stage resize or a component resize.
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
		 * Called to notify the displayobject to be laid out by this container. Sets the instrinsicSize of the sprite based off of the 
		 * current width and height of the view sprite.
		 */
		public function set view(value:DisplayObject):void
		{
			if(_view)
			{
				removeChild(_view);
			}
			_view = value;
			if(_view)
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
		 * Called by subclasses to notify the prefered size of the content.
		 */
		public function setIntrinsicSize(width:Number, height:Number):void
		{
			instrinsicWidth = width;
			instrinsicHeight = height;
			updateView(availableWidth, availableHeight);
		}
						
		private function updateView(width:Number, height:Number):void
		{			
			if(_view && !isNaN(availableWidth) && !isNaN(availableHeight))						
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