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
	import flash.utils.Dictionary;
	
	import org.osmf.media.IMediaTrait;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.MediaTraitType;
	
	/**
	 * A SerialElement is a media composition whose elements are presented
	 * serially (i.e. in sequence).
	 * 
	 * <p>The media elements that make up a SerialElement are treated as a
	 * single, unified media element whose capabilities are expressed through
	 * the traits of the granular media elements.  Typically, a trait on a
	 * SerialElement is a reflection of the "current" child of the composition.
	 * A SerialElement cycles through its children in serial order.  As the
	 * current child completes its execution, the next child in the sequence
	 * becomes the "current" child.  To a client of the class, the
	 * changes from one current child to the next are hidden. They are only
	 * noticeable through changes to the traits of this class.</p>
	 * 
	 * <p>A childless SerialElement has no notion of a "current" child, so
	 * it reflects no traits.  The first child that
	 * is added to a SerialElement immediately becomes the current child
	 * of the composition.  If the current child is removed, the next
	 * child in the sequence becomes the new current
	 * child, if there is a next child. If there is no next child,
	 * the first child in the sequence becomes the current child.</p>  
	 * <p>The only way that the "current" status can pass from one
	 * child to another is when the state of one of the current child's 
	 * traits changes in such a way that the
	 * SerialElement knows that it needs to change its current child.  For
	 * example, if each child in the sequence has the IPlayable trait,
	 * the "current" status advances from one child to the next when a 
	 * child finishes playing and its IPlayable's <code>playing</code>
	 * property changes from <code>true</code> to <code>false</code>.  
	 * Another example:  if the client of an
	 * ISeekable SerialElement seeks from one point to another, the "current"
	 * status is likely to change from one child to another.</p>   
	 * 
	 * <p>Here is how each trait is expressed when in serial:</p>
	 * <ul>
	 * <li>
	 * IAudible - The composite trait keeps the audible properties of all
	 * children in sync.  When the volume of a child element (or the composite
	 * element) is changed, the volume is similarly changed for all audible
	 * children (and for the composite trait).
	 * </li>
	 * <li>
	 * IBufferable - The composite trait represents the bufferable trait of
	 * the current child in the sequence.  Any changes apply only to the
	 * current child.
	 * </li>
	 * <li>
	 * ILoadable - The composite trait represents the loadable trait of the
	 * current child in the sequence.  Any changes apply only to the current
	 * child.
	 * </li>
	 * <li>
	 * IPausable - The composite trait represents the Pausable trait of the
	 * current child in the sequence.  Any changes apply only to the current
	 * child. 
	 * </li>
	 * <li>
	 * IPlayable - The composite trait represents the playable trait of the
	 * current child in the sequence.  Any changes apply only to the current
	 * child. 
	 * </li>
	 * <li>
	 * ISeekable - The composite trait represents the seekable trait of the
	 * current child in the sequence.  A seek operation can change the current
	 * child.
	 * </li>
	 * <li>
	 * ISpatial - The composite trait represents the spatial trait of the
	 * current child in the sequence.
	 * </li>
	 * <li>
	 * ITemporal - The composite trait represents a timeline that encapsulates
	 * the timeline of all children.  Its duration is the sum of the durations
	 * of all children.  Its position is the sum of the positions of the first
	 * N fully complete children, plus the position of the next child.
	 * </li>
	 * <li>
	 * IViewable - The composite trait represents the viewable trait of the
	 * current child in the sequence.
	 * </li>
	 * </ul>
	 **/
	public class SerialElement extends CompositeElement
	{
		/**
		 * Constructor.
		 **/
		public function SerialElement()
		{
			super();
			
			traitAggregator.addEventListener
				( TraitAggregatorEvent.LISTENED_CHILD_CHANGE
				, onListenedChildChanged
				);
				
			reusableTraits = new Dictionary();
		}
		
		// Overrides
		//
			
		/**
		 * @private
		 **/
		override protected function processAddedChild(child:MediaElement, index:int):void
		{
			super.processAddedChild(child, index);
			
			// The first added child of a SerialElement becomes the "current"
			// child (i.e. the child from which all traits of the composite
			// element come).			
			if (traitAggregator.listenedChild == null)
			{
				traitAggregator.listenedChild = child;
				
				updateListenedChildIndex();
			}
		}

		/**
		 * @private
		 **/
		override protected function processRemovedChild(child:MediaElement):void
		{
			super.processRemovedChild(child);

			// If we remove the current child, then we should set a new
			// current child (if one is available).
			if (traitAggregator.listenedChild == child)
			{
				// Our first choice for the new current child is the next
				// child.
				listenedChildIndex += 1;
				var newListenedChild:MediaElement = getChildAt(listenedChildIndex);
				
				// If there is no next child, then we pick the first child.
				if (newListenedChild == null)
				{
					listenedChildIndex = (numChildren > 0) ? 0 : -1;

					newListenedChild = getChildAt(listenedChildIndex);
				}
				
				traitAggregator.listenedChild = newListenedChild;
			}
			
		}
		
		/**
		 * @private
		 **/
		override protected function processAggregatedTrait(traitType:MediaTraitType, trait:IMediaTrait):void
		{
			super.processAggregatedTrait(traitType, trait);
			
			var compositeTrait:IMediaTrait = getTrait(traitType);
			
			// Create the composite trait if the aggregated trait is for the
			// current child, the reason being that aggregating a new trait on
			// a non-current child shouldn't cause a new trait to be reflected. 
			if	(	compositeTrait == null
				&&	traitAggregator.listenedChild != null
				&&	traitAggregator.listenedChild.getTrait(traitType) == trait
				)
			{
				compositeTrait = reusableTraits[traitType] as IMediaTrait;
				if (compositeTrait == null)
				{
					compositeTrait = traitFactory.createTrait
							( traitType
							, traitAggregator
							, CompositionMode.SERIAL
							, this
							);
				}
				else
				{
					(compositeTrait as IReusable).prepare();
					reusableTraits[traitType] = null;
				}
				
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
			
			// Remove the composite trait if the unaggregated trait comes from
			// the current child, the reason being that the composition should
			// not reflect a trait that doesn't exist on the current child.
			if	(	traitAggregator.listenedChild != null
				&&	traitAggregator.listenedChild.getTrait(traitType) == trait
				)
			{
				var trait:IMediaTrait = removeTrait(traitType);
				if (trait != null && trait is IReusable) 
				{
					reusableTraits[traitType] = trait;
				}
			}
		}
		
	
		// Internals
		//
				
		private function onListenedChildChanged(event:TraitAggregatorEvent):void
		{
			if (event.oldListenedChild != null)
			{
				compositeMetadata.removeChildMetadata(event.oldListenedChild.metadata);
			}
			if (event.newListenedChild != null)
			{
				compositeMetadata.addChildMetadata(event.newListenedChild.metadata);
			}
					
			// Update the index of the current child.
			updateListenedChildIndex();
		}

		private function updateListenedChildIndex():void
		{
			listenedChildIndex = traitAggregator.getChildIndex(traitAggregator.listenedChild);
		}
		
		private var listenedChildIndex:int = -1;
		private var reusableTraits:Dictionary;
	}
}