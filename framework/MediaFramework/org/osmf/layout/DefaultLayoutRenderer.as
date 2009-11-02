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
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
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
	 */	
	public class DefaultLayoutRenderer extends LayoutRendererBase
	{
		// Overrides
		//
		
		/**
		 * @inheritDoc
		 */
		override protected function processContextChange(oldContext:ILayoutTarget, newContext:ILayoutTarget):void
		{
			_context = newContext;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function get usedMetadataFacets():Vector.<URL>
		{
			return USED_METADATA_FACETS;
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function compareTargets(x:ILayoutTarget, y:ILayoutTarget):Number
		{
			var attributesX:LayoutAttributesFacet
				= x.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES)
				as LayoutAttributesFacet;
				
			var attributesY:LayoutAttributesFacet
				= y.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES)
				as LayoutAttributesFacet;
				
			var orderX:Number = attributesX ? attributesX.order : NaN;
			var orderY:Number = attributesY ? attributesY.order : NaN;
			
			return	(	isNaN(orderX)					// if orderX is NaN, consider x it to be smaller
							? -1						// than y, else
							: isNaN(orderY)				// if orderY is NaN, consider y to be smaller
								? 1						// than x, else
								: orderX == orderY		// if the orders are equal, then so 
									? 0					// are x and y, else
									: orderX < orderY	// if orderX is smaller than orderY, 
										? -1			// then consider x smaller than Y, else
										: 1				// x must be bigger than y.
					);
		}
		
		// Overrides
		//
		
		override protected function processTargetAdded(target:ILayoutTarget):void
		{
			metaDataWatchers[target] = MetadataUtils.watchFacetValue
				( target.metadata
				, MetadataNamespaces.LAYOUT_ATTRIBUTES
				, LayoutAttributesFacet.ORDER
				, function(..._):void 
					{
						updateTargetOrder(target);
					}
				);
		}
		
		override protected function processTargetRemoved(target:ILayoutTarget):void
		{
			var watcher:MetadataWatcher = metaDataWatchers[target];
			delete metaDataWatchers[target];
			
			watcher.unwatch();
			watcher = null;
		}
	
		
		override protected function calculateTargetBounds(target:ILayoutTarget):Rectangle
		{
			return calculatePositionAndDimensions(target, NaN, NaN, false);
		}
		
		override protected function applyTargetLayout(target:ILayoutTarget, availableWidth:Number, availableHeight:Number):Rectangle
		{
			var rect:Rectangle 
				= calculatePositionAndDimensions
					( target
					, availableWidth
					, availableHeight
					, true
					)
					;
			var view:DisplayObject = target.view;
			if (view)
			{
				view.x = rect.x;
				view.y = rect.y;
				view.width = isNaN(rect.width) ? view.width : rect.width;
				view.height = isNaN(rect.height) ? view.height : rect.height;
			}
			
			return rect;
		}
		
		// Internals
		//
		
		private function calculatePositionAndDimensions
								( target:ILayoutTarget
								, availableWidth:Number
								, availableHeight:Number
								, layoutPass:Boolean
								):Rectangle
		{
			var targetContext:ILayoutContext = target as ILayoutContext;
			var rect:Rectangle = new Rectangle(0, 0, target.intrinsicWidth, target.intrinsicHeight);
			
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
			
			// Last, do anchors: (doing them last is a natural order because we require
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
			
			if (layoutPass)
			{
				if (targetContext)
				{
					if (toDo & WIDTH)
					{
						rect.width = targetContext.calculatedWidth;
						toDo ^= WIDTH;
					}
					
					if (toDo & HEIGHT)
					{
						rect.height = targetContext.calculatedHeight;
						toDo ^= HEIGHT;
					}
				}
			}
			else
			{
				if (toDo & WIDTH)
				{
					rect.width = target.intrinsicWidth;
					toDo ^= WIDTH;	
				}
				
				if (toDo & HEIGHT)
				{
					rect.height = target.intrinsicHeight;
					toDo ^= HEIGHT;
				}
			}
			
			// Apply padding, if set. Note the bottom and right padding can only be
			// applied when a calculated height and width value are available!
			
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
			
			// Apply scaling mode:
			if (attributes.scaleMode)
			{
				var intrinsicOrCalculatedWidth:Number
					=	target.intrinsicWidth
					|| 	( targetContext
							? targetContext.calculatedWidth
							: NaN
						);
							
				var intrinsicOrCalculatedHeight:Number
					=	target.intrinsicHeight
					||	( targetContext
							? targetContext.calculatedHeight
							: 0
						);
				  
				if	(!	( toDo & WIDTH || toDo & HEIGHT)					
					&&	intrinsicOrCalculatedWidth
					&&	intrinsicOrCalculatedHeight
					)
				{
					var size:Point = attributes.scaleMode.getScaledSize
						( rect.width, rect.height
						, intrinsicOrCalculatedWidth
						, intrinsicOrCalculatedHeight
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
			if (deltaX || deltaY)
			{
				deltaX ||= 0;
				deltaY ||= 0;
				
				switch (attributes.alignment)
				{
					case RegistrationPoint.TOP_LEFT:
						// all set.
						break;
					case RegistrationPoint.MIDDLE_LEFT:
						rect.y += deltaY / 2;
						toDo ^= Y;
						break;
					case RegistrationPoint.BOTTOM_LEFT:
						rect.y += deltaY;
						toDo ^= Y;
						break;
					case RegistrationPoint.TOP_MIDDLE:
						rect.x += deltaX / 2;
						toDo ^= X;
						break;
					case RegistrationPoint.CENTER:
						rect.x += deltaX / 2;
						rect.y += deltaY / 2;
						toDo ^= POSITION;
						break;
					case RegistrationPoint.BOTTOM_MIDDLE:
						rect.x += deltaX / 2;
						rect.y += deltaY;
						toDo ^= POSITION;
						break;
					case RegistrationPoint.TOP_RIGHT:
						rect.x += deltaX;
						toDo ^= X;
						break;
					case RegistrationPoint.MIDDLE_RIGHT:
						rect.x += deltaX;
						rect.y += deltaY / 2;
						toDo ^= POSITION;
						break;
					case RegistrationPoint.BOTTOM_RIGHT:
						rect.x += deltaX;
						rect.y += deltaY;
						toDo ^= POSITION;
						break; 
				}
			}
			
			// Apply registration point adjustments:
			
			switch (attributes.registrationPoint)
			{ 
				case RegistrationPoint.TOP_LEFT:
					// all set.
					break;
				case RegistrationPoint.MIDDLE_LEFT:
					rect.y -= rect.height / 2;
					toDo ^= Y;
					break;
				case RegistrationPoint.BOTTOM_LEFT:
					rect.y -= rect.height;
					toDo ^= Y;
					break;
				case RegistrationPoint.TOP_MIDDLE:
					rect.x -= rect.width / 2;
					toDo ^= X;
					break;
				case RegistrationPoint.CENTER:
					rect.x -= rect.width / 2;
					rect.y -= rect.height / 2;
					toDo ^= POSITION;
					break;
				case RegistrationPoint.BOTTOM_MIDDLE:
					rect.x -= rect.width / 2;
					rect.y -= rect.height;
					toDo ^= POSITION;
					break;
				case RegistrationPoint.TOP_RIGHT:
					rect.x -= rect.width;
					toDo ^= X;
					break;
				case RegistrationPoint.MIDDLE_RIGHT:
					rect.x -= rect.width;
					rect.y -= rect.height / 2;
					toDo ^= POSITION;
					break;
				case RegistrationPoint.BOTTOM_RIGHT:
					rect.x -= rect.width;
					rect.y -= rect.height;
					toDo ^= POSITION;
					break;
			}
			
			// Apply pixel snapping:
			if (attributes.snapToPixel)
			{
			 	rect.x = Math.round(rect.x);
			 	rect.y = Math.round(rect.y);
			 	rect.width = Math.round(rect.width);
			 	rect.height = Math.round(rect.height);
			}
			
			CONFIG::LOGGING
			{
				logger.debug
					( "{0} {1} dimensions: {2} available: {3}, {4}"
					, target.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, layoutPass ? "layout":"calculated"
					, rect
					, availableWidth,availableHeight
					);
			}
			
			return rect;
		}
		
		// Internals
		//
		
		private var _context:ILayoutTarget;
		
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
		
		private var metaDataWatchers:Dictionary = new Dictionary();
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("DefaultLayoutRenderer");
	}
}