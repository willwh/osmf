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
	import org.osmf.media.IMediaTrait;
	import org.osmf.traits.IDisposable;
	import org.osmf.traits.MediaTraitBase;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Base class for all composite media traits.
	 **/
	internal class CompositeMediaTraitBase extends MediaTraitBase implements IDisposable
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
			
			attach();
		}
		
		public function dispose():void
		{
			_traitAggregator.removeEventListener(TraitAggregatorEvent.TRAIT_AGGREGATED, onChildAggregated);
			_traitAggregator.removeEventListener(TraitAggregatorEvent.TRAIT_UNAGGREGATED, onChildUnaggregated);
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

		protected function attach():void
		{
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