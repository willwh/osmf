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
package org.openvideoplayer.layout
{
	import __AS3__.vec.Vector;
	
	import flash.display.DisplayObject;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.utils.URL;

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
		override protected function processContextChange(oldContext:ILayoutContext, newContext:ILayoutContext):void
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
		override protected function render(targets:Vector.<ILayoutTarget>):void
		{
			for each (var target:ILayoutTarget in targets)
			{
				renderTarget(target);
			}
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function compareTargets(x:ILayoutTarget, y:ILayoutTarget):Number
		{
			if (x == y)
			{
				return 0;
			}
			
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
		
		// Internals
		//
		
		private function renderTarget(target:ILayoutTarget):void
		{
			var view:DisplayObject = target.view;
			var parentWidth:Number = _context.intrinsicWidth;
			var parentHeight:Number = _context.intrinsicHeight;
				
			if (view)
			{
				var attributes:LayoutAttributesFacet
					= target.metadata.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES) as LayoutAttributesFacet
					|| new LayoutAttributesFacet();
					
				var absolute:AbsoluteLayoutFacet
					= target.metadata.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
					as AbsoluteLayoutFacet;
				
				var rect:Rectangle = new Rectangle(NaN, NaN, NaN, NaN);
				var deltaX:Number = 0;
				var deltaY:Number = 0;
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
						if (!isNaN(parentWidth))
						{ 
						 	if ((toDo & X) && !isNaN(relative.x))
							{
								rect.x = (parentWidth * relative.x) / 100;
								toDo ^= X; 
							}
							
							if ((toDo & WIDTH) && !isNaN(relative.width))
							{
								rect.width = (parentWidth * relative.width) / 100;
								toDo ^= WIDTH; 
							}
						}
						
						if (!isNaN(parentHeight))
						{
							if ((toDo & Y) && !isNaN(relative.y))
							{
								rect.y = (parentHeight * relative.y) / 100;
								toDo ^= Y;
							}
							
							if ((toDo & HEIGHT) && !isNaN(relative.height))
							{
								rect.height = (parentHeight * relative.height) / 100;
								toDo ^= HEIGHT;
							}
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
						
						if (!isNaN(parentWidth) && (toDo & WIDTH) && !isNaN(anchors.right))
						{
							rect.width = Math.max(0, parentWidth - anchors.right - ((toDo & X) ? 0 : rect.x));
							toDo ^= WIDTH; 
						}
						
						if (!isNaN(parentHeight) && (toDo & HEIGHT) && !isNaN(anchors.bottom))
						{
							rect.height = Math.max(0, parentHeight - anchors.bottom - ((toDo & Y) ? 0: rect.y));
							toDo ^= HEIGHT;
						}
					}
				}
				
				var padding:PaddingLayoutFacet
					= target.metadata.getFacet(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS)
					as PaddingLayoutFacet;
				
				// Apply padding, if set. Note the bottom and right padding can only be
				// applied when a calculated height and width value are available!
				
				if (padding)
				{
					if (!isNaN(padding.left) && !(toDo & X))
					{
						rect.x = padding.left + rect.x;
					}
					if (!isNaN(padding.top) && !(toDo & Y))
					{
						rect.y = padding.top + rect.y;
					}
					if (!isNaN(padding.right) && !(toDo & WIDTH))
					{
						rect.width -= padding.right + (isNaN(padding.left) ? 0 : padding.left);
					}
					if (!isNaN(padding.bottom) && !(toDo & HEIGHT))
					{
						rect.height -= padding.bottom + (isNaN(padding.top) ? 0 : padding.top);
					}
				}
				
				// Apply scaling mode:
				
				if (attributes.scaleMode)
				{
					if	(!	(	toDo & WIDTH
							||	toDo & HEIGHT
							||	isNaN(target.intrinsicWidth)
							||	isNaN(target.intrinsicHeight)
							||	target.intrinsicWidth == 0
							||	target.intrinsicHeight == 0
							)
						)
					{
						var size:Point = attributes.scaleMode.getScaledSize
							( rect.width, rect.height
							, target.intrinsicWidth, target.intrinsicHeight
							);
						
						deltaX = rect.width - size.x;
						deltaY = rect.height - size.y;
							
						rect.width = size.x;
						rect.height = size.y;
					}
				}
				
				// Apply alignment (if there's surpluss space reported:)
				
				if (deltaX || deltaY)
				{
					switch (attributes.alignment)
					{
						case RegistrationPoint.TOP_LEFT:
							// all set.
							break;
						case RegistrationPoint.MIDDLE_LEFT:
							rect.y = (rect.y ? rect.y : 0) + deltaY / 2;
							toDo ^= Y;
							break;
						case RegistrationPoint.BOTTOM_LEFT:
							rect.y = (rect.y ? rect.y : 0) + deltaY;
							toDo ^= Y;
							break;
						case RegistrationPoint.TOP_MIDDLE:
							rect.x = (rect.x ? rect.x : 0) + deltaX / 2;
							toDo ^= X;
							break;
						case RegistrationPoint.CENTER:
							rect.x = (rect.x ? rect.x : 0) + deltaX / 2;
							rect.y = (rect.y ? rect.y : 0) + deltaY / 2;
							toDo ^= POSITION;
							break;
						case RegistrationPoint.BOTTOM_MIDDLE:
							rect.x = (rect.x ? rect.x : 0) + deltaX / 2;
							rect.y = (rect.y ? rect.y : 0) + deltaY;
							toDo ^= POSITION;
							break;
						case RegistrationPoint.TOP_RIGHT:
							rect.x = (rect.x ? rect.x : 0) + deltaX;
							break;
						case RegistrationPoint.MIDDLE_RIGHT:
							rect.x = (rect.x ? rect.x : 0) + deltaX;
							rect.y = (rect.y ? rect.y : 0) + deltaY / 2;
							toDo ^= POSITION;
							break;
						case RegistrationPoint.BOTTOM_RIGHT:
							rect.x = (rect.x ? rect.x : 0) + deltaX;
							rect.y = (rect.y ? rect.y : 0) + deltaY;
							toDo ^= X;
							break; 
					}
				}
				
				// Apply registration point adjustment:
				
				switch (attributes.registrationPoint)
				{ 
					case RegistrationPoint.TOP_LEFT:
						// all set.
						break;
					case RegistrationPoint.MIDDLE_LEFT:
						rect.y = rect.y - rect.height / 2;
						break;
					case RegistrationPoint.BOTTOM_LEFT:
						rect.y = rect.y - rect.height;
						break;
					case RegistrationPoint.TOP_MIDDLE:
						rect.x = rect.x - rect.width / 2;
						break;
					case RegistrationPoint.CENTER:
						rect.x = rect.x - rect.width / 2;
						rect.y = rect.y - rect.height / 2;
						break;
					case RegistrationPoint.BOTTOM_MIDDLE:
						rect.x = rect.x - rect.width / 2;
						rect.y = rect.y - rect.height;
						break;
					case RegistrationPoint.TOP_RIGHT:
						rect.x = rect.x - rect.width;
						break;
					case RegistrationPoint.MIDDLE_RIGHT:
						rect.x = rect.x - rect.width;
						rect.y = rect.y - rect.height / 2;
						break;
					case RegistrationPoint.BOTTOM_RIGHT:
						rect.x = rect.x - rect.width;
						rect.y = rect.y - rect.height;
						break;
				}
					
				// Apply the set new values to the view:
				
				if (!(toDo & X) && rect.x != view.x)
				{
					view.x = attributes.snapToPixel ? Math.round(rect.x) : rect.x;
				}
				if (!(toDo & Y) && rect.y != view.y)
				{
					view.y = attributes.snapToPixel ? Math.round(rect.y) : rect.y;
				}
				if (!(toDo & WIDTH) && rect.width != view.width)
				{
					view.width = attributes.snapToPixel ? Math.round(rect.width) : rect.width;
				}
				if (!(toDo & HEIGHT) && rect.height != view.height)
				{
					view.height = attributes.snapToPixel ? Math.round(rect.height) : rect.height;
				}
			}
		}
		
		private var _context:ILayoutContext;
		
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
	}
}