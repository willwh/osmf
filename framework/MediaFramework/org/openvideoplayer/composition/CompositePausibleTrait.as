/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.composition
{
	import org.openvideoplayer.events.PausedChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.IPausible;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when the IPausible's <code>paused</code> property has changed.
	 * 
	 * @eventType org.openvideoplayer.events.PausedChangeEvent.PAUSED_CHANGE
	 */
	[Event(name="pausedChange",type="org.openvideoplayer.events.PausedChangeEvent")]

	/**
	 * Implementation of IPausible which can be a composite media trait.
	 * 
	 * For both parallel and serial media elements, a composite pausible trait
	 * keeps all pausible properties in sync for the composite element and its
	 * children.
	 **/
	internal class CompositePausibleTrait extends CompositeMediaTraitBase implements IPausible
	{
		public function CompositePausibleTrait(traitAggregator:TraitAggregator, mode:CompositionMode)
		{
			this.mode = mode;

			super(MediaTraitType.PAUSIBLE, traitAggregator);
		}
		
		/**
		 * Resets the <code>paused</code> property of the trait.
		 * Changes the value of <code>paused</code> from <code>true</code> to <code>false</code>.
		 * <p>Used after <code>CompositePlayableTrait.play()</code> is invoked.</p>
		 * 
		 */		
		final public function resetPaused():void
		{
			if (paused == true)
			{
				setPaused(false);
			}
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
					traitAggregator.invokeOnEachChildTrait("pause", [], MediaTraitType.PAUSIBLE);
				}
				else // SERIAL
				{
					// Invoke play on the current child.
					traitOfCurrentChild.pause();
				}
				
				setPaused(true);
			}
		}	

		// Overrides
		//

		/**
		 * @inheritDoc
		 **/
		override protected function processAggregatedChild(child:IMediaTrait):void
		{
			child.addEventListener(PausedChangeEvent.PAUSED_CHANGE, onPausedChanged, false, 0, true);
			
			var pausible:IPausible = child as IPausible;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (traitAggregator.getNumTraits(MediaTraitType.PAUSIBLE) == 1)
				{
					// The first added child's properties are applied to the
					// composite trait.
					setPaused(pausible.paused);
				}
				else
				{
					// All subsequently added children inherit their properties
					// from the composite trait.
					if (paused)
					{
						pausible.pause();
					}
				}
			}
			else if (child == traitOfCurrentChild)
			{
				// The first added child's properties are applied to the
				// composite trait.
				setPaused(pausible.paused);
			}
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
			var pausible:IPausible = event.target as IPausible;
			
			if (mode == CompositionMode.PARALLEL)
			{
				if (pausible.paused)
				{
					// If a child has been paused, then the composition should
					// be paused too.
					pause();
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
								if (IPausible(mediaTrait).paused)
								{
									hasPausedChild = true;
								}
							}
							, MediaTraitType.PAUSIBLE
						);
						
					// there is no paused child, so set the state to be NOT paused
					if (hasPausedChild == false)
					{
						setPaused(false);
					}
				}
			}
			else if (pausible == traitOfCurrentChild)
			{
				// this is the case when mode is serial:
				//
				// if the child is current the composite pausible state should be set 
				// to be the same as that of the current child
				//
				// if the child is not current, do nothing because inserial mode only
				// the current child matters
				//
				
				setPaused(pausible.paused);
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
		
		private function get traitOfCurrentChild():IPausible
		{
			return   traitAggregator.listenedChild
				   ? traitAggregator.listenedChild.getTrait(MediaTraitType.PAUSIBLE) as IPausible
				   : null;			
		}
		
		private var mode:CompositionMode;
		private var _paused:Boolean = false;
	}
}
