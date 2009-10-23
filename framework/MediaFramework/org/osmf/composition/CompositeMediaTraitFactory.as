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
	import org.osmf.media.MediaElement;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * Factory class for generating composite media traits.
	 **/
	internal class CompositeMediaTraitFactory
	{
		/**
		 * Instantiates and returns a new IMediaTrait which acts as a composite
		 * trait for a homogeneous set of child traits.
		 * 
		 * @param traitType The type of the composite trait (and by extension,
		 * the type of all child traits).
		 * @param traitAggregator The aggregator of all traits within the
		 * composite trait.  Note that the composite trait is only considered
		 * to contain those traits which are of type traitType.
		 * @param mode The composition mode to which the composite trait should
		 * adhere.  See CompositionMode for valid values.
		 * 
		 * @return The composite trait of the specified type.
		 **/
		public function createTrait
							( traitType:MediaTraitType
							, traitAggregator:TraitAggregator
							, mode:CompositionMode
							, owner:MediaElement
							):IMediaTrait
		{
			var compositeTrait:IMediaTrait = null;
			
			switch (traitType)
			{
				case MediaTraitType.AUDIBLE:
					// No distinction between modes for IAudible. 
					compositeTrait = new CompositeAudibleTrait(traitAggregator);
					break;
					
				case MediaTraitType.BUFFERABLE:
					compositeTrait = new CompositeBufferableTrait(traitAggregator, mode);
					break;

				case MediaTraitType.LOADABLE:
					compositeTrait = new CompositeLoadableTrait(traitAggregator, mode);
					break;
				
				case MediaTraitType.PLAYABLE:
					compositeTrait = new CompositePlayableTrait(traitAggregator, mode);
					break;
					
				case MediaTraitType.PAUSABLE:
					compositeTrait = new CompositePausableTrait(traitAggregator, mode);
					break;

				case MediaTraitType.SEEKABLE:
					compositeTrait 
						= mode == CompositionMode.PARALLEL
							?	new ParallelSeekableTrait(traitAggregator, owner)
							:	new SerialSeekableTrait(traitAggregator, owner);
					break;				
				case MediaTraitType.TEMPORAL:
					compositeTrait = new CompositeTemporalTrait(traitAggregator, mode, owner);
					break;
					
				case MediaTraitType.SPATIAL:
					compositeTrait 
						= mode == CompositionMode.PARALLEL
							? new ParallelSpatialTrait(traitAggregator, owner)
							: new SerialSpatialTrait(traitAggregator, owner);
					break; 
					
				case MediaTraitType.VIEWABLE:
					compositeTrait
						= mode == CompositionMode.PARALLEL
							? new ParallelViewableTrait(traitAggregator, owner)
							: new SerialViewableTrait(traitAggregator, owner);
					break;
				case MediaTraitType.SWITCHABLE:
					compositeTrait
						= mode == CompositionMode.PARALLEL
							? new ParallelSwitchableTrait(traitAggregator)
							: new SerialSwitchableTrait(traitAggregator);		
					break;	
				case MediaTraitType.DOWNLOADABLE:
					// TODO: we currently don't support IDownloadable at composite layer yet. Therefore
					//		this returns null. However, in subsequent sprints, we will add the support.
					break;		
				default:
					throw new Error("");
					break;
			}
			
			return compositeTrait;			
		}
	}
}