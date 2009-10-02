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
	import flash.display.DisplayObjectContainer;
	
	/**
	 * ILayoutContext defines the interface to the objects that an ILayoutRenderer
	 * implementing instance requires in order to calculate and effect the spatial
	 * characteristics of its targets.
	 * 
	 * An ILayoutContext exposes a container property of type DisplayObjectContainer
	 * that ILayoutRenderer implementing classes may use to stage and unstage their
	 * targets, as well as to manage the z-ordering of their targets.
	 */	
	public interface ILayoutContext extends ILayoutTarget
	{
		/**
		 * Defines the DisplayObjectContainer instance that an ILayoutRenderer class
		 * may use to to stage and unstage their targets, as well as to manage the
		 * z-ordering of their targets.
		 */		
		function get container():DisplayObjectContainer;
		
		/**
		 * Defines the index that the ILayoutRenderer class should use on staging
		 * its first target onto the container. 
		 */		
		function get firstChildIndex():uint;
	
		/**
		 * Defines the layout renderer that manages this target's children (if any).
		 */
		function get layoutRenderer():ILayoutRenderer;
		function set layoutRenderer(value:ILayoutRenderer):void;
		
		/**
		 * Method invoked by an ILayoutRenderer class to inform the context that it
		 * should recalculate its intrinsicWidth and intrinsicHeight fields:
		 */		
		function updateIntrinsicDimensions():void
		
		/**
		 * Defines the context's last calculated width.
		 */
		function get calculatedWidth():Number;
	 	function set calculatedWidth(value:Number):void;
	 	
	 	/**
	 	 * Defines the context's last calculated height.
	 	 */
	 	function get calculatedHeight():Number;
	 	function set calculatedHeight(value:Number):void;
	 	
	 	/**
	 	 * Defines the context's last projected width.
	 	 */
	 	function get projectedWidth():Number;
	 	function set projectedWidth(value:Number):void;
	 	
	 	/**
	 	 * Defines the context's last projected height.
	 	 */
	 	function get projectedHeight():Number;
	 	function set projectedHeight(value:Number):void;
	}
}