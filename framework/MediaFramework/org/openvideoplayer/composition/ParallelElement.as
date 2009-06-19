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
	 * A ParallelElement is a media composition whose elements are presented
	 * in parallel (concurrently).
	 * 
	 * <p>The media elements that make up a ParallelElement are treated as a
	 * single, unified media element whose capabilities are expressed through
	 * the traits of the granular media elements.  Typically, a trait on a
	 * ParallelElement is a composite or merged combination of that trait on
	 * all its children.  When a new media element is added as a child of the media
	 * composition,  either its traits or the composite's traits are adjusted
	 * to make the traits of the media composiiton and its children consistent.</p>
	 * <p> As an example of the first case, consider the IAudible trait.
	 * If a client adds a new MediaElement that has its IAudible trait's volume at 0.5
	 * to a ParallelElement that has its IAudible trait's volume at 0.3,
	 * the IAudible trait's volume for the child MediaElement is set to 0.3
	 * to be consistent with ParallelElement's trait.</p>
	 * <p>As an example of the second case, consider the IBufferable trait.
	 * If the added MediaElement has the IBufferable trait, the ParallelElement's
	 * IBufferable trait may need to "grow" if the new MediaElement has a
	 * larger buffer than any of its other children. In this case, the buffer of the 
	 * ParallelElement adjusts to the size of its new child.
	 * </p>
	 * 
	 * Here is how each trait is expressed when in parallel:
	 * <ul>
	 * <li>
	 * IAudible - The composite trait keeps the audible properties of all
	 * children in sync.  When the volume of a child element (or the composite
	 * element) is changed, the volume is similarly changed for all audible
	 * children (and for the composite trait).
	 * </li>
	 * <li>
	 * IBufferable - The composite trait is buffering if any child is buffering.
	 * Its length and size are the length and size of the child with the
	 * longest buffer.  Its starting position is the minimum (earliest)
	 * starting position of all of its children.
	 * </li>
	 * <li>
	 * ILoadable - The composite trait keeps the load state of all children in
	 * sync.  When a child element (or the composite element) is loaded, all
	 * loadable children (and the composite element) are simultaneously loaded.
	 * </li>
	 * <li>
	 * IPausible - The composite trait keeps the pause state of all children in
	 * sync.  When a child element (or the composite element) is paused, all
	 * pausible children (and the composite element) are simultaneously paused. 
	 * </li>
	 * <li>
	 * IPlayable - The composite trait keeps the play state of all children in
	 * sync.  When a child element (or the composite element) is played, all
	 * playable children (and the composite element) are simultaneously played. 
	 * </li>
	 * <li>
	 * ISeekable - The composite trait keeps the seek state of all children in
	 * sync.  When a child element (or the composite element) performs a seek,
	 * all seekable children (and the composite element) simultaneously perform
	 * that same seek. 
	 * </li>
	 * <li>
	 * ISpatial - If one or more of the composite’s children has the IViewable trait,
	 * the composite trait’s spatial dimensions are defined by the bounding box
	 * of the DisplayObject referenced by
	 * the <code>view</code> property of the composite's IViewable trait.
	 * If none of the composite’s children have the IViewable trait,
	 * the composite trait's width is the width of its widest child and its
	 * height is the height of its tallest child.
	 * </li>
	 * <li>
	 * ITemporal - The composite trait represents a timeline that encapsulates
	 * the timelines of all children. Its duration is the maximum of the
	 * durations of all children.  Its position is kept in sync for all
	 * children, with the obvious caveat that a child's position will never be
	 * greater than its duration.
	 * </li>
	 * <li>
	 * IViewable - The composite trait represents a DisplayObject that wraps
	 * the DisplayObjects of all children.
	 * </li>
	 * </ul>
	 * <p>Note that the ISeekable, IPausible and IBufferable traits have not yet
	 * been implemented for the ParallelElement.</p>
	 **/
	public class ParallelElement extends CompositeElement
	{
		/**
		 * Constructor.
		 **/
		public function ParallelElement()
		{
			super();
		}
		
		// Overrides
		//
		

		/**
		 * @private
		 **/			
		override protected function processAggregatedTrait(traitType:MediaTraitType, trait:IMediaTrait):void
		{
			super.processAggregatedTrait(traitType, trait);
			
			var compositeTrait:IMediaTrait = getTrait(traitType);

			// Create the composite trait if it doesn't exist yet.
			if (compositeTrait == null)
			{
				compositeTrait = traitFactory.createTrait
						( traitType
						, traitAggregator
						, CompositionMode.PARALLEL
						, this
						);

				addTrait(traitType, compositeTrait);
				postProcessAggregatedTrait(traitType, compositeTrait);
			}
		}
		/**
		 * @private
		 **/	
		override protected function processUnaggregatedTrait(traitType:MediaTraitType, trait:IMediaTrait):void
		{
			super.processUnaggregatedTrait(traitType, trait);
			
			// Remove the composite trait if the unaggregated trait was the
			// last child of the composite trait.
			if (traitAggregator.hasTrait(traitType) == false)
			{
				removeTrait(traitType);
			}
		}
	}
}