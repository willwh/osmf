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
package org.osmf.layout
{
	import __AS3__.vec.Vector;
	
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.logging.ILogger;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	import org.osmf.utils.URL;

	/**
	 * Defines a layout renderer that sizes and positions its targets using the folowing
	 * metadata facets it looks for on its targets:
	 * 
	 *  * LayoutAttributesFacet
	 *  * AbsoluteLayoutFacet
	 *  * RelativeLayoutFacet
	 *  * AnchorLayoutFacet
	 *  * PaddingLayoutFacet
	 * 
	 * The documentation on each of these classes states how their respective properties
	 * are interpreted by this renderer.
	 * 
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class LayoutRenderer extends LayoutRendererBase
	{
		// Overrides
		//
		
		/**
		 * @private
		 */
		override protected function get usedMetadataFacets():Vector.<URL>
		{
			return USED_METADATA_FACETS;
		}
		
		/**
		 * @private
		 */
		override protected function processContainerChange(oldContainer:ILayoutTarget, newContainer:ILayoutTarget):void
		{
			if (oldContainer)
			{
				containerAbsoluteWatcher.unwatch();
				containerAttributesWatcher.unwatch();
			}
			
			if (newContainer)
			{
				containerAbsoluteWatcher
					= MetadataUtils.watchFacet
						( newContainer.metadata
						, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS
						, function (..._):void
							{
								invalidate();
							}
						);
						
				containerAttributesWatcher
					= MetadataUtils.watchFacet
						( newContainer.metadata
						, MetadataNamespaces.LAYOUT_ATTRIBUTES
						, function (facet:LayoutAttributesFacet):void
							{
								layoutMode = facet ? facet.layoutMode : LayoutMode.NONE
								invalidate();
							}
						);
			}
			
			invalidate();
		}
		
		/**
		 * @private
		 */
		override protected function processUpdateMediaDisplayBegin(targets:Vector.<ILayoutTarget>):void
		{
			lastCalculatedBounds = null;
		}
		
		/**
		 * @private
		 */
		override protected function processUpdateMediaDisplayEnd():void
		{
			lastCalculatedBounds = null;
		}
		
		/**
		 * @private
		 */
		override protected function processTargetAdded(target:ILayoutTarget):void
		{
			var attributes:LayoutAttributesFacet = target.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesFacet;
			
			// If no layout properties are set on the target ...
			var relative:RelativeLayoutFacet = target.metadata.getFacet(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS) as RelativeLayoutFacet;
			if	(	layoutMode == LayoutMode.NONE
				&&	relative == null
				&&	attributes == null
				&&	target.metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS) == null
				&&	target.metadata.getFacet(MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS) == null
				)
			{
				// Set target to take 100% of their container's width and height
				relative = new RelativeLayoutFacet();
				relative.width = 100;
				relative.height = 100;
				target.metadata.addFacet(relative);
			
				// Set target to scale letter box layoutMode, centered, by default:
				attributes = new LayoutAttributesFacet();
				attributes.scaleMode ||= ScaleMode.LETTERBOX;
				attributes.verticalAlign ||= VerticalAlign.MIDDLE;
				attributes.horizontalAlign ||= HorizontalAlign.CENTER;
				target.metadata.addFacet(attributes);
			}
			
			// Watch the index metadata attribute for change:
			//
			
			targetMetadataWatchers[target] = MetadataUtils.watchFacetValue
				( target.metadata
				, MetadataNamespaces.LAYOUT_ATTRIBUTES
				, LayoutAttributesFacet.INDEX
				, function(..._):void 
					{
						updateTargetOrder(target);
					}
				);
		}
		
		/**
		 * @private
		 */
		override protected function processTargetRemoved(target:ILayoutTarget):void
		{
			var watcher:MetadataWatcher = targetMetadataWatchers[target];
			delete targetMetadataWatchers[target];
			
			watcher.unwatch();
			watcher = null;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function compareTargets(x:ILayoutTarget, y:ILayoutTarget):Number
		{
			var attributesX:LayoutAttributesFacet
				= x.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES)
				as LayoutAttributesFacet;
				
			var attributesY:LayoutAttributesFacet
				= y.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES)
				as LayoutAttributesFacet;
				
			var indexX:Number = attributesX ? attributesX.index : NaN;
			var indexY:Number = attributesY ? attributesY.index : NaN;
			
			return	(	isNaN(indexY)					// if indexY is NaN, consider x it to be bigger
							? 1							// than x, else
							: isNaN(indexX)				// if indexX is NaN, consider x to be smaller
								? -1					// than y, else
								: indexX == indexY		// if the indexs are equal, then so 
									? 0					// are x and y, else
									: indexX < indexY	// if indexX is smaller than indexY, 
										? -1			// then consider x smaller than Y, else
										: 1				// x must be bigger than y.
					);
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override protected function calculateTargetBounds(target:ILayoutTarget, availableWidth:Number, availableHeight:Number):Rectangle
		{
			var rect:Rectangle = new Rectangle(0, 0, target.measuredWidth, target.measuredHeight);
			
			var attributes:LayoutAttributesFacet
				= target.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesFacet
				|| new LayoutAttributesFacet();
				
			var absolute:AbsoluteLayoutFacet
				= target.metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
				as AbsoluteLayoutFacet;
			
			var deltaX:Number;
			var deltaY:Number;
			
			var toDo:int = ALL;
			
			// Next, get all absolute layout values, if available:
			if (absolute)
			{
				if (!isNaN(absolute.x))
				{
					rect.x = absolute.x;
					toDo ^= X;							
				}
				
				if (!isNaN(absolute.y))
				{
					rect.y = absolute.y;
					toDo ^= Y;
				}
				
				if (!isNaN(absolute.width))
				{
					rect.width = absolute.width;
					toDo ^= WIDTH;
				}
				
				if (!isNaN(absolute.height))
				{
					rect.height = absolute.height;
					toDo ^= HEIGHT;
				}
			}
			
			// If not all position and size fieds have been set yet, then continue
			// processing relative parameters:
			if (toDo != 0)
			{
				var relative:RelativeLayoutFacet
					= target.metadata.getFacet(MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS)
					as RelativeLayoutFacet;
					
				if (relative)
				{
					if ((toDo & X) && !isNaN(relative.x))
					{
						rect.x = (availableWidth * relative.x) / 100 || 0;
						toDo ^= X; 
					}
					
					if ((toDo & WIDTH) && !isNaN(relative.width))
					{
						rect.width = (availableWidth * relative.width) / 100;
						toDo ^= WIDTH; 
					}
					
					if ((toDo & Y) && !isNaN(relative.y))
					{
						rect.y = (availableHeight * relative.y) / 100 || 0;
						toDo ^= Y;
					}
					
					if ((toDo & HEIGHT) && !isNaN(relative.height))
					{
						rect.height = (availableHeight * relative.height) / 100;
						toDo ^= HEIGHT;
					}
				}
			}
			
			// Last, do anchors: (doing them last is a natural index because we require
			// a set width and x to do 'right', as well as a set height and y to do
			// 'bottom'.)
			if (toDo != 0)
			{
				var anchors:AnchorLayoutFacet
					= target.metadata.getFacet(MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS)
					as AnchorLayoutFacet;
				
				// Process the anchor parameters:
				if (anchors)
				{
					if ((toDo & X) && !isNaN(anchors.left))
					{
						rect.x = anchors.left;
						toDo ^= X;
					}
					
					if ((toDo & Y) && !isNaN(anchors.top))
					{
						rect.y = anchors.top;
						toDo ^= Y;
					}
					
					if (!isNaN(anchors.right))
					{
						if ((toDo & X) && !(toDo & WIDTH))
						{
							rect.x = Math.max(0, availableWidth - rect.width - anchors.right);
							toDo ^= X;
						}
						else if ((toDo & WIDTH) && !(toDo & X))
						{
							rect.width = Math.max(0, availableWidth - anchors.right - rect.x);
							toDo ^= WIDTH;
						}
					}
					
					if (!isNaN(anchors.bottom))
					{
						if ((toDo & Y) && !(toDo & HEIGHT)) 
						{
							rect.y = Math.max(0, availableHeight - rect.height - anchors.bottom);
							toDo ^= Y;
						}
						else if ((toDo & HEIGHT) && !(toDo & Y))
						{
							rect.height = Math.max(0, availableHeight - anchors.bottom - rect.y);
							toDo ^= HEIGHT;
						}
					}
				}
			}
			
			// Apply padding, if set. Note the bottom and right padding can only be
			// applied when a height and width value are available!
			
			var padding:PaddingLayoutFacet
				= target.metadata.getFacet(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS)
				as PaddingLayoutFacet;
			
			if (padding)
			{
				if (!isNaN(padding.left))
				{
					rect.x += padding.left;
				}
				if (!isNaN(padding.top))
				{
					rect.y += padding.top;
				}
				if (!isNaN(padding.right) && !(toDo & WIDTH))
				{
					rect.width -= padding.right + (padding.left || 0);
				}
				if (!isNaN(padding.bottom) && !(toDo & HEIGHT))
				{
					rect.height -= padding.bottom + (padding.top || 0);
				}
			}
			
			// Apply scaling layoutMode:
			if (attributes.scaleMode)
			{
				if	(!	( toDo & WIDTH || toDo & HEIGHT)					
					&&	target.measuredWidth
					&&	target.measuredHeight
					)
				{
					var size:Point = ScaleModeUtils.getScaledSize
						( attributes.scaleMode
						, rect.width
						, rect.height
						, target.measuredWidth
						, target.measuredHeight
						);
					
					deltaX = rect.width - size.x;
					deltaY = rect.height - size.y;
					
					rect.width = size.x;
					rect.height = size.y;
				}
			}
			
			// Set deltas:
			deltaX ||= availableWidth - (rect.x || 0) - (rect.width || 0);
			deltaY ||= availableHeight - (rect.y || 0) - (rect.height || 0);
			
			// Apply alignment (if there's surpluss space reported:)
			if (deltaY)
			{
				switch (attributes.verticalAlign)
				{
					case null:
					case VerticalAlign.TOP:
						// all set.
						break;
					case VerticalAlign.MIDDLE:
						rect.y += deltaY / 2;
						break;
					case VerticalAlign.BOTTOM:
						rect.y += deltaY;
						break;
				}
			}
			
			if (deltaX)
			{	
				switch (attributes.horizontalAlign)
				{
					case null:
					case HorizontalAlign.LEFT:
						// all set.
						break;
					case HorizontalAlign.CENTER:
						rect.x += deltaX / 2;
						break;
					case HorizontalAlign.RIGHT:
						rect.x += deltaX;
						break;
				}
			}						
			
			// Apply pixel snapping:
			if (attributes.snapToPixel)
			{
			 	rect.x = Math.round(rect.x);
			 	rect.y = Math.round(rect.y);
			 	rect.width = Math.round(rect.width);
			 	rect.height = Math.round(rect.height);
			}
			
			if	(layoutMode == LayoutMode.HORIZONTAL || layoutMode == LayoutMode.VERTICAL)
			{ 
				if (lastCalculatedBounds != null)
				{
					// Apply either the x or y coordinate to apply the desired boxing
					// behavior:
					
					if (layoutMode == LayoutMode.HORIZONTAL)
					{
						rect.x = lastCalculatedBounds.x + lastCalculatedBounds.width;
					}
					else // layoutMode == VERTICAL
					{
						rect.y = lastCalculatedBounds.y + lastCalculatedBounds.height;
					}
				}
				
				lastCalculatedBounds = rect;
			}
			
			CONFIG::LOGGING
			{
				logger.debug
					( "{0} dimensions: {1} available: ({2}, {3}), media: ({4},{5})"
					, target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, rect
					, availableWidth, availableHeight
					, target.measuredWidth, target.measuredHeight
					);
			}
			
			return rect;
		}
		
		/**
		 * @private
		 */		
		override protected function calculateContainerSize(targets:Vector.<ILayoutTarget>):Point
		{
			var size:Point = new Point(NaN, NaN);
			
			var absolute:AbsoluteLayoutFacet
				= container.metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
				as AbsoluteLayoutFacet;
			
			if (absolute)
			{
				size.x = absolute.width;
				size.y = absolute.height;
			}
			
			if (isNaN(size.x) || isNaN(size.y))
			{
				// Iterrate over all targets, calculating their bounds, combining the results
				// into a bounds rectangle:
				var containerBounds:Rectangle = new Rectangle();
				var targetBounds:Rectangle;
				var lastBounds:Rectangle;
				
				for each (var target:ILayoutTarget in targets)
				{
					targetBounds = calculateTargetBounds(target, size.x, size.y);
					targetBounds.x ||= 0;
					targetBounds.y ||= 0;
					targetBounds.width ||= target.measuredWidth || 0;
					targetBounds.height ||= target.measuredHeight || 0;
					
					if (layoutMode == LayoutMode.HORIZONTAL || layoutMode == LayoutMode.VERTICAL)
					{
						if (lastBounds)
						{
							if (layoutMode == LayoutMode.HORIZONTAL)
							{
								targetBounds.x = lastBounds.x + lastBounds.width;
							}
							else // layoutMode == VERTICAL
							{
								targetBounds.y = lastBounds.y + lastBounds.height;
							}
						}
						
						lastBounds = targetBounds;
					}
					
					containerBounds = containerBounds.union(targetBounds);
				}
				
				size.x ||= containerBounds.width;
				size.y ||= containerBounds.height;	
			}
			
			CONFIG::LOGGING
			{
				logger.debug
					( "{0} calculated container size ({1}, {2}) (bounds: {3})"
					, container.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, size.x, size.y
					, containerBounds
					);
			}
			
			return size;
		}
		
		// Internals
		//
		
		private static const USED_METADATA_FACETS:Vector.<URL> = new Vector.<URL>(5, true);
		
		/* static */
		{
			USED_METADATA_FACETS[0] = MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS;
			USED_METADATA_FACETS[1] = MetadataNamespaces.RELATIVE_LAYOUT_PARAMETERS;
			USED_METADATA_FACETS[2] = MetadataNamespaces.ANCHOR_LAYOUT_PARAMETERS;
			USED_METADATA_FACETS[3] = MetadataNamespaces.PADDING_LAYOUT_PARAMETERS;
			USED_METADATA_FACETS[4] = MetadataNamespaces.LAYOUT_ATTRIBUTES;
		}
		
		private static const X:int = 0x1;
		private static const Y:int = 0x2;
		private static const WIDTH:int = 0x4;
		private static const HEIGHT:int = 0x8;
		
		private static const POSITION:int = X + Y;
		private static const DIMENSIONS:int = WIDTH + HEIGHT;
		private static const ALL:int = POSITION + DIMENSIONS;
		
		private var layoutMode:String = LayoutMode.NONE;
		private var lastCalculatedBounds:Rectangle;
		
		private var targetMetadataWatchers:Dictionary = new Dictionary();
		private var containerAbsoluteWatcher:MetadataWatcher;
		private var containerAttributesWatcher:MetadataWatcher;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("DefaultLayoutRenderer");
	}
}