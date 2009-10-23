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
	 * A ParallelElement is a media composition whose elements are presented
	 * in parallel (concurrently).
	 * 
	 * <p>The media elements that make up a ParallelElement are treated as a
	 * single, unified media element whose capabilities are expressed through
	 * the traits of the granular media elements.  Typically, a trait on a
	 * ParallelElement is a composite or merged combination of that trait on
	 * all its children.  When a new media element is added as a child of the media
	 * composition,  either its traits or the composite's traits are adjusted
	 * to make the traits of the media composition and its children consistent.</p>
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
	 * IPausable - The composite trait keeps the pause state of all children in
	 * sync.  When a child element (or the composite element) is paused, all
	 * Pausable children (and the composite element) are simultaneously paused. 
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
		override protected function processAddedChild(child:MediaElement, index:int):void
		{
			super.processAddedChild(child,index);			
			compositeMetadata.addChildMetadata(child.metadata);
		}
		
		override protected function processRemovedChild(child:MediaElement):void
		{
			super.processRemovedChild(child);
			compositeMetadata.removeChildMetadata(child.metadata);
		}

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

				if (compositeTrait != null)
				{
					addTrait(traitType, compositeTrait);
				}
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