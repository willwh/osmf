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
	 * Dispatched when this trait's <code>seeking</code> property changes.
	 * 
	 * @eventType org.osmf.events.SeekingChangeEvent.SEEKING_CHANGE
	 */
	[Event(name="seekingChange",type="org.osmf.events.SeekingChangeEvent")]
	
	/**
	 * ISeekable defines the trait interface for media that can be instructed to jump to a 
	 * position in time.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.SEEKABLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.SEEKABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.SEEKABLE)</code> method
	 * to get an object that is guaranteed to implement the ISeekable interface.</p>
	 * <p>Through its MediaElement, an ISeekable trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 */	
	public interface ISeekable extends IMediaTrait
	{
		/**
		 * Indicates whether the media is currently seeking.
		 */				
		function get seeking():Boolean;

		/**
		 * Instructs the ISeekable to jump to the specified <code>time</code> (in
		 * seconds).
		 * 
		 * If a seek is attempted, dispatches a seekingChange event, unless
		 * the trait is already in a seeking state.
		 * If <code>time</code> is non numerical or negative, does not attempt to seek. 
		 *  
		 * @param time The time to seek to in seconds. Coerced to zero if
		 * the value is non numerical or negative.
		 * 
		 */				
		function seek(time:Number):void;

		/**
		 * Indicates whether the media is capable of seeking to the
		 * specified time.
		 *  
		 * <p>This method is not bound to the trait's current <code>seeking</code> state. It can
         * return <code>true</code> while the trait is seeking, even though a call to <code>seek()</code>
         * will fail if a previous seek is still in progress.</p>
		 * 
		 * @param time Time to seek to in seconds.
		 * @return Returns <code>true</code> if the media can seek to the specified time.
		 * 
		 */				
		function canSeekTo(time:Number):Boolean;
	}
}