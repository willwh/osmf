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
	import org.osmf.events.AudioEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IAudible;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Dispatched when the IAudible's <code>volume</code> property has changed.
	 * 
	 * @eventType org.osmf.events.AudioEvent.VOLUME_CHANGE
	 */	
	[Event(name="volumeChange",type="org.osmf.events.AudioEvent")]
	
	/**
  	 * Dispatched when the IAudible's <code>muted</code> property has changed.
  	 * 
  	 * @eventType org.osmf.events.AudioEvent.MUTED_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mutedChange",type="org.osmf.events.AudioEvent")]
	
	/**
 	 * Dispatched when the IAudible's <code>pan</code> property has changed.
 	 * 
 	 * @eventType org.osmf.events.AudioEvent.PAN_CHANGE 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="panChange",type="org.osmf.events.AudioEvent")]

	/**
	 * Implementation of IAudible which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite audible trait
	 * keeps all audible properties in sync for the composite element and its
	 * children.
	 **/
	internal class CompositeAudibleTrait extends CompositeMediaTraitBase implements IAudible, IReusable
	{
		/**
		 * Constructor.
		 * 
		 * @param traitAggregator The object which is aggregating all instances
		 * of the IAudible trait within this composite trait.
		 **/
		public function CompositeAudibleTrait(traitAggregator:TraitAggregator)
		{
			super(MediaTraitType.AUDIBLE, traitAggregator);
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get volume():Number
		{
			return _volume;
		}
		
		public function set volume(value:Number):void
		{
			// Make sure the value is in range. 
			value = Math.max(0, Math.min(1, value));
			
			if (value != _volume)
			{
				_volume = value;
				
				applyVolumeToChildren();
				
				dispatchEvent(new AudioEvent(AudioEvent.VOLUME_CHANGE, false, false, false, _volume));
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
		public function get muted():Boolean
		{
			return _muted;
		}
		
		public function set muted(value:Boolean):void
		{
			if (value != _muted)
			{
				_muted = value;
				
				applyMutedToChildren();
				
				dispatchEvent(new AudioEvent(AudioEvent.MUTED_CHANGE, false, false, _muted));
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
		public function get pan():Number
		{
			return _pan;
		}
		
		public function set pan(value:Number):void
		{
			// Make sure the value is in range. 
			value = Math.max(-1, Math.min(1, value));

			if (value != _pan)
			{
				_pan = value;
				
				applyPanToChildren();
				
				dispatchEvent(new AudioEvent(AudioEvent.PAN_CHANGE, false, false, false, NaN, _pan));
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
			child.addEventListener(AudioEvent.MUTED_CHANGE,  onMutedChanged, 	false, 0, true);
			child.addEventListener(AudioEvent.PAN_CHANGE, 	 onPanChanged, 		false, 0, true);
			child.addEventListener(AudioEvent.VOLUME_CHANGE, onVolumeChanged, 	false, 0, true);
			
			var audible:IAudible = child as IAudible;
			
			if (traitAggregator.getNumTraits(MediaTraitType.AUDIBLE) == 1)
			{
				// The first added child's properties are applied to the
				// composite trait.
				pan 	= audible.pan;
				muted 	= audible.muted;
				volume  = audible.volume;
			}
			else
			{
				// All subsequently added children inherit their properties
				// from the composite trait.
				audible.pan 	= pan;
				audible.muted	= muted;
				audible.volume	= volume;
			}
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			// All we need to do is remove the listeners.  For both parallel
			// and serial media, unaggregated children have no bearing on
			// the properties of the composite trait.
			child.removeEventListener(AudioEvent.MUTED_CHANGE, 	onMutedChanged);
			child.removeEventListener(AudioEvent.PAN_CHANGE, 	onPanChanged);
			child.removeEventListener(AudioEvent.VOLUME_CHANGE,	onVolumeChanged);
		}
		
		// Internals
		//
		
		private function onVolumeChanged(event:AudioEvent):void
		{
			// Changes from the child propagate to the composite trait.
			volume = (event.target as IAudible).volume;
		}

		private function onMutedChanged(event:AudioEvent):void
		{
			// Changes from the child propagate to the composite trait.
			muted = (event.target as IAudible).muted;
		}

		private function onPanChanged(event:AudioEvent):void
		{
			/// Changes from the child propagate to the composite trait.
			pan = (event.target as IAudible).pan;
		}
				
		private function applyVolumeToChildren():void
		{
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     IAudible(mediaTrait).volume = volume;
				  }
				, MediaTraitType.AUDIBLE
				);
		}
		
		private function applyMutedToChildren():void
		{
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     IAudible(mediaTrait).muted = muted;
				  }
				, MediaTraitType.AUDIBLE
				);
		}
		
		private function applyPanToChildren():void
		{
			traitAggregator.forEachChildTrait
				(
				  function(mediaTrait:IMediaTrait):void
				  {
				     IAudible(mediaTrait).pan = pan;
				  }
				, MediaTraitType.AUDIBLE
				);
		}
		
		private var _volume:Number = 1;
		private var _muted:Boolean = false;
		private var _pan:Number = 0;
	}
}