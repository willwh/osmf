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
	import org.osmf.events.BufferEvent;

	/**
	 * Dispatched when the trait's <code>buffering</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferEvent.BUFFERING_CHANGE
	 */
	[Event(name="bufferingChange",type="org.osmf.events.BufferEvent")]
	
	/**
	 * Dispatched when the trait's <code>bufferTime</code> property has changed.
	 * 
	 * @eventType org.osmf.events.BufferEvent.BUFFER_TIME_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	[Event(name="bufferTimeChange",type="org.osmf.events.BufferEvent")]

	/**
	 * The BufferableTrait class provides a base IBufferable implementation. 
	 * It can be used as the base class for a more specific bufferable trait
	 * subclass or as is by a media element that listens for and handles
	 * its change events.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	public class BufferableTrait extends MediaTraitBase implements IBufferable
	{
		// Public interface
		//
		
		/**
		 * Defines the  value of the bufferLength property.
		 * 
		 * <p>This method fires a BufferLengthChangeEvent if the value's
		 * change persists.</p>
		 * 
		 * @see canProcessBufferLengthChange
		 * @see processBufferLengthChange
		 * @see postProcessBufferLengthChange
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		final public function set bufferLength(value:Number):void
		{
			if (value != _bufferLength)
			{
				if (canProcessBufferLengthChange(value))
				{
					processBufferLengthChange(value);
					
					var oldBufferLength:Number = _bufferLength;
					_bufferLength = value;
					
					postProcessBufferLengthChange(oldBufferLength);
				}
			}
		}
		
		/**
		 * Indicates whether the trait is in a buffering state. Dispatches
		 * a bufferingChange event if invocation results in the <code>buffering</code>
		 * property changing.
		 * 
		 * @see #canProcessBufferingChange()
		 * @see #processBufferingChange()
		 * @see #postProcessBufferingChange()
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		final public function set buffering(value:Boolean):void
		{
			if (value != _buffering)
			{
				if (canProcessBufferingChange(value))
				{
					processBufferingChange(value);
					
					_buffering = value;
					
					postProcessBufferingChange(!_buffering);
				}
			}
		}
		
		// IBufferable
		//
		
		/**
		 * @inheritDoc
		 **/
		public function get buffering():Boolean
		{
			return _buffering;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get bufferLength():Number
		{
			return _bufferLength;
		}
		
		/**
		 * @inheritDoc
		 **/
		public function get bufferTime():Number
		{
			return _bufferTime;
		}

		/**
		 * @inheritDoc
		 **/
		final public function set bufferTime(value:Number):void
		{
			// Coerce value into a positive:
			if (isNaN(value) || value < 0)
			{
				value = 0;
			}
			
			if (value != _bufferTime)
			{
				if (canProcessBufferTimeChange(value))
				{
					processBufferTimeChange(value);
					
					var oldBufferTime:Number = _bufferTime;
					_bufferTime = value;
					
					postProcessBufferTimeChange(oldBufferTime); 
				}
			}
		}
		
		// Internals
		//
		
		private var _buffering:Boolean = false;
		private var _bufferLength:Number = 0;
		private var _bufferTime:Number = 0;
		
		/**
		 * Called before buffering is started or stopped.
		 *
		 * @param newBuffering Proposed new <code>buffering</code> value.
		 * @return Returns <code>true</code> by default. 
		 * Subclasses that override this method can return <code>false</code> to
		 * abort processing.
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessBufferingChange(newBuffering:Boolean):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>buffering</code> value is changed.
		 * <p>Subclasses implement this method to communicate the change to the media.</p>
		 *
		 * @param newBuffering New <code>buffering</code> value. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processBufferingChange(newBuffering:Boolean):void
		{
		}
		
		/**
		 * Called just after <code>buffering</code> has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the bufferingChange event.</p> 
		 * @param oldBuffering Previous <code>buffering</code> value.
		 *
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBufferingChange(oldBuffering:Boolean):void
		{
			dispatchEvent(new BufferEvent(BufferEvent.BUFFERING_CHANGE, false, false, _buffering));
		}
		
		/**
		 * Called before the <code>bufferLength</code> value is changed. 
		 * @param newSize Proposed new <code>bufferLength</code> value.
		 * @return Returns <code>true</code> by default. 
		 * Subclasses that override this method can return <code>false</code> to
		 * abort processing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessBufferLengthChange(newSize:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>bufferLength</code> value is changed. 
		 * Subclasses implement this method to communicate the change to the media.
		 * @param newSize New <code>bufferLength</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processBufferLengthChange(newSize:Number):void
		{
		}
		
		/**
		 * Called just after the <code>bufferLength</code> value has changed.
		 * @param oldSize Previous  <code>bufferLength</code> value.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function postProcessBufferLengthChange(oldSize:Number):void
		{	
		}
		
		/**
		 * Called before <code>bufferTime</code> value is changed. 

		 * @param newTime Proposed new <code>bufferTime</code> value.
		 * @return Returns <code>true</code> by default. 
		 * Subclasses that override this method can return <code>false</code> to
		 * abort processing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function canProcessBufferTimeChange(newTime:Number):Boolean
		{
			return true;
		}
		
		/**
		 * Called immediately before the <code>bufferTime</code> value is changed.
		 * Subclasses implement this method to communicate the change to the media. 
		 *
		 * @param newTime New <code>bufferTime</code> value.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		protected function processBufferTimeChange(newTime:Number):void
		{
		}
		
		/**
		 * Called just after the <code>bufferTime</code> value has changed.
		 * Dispatches the change event.
		 * <p>Subclasses that override should call this method 
		 * to dispatch the bufferTimeChange event.</p>
		 *  
		 * @param oldTime Previous <code>bufferTime</code> value.
		 * 

		 *  

		 *  @langversion 3.0

		 *  @playerversion Flash 10

		 *  @playerversion AIR 1.0

		 *  @productversion OSMF 1.0

		 */		
		protected function postProcessBufferTimeChange(oldTime:Number):void
		{
			dispatchEvent(new BufferEvent(BufferEvent.BUFFER_TIME_CHANGE, false, false, false, _bufferTime));	
		}
	}
}