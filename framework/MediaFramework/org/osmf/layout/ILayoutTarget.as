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
	 * @eventType org.osmf.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewChangeEvent")]
	
	/**
	 * Dispatched when a layout target's intrinsical width and/or height changed.
	 * 
	 * @eventType org.osmf.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionChangeEvent")]

	/**
	 * ILayoutTarget defines the interface to the objects that an ILayoutRenderer
	 * implementing instance will be capable of laying out. 
	 */	
	public interface ILayoutTarget extends IEventDispatcher
	{
		/**
		 * A reference to the metadata that is to be used by the ILayoutRenderer
		 * on determining its size and position.
		 */		
		function get metadata():Metadata;
	 
		/**
		 * A reference to the display object that represents the target. An
		 * ILayoutRenderer may use this reference to effect its calculated
		 * values onto the target, as well as correctly parenting the target on
		 * its context's display object container.
		 */		
		function get view():DisplayObject;
		
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 1024 pixels. An ILayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 */	 	
	 	function get intrinsicWidth():Number;
	 	
	 	/**
	 	 * Defines the width of the element without any transformations being
	 	 * applied. For a JPG with an original resolution of 1024x768, this
	 	 * would be 768 pixels. An ILayoutRenderer may use this value to
	 	 * for example keep ratio on scaling the element.
	 	 */
	 	function get intrinsicHeight():Number;
	 	
	 	
	}
}