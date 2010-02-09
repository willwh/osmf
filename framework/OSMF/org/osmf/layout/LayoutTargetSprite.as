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

	/**
	 * Dispatched when a layout target's view has changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="displayObjectChange",type="org.osmf.events.DisplayObjectEvent")]

	/**
	 * Dispatched when a layout element's measured width and height changed.
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
	 * Dispatched when a layout target is being set as a layout renderer's container.
	 *
	 * LayoutRendererBase dispatches this event on the target being set as its container.
	 * 
	 * Implementations that are to be used as layout renderer containers are required
	 * to listen to the event in order to maintain a reference to their layout
	 * renderer, so it can be correctly parented on the container becoming a child
	 * of another container.
	 *  
	 * @eventType org.osmf.layout.LayoutTargetEvent.SET_AS_LAYOUT_RENDERER_CONTAINER
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="setAsLayoutRendererContainer",type="org.osmf.layout.LayoutTargetEvent")]
	
	/**
	 * Dispatched when a layout target is being un-set as a layout renderer's container.
	 * 
	 * LayoutRendererBase dispatches this event on the target being unset as its container.
	 * 
	 * Implementations that are to be used as layout renderer containers are required
	 * to listen to the event in order to reset the reference to their layout renderer. 
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.UNSET_AS_LAYOUT_RENDERER_CONTAINER
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="unsetAsLayoutRendererContainer",type="org.osmf.layout.LayoutTargetEvent")]
	
	/**
	 * Dispatched when a layout target is added as a target to a layout renderer.
	 * 
	 * LayoutRendererBase dispatches this event on a target when it gets added to
	 * its list of targets.
	 * 
	 * Implementations that are to be used as layout renderer containers
	 * are required to listen to the event in order to invoke <code>setParent</code>
	 * on the renderer that they are the container for.
	 * 
	 * Failing to do so will break the rendering tree, resulting in unneccasary
	 * layout recalculations, as well as unexpected size and positioning of the target.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.ADD_TO_LAYOUT_RENDERER
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="addToLayoutRenderer",type="org.osmf.layout.LayoutTargetEvent")]

	/**
	 * Dispatched when a layout target is removed as a target from a layout renderer.
	 * 
	 * LayoutRendererBase dispatches this event on a target when it gets removed from
	 * its list of targets.
	 *
	 * Implementations that are to be used as layout renderer containers
	 * are required to listen to the event in order to invoke <code>setParent</code>
	 * on the renderer that they are the container for. In case of removal, the
	 * parent should be set to null, unless the target has already been assigned
	 * as the container of another renderer.
	 * 
	 * Failing to do so will break the rendering tree, resulting in unneccasary
	 * layout recalculations, as well as unexpected size and positioning of the target.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.REMOVE_FROM_LAYOUT_RENDERER
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="removeFromLayoutRenderer",type="org.osmf.layout.LayoutTargetEvent")]

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
			
			renderers = new LayoutTargetRenderers(this);
			
			mouseEnabled = true;
			mouseChildren = true;
			
			super();
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
		public function measure(deep:Boolean = true):void
		{
			if (deep && renderers.containerRenderer)
			{
				renderers.containerRenderer.measure();
			}
			
			var newMeasuredWidth:Number;
			var newMeasuredHeight:Number;
			
			if (renderers.containerRenderer)
			{
				// The measured dimensions can be fetched from the sprite's own
				// layout renderer. Since measurement takes place bottom to top,
				// the renderer should already be up to date for this pass:
				newMeasuredWidth = renderers.containerRenderer.measuredWidth;
				newMeasuredHeight = renderers.containerRenderer.measuredHeight;
			}
			else
			{
				// The sprite is a leaf. Fetch the size from the sprite itself:
				newMeasuredWidth = super.width / scaleX;
				newMeasuredHeight = super.height / scaleY;
			}
				
			if 	(	newMeasuredWidth != _measuredWidth
				||	newMeasuredHeight != _measuredHeight
				)
			{
				var event:DisplayObjectEvent
						= new DisplayObjectEvent
							( DisplayObjectEvent.MEDIA_SIZE_CHANGE, false, false
							, null			, null
							, _measuredWidth	, _measuredHeight
							, newMeasuredWidth	, newMeasuredHeight
							);
							
				_measuredWidth = newMeasuredWidth;
				_measuredHeight = newMeasuredHeight;
				
				dispatchEvent(event);
			}
		}
		
		/**
		 * @private
		 */
		public function validateNow():void
		{
			if (renderers.containerRenderer)
			{
				renderers.containerRenderer.validateNow();
			}
		}
	 	
	 	/**
		 * @private
		 */
	 	public function layout(availableWidth:Number, availableHeight:Number, deep:Boolean = true):void
	 	{
	 		if (renderers.containerRenderer == null)
	 		{
	 			super.width = availableWidth;
	 			super.height = availableHeight;
	 		}
	 		else if (deep)
	 		{
	 			renderers.containerRenderer.layout(availableWidth, availableHeight);
	 		}
	 	}
	 	
	 	// Overrides
		//
		
		/**
		 * @private
		 **/
		override public function set width(value:Number):void
		{
			new LayoutRendererProperties(this).width = value; 
		}
		override public function get width():Number
		{
			return _measuredWidth;
		}
		
		/**
		 * @private
		 **/
		override public function set height(value:Number):void
		{
			new LayoutRendererProperties(this).height = value; 
		}
		override public function get height():Number
		{
			return _measuredHeight;
		}
		
		// Internals
		//
		
		/**
		 * @private
		 * 
		 * This method is provided internally for the sole purpose of being
		 * able to set the parent of the targetting layout renderer in case
		 * it is the display object of a media element's display object
		 * trait.
		 * 
		 * @return
		 */		
		internal function getContainerRenderer():LayoutRendererBase
		{
			return renderers.containerRenderer;
		}
		
		// Private
		//
		
		private var _metadata:Metadata;
		
		private var renderers:LayoutTargetRenderers;
		
		private var _measuredWidth:Number = NaN;
		private var _measuredHeight:Number = NaN;
		
		/* static */
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("LayoutTargetSprite");
	}
}