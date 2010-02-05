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
	import org.osmf.logging.ILogger;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.utils.ExternalProperty;

	/**
	 * Dispatched when a layout element's media width and height changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.MEDIA_SIZE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mediaSizeChange",type="org.osmf.events.DisplayObjectEvent")]
	
	/**
	 * Dispatched when a layout target's layoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="layoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]
	
	/**
	 * Dispatched when a layout target's parentLayoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.PARENT_LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="parentLayoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]

	/**
	 * LayoutContextSprite defines a Sprite based ILayoutContext implementation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class LayoutTargetSprite extends Sprite implements ILayoutTarget
	{
		/**
		 * Constructor
		 * 
		 * @param metadata The metadata that an LayoutRenderer may be using on calculating
		 * a layout using this context.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function LayoutTargetSprite(metadata:Metadata=null)
		{
			_metadata = metadata || new Metadata();
			
			_layoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE);
			_parentLayoutRenderer = new ExternalProperty(this, LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE);
			
			super();
			
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		// ILayoutTarget
		
		/**
		 * @private
		 */
		public function get metadata():Metadata
		{
			return _metadata;
		}
		
		/**
		 * A reference to this instance.
		 * 
		 * @private
		 */
		public function get displayObject():DisplayObject
		{
			return this;
		}
		
		/**
		 * @private
		 */
		public function get measuredWidth():Number
		{
			return _measuredWidth;
		}
		
		/**
		 * @private
		 */
		public function get measuredHeight():Number
		{
			return _measuredHeight;
		}
		
		/**
		 * @private
		 */	
		public function measure():void
		{
			var newMediaWidth:Number;
			var newMediaHeight:Number;
			
			var layoutRenderer:LayoutRendererBase = _layoutRenderer.value as LayoutRendererBase;
			
			if (layoutRenderer)
			{
				// The measured dimensions can be fetched from the sprite's own
				// layout renderer. Since measurement takes place bottom to top,
				// the renderer should already be up to date for this pass:
				newMediaWidth = layoutRenderer.measuredWidth;
				newMediaHeight = layoutRenderer.measuredHeight;
			}
			else
			{
				// The sprite is a leaf. Fetch the size from the sprite itself:
				newMediaWidth = super.width / scaleX;
				newMediaHeight = super.height / scaleY;
			}
				
			if 	(	newMediaWidth != _measuredWidth
				||	newMediaHeight != _measuredHeight
				)
			{
				var event:DisplayObjectEvent
						= new DisplayObjectEvent
							( DisplayObjectEvent.MEDIA_SIZE_CHANGE, false, false
							, null			, null
							, _measuredWidth	, _measuredHeight
							, newMediaWidth	, newMediaHeight
							);
							
				_measuredWidth = newMediaWidth;
				_measuredHeight = newMediaHeight;
				
				dispatchEvent(event);
			}
		}
	 	
	 	/**
		 * @private
		 */
	 	public function layout(availableWidth:Number, availableHeight:Number):void
	 	{
	 		if (_layoutRenderer.value == null)
	 		{
	 			super.width = availableWidth;
	 			super.height = availableHeight;
	 		}
	 		else
	 		{
	 			// Nothing to do: our children get resized by the layout renderer.
	 		}
	 	}
	 	
	 	/**
		 * @private
		 */		
		public function get layoutRenderer():LayoutRendererBase
		{
			return _layoutRenderer.value as LayoutRendererBase;
		}
		
		/**
		 * @private
		 */		
		public function get parentLayoutRenderer():LayoutRendererBase
		{
			return _parentLayoutRenderer.value as LayoutRendererBase;
		}
		
		// Overrides
		//
		
		override public function set width(value:Number):void
		{
			new LayoutProperties(this).width = value; 
		}
		override public function get width():Number
		{
			return _measuredWidth;
		}
		
		override public function set height(value:Number):void
		{
			new LayoutProperties(this).height = value; 
		}
		override public function get height():Number
		{
			return _measuredHeight;
		}
		
		// Internals
		//
		
		private var _metadata:Metadata;
		private var _layoutRenderer:ExternalProperty
		private var _parentLayoutRenderer:ExternalProperty;
		
		private var _measuredWidth:Number = NaN;
		private var _measuredHeight:Number = NaN;
		
		private var _width:Number;
		private var _height:Number;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("LayoutTargetSprite");
	}
}