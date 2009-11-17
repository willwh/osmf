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
	import flash.events.IEventDispatcher;
	
	import org.osmf.metadata.Metadata;
	
	/**
	 * Dispatched when a layout target's view has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewEvent")]
	
	/**
	 * Dispatched when a layout target's intrinsical width and/or height changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionEvent")]

	/**
	 * ILayoutTarget defines the interface to the objects that an ILayoutRenderer
	 * implementing instance will be capable of laying out. 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public interface ILayoutTarget extends IEventDispatcher
	{
		/**
		 * A reference to the metadata that is to be used by the ILayoutRenderer
		 * on determining its size and position.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function get metadata():Metadata;
	 
		/**
		 * A reference to the display object that represents the target. An
		 * ILayoutRenderer may use this reference to effect its calculated
		 * values onto the target, as well as correctly parenting the target on
		 * its context's display object container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function get view():DisplayObject;
		
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 1024 pixels. An ILayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 10
	 	 *  @playerversion AIR 1.0
	 	 *  @productversion OSMF 1.0
	 	 */	 	
	 	function get intrinsicWidth():Number;
	 	
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 768 pixels. An ILayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 *  
	 	 *  @langversion 3.0
	 	 *  @playerversion Flash 10
	 	 *  @playerversion AIR 1.0
	 	 *  @productversion OSMF 1.0
	 	 */
	 	function get intrinsicHeight():Number;
	 	
	 	
	}
}