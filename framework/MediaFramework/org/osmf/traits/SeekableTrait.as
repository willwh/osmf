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
	import org.osmf.events.SeekingChangeEvent;

	/**
	 * Dispatched when this trait's <code>seeking</code> property changes.
	 * 
	 * @eventType org.osmf.events.SeekingChangeEvent.SEEKING_CHANGE
	 */
	[Event(name="seekingChange",type="org.osmf.events.SeekingChangeEvent")]

	/**
	 * The SeekableTrait class provides a base ISeekable implementation.
	 * 
	 * It can be used as the base class for a more specific seekable trait
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
				
				processSeekingChange(false, time);
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
		 * If <code>time</code> is non numerical or negative, does not attempt to seek. 
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