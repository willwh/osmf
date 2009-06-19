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
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.MediaTraitBase;
	import org.openvideoplayer.traits.MediaTraitType;
	
	/**
	 * Base class for all composite media traits.
	 **/
	internal class CompositeMediaTraitBase extends MediaTraitBase
	{
		/**
		 * Constructor.
		 * 
		 * @param traitType The type of this composite trait (and by extension,
		 * the type of all of its children).
		 * @param traitAggregator The aggregator for this composite trait's
		 * set of child traits.
		 **/
		public function CompositeMediaTraitBase(traitType:MediaTraitType, traitAggregator:TraitAggregator)
		{
			_traitType = traitType;
			_traitAggregator = traitAggregator;
			
			// Keep apprised of traits of our type that come and go.
			traitAggregator.addEventListener(TraitAggregatorEvent.TRAIT_AGGREGATED, 	onChildAggregated, 		false, 0, true);
			traitAggregator.addEventListener(TraitAggregatorEvent.TRAIT_UNAGGREGATED, 	onChildUnaggregated, 	false, 0, true);
			
			// Process each aggregated trait of our type.
			traitAggregator.forEachChildTrait
				(
					function(mediaTrait:IMediaTrait):void
					{
						processAggregatedChild(mediaTrait);
					}
				,   traitType
				);
		}
		
		// Protected
		//

		/**
		 * The type of this composite trait.
		 **/
		protected function get traitType():MediaTraitType
		{
			return _traitType;
		}
		
		/**
		 * The aggregator for this composite trait's set of child traits.
		 **/
		protected function get traitAggregator():TraitAggregator
		{
			return _traitAggregator;
		}
		
		/**
		 * Invoked when a child trait is aggregated by this composite
		 * trait. Subclasses can override to do custom processing.
		 * 
		 * @param child The child trait that was just aggregated.
		 **/ 
		protected function processAggregatedChild(child:IMediaTrait):void
		{
		}

		/**
		 * Invoked when a child trait is unaggregated by this composite
		 * trait. Subclasses can override to do custom processing.
		 * 
		 * @param child The child trait that was just unaggregated.
		 **/ 
		protected function processUnaggregatedChild(child:IMediaTrait):void
		{
		}

		// Internals
		//
		
		private function onChildAggregated(event:TraitAggregatorEvent):void
		{
			if (event.traitType == traitType)
			{
				processAggregatedChild(event.trait);
			}
		}

		private function onChildUnaggregated(event:TraitAggregatorEvent):void
		{
			if (event.traitType == traitType)
			{
				processUnaggregatedChild(event.trait);
			}
		}
		
		private var _traitType:MediaTraitType;
		private var _traitAggregator:TraitAggregator;
	}
}