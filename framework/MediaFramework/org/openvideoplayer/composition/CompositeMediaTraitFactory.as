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
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.MediaTraitType;
	
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
					
				case MediaTraitType.PAUSIBLE:
					compositeTrait = new CompositePausibleTrait(traitAggregator, mode);
					break;

				case MediaTraitType.SEEKABLE:
					compositeTrait 
						= mode == CompositionMode.PARALLEL
							?	new ParallelSeekableTrait(traitAggregator, owner)
							:	new SerialSeekableTrait(traitAggregator, owner);
					break;
					
				case MediaTraitType.TEMPORAL:
					compositeTrait = new CompositeTemporalTrait(traitAggregator, mode);
					break;
					
				case MediaTraitType.SPATIAL:
					compositeTrait 
						= mode == CompositionMode.PARALLEL
							? new ParallelSpatialTrait(traitAggregator, owner)
							: new SerialSpatialTrait(traitAggregator);
					break; 
					
				case MediaTraitType.VIEWABLE:
					compositeTrait
						= mode == CompositionMode.PARALLEL
							? new ParallelViewableTrait(traitAggregator)
							: new SerialViewableTrait(traitAggregator);
					break;
					
				default:
					// TODO: Currently our default returns an arbitrary child.
					// We should remove this once we've implemented all of the
					// other composite traits.
					traitAggregator.forEachChildTrait
						(
						  function(mediaTrait:IMediaTrait):void
						  {
						     compositeTrait = mediaTrait;
						  }
						, traitType
						);
					break;
			}
			
			return compositeTrait;			
		}
	}
}