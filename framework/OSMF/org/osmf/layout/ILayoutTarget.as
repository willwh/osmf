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
	 * Dispatched when a layout target's intrinsical width and/or height changed.
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
	 	 */	 	
	 	function get layoutRenderer():LayoutRenderer;
	 	
	 	/**
	 	 * Defines the layout renderer that lays out the implementing object.
	 	 */	 	
	 	function get parentLayoutRenderer():LayoutRenderer;
		
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
	 	function get mediaWidth():Number;
	 	
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
	 	function get mediaHeight():Number;
	 	
	 	/**
		 * Method invoked by a LayoutRenderer object to inform the implementation
		 * that it should reasses its mediaWidth and mediaHeight fields:
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
	 	function measureMedia():void;
	 	
	 	/**
		 * Method invoked by a LayoutRenderer object to inform the implementation
		 * that it should update its display to adjust to the given available
		 * width and height.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */	
	 	function updateMediaDisplay(availableWidth:Number, availableHeight:Number):void;
	 	
	 	
	}
}