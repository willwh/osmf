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
package org.osmf.traits
{
	import org.osmf.events.DimensionEvent;

	/**
	 * Dispatched when the width and/or height of the spatial media has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionEvent")]

	/**
	 * The SpatialTrait class provides a base ISpatial implementation. 	 
	 * It can be used as the base class for a more specific spatial trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 * <p>The SpatialTrait class describes the intrinsic dimensions of spatial media
	 * before any processing has been applied. 
	 * Players can use it to determine the size at which to project the media's view,
	 * which can be useful when the dimensions of the media can change.
	 * This can occur, for example, when a bit rate change for dynamic streaming media 
	 * causes a resolution change
	 * or when the active child in a serial composition changes.</p>
	 * 
	 * @ see org.osmf.composition.SerialElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class SpatialTrait extends MediaTraitBase implements ISpatial
	{
		// Public interface
		//
		
		/**
		 * Sets the trait's width and height.
		 * 
		 * <p>Forces non numerical and negative values to zero.</p>
		 * 
		 * <p>If the either the width or the height differs from the
		 * previous width or height, dispatches a dimensionChange event.</p>
		 * 
		 * @param width The new width.
		 * @param height The new height.
		 * 
		 * @see #canProcessDimensionsChange()
		 * @see #processDimensionsChange()
		 * @see #postProcessDimensionsChange()
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		final public function setDimensions(width:Number, height:Number):void
		{
			if	(	width != _width
				||	height != _height
				)
			{
				if (canProcessDimensionsChange(width, height))
				{
					processDimensionsChange(width, height);
					
					var oldWidth:Number = _width;
					var oldHeight:Number = _height;
					
					_width = width;
					_height = height;
					
					postProcessDimensionsChange(oldWidth, oldHeight);
				}
			}
		}
		
		// ISpatial
		//
		
		/**
		 * @inheritDoc
		 **/
		public function get width():Number
		{
			return _width;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get height():Number
		{
			return _height;
		}
	
		// Internals
		//
		
		/**
		 * Called just before <code>setDimensions()</code> is invoked.
		 *  
		 * @param newWidth Proposed new <code>width</code> value.
		 * @param newHeight Proposed new <code>height</code> value.
		 * @return Returns <code>true</code> by default. 
		 * Subclasses that override this method can return <code>false</code> to abort processing. 
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessDimensionsChange(newWidth:Number, newHeight:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called just before a call to <code>setDimensions()</code>. 
		 * Subclasses implement this method to communicate the change to the media.
		 * @param newWidth New <code>width</code> value.
		 * @param newHeight New <code>height</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processDimensionsChange(newWidth:Number, newHeight:Number):void
		{
		}
		
		/**
		 * Called just after <code>setDimensions()</code> has applied new width and/or height
		 * values. Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the dimensionChange event.</p>
		 *  
		 * @param oldWidth Previous <code>width</code> value.
		 * @param oldHeight Previous <code>width</code> value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessDimensionsChange(oldWidth:Number, oldHeight:Number):void
		{
			dispatchEvent(new DimensionEvent(DimensionEvent.DIMENSION_CHANGE, false, false, oldWidth, oldHeight, _width, _height));
		}

		private var _width:Number = 0;
		private var _height:Number = 0;
	}
}