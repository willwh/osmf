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
package org.openvideoplayer.regions
{
	import flash.errors.IllegalOperationError;
	import flash.utils.Dictionary;
	
	import org.openvideoplayer.layout.DefaultLayoutRenderer;
	import org.openvideoplayer.layout.ILayoutRenderer;
	import org.openvideoplayer.layout.LayoutContextSprite;
	import org.openvideoplayer.layout.MediaElementLayoutTarget;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * RegionSprite defines a Sprite based IRegion implementation.
	 */	
	public class RegionSprite extends LayoutContextSprite implements IRegion
	{
		/**
		 * Constructor
		 *  
		 * @param metadata The metadata that elementLayoutRenderer and/or
		 * regionsLayoutRenderer may be using on calculating their layouts using
		 * this region as their context.
		 * @param elementLayoutRenderer The layout renderer that will render
		 * the MediaElement instances that get added to this region. If no
		 * renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 * @param regionsLayoutRenderer The layout renderer that will render
		 * the child RegionSprite instances that get added to this region. If
		 * no renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 */		
		public function RegionSprite
							( metadata:Metadata=null
							, contentLayoutRenderer:ILayoutRenderer=null
							, regionsLayoutRenderer:ILayoutRenderer=null
							)
		{
			super(metadata);
			
			// Setup a content sprite for holding the assigned MediaElement(s):
			
			var content:LayoutContextSprite = new LayoutContextSprite(this.metadata);
			addChild(content);
			
			this.contentLayoutRenderer = contentLayoutRenderer || new DefaultLayoutRenderer();
			this.contentLayoutRenderer.context = content;
			
			// Setup the layout renderer that will govern sub-regions:
			
			this.regionsLayoutRenderer = regionsLayoutRenderer || new DefaultLayoutRenderer();
			this.regionsLayoutRenderer.context = this;
		}
		
		// IRegion
		//
		
		/**
		 * @inheritDoc
		 */
		public function addChildElement(element:MediaElement):void
		{
			if (element == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (contentLayoutTargets[element] == undefined)
			{
				var contentTarget:MediaElementLayoutTarget = new MediaElementLayoutTarget(element);
				contentLayoutTargets[element] = contentTarget;
				contentLayoutRenderer.addTarget(contentTarget);
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeChildElement(element:MediaElement):MediaElement
		{
			if (element == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var result:MediaElement;
			var contentTarget:MediaElementLayoutTarget = contentLayoutTargets[element];
			
			if (contentTarget)
			{
				contentLayoutRenderer.removeTarget(contentTarget);
				delete contentLayoutTargets[element];
				result = element;
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			return result;
		}
		
		/**
		 * @inheritDoc
		 */
		public function containsElement(element:MediaElement):Boolean
		{
			return contentLayoutTargets[element] != undefined
		}
		
		// Overrides
		//
		
		/**
		 * Returns 1, for index 0 is occupied by the LayoutContextSprite instance
		 * that holds sub-regions.
		 * 
		 * @inheritDoc
		 */
		override public function get firstChildIndex():uint
		{
			// The content sprite is at index 0, add sub-regions
			// at index 1 and up:
			return 1;
		}
		
		// Public Interface
		//
		
		/**
		 * Adds the specified region as a sub-region.
		 * 
		 * If the region contains metadata, then it will be layed out using this
		 * instance's regions layout renderer.
		 *  
		 * @param region The child region to add.
		 * @throws IllegalOperationError if region is null, or already a sub-region.
		 */		
		public function addChildRegion(region:RegionSprite):void
		{
			if (region == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (regionsLayoutRenderer.targets(region) == false)
			{
				regionsLayoutRenderer.addTarget(region);
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
		}
		
		/**
		 * Removes a sub-region.
		 *  
		 * @param region The region to remove.
		 * @throws IllegalOperationErrror if region is null, or not a sub-region.
		 */		
		public function removeChildRegion(region:RegionSprite):void
		{
			if (region == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (regionsLayoutRenderer.targets(region))
			{
				regionsLayoutRenderer.removeTarget(region);
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
		}
		
		/**
		 * Verifies if a region is a sub-region of this RegionSprite.
		 *  
		 * @param region Region to verify.
		 * @return True if target is a sub-region of this RegionSprite.
		 * 
		 */		
		public function containsRegion(region:RegionSprite):Boolean
		{
			return regionsLayoutRenderer.targets(region);
		}
		
		// Internals
		//
		
		/**
		 * Dictionary of MediaElementLayoutTarget instances, index by the
		 * media elements that they wrap: 
		 */		
		private var contentLayoutTargets:Dictionary = new Dictionary();
		
		private var contentLayoutRenderer:ILayoutRenderer;
		private var regionsLayoutRenderer:ILayoutRenderer;
	}
}