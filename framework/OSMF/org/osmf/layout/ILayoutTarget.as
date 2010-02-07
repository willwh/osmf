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
	import flash.events.IEventDispatcher;
	
	import org.osmf.metadata.IMetadataProvider;
	
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
	 * ILayoutTarget defines the interface to the objects that an LayoutRenderer
	 * implementing instance will be capable of laying out. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public interface ILayoutTarget extends IEventDispatcher, IMetadataProvider
	{
		/**
		 * A reference to the display object that represents the target. A
		 * LayoutRenderer object may use this reference to position the target,
		 * as well as to correctly parent the target on its context's display
		 * object container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		function get displayObject():DisplayObject;
		
		/**
	 	 * Defines the layout renderer that the implementing object uses to render
	 	 * its children. Can be null.
	 	function get layoutRenderer():LayoutRendererBase;
	 	 */	 	
	 	
	 	/**
	 	 * Defines the layout renderer that lays out the implementing object.
	 	function get parentLayoutRenderer():LayoutRendererBase;
	 	 */	 	
		
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 1024 pixels. An LayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 10
	 	 *  @playerversion AIR 1.5
	 	 *  @productversion OSMF 1.0
	 	 */	 	
	 	function get measuredWidth():Number;
	 	
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 768 pixels. An LayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 10
	 	 *  @playerversion AIR 1.5
	 	 *  @productversion OSMF 1.0
	 	 */
	 	function get measuredHeight():Number;
	 	
	 	/**
		 * Method invoked by a LayoutRenderer object to inform the implementation
		 * that it should reasses its measuredWidth and measuredHeight fields:
		 * 
		 * @param deep True if the measurement request is to be forwarded to
		 * the target's potential associated layout renderer (if the target
		 * implementation is a container). The forwarding should take place before
		 * the target measures itself.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
	 	function measure(deep:Boolean = true):void;
	 	
	 	/**
		 * Method invoked by a LayoutRenderer object to inform the implementation
		 * that it should update its display to adjust to the given available
		 * width and height.
		 *  
	 	 * @param availableWidth
	 	 * @param availableHeight
	 	 * @param deep True if the layout request is to be forwarded to
		 * the target's potential associated layout renderer (if the target
		 * implementation is a container). The forwarding should take place
		 * after the target lays itself out.
	 	 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
	 	function layout(availableWidth:Number, availableHeight:Number, deep:Boolean = true):void;
	}
}