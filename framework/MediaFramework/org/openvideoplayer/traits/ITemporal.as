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
	 * Dispatched when the <code>duration</code> of the trait has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DurationChangeEvent.DURATION_CHANGE
	 */
	[Event(name="durationChange", type="org.openvideoplayer.events.DurationChangeEvent")]
	
	/**
	 * Dispatched when the <code>position</code> of the trait has changed to a value
	 * equal to its <code>duration</code>.
	 * 
	 * @eventType org.openvideoplayer.events.TraitEvent.DURATION_REACHED
	 */
	[Event(name="durationReached",type="org.openvideoplayer.events.TraitEvent")]
	
	/**
	 * ITemporal defines the trait interface for media that have a duration and
	 * a position.
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
	 * @see org.openvideoplayer.composition
	 * @see org.openvideoplayer.media.MediaElement
	 */	
	public interface ITemporal extends IMediaTrait
	{
		/**
		 * The duration of the associated media element in
		 * seconds.
		 */		
		function get duration():Number;
		
		/**
		 * The position of the associated media element's cursor 
		 * in seconds.  Must never exceed the <code>duration</code>.
		 */		
		function get position():Number;
	}
}