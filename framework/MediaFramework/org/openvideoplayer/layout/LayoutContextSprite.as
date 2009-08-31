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
package org.openvideoplayer.layout
{
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.MetadataUtils;

	/**
	 * Dispatched when a layout element's intrinsic width and height changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]
	
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
			
			MetadataUtils.watchFacet
				( _metadata
				, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS
				, absoluteLayoutParametersChangeCallback
				);
		}
		
		// ILayoutContext
		//
		
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
		
		public function updateIntrinsicDimensions():void
		{
			var bounds:Rectangle = getBounds(this);
			var newIntrinsicWidth:Number
				= isNaN(absoluteWidth)
					? (bounds.width || NaN)
					: absoluteWidth;
					
			var newIntrinsicHeight:Number
				= isNaN(absoluteHeight)
					? (bounds.height || NaN)
					: absoluteHeight;
					
			if 	(	(_intrinsicWidth != newIntrinsicWidth)
				||	(_intrinsicHeight != newIntrinsicHeight)  
				)
			{
				var event:DimensionChangeEvent
					= new DimensionChangeEvent
						( _intrinsicWidth, _intrinsicHeight
						, newIntrinsicWidth, newIntrinsicHeight
						);
				
				_intrinsicWidth = newIntrinsicWidth;
				_intrinsicHeight = newIntrinsicHeight;
			
				dispatchEvent(event);	
			}
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
		 * The instance's intrinsic width if availabe, otherwise
		 * the last indicated available width, instead.
		 * 
		 * @inheritDoc
		 */
		public function get intrinsicWidth():Number
		{
			return _intrinsicWidth;
		}
		
		/**
		 * The instance's intrinsic height if availabe, otherwise
		 * the last indicated available height, instead.
		 * 
		 * @inheritDoc
		 */
		public function get intrinsicHeight():Number
		{
			return _intrinsicHeight;
		}
		
		// Internals
		//
		
		private function absoluteLayoutParametersChangeCallback(absolute:AbsoluteLayoutFacet):void
		{
			if	(	absolute
				&&	(	absolute.width != absoluteWidth
					||	absolute.height != absoluteHeight
					)
				)
			{
				var oldWidth:Number = absoluteWidth;
				var oldHeight:Number = absoluteHeight;
				
				_intrinsicWidth = absoluteWidth = absolute.width;
				_intrinsicHeight = absoluteHeight = absolute.height;
				
				dispatchEvent
					( new DimensionChangeEvent
						( oldWidth, oldHeight
						, absoluteWidth, absoluteHeight
						)
					);
			}
		}
		
		private var _metadata:Metadata;
		
		private var absoluteWidth:Number;
		private var absoluteHeight:Number;
		
		private var _intrinsicWidth:Number;
		private var _intrinsicHeight:Number;
	}
}