/*****************************************************
*  
*  Copyright 2011 Adobe Systems Incorporated.  All Rights Reserved.
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
*  Portions created by Adobe Systems Incorporated are Copyright (C) 2011 Adobe Systems 
*  Incorporated. All Rights Reserved. 
*  
*****************************************************/
package org.osmf.traits
{
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.AlternativeAudioEvent;
	import org.osmf.net.StreamingItem;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Dispatched when an alternative audio stream switch is requested, completed,
	 * or has failed.
	 * 
	 * @eventType org.osmf.events.AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	[Event(name="audioSwitchingChange",type="org.osmf.events.AlternativeAudioEvent")]
	
	/**
	 * Dispatched when the number of alternative audio streams has changed.
	 * 
	 * @eventType org.osmf.events.AlternativeAudioEvent.NUM_ALTERNATIVE_AUDIO_STREAMS_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.6
	 */
	[Event(name="numAlternativeAudioStreamsChange",type="org.osmf.events.AlternativeAudioEvent")]
	
	/**
	 * AlternativeAudioTrait defines the trait interface for media supporting alternative
	 * audio streams. It can also be used as the base class for a more specific 
	 * AlternativeAudioTrait subclass.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> 
	 * method to query whether a media element has a trait of this type.
	 * If <code>hasTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> method
	 * to get an object of this type.</p>
	 * 
	 * @see org.osmf.media.MediaElement
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	public class AlternativeAudioTrait extends MediaTraitBase
	{
		/**
		 * Default Constructor.
		 * 
		 * @param numAlternativeAudio The total number of alternative audio streams.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */ 
		public function AlternativeAudioTrait(numAlternativeAudioStreams:int)
		{
			super(MediaTraitType.ALTERNATIVE_AUDIO);
			
			_numAlternativeAudioStreams = numAlternativeAudioStreams;

			_switching = false;
		}
		
		/**
		 * The total number of alternative audio streams.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public function get numAlternativeAudioStreams():int
		{
			return _numAlternativeAudioStreams;
		}

		/**
		 * The index of the current alternative audio stream. The 0-based index of 
		 * the selected stream, or <code>-1</code> if no stream is selected. The value 
		 * is always between <code>-1</code> and <code>(numAlternativeAudioStreams - 1)
		 * </code>. 
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}

		/**
		 * Returns the associated streaming item for the specified index. Returns 
		 * <code>null</code> if the index is <code>-1</code>.
		 * 
		 * @throws RangeError If the specified index is less than <code>-1</code> or 
		 * greater than <code>(numAlternativeAudioStreams - 1)</code>.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */ 
		public function getItemForIndex(index:int):StreamingItem
		{
			if (index <= INVALID_TRANSITION_INDEX || index >= numAlternativeAudioStreams)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
			}
			
			return null;
		}

		/**
		 * Indicates whether or not an alternative audio stream switching is currently
		 * in progress. 
		 * 
		 * This property will return <code>true</code> while an audio stream switch 
		 * has been requested and the switch has not yet been acknowledged and no audio 
		 * stream switch failure has occurred. Once the audio stream switch request has
		 * been acknowledged or a failure occurs, the property will return 
		 * <code>false</code>.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public function get switching():Boolean
		{			
			return _switching;
		}
		
		/**
		 * Switches audio stream to a specific alternative audio stream index. Using 
		 * <code>-1</code> as index value, will reset the alternative audio stream to
		 * the default one.
		 * 
    	 * Note:  If the media is paused, stream switch will not take place until 
		 * after play resumes.		 
		 * 
		 * @throws RangeError If the specified index is less than <code>-1</code> or
		 * greater than <code>numAlternativeAudioStreams-1</code>.
		 * 
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */
		public function switchTo(index:int):void
		{
			if (index != _indexToSwitchTo)
			{
				if (index < INVALID_TRANSITION_INDEX || index >= numAlternativeAudioStreams)
				{
					throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
				}

				// This method sets the switching state to true.  The processing
				// and completion of the switch are up to the implementing media,
				// but once the switch is completed or aborted the implementing
				// media must set the switching mode to false.
				setSwitching(true, index);
			}			
		}
				
		// Internals
		/**
		 * @private 
		 * 
		 * Invoking this setter will result in the trait's currentIndex
		 * property changing.
		 *  
		 * @langversion 3.0
		 * @playerversion Flash 10
		 * @playerversion AIR 1.5
		 * @productversion OSMF 1.6
		 */		
		protected final function setCurrentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		/**
		 * @private
		 * 
		 * Must be called by the implementing media on starting or completing a change.
		 * 
		 * Calls the <code>beginChangingStream</code> and <code>endChangingStream</code>
		 * methods.
		 * @param newChangingStream New <code>changingStream</code> value for the trait.
		 * @param index The index to which the change shall (or did) occur.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setSwitching(newSwitching:Boolean, index:int):void
		{
			if (newSwitching != _switching || index != _indexToSwitchTo)
			{
				beginSwitching(newSwitching, index);
				
				// Update the index when a change finishes.
				_switching = newSwitching;
				if (_switching == false)
				{
					setCurrentIndex(index);
				}
				
				endSwitching(index);
			}
		}

		/**
		 * @private
		 * 
		 * Called immediately before the <code>changingSource</code> property is changed.
		 * <p>Subclasses can override this method to communicate the change to the media.</p>
         * @param newChangingStream New value for the <code>changingStream</code> property.
         * @param index The index of the stream to change to.
 		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		protected function beginSwitching(newSwitching:Boolean, index:int):void
		{
			if (newSwitching)
			{
				// Keep track of the target index, we don't want to begin
				// the switch now since our switching state won't be
				// updated until the switchingChangeEnd method is called.
				_indexToSwitchTo = index;
			}
		}
		
		/**
		 * Called just after the <code>switching</code> property has changed.
		 * Dispatches the change event.
		 * 
		 * <p>Subclasses that override should call this method to
		 * dispatch the change event.</p>
		 * 
		 * @param index The index of the changed-to stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected function endSwitching(index:int):void
		{
			if (!_switching)
			{
				// The switching is now over. Reset the cached value.
				_indexToSwitchTo = INVALID_TRANSITION_INDEX;	
			}

			dispatchEvent
				( new AlternativeAudioEvent
					( AlternativeAudioEvent.AUDIO_SWITCHING_CHANGE
					, false
					, false
					, switching
					)
				);
		}
		
		/// Internals
		protected static const INVALID_TRANSITION_INDEX:int = -2;
		protected static const DEFAULT_TRANSITION_INDEX:int = -1;

		private var _currentIndex:int = DEFAULT_TRANSITION_INDEX;
		private var _numAlternativeAudioStreams:int;
		private var _switching:Boolean;
		
		protected var _indexToSwitchTo:int = INVALID_TRANSITION_INDEX;
	}
}
