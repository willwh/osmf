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
	import org.osmf.events.SeekEvent;

	/**
	 * Dispatched when this trait begins a seek operation.
	 * 
	 * @eventType org.osmf.events.SeekEvent.SEEK_BEGIN
	 */
	[Event(name="seekBegin",type="org.osmf.events.SeekEvent")]

	/**
	 * Dispatched when this trait ends a seek operation.
	 * 
	 * @eventType org.osmf.events.SeekEvent.SEEK_END
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="seekEnd",type="org.osmf.events.SeekEvent")]

	/**
	 * The SeekableTrait class provides a base ISeekable implementation.
	 * 
	 * It can be used as the base class for a more specific seekable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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
		 * dispatches a seekingChange event.
		 * It is the responsibility of the media element that
		 * owns this trait to handle this event. </p>
		 *
		 * <p>It is important to invoke the <code>processSeekCompletion()</code> method
		 * when the seek completes, whether successfully or unsuccessfully. 
		 * Otherwise future seek operations may be blocked.</p>
		 * @param time Time to seek to in seconds.
		 * @see #processSeekCompletion()
		 * @see #canProcessSeekingChange()
		 * @see #processSeekingChange()
		 * @see #postProcessSeekingChange()
		 * 
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		final public function seek(time:Number):void
		{
			if (canSeekTo(time))
			{
				seekTargetTime = time;
				
				if (canProcessSeekingChange(true))
				{
					processSeekingChange(true, time);
					
					_seeking = true;
					
					postProcessSeekingChange(false);
				}
			}
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function canSeekTo(time:Number):Boolean
		{
			// Validate that the time is in range.  Note that we return true
			// if the time is less than the duration *or* the current time.  The
			// latter is for the case where the media has no (NaN) duration, but
			// is still progressing.  Presumably it should be possible to seek
			// backwards.
			return _temporal 
				?	(	isNaN(time) == false
					&& 	time >= 0
					&&	(time <= _temporal.duration || time <= _temporal.currentTime)
					)
				: 	false;
		}
		
		// Internals
		//
		
		/**
		 * Called before the <code>seeking</code> property is changed. 
		 *  
         * @param newSeeking Proposed new <code>seeking</code> value.
		 * @return Returns <code>true</code> by default. Subclasses that override 
		 * this method can return <code>false</code> to abort processing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessSeekingChange(newSeeking:Boolean):Boolean
		{
			return true;
		}
		
		/**
         * Called immediately before the <code>seeking</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
         * @param time New <code>time</code> value representing the time that the playhead seeks to.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processSeekingChange(newSeeking:Boolean, time:Number):void
		{
		}
		
		/**
		 * Called just after the <code>seeking</code> property has changed.
		 * Dispatches the change event.
		 * 
		 * <p>Subclasses that override should call this method to
		 * dispatch the change event.</p>
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessSeekingChange(oldSeeking:Boolean):void
		{
			dispatchEvent
				( new SeekEvent
					( seeking ? SeekEvent.SEEK_BEGIN : SeekEvent.SEEK_END
					, false
					, false
					, seekTargetTime
					)
				);
		}

		private var _temporal:ITemporal;
		private var _seeking:Boolean;
		private var seekTargetTime:Number;
	}
}