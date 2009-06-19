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
	 * Dispatched when the trait's <code>buffering</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.BufferingChangeEvent.BUFFERING_CHANGE
	 */
	[Event(name="bufferingChange",type="org.openvideoplayer.events.BufferingChangeEvent")]
	
	/**
	 * Dispatched when the trait's <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.BufferTimeChangeEvent.BUFFER_TIME_CHANGE
	 */
	[Event(name="bufferTimeChange",type="org.openvideoplayer.events.BufferTimeChangeEvent")]
	
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
	 * @see org.openvideoplayer.composition
	 * @see org.openvideoplayer.media.MediaElement 
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
		 * <p>If the passed value is NaN or negative, it
		 * is coerced to zero.</p>
		 * 
		 * <p>The default is zero.</p> 
		 */		
		function get bufferTime():Number;
		function set bufferTime(value:Number):void;
	}
}