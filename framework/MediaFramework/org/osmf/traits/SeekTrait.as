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
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="seekEnd",type="org.osmf.events.SeekEvent")]

	/**
	 * SeekTrait defines the trait interface for media that can be instructed
	 * to jump to a position in time.  It can also be used as the base class for a
	 * more specific SeekTrait subclass.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.SEEK)</code> method to query
	 * whether a media element has a trait of this type.
	 * If <code>hasTrait(MediaTraitType.SEEK)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.SEEK)</code> method
	 * to get an object that is guaranteed to be of this type.</p>
	 * <p>Through its MediaElement, a SeekTrait can participate in media compositions.
	 * See the applicable class in the composition package for details about its behavior
	 * in this context.</p>
	 * 
	 * @see org.osmf.composition
	 * @see org.osmf.media.MediaElement
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class SeekTrait extends MediaTraitBase
	{
		public function SeekTrait(timeTrait:TimeTrait)
		{
			super(MediaTraitType.SEEK);
			
			_timeTrait = timeTrait;
		}
		
		/**
		 * Indicates whether the media is currently seeking.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public final function get seeking():Boolean
		{
			return _seeking;
		}
		
		/**
		 * Instructs the media's cursor to jump to the specified <code>time</code>.
		 * 
		 * If a seek is attempted, dispatches a seekingChange event.
		 * If <code>time</code> is non numerical or negative, does not attempt to seek. 
		 * 
		 * @param time Time to seek to in seconds.
		 * @see #processSeekCompletion()
		 * @see #canProcessSeekingChange()
		 * @see #processSeekingChange()
		 * @see #postProcessSeekingChange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public final function seek(time:Number):void
		{
			if (canSeekTo(time))
			{
				processSeekingChange(true, time);
					
				_seeking = true;
					
				postProcessSeekingChange(time);
			}
		}
		
		/**
		 * Indicates whether the media is capable of seeking to the
		 * specified time.
		 *  
		 * @param time Time to seek to in seconds.
		 * @return Returns <code>true</code> if the media can seek to the specified time.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */				
		public function canSeekTo(time:Number):Boolean
		{
			// Validate that the time is in range.  Note that we return true
			// if the time is less than the duration *or* the current time.  The
			// latter is for the case where the media has no (NaN) duration, but
			// is still progressing.  Presumably it should be possible to seek
			// backwards.
			return _timeTrait 
				?	(	isNaN(time) == false
					&& 	time >= 0
					&&	(time <= _timeTrait.duration || time <= _timeTrait.currentTime)
					)
				: 	false;
		}
		
		// Internals
		//
		
		/**
		 * The TimeTrait used by this SeekTrait.
		 **/
		protected final function get timeTrait():TimeTrait
		{
			return _timeTrait;
		}
		
		/**
         * Called immediately before the <code>seeking</code> property is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
         * @param time New <code>time</code> value representing the time that the playhead seeks to.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
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
		 * @param time New <code>time</code> value representing the time that the playhead seeked to.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessSeekingChange(time:Number):void
		{
			dispatchEvent
				( new SeekEvent
					( seeking ? SeekEvent.SEEK_BEGIN : SeekEvent.SEEK_END
					, false
					, false
					, time
					)
				);
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
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function processSeekCompletion(time:Number):void
		{
			if (_seeking == true)
			{
				processSeekingChange(false, time);
				
				_seeking = false;
				
				postProcessSeekingChange(time);
			}
		}
	
		private var _timeTrait:TimeTrait;
		private var _seeking:Boolean;
	}
}