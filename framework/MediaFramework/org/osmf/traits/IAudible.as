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
	 * Dispatched when the audible trait's <code>volume</code> property has changed.
	 * 
	 * @eventType org.osmf.events.VolumeChangeEvent.VOLUME_CHANGE
	 */	
	[Event(name="volumeChange",type="org.osmf.events.VolumeChangeEvent")]
	
	/**
  	 * Dispatched when the audible trait's <code>muted</code> property has changed.
  	 * 
  	 * @eventType org.osmf.events.MutedChangeEvent.MUTED_CHANGE
	 */	
	[Event(name="mutedChange",type="org.osmf.events.MutedChangeEvent")]
	
	/**
 	 * Dispatched when the audible trait's <code>pan</code> property has changed.
 	 * 
 	 * @eventType org.osmf.events.PanChangeEvent.PAN_CHANGE 
	 */	
	[Event(name="panChange",type="org.osmf.events.PanChangeEvent")]
	
	/**
	 * IAudible defines the trait interface for media that are audible. 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.AUDIBLE)</code> method to query
	 * whether a media element has a trait that implements this interface. 
	 * If <code>hasTrait(MediaTraitType.AUDIBLE)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.AUDIBLE)</code> method
	 * to get an object that is guaranteed to implement the IAudible interface.</p>
	 * 
	 * <p>Through its MediaElement, an IAudible trait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 */	
	public interface IAudible extends IMediaTrait
	{
		/**
		 * The volume, ranging from 0 (silent) to 1 (full volume).
		 * 
		 * <p>Passing a value greater than 1 sets the value to 1.
		 * Passing a value less than zero sets the value to zero.
		 * </p>
		 * 
		 * <p>Changing the value of the <code>volume</code> property does not affect the value of the
		 * <code>muted</code> property.</p>
		 * 
		 * <p>The default is 1.</p>
		 * 
		 * @see IAudible#muted 
		 */		
		function get volume():Number;
		function set volume(value:Number):void;
		
		/**
		 * Indicates whether the audible trait is muted or sounding. 
		 * 
		 * <p>Changing the value of the <code>muted</code> property does not affect the 
		 * value of the <code>volume</code> property.</p>
		 * 
		 * <p>The default value is <code>false</code>.</p>
		 * 
		 * @see IAudible#volume
		 */		
		function get muted():Boolean;
		function set muted(value:Boolean):void;
		
		/**
		 * The left-to-right panning of the sound. Ranges from -1
		 * (full pan left) to 1 (full pan right).
		 * 
		 * <p>Passing a value greater than 1 sets the value to 1.
		 * Passing a value less than -1 sets the value to -1.
		 * </p>
		 * 
		 * <p>The default is zero.</p>
		 */
		function get pan():Number;
		function set pan(value:Number):void;
	}
}