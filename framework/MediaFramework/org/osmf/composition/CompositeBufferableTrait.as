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
package org.osmf.composition
{
	import org.osmf.events.BufferEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IBufferable;
	import org.osmf.traits.MediaTraitType;

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
	 * Implementation of IBufferable which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite bufferable trait
	 * keeps all bufferable properties in sync for the composite element and its
	 * children.
	 **/
	internal class CompositeBufferableTrait extends CompositeMediaTraitBase implements IBufferable, IReusable
	{
		public function CompositeBufferableTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			_bufferTime					= 0;
			_bufferTimeFromChildren		= true;
			_buffering					= false;
			_settingBufferTime			= false;
			this.mode					= mode;
			
			super(MediaTraitType.BUFFERABLE, traitAggregator);			
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get buffering():Boolean
		{
			return _buffering;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bufferLength():Number
		{
			var length:Number;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel,
				//
				// When none of the child trait is in the condition of bufferLength < bufferTime, 
				// the bufferLength of the trait is the average of the bufferLength values of its 
				// children. 
				// 
				// When at least one of the children is in the condition of bufferLength < bufferTime, 
				// the composite trait calculates its bufferLength as follows. For each child trait 
				// with bufferLength < bufferTime, the composite trait takes the actual bufferLength. 
				// For the rest of the children, the composite trait takes its bufferTime as its 
				// current bufferLength. Then the composite trait takes the average of the current 
				// bufferLength of the children (as described) as its bufferLength.
				var totalUnadjustedBufferLength:Number	= 0;
				var totalAdjustedBufferLength:Number	= 0;
				var needAdjustment:Boolean				= false;
				
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					  	var bufferable:IBufferable = IBufferable(mediaTrait);
					  	if (bufferable.bufferLength < bufferable.bufferTime)
					  	{
					  		totalUnadjustedBufferLength	+= bufferable.bufferLength;
					  		totalAdjustedBufferLength	+= bufferable.bufferLength;
					  		needAdjustment = true;
					  	}
					  	else
					  	{
					  		totalUnadjustedBufferLength	+= bufferable.bufferLength;
					  		totalAdjustedBufferLength	+= bufferable.bufferTime;
					  	}
					  }
					, MediaTraitType.BUFFERABLE
					);
					
				length = (needAdjustment? totalAdjustedBufferLength : totalUnadjustedBufferLength)
						/ traitAggregator.getNumTraits(MediaTraitType.BUFFERABLE);
			}
			else
			{
				// In serial, the values of bufferLength of the composite trait is taken from the curent 
				// child trait.
				length =  (traitOfCurrentChild != null)? traitOfCurrentChild.bufferLength : 0;
			}
			
			return length;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get bufferTime():Number
		{
			return _bufferTime;
		}
		
		public function set bufferTime(value:Number):void
		{
			if (_bufferTime == value)
			{
				return;
			}
			
			_settingBufferTime = true;
			
			var oldBufferTime:Number = _bufferTime;
			
			// Set new bufferTime to each child who supports bufferable 
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     IBufferable(mediaTrait).bufferTime = value;
				  }
				, MediaTraitType.BUFFERABLE
				);
			
			_bufferTime = value;
			_bufferTimeFromChildren = false;
			_settingBufferTime = false;
			dispatchEvent(new BufferEvent(BufferEvent.BUFFER_TIME_CHANGE, false, false, false, _bufferTime));
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function prepare():void
		{
			attach();
		}
		
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			onBufferingChanged();
			
			if (_bufferTimeFromChildren)
			{
				onBufferTimeChanged();
			}
			else if (child is IBufferable)
			{
				_settingBufferTime = true;
				(child as IBufferable).bufferTime = bufferTime;
				_settingBufferTime = false;
			}

			child.addEventListener(BufferEvent.BUFFERING_CHANGE,	onBufferingChanged,		false, 0, true);
			child.addEventListener(BufferEvent.BUFFER_TIME_CHANGE,	onBufferTimeChanged,	false, 0, true);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			onBufferingChanged();
			if (_bufferTimeFromChildren)
			{
				onBufferTimeChanged();
			}

			child.removeEventListener(BufferEvent.BUFFERING_CHANGE,		onBufferingChanged);
			child.removeEventListener(BufferEvent.BUFFER_TIME_CHANGE,	onBufferTimeChanged);
		}
		
		// Internals
		//
		
		private function onBufferingChanged(event:BufferEvent=null):void
		{
			var newBufferingState:Boolean = checkBuffering();
			if (newBufferingState != buffering)
			{
				_buffering = newBufferingState;
				dispatchEvent(new BufferEvent(BufferEvent.BUFFERING_CHANGE, false, false, buffering));
			}
		}
		
		private function onBufferTimeChanged(event:BufferEvent=null):void
		{
			// The composite trait is in the middle of setting the bufferTime of each child.
			// So it may expect some bufferTimeChange events dispatched from the children. 
			// But under the circumstance, all these events should be ignored.
			if (_settingBufferTime)
			{
				return;
			}
			
			var oldBufferTime:Number = _bufferTime;
			_bufferTime = calculateBufferTime();
			_bufferTimeFromChildren = true;
			if (oldBufferTime != _bufferTime)
			{
				dispatchEvent(new BufferEvent(BufferEvent.BUFFER_TIME_CHANGE, false, false, false, _bufferTime));
			}
		}
		
		private function calculateBufferTime():Number
		{
			var time:Number = 0;
			
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel case, the bufferTime is the average of the bufferTime of the children.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     time += IBufferable(mediaTrait).bufferTime;
					  }
					, MediaTraitType.BUFFERABLE
					);
				if (time > 0)
				{
					time = time / traitAggregator.getNumTraits(MediaTraitType.BUFFERABLE);
				}
			}
			else
			{
				// In serial case, the bufferTime is taken from the current child.
				// If the current child does not support bufferable, return zero.
				time = traitOfCurrentChild != null ? traitOfCurrentChild.bufferTime : 0;
			}
			
			return time;
		}
		
		private function checkBuffering():Boolean
		{
			var isBuffering:Boolean = false;
			if (mode == CompositionMode.PARALLEL)
			{
				// In parallel case, buffering is true when at least one child is buffering.
				traitAggregator.forEachChildTrait
					(
					  function(mediaTrait:IMediaTrait):void
					  {
					     isBuffering ||= IBufferable(mediaTrait).buffering;
					  }
					, MediaTraitType.BUFFERABLE
					);
			}
			else
			{
				// In serial case, buffering state is taken from that of the current child.
				// If the current child does not support bufferable, return false.
				isBuffering = traitOfCurrentChild != null? traitOfCurrentChild.buffering : false;
			}	
			
			return isBuffering;
		}
		
		private function get traitOfCurrentChild():IBufferable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.BUFFERABLE) as IBufferable
				   : null;			
		}

		private var mode:CompositionMode;		
		private var _bufferTime:Number;
		private var _bufferTimeFromChildren:Boolean;
		private var _buffering:Boolean;
		private var _settingBufferTime:Boolean;
	}
}