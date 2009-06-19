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
	import org.openvideoplayer.events.SeekingChangeEvent;

	/**
	 * Dispatched when this trait's <code>seeking</code> property changes.
	 * 
	 * @eventType org.openvideoplayer.events.SeekingChangeEvent.SEEKING_CHANGE
	 */
	[Event(name="seekingChange",type="org.openvideoplayer.events.SeekingChangeEvent")]

	/**
	 * The SeekableTrait class provides a base ISeekable implementation.
	 * 
	 * It can be used as the base class for a more specific seekeable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 */	
	public class SeekableTrait extends MediaTraitBase implements ISeekable
	{
		/**
		 * Defines the temporal trait instance that this SeekableTrait 
		 * uses. 
		 * Typically this is the temporal trait owned by the same media
		 * element that owns this SeekableTrait, as reflected in the following
		 * assignments by the media element:
		 * <listing>
		 * // media element creates and assigns its seekable and temporal traits
		 * seekable = new SeekableTrait();
		 * temporal = new TemporalTrait();
		 * 
		 *  //then assigns the temporal trait to the seekable trait’s temporal property
		 * seekable.temporal = temporal;
		 * 
		 * //adds the traits to the media element
		 * addTrait(MediaTraitType.SEEKABLE, seekable);
		 * addTrait(MediaTraitType.TEMPORAL, temporal);
		 * </listing>
		 * The temporal property reflects the dependency between the seekable and temporal
		 * capabilities in this implementation.
		 * <p>If no temporal class is assigned, the 
		 * <code>canSeekTo()</code> method should return <code>false</code>.</p>
		 */		
		public function set temporal(value:ITemporal):void
		{
			_temporal = value;
		}
		
		public function get temporal():ITemporal
		{
			return _temporal;
		}
		
		/**
		 * Must be called by the implementing media
		 * on completing a seek.
		 * Calls the <code>processSeekingChange()</code> and <code>postProcessSeekingChange()</code>
		 * methods.
		 * @param time Position in seconds that the playhead was ultimately
		 * moved to.
		 * 
		 */		
		final public function processSeekCompletion(time:Number):void
		{
			if (_seeking == true)
			{
				seekTargetTime = time;
				
				processSeekingChange(false,time)
				_seeking = false;
				
				postProcessSeekingChange(true);
			}
		}
		
		// ISeekable
		//
		
		/**
		 * @inheritDoc
		 */
		final public function get seeking():Boolean
		{
			return _seeking;
		}
		
		/**
		 * Instructs the media's cursor to jump to the specified <code>time</code>.
		 * 
		 * If <code>time</code> is NaN or negative, does not attempt to seek. 
		 * 
		 * <p>If the seeking attempt sets the <code>seeking</code> property to <code>true</code>,
		 * dispatches a seekingChange event unless
		 * the trait is already seeking.
		 * It is the responsibility of the media element that
		 * owns this trait to handle this event. </p>
		 *
		 * <p>It is important to invoke the <code>processSeekCompletion()</code> method
		 * when the seek completes, whether successfully or unsuccessfully. 
		 * Otherwise future seek operations will be blocked.</p>
		 * @param time Time to seek to in seconds.
		 * @see #processSeekCompletion()
		 * @see #canProcessSeekingChange()
		 * @see #processSeekingChange()
		 * @see #postProcessSeekingChange()
		 * 
		 * 
		 */
		final public function seek(time:Number):void
		{
			if (_seeking == false)
			{
				if (isNaN(time) || time < 0)
				{
					time = 0;
				}
				
				if (canSeekTo(time))
				{
					seekTargetTime = time;
					
					if (canProcessSeekingChange(true))
					{
						processSeekingChange(true,time)
						
						_seeking = true;
						
						postProcessSeekingChange(false);
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function canSeekTo(time:Number):Boolean
		{
			return _temporal 
				?	(	isNaN(time) == false
					&&	time <= _temporal.duration
					&&	time >= 0
					)
				: 	false;
		}
		
		// Internals
		//
		
		private var _temporal:ITemporal;
		private var _seeking:Boolean;
		private var seekTargetTime:Number;
		
		/**
		 * Called before the <code>seeking</code> property is changed. 
		 *  
         * @param newSeeking Proposed new <code>seeking</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 */		
		protected function canProcessSeekingChange(newSeeking:Boolean):Boolean
		{
			return true;
		}
		
		/**
         * Called immediately before the <code>seeking</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
         * @param newSeeking New <code>seeking</code> value.
         * @param time New <code>time</code> value representing the time that the playhead seeks to
         * when <code>newSeeking</code> is <code>true</code>.
		 */		
		protected function processSeekingChange(newSeeking:Boolean,time:Number):void
		{
		}
		
		/**
		 * Called just after the <code>seeking</code> property has changed.
		 * Dispatches the change event.
		 * 
		 * <p>Subclasses that override should call this method to
		 * dispatch the seekingChange event.</p>
		 * @param oldSeeking Previous <code>seeking</code> value.
		 * 
		 */		
		protected function postProcessSeekingChange(oldSeeking:Boolean):void
		{
			dispatchEvent(new SeekingChangeEvent(_seeking,seekTargetTime));
		}
		
		
	}
}