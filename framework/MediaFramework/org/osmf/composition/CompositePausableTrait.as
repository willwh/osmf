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
	import org.osmf.events.PausedChangeEvent;
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IPausable;
	import org.osmf.traits.MediaTraitType;

	/**
	 * Dispatched when the IPausable's <code>paused</code> property has changed.
	 * 
	 * @eventType org.osmf.events.PausedChangeEvent.PAUSED_CHANGE
	 */
	[Event(name="pausedChange",type="org.osmf.events.PausedChangeEvent")]

	/**
	 * Implementation of IPausable which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite Pausable trait
	 * keeps all Pausable properties in sync for the composite element and its
	 * children.
	 **/
	internal class CompositePausableTrait extends CompositeMediaTraitBase implements IPausable
	{
		public function CompositePausableTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			this.mode = mode;

			super(MediaTraitType.PAUSABLE, traitAggregator);
		}
				
		/**
		 * @inheritDoc
		 */		
		public function get paused():Boolean
		{
			return _paused;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function pause():void
		{
			if (paused == false)
			{
				if (mode == CompositionMode.PARALLEL)
				{
					// Invoke play on all children.
					traitAggregator.invokeOnEachChildTrait("pause", [], MediaTraitType.PAUSABLE);
				}
				else // SERIAL
				{
					// Invoke play on the current child.
					traitOfCurrentChild.pause();
				}
				
			}
		}	

		// Overrides
		//

		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			var pausable:IPausable = child as IPausable;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (traitAggregator.getNumTraits(MediaTraitType.PAUSABLE) == 1)
				{
					// The first added child's properties are applied to the
					// composite trait.
					setPaused(pausable.paused);
				}
				else
				{
					// All subsequently added children inherit their properties
					// from the composite trait.
					if (paused)
					{
						pausable.pause();
					}
				}
			}
			else if (child == traitOfCurrentChild)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setPaused(pausable.paused);
			}

			child.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged, false, 0, true);
		}

		/**
		 * @inheritDoc
		 **/
		override protected function processUnaggregatedChild(child:IMediaTrait):void
		{
			child.removeEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged);
		}
		
		// Internals
		//
		
		private function onPausedChanged(event:PausedChangeEvent):void
		{
			var pausable:IPausable = event.target as IPausable;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (pausable.paused)
				{
					// If a child has been paused, then the composition should
					// be paused too.
					pause();
					
					setPaused(true);
				}
				else
				{
					// If the child is not paused, we should check all
					// children to see if we need to update our own state.
					//
					
					var hasPausedChild:Boolean = false;
					
					traitAggregator.forEachChildTrait
						(
							function(mediaTrait:IMediaTrait):void
							{
								if (IPausable(mediaTrait).paused)
								{
									hasPausedChild = true;
								}
							}
							, MediaTraitType.PAUSABLE
						);
						
					// there is no paused child, so set the state to be NOT paused
					if (hasPausedChild == false)
					{
						setPaused(false);
					}
				}
			}
			else if (pausable == traitOfCurrentChild)
			{
				// this is the case when mode is serial:
				//
				// if the child is current the composite Pausable state should be set 
				// to be the same as that of the current child
				//
				// if the child is not current, do nothing because in serial mode only
				// the current child matters
				//
				
				setPaused(pausable.paused);
			}
		}
		
		private function setPaused(value:Boolean):void
		{
			if (value != _paused)
			{
				_paused = value;
				
				dispatchEvent(new PausedChangeEvent(value));
			}
		}
		
		private function get traitOfCurrentChild():IPausable
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.PAUSABLE) as IPausable
				   : null;			
		}
		
		private var mode:CompositionMode;
		private var _paused:Boolean = false;
	}
}
