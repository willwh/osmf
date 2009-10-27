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
package org.osmf.gateways
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osmf.layout.DefaultLayoutRenderer;
	import org.osmf.layout.ILayoutRenderer;
	import org.osmf.layout.LayoutContextSprite;
	import org.osmf.layout.MediaElementLayoutTarget;
	import org.osmf.media.IContainerGateway;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * RegionSprite defines a Sprite based IContainerGateway implementation.
	 */	
	public class RegionGateway extends LayoutContextSprite implements IContainerGateway
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
		public function RegionGateway
							( metadata:Metadata=null
							, contentLayoutRenderer:ILayoutRenderer=null
							, regionsLayoutRenderer:ILayoutRenderer=null
							)
		{
			super(metadata);
			
			// Setup a content sprite for holding the assigned MediaElement(s):
			
			content = new LayoutContextSprite(this.metadata);
			addChild(content);
			
			this.contentLayoutRenderer = contentLayoutRenderer || new DefaultLayoutRenderer();
			this.contentLayoutRenderer.context = content;
			content.layoutRenderer = this.contentLayoutRenderer;
			
			// Setup the layout renderer that will govern sub-regions:
			
			this.regionsLayoutRenderer = regionsLayoutRenderer || new DefaultLayoutRenderer();
			this.regionsLayoutRenderer.context = this;
			layoutRenderer = this.regionsLayoutRenderer; 
		}
		
		// IContainerGateway
		//
		
		/**
		 * @inheritDoc
		 */
		public function addElement(element:MediaElement):MediaElement
		{
			if (element == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			if (contentLayoutTargets[element] == undefined)
			{
				var contentTarget:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(element);
				
				contentLayoutTargets[element] = contentTarget;
				contentLayoutRenderer.addTarget(contentTarget);
			}
			else
			{
				throw new IllegalOperationError(MediaFrameworkStrings.INVALID_PARAM);
			}
			
			return element;
		}
		
		/**
		 * @inheritDoc
		 */
		public function removeElement(element:MediaElement):MediaElement
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
		
		// Public API
		//
		
		/**
		 * Defines if the children of the region that display outside of its bounds 
		 * will be clipped or not.
		 * 
		 */		
		public function set clipChildren(value:Boolean):void
		{
			if (value && scrollRect == null)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
			else if (value == false && scrollRect)
			{
				scrollRect = null;
			} 
		}
		
		public function get clipChildren():Boolean
		{
			return scrollRect != null;
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
		
		/**
		 * @inheritDoc
		 */
		override public function set calculatedWidth(value:Number):void
		{
			content.calculatedWidth = value;
			super.calculatedWidth = value;
		}
		
		override public function set calculatedHeight(value:Number):void
		{
			content.calculatedHeight = value;
			super.calculatedHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set projectedWidth(value:Number):void
		{
			content.projectedWidth = value;
			super.projectedWidth = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set projectedHeight(value:Number):void
		{
			content.projectedHeight = value;
			super.projectedHeight = value;
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set width(value:Number):void
		{
			super.width = content.width = value;
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override public function set height(value:Number):void
		{
			super.height = content.height = value;
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
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
		public function addChildRegion(region:RegionGateway):void
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
		public function removeChildRegion(region:RegionGateway):void
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
		public function containsRegion(region:RegionGateway):Boolean
		{
			return regionsLayoutRenderer.targets(region);
		}
		
		public function validateContentNow():void
		{
			contentLayoutRenderer.validateNow();
		}
		
		/**
		 * Defines the region's background color. By default, this value
		 * is set to NaN, which results in no background being drawn.
		 */		
		public function set backgroundColor(value:Number):void
		{
			if (value != _backgroundColor)
			{
				_backgroundColor = value;
				drawBackground();
			}
		}
		public function get backgroundColor():Number
		{
			return _backgroundColor;
		}
		
		/**
		 * Defines the region's background alpha. By default, this value
		 * is set to 1, which results in the background being fully opaque.
		 * 
		 * Note that a region will not have a background drawn unless its
		 * backgroundColor property is set.
		 */
		public function set backgroundAlpha(value:Number):void
		{
			if (value != _backgroundAlpha)
			{
				_backgroundAlpha = value;
				drawBackground();
			}
		}
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		// Internals
		//
		
		private function drawBackground():void
		{
			graphics.clear();
			
			if	(	!isNaN(_backgroundColor)
				&& 	_backgroundAlpha != 0
				&&	width
				&&	height
				)
			{
				graphics.beginFill(_backgroundColor,_backgroundAlpha);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}
		
		/**
		 * Dictionary of MediaElementLayoutTarget instances, index by the
		 * media elements that they wrap: 
		 */		
		private var contentLayoutTargets:Dictionary = new Dictionary();
		private var content:LayoutContextSprite;
		
		private var contentLayoutRenderer:ILayoutRenderer;
		private var regionsLayoutRenderer:ILayoutRenderer;
		
		private var _backgroundColor:Number;
		private var _backgroundAlpha:Number;
	}
}