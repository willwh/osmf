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
	import org.osmf.media.IMediaTrait;
	
	import flash.display.DisplayObject;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewEvent")]

	/**
	 * IViewable defines the trait interface for media that expose a DisplayObject. 
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.VIEWABLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.VIEWABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.VIEWABLE)</code> method
	 * to get an object that is guaranteed to implement the IViewable interface.</p>
	 * <p>Through its MediaElement, an IViewable trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 * @see flash.display.DisplayObject
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public interface IViewable extends IMediaTrait
	{
		/**
		 * DisplayObject representing the viewable media element.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function get view():DisplayObject;
	}
}