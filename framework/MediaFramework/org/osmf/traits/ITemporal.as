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
	
	/**
	 * Dispatched when the <code>duration</code> of the trait has changed.
	 * 
	 * @eventType org.osmf.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.osmf.events.DurationChangeEvent")]
	
	/**
	 * Dispatched when the <code>currentTime</code> of the trait has changed to a value
	 * equal to its <code>duration</code>.
	 * 
	 * @eventType org.osmf.events.TraitEvent.DURATION_REACHED
	 */
	[Event(name="durationReached",type="org.osmf.events.TraitEvent")]
	
	/**
	 * ITemporal defines the trait interface for media that have a duration and
	 * a currentTime.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.TEMPORAL)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.TEMPORAL)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.TEMPORAL)</code> method
	 * to get an object that is guaranteed to implement the ITemporal interface.</p>
	 * <p>Through its MediaElement, an ITemporal trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 */	
	public interface ITemporal extends IMediaTrait
	{
		/**
		 * The duration of the associated media element in
		 * seconds.
		 */		
		function get duration():Number;
		
		/**
		 * The current time of the associated media element's cursor 
		 * in seconds.  Must never exceed the <code>duration</code>.
		 */		
		function get currentTime():Number;
	}
}