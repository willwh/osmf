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
	 * Dispatched when the trait's <code>playing</code> property has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PLAYING_CHANGE
	 */
	[Event(name="playingChange",type="org.osmf.events.PlayingChangeEvent")]
	
	/**
	 * IPlayable defines the trait interface for media whose playback can be started
	 * and stopped.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.PLAYABLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.PLAYABLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.PLAYABLE)</code> method
	 * to get an object that is guaranteed to implement the IPlayable interface.</p>
	 * <p>Through its MediaElement, an IPlayable trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public interface IPlayable extends IMediaTrait
	{
		/**
		 * Indicates whether the media is currently playing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function get playing():Boolean;
		
		/**
		 * Plays the media if it is not already playing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		function play():void;
	}
}