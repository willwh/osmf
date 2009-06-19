/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.traits
{
	import org.openvideoplayer.media.IMediaTrait;

	/**
	 * Dispatched when the audible trait's <code>volume</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.VolumeChangeEvent.VOLUME_CHANGE
	 */	
	[Event(name="volumeChange",type="org.openvideoplayer.events.VolumeChangeEvent")]
	
	/**
  	 * Dispatched when the audible trait's <code>muted</code> property has changed.
  	 * 
  	 * @eventType org.openvideoplayer.events.MutedChangeEvent.MUTED_CHANGE
	 */	
	[Event(name="mutedChange",type="org.openvideoplayer.events.MutedChangeEvent")]
	
	/**
 	 * Dispatched when the audible trait's <code>pan</code> property has changed.
 	 * 
 	 * @eventType org.openvideoplayer.events.PanChangeEvent.PAN_CHANGE 
	 */	
	[Event(name="panChange",type="org.openvideoplayer.events.PanChangeEvent")]
	
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
	 * @see org.openvideoplayer.composition
	 * @see org.openvideoplayer.media.MediaElement
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