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
	import org.osmf.net.MediaItem;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * @private
	 * 
	 * Dispatched when an alternative audio stream change is requested, completed, or failed.
	 * 
	 * @eventType org.osmf.events.AlternativeAudioEvent.SOURCE_CHANGE
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.6
	 */
	[Event(name="streamChange",type="org.osmf.events.AlternativeAudioEvent")]
	
	/**
	 * @private
	 * 
	 * Dispatched when the number of alternative audio streams has changed.
	 * 
	 * @eventType org.osmf.events.AlternativeAudioEvent.NUM_ALTERNATIVE_AUDIO_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="numAlternativeAudioChange",type="org.osmf.events.AlternativeAudioEvent")]
	
	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * AlternativeAudioTrait defines the trait interface for media supporting alternative
	 * audio streams. It can also be used as the base class for a more specific AlternativeAudioTrait
	 * subclass.
	 * 
	 * <p>Use the <code>MediaElement.hasTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> method to query
	 * whether a media element has a trait of this type.
	 * If <code>hasTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> returns <code>true</code>,
	 * use the <code>MediaElement.getTrait(MediaTraitType.ALTERNATIVE_AUDIO)</code> method
	 * to get an object of this type.</p>
	 * 
	 * @see org.osmf.media.MediaElement
	 *  
	 * @langversion 3.0
	 * @playerversion Flash 10
	 * @playerversion AIR 1.5
	 * @productversion OSMF 1.0
	 */
	public class AlternativeAudioTrait extends MediaTraitBase
	{
		/**
		 * Constructor.
		 * 
		 * @param numAlternativeAudio The total number of alternative audio streams.
		 * @param currentIndex The initial alternative audio stream index for the trait.  The default is -1 which means use the default audio stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function AlternativeAudioTrait(numAlternativeAudioStreams:int, initialIndex:int=-1)
		{
			super(MediaTraitType.ALTERNATIVE_AUDIO);
			
			_numAlternativeAudioStreams = numAlternativeAudioStreams;
			_currentIndex = initialIndex;		

			_changingStream = false;
		}
		
		/**
		 * The total number of alternative audio streams.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get numAlternativeAudioStreams():int
		{
			return _numAlternativeAudioStreams;
		}

		/**
		 * The index of the current alternative stream.  Uses a zero-based index.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get currentIndex():int
		{
			return _currentIndex;
		}

		/**
		 * Returns the associated media item for the specified index.
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater or equal with <code>numAlternativeAudioStreams</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */ 
		public function getMediaItemForIndex(index:int):MediaItem
		{
			if (index < 0 || index >= numAlternativeAudioStreams)
			{
				throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
			}
			
			return null;
		}

		/**
		 * Indicates whether or not an alternative audio stream changing is currently in progress.
		 * This property will return <code>true</code> while a stream change has been 
		 * requested and the stream change has not yet been acknowledged and no stream
		 * change failure has occurred.  Once the stream change request has been acknowledged 
		 * or a failure occurs, the property will return <code>false</code>.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get changingStream():Boolean
		{			
			return _changingStream;
		}
		
		/**
		 * Changes audio stream to a specific alternative audio stream index. 
    	 * Note:  If the media is paused, changin stream will not take place until after play resumes.		 
		 * 
		 * @throws RangeError If the specified index is less than zero or
		 * greater than or equal with <code>numAlternativeAudioStreams</code>.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function changeTo(index:int):void
		{
			if (index != currentIndex)
			{
				if (index < 0 || index >= numAlternativeAudioStreams)
				{
					throw new RangeError(OSMFStrings.getString(OSMFStrings.ALTERNATIVEAUDIO_INVALID_INDEX));
				}

				// This method sets the changing state to true.  The processing
				// and completion of the change are up to the implementing media.
				setChangingStream(true, index);
			}			
		}
				
		// Internals
		//

//		/**
//		 * Invoking this setter will result in the trait's numDynamicStreams
//		 * property changing.
//		 *  
//		 *  @langversion 3.0
//		 *  @playerversion Flash 10
//		 *  @playerversion AIR 1.5
//		 *  @productversion OSMF 1.0
//		 */		
//		protected final function setNumDynamicStreams(value:int):void
//		{
//			if (value != _numDynamicStreams)
//			{
//				_numDynamicStreams = value;
//				
//				// Only adjust our maxAllowedIndex property if the old value
//				// is now out of range.
//				if (maxAllowedIndex >= _numDynamicStreams)
//				{
//					maxAllowedIndex = Math.max(0, _numDynamicStreams - 1);
//				}
//				
//				dispatchEvent(new DynamicStreamEvent(DynamicStreamEvent.NUM_DYNAMIC_STREAMS_CHANGE));
//			}			
//		}
		
		/**
		 * Invoking this setter will result in the trait's currentIndex
		 * property changing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		protected final function setCurrentIndex(value:int):void
		{
			_currentIndex = value;
		}
		
		/**
		 * Must be called by the implementing media on completing a change.
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
		protected final function setChangingStream(newChangingStream:Boolean, index:int):void
		{
			if (newChangingStream != _changingStream)
			{
				beginChangingStream(newChangingStream, index);
				
				_changingStream = newChangingStream;
				
				// Update the index when a change finishes.
				if (newChangingStream == false)
				{
					setCurrentIndex(index);
				}
				
				endChangingStream(index);
			}
		}

		/**
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
		protected function beginChangingStream(newChangingStream:Boolean, index:int):void
		{			
		}
		
		/**
		 * Called just after the <code>changingSource</code> property has changed.
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
		protected function endChangingStream(index:int):void
		{
			dispatchEvent
				( new AlternativeAudioEvent
					( AlternativeAudioEvent.STREAM_CHANGE
					, false
					, false
					, changingStream
					)
				);
		}
		
		private var _currentIndex:int = -1;
		private var _numAlternativeAudioStreams:int;
		private var _changingStream:Boolean;
	}
}
