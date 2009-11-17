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
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.SeekEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.ISeekable;
	import org.osmf.traits.ITemporal;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;

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
	 * Implementation of ISeekable which can be a composite media trait.
	 * 
	 * This is the base class for composite seekable. There are two derived classes: ParallelSeekableTrait
	 * and SerialSeekableTrait.
	 * 
	 * @see SerialSeekableTrait
	 * @see ParallelSeekableTrait
	 **/
	internal class CompositeSeekableTrait extends CompositeMediaTraitBase implements ISeekable
	{
		public function CompositeSeekableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			this.owner	= owner;
			_seeking	= false;
			seekToTime	= 0;

			super(MediaTraitType.SEEKABLE, traitAggregator);			
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get seeking():Boolean
		{
			return _seeking;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function seek(time:Number):void
		{
			if (detached)
			{
				return;
			}

			if (!seeking)
			{
				if (isNaN(time) || time < 0)
				{
					time = 0;
				}

				// Calls prepareSeekOperationInfo methods of the derived classes, ParallelSeekableTrait
				// and SerialSeekableTrait. The prepareSeekOperationInfo returns whether the composite
				// trait can seek to the position. If yes, it also returns a "description" of how
				// to carry out the seek operation for the composite, depending on the concrete type 
				// of the composite seekable trait.
				var seekOp:CompositeSeekOperationInfo = prepareSeekOperationInfo(time);
				if (seekOp.canSeekTo)
				{
					setSeeking(true, time);
					doSeek(seekOp);
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
			if (detached)
			{
				return false;
			}

			if (isNaN(time) || time < 0)
			{
				return false;
			}
							
			// Similar to the seek function, here we call the preapareSeekOperation of the derived
			// composite seekable trait. Only this time the returned operation is only used to 
			// determine whether a seek is possible.
			return prepareSeekOperationInfo(time).canSeekTo;
		}

		// Overrides
		//
		
		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			if (detached)
			{
				return;
			}

			child.addEventListener(SeekEvent.SEEK_BEGIN, onSeekingChanged, false, 0, true);
			child.addEventListener(SeekEvent.SEEK_END, onSeekingChanged, false, 0, true);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			if (detached)
			{
				return;
			}

			child.removeEventListener(SeekEvent.SEEK_BEGIN, onSeekingChanged);
			child.removeEventListener(SeekEvent.SEEK_END, onSeekingChanged);
		}
		
		/**
		 * This is event handler for SeekiEvent, typically dispatched from the ISeekable trait
		 * of a child/children. This must be overridden by derived classes. 
		 * 
		 * @param event The SeekEvent.
  		 **/
		protected function onSeekingChanged(event:SeekEvent):void
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}
		
		/**
		 * This function carries out the actual seeking operation. Derived classes must override this
		 * function. 
		 * 
		 * @param seekOp The object that contains the complete information of how to carry out this 
		 * particular seek operation.
		 **/
		protected function doSeek(seekOp:CompositeSeekOperationInfo):void
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}
		
		/**
		 * This function carries out the operation to check whether a seek operation is feasible
		 * as well as coming up with a complete planning of how to do the actual seek. The derived 
		 * classes must override this function.
		 * 
		 * @param time The time the seek operation will seek to.
		 **/
		protected function prepareSeekOperationInfo(time:Number):CompositeSeekOperationInfo
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}
		
		/**
		 * This function checks whether the composite seekable trait is currently seeking. The derived
		 * classes must override this function.
		 * 
		 **/
		protected function checkSeeking():Boolean
		{
			throw new IllegalOperationError(MediaFrameworkStrings.FUNCTION_MUST_BE_OVERRIDDEN);
		}

		/**
		 * This function returns the composite temporal trait of the current composition.
		 * 
		 **/
		protected function get temporal():ITemporal
		{
			return owner.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
		}
		
		/**
		 * This function sets the seeking state of the composite trait.
		 * 
		 * @param value		Whether the composite trait is in seeking state.
		 * @param seekTo	The time that the seek operation will seek to.
		 **/
		protected function setSeeking(value:Boolean, seekTo:Number = 0):void
		{
			if (_seeking != value)
			{
				_seeking	= value;
				
				// Child seektable traits will be instructed to seek and the composite
				// seek trait will be dispateched a lot of SeekingChangeEvent. So the
				// composite trait needs to remember where the composition seeks to.
				seekToTime	= seekTo;
				
				dispatchEvent(new SeekEvent(_seeking ? SeekEvent.SEEK_BEGIN : SeekEvent.SEEK_END, false, false, seekTo));
			}
		}
		
		/**
		 * Given the ISeekable trait of a child media element, this function 
		 * returns the ITemporal trait of the child media element.
		 * 
		 * @param childSeekable		The ISeekable trait of the child media element.
		 **/
		protected function getChildTemporal(childSeekable:ISeekable):ITemporal
		{
			// Given the SeekableTrait of a child, retrieve the corresponding TempoeralTrait.
			for (var index:int = 0; index < traitAggregator.numChildren; index++)
			{
				var child:MediaElement = traitAggregator.getChildAt(index);
				if (child.getTrait(MediaTraitType.SEEKABLE) == childSeekable)
				{
					return child.getTrait(MediaTraitType.TEMPORAL) as ITemporal;
				}
			}
			
			return null;
		}
		
		/**
		 * Sets the composite seekable trait to be detached or not.
		 * 
		 * @param value		The value indicates whether the composite seekable trait has been detached.
		 **/
		protected function set detached(value:Boolean):void
		{
			_detached = value;
		}
		
		/**
		 * Indicates whether the composite seekable trait object is no longer associated with 
		 * the corresponding composition.
		 * 
		 **/
		protected function get detached():Boolean
		{
			// Here is a little optimization. Once a composite seekable trait has been detached, 
			// it will never be re-used. Therefore, after the value has been set true, there is 
			// no need to check any more.
			if (_detached)
			{
				return _detached;
			}
			
			var seekable:ISeekable = owner.getTrait(MediaTraitType.SEEKABLE) as ISeekable;
			_detached = (seekable != this && seekable != null);
			
			return _detached;
		}

		// The time that the seek operation seeks to.
		protected var seekToTime:Number;

		// The composition media element that owns this composite trait.
		protected var owner:MediaElement;

		// Internals
		//
		
		private var _seeking:Boolean;
		private var _detached:Boolean = false;
	}
}
