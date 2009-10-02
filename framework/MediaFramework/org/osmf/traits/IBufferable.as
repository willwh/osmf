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
	 * Dispatched when the trait's <code>buffering</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferingChangeEvent.BUFFERING_CHANGE
	 */
	[Event(name="bufferingChange",type="org.osmf.events.BufferingChangeEvent")]
	
	/**
	 * Dispatched when the trait's <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferTimeChangeEvent.BUFFER_TIME_CHANGE
	 */
	[Event(name="bufferTimeChange",type="org.osmf.events.BufferTimeChangeEvent")]
	
	/**
	 * IBufferable defines the trait interface for media that can use a data buffer.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.BUFFERABLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.BUFFERABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.BUFFERABLE)</code> method
	 * to get an object that is guaranteed to implement the IBufferable interface.</p>
	 * <p>Through its MediaElement, an IBufferable trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement 
	 */	
	public interface IBufferable extends IMediaTrait
	{
		/**
		 * Indicates whether the media is currently buffering.
		 * 
		 * <p>The default is <code>false</code>.</p>
		 */		
		function get buffering():Boolean;
		
		/**
		 * The length of the content currently in the media's
		 * buffer in seconds. 
		 */		
		function get bufferLength():Number;
		
		/**
		 * The desired length of the media's buffer in seconds.
		 * 
		 * <p>If the passed value is not numerical or negative, it
		 * is forced to zero.</p>
		 * 
		 * <p>The default is zero.</p> 
		 */		
		function get bufferTime():Number;
		function set bufferTime(value:Number):void;
	}
}