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
	import flash.errors.IllegalOperationError;
	
	import org.osmf.display.ScaleMode;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Static utility functions used with Layouts.
	 */		
	public class LayoutUtils
	{
		// Public API
		//
		
		/**
		 * Applies the specified absolute layout properties to a media element's metadata:
		 * 
		 * @param target Metadata that will get the specified properties set on its
		 * absolute layout facet.
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @return Either a newly created, or updated AbsoluteLayoutFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the AbsoluteLayoutFacet documentation for the semantics of
		 * the x, y, width, and height parameters.
		 */		
		public static function setAbsoluteLayout
								( target:Metadata
								, width:Number, height:Number
								, x:Number = Number.NEGATIVE_INFINITY
								, y:Number = Number.NEGATIVE_INFINITY
								):AbsoluteLayoutFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var absoluteLayout:AbsoluteLayoutFacet
				= 	target.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
					as AbsoluteLayoutFacet;
				
			if (absoluteLayout == null)
			{
				addFacet = true;
				absoluteLayout = new AbsoluteLayoutFacet();
			}
			
			if (x != Number.NEGATIVE_INFINITY)
			{
				absoluteLayout.x = x;
			}
			
			if (y != Number.NEGATIVE_INFINITY)
			{
				absoluteLayout.y = y;
			}
			
			absoluteLayout.width = width;
			absoluteLayout.height = height;
			
			if (addFacet)
			{
				target.addFacet(absoluteLayout);
			}
			
			return absoluteLayout;
		}
		
		/**
		 * Applies the specified relative layout properties to a media element's metadata:
		 * 
		 * @param target Metadata that will get the specified properties set on its
		 * relative layout facet.
		 * @param x
		 * @param y
		 * @param width
		 * @param height
		 * @return Either a newly created, or updated RelativeLayoutFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the RelativeLayoutFacet documentation for the semantics of
		 * the x, y, width, and height parameters.
		 */		
		public static function setRelativeLayout
								( target:Metadata
								, width:Number, height:Number
								, x:Number = Number.NEGATIVE_INFINITY
								, y:Number = Number.NEGATIVE_INFINITY
								):RelativeLayoutFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var relativeLayout:RelativeLayoutFacet
				= 	target.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
					as RelativeLayoutFacet;
				
			if (relativeLayout == null)
			{
				addFacet = true;
				relativeLayout = new RelativeLayoutFacet();
			}
			
			if (x != Number.NEGATIVE_INFINITY)
			{
				relativeLayout.x = x;
			}
			
			if (y != Number.NEGATIVE_INFINITY)
			{
				relativeLayout.y = y;
			}
			
			relativeLayout.width = width;
			relativeLayout.height = height;
			
			if (addFacet)
			{
				target.addFacet(relativeLayout);
			}
			
			return relativeLayout;
		}
		
		/**
		 * Applies the specified anchor layout properties to a media element's metadata:
		 * 
		 * @param target Metadata that will get the specified properties set on its
		 * anchor layout facet.
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * @return Either a newly created, or updated AnchorLayoutFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the AnchorLayoutFacet documentation for the semantics of
		 * the left, top, right, and bottom parameters.
		 */		
		public static function setAnchorLayout
								( target:Metadata
								, left:Number, top:Number
								, right:Number, bottom:Number
								):AnchorLayoutFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var anchorLayout:AnchorLayoutFacet
				= 	target.getFacet(MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS)
					as AnchorLayoutFacet;
				
			if (anchorLayout == null)
			{
				addFacet = true;
				anchorLayout = new AnchorLayoutFacet();
			}
			
			anchorLayout.left = left;
			anchorLayout.top = top;
			anchorLayout.right = right;
			anchorLayout.bottom = bottom;
			
			if (addFacet)
			{
				target.addFacet(anchorLayout);
			}
			
			return anchorLayout;
		}
		
		/**
		 * Applies the specified padding layout properties to a media element's metadata:
		 * 
		 * @param target Metadata that will get the specified properties set on its
		 * padding layout facet.
		 * @param left
		 * @param top
		 * @param right
		 * @param bottom
		 * @return Either a newly created, or updated PaddingLayoutFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the PaddingLayoutFacet documentation for the semantics of
		 * the left, top, right, and bottom parameters.
		 */		
		public static function setPaddingLayout
								( target:Metadata
								, left:Number, top:Number
								, right:Number, bottom:Number
								):PaddingLayoutFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var paddingLayout:PaddingLayoutFacet
				= 	target.getFacet(MetadataNamespaces.PADDING_LAYOUT_PARAMETERS)
					as PaddingLayoutFacet;
				
			if (paddingLayout == null)
			{
				addFacet = true;
				paddingLayout = new PaddingLayoutFacet();
			}
			
			paddingLayout.left = left;
			paddingLayout.top = top;
			paddingLayout.right = right;
			paddingLayout.bottom = bottom;
			
			if (addFacet)
			{
				target.addFacet(paddingLayout);
			}
			
			return paddingLayout;
		}
		
		/**
		 * Applies the specified layout attributes.
		 *  
		 * @param target Metadata that will get the specified properties set on its
		 * layout attributes facet.
		 * @param scaleMode The scale mode to set.
		 * @param alignment The alignment mode to set.
		 * @param order Display stack order (highest number is on top).
		 * @param snapToPixel If true, the renderer will round the calculated metrics to
		 * natural numbers.
		 * @return Either a newly created, or updated LayoutAttributesFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the LayoutAttributesFacet documentation for the semantics of
		 * the scaleMode and alignment parameters.
		 */		
		public static function setLayoutAttributes
									( target:Metadata
									, scaleMode:ScaleMode
									, alignment:RegistrationPoint = null
									, order:Number = NaN
									, snapToPixel:Boolean = false
									):LayoutAttributesFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var layoutAttributes:LayoutAttributesFacet
				= target.getFacet(MetadataNamespaces.LAYOUT_ATTRIBUTES)
				as LayoutAttributesFacet;
			
			if (layoutAttributes == null)
			{
				layoutAttributes = new LayoutAttributesFacet();
				addFacet = true;
			}
			
			layoutAttributes.scaleMode = scaleMode;
			
			if (alignment)
			{
				layoutAttributes.alignment = alignment;
			}
			if (!isNaN(order))
			{
				layoutAttributes.order = order;			
			}
			
			layoutAttributes.snapToPixel = snapToPixel;
			
			if (addFacet)
			{
				target.addFacet(layoutAttributes);
			}
			
			return layoutAttributes;
		}
		
		/**
		 * Applies the specified renderer type to the specified metadata target.
		 *  
		 * @param target Metadata that will get the specified renderer set on its
		 * layout renderer facet.
		 * @param renderer The renderer type to set.
		 * @return Either a newly created, or updated LayoutRendererFacet instance that
		 * contains the specified properties.
		 * @throws IllegalOperationError on a null argument being passed for target.
		 * 
		 * Please referer to the LayoutRendererFacet documentation for the semantics of
		 * setting a renderer type.
		 */	
		public static function setLayoutRenderer(target:Metadata, renderer:Class):LayoutRendererFacet
		{
			if (target == null)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.NULL_PARAM);
			}
			
			var addFacet:Boolean;
			var layoutRenderer:LayoutRendererFacet
				= 	target.getFacet(MetadataNamespaces.LAYOUT_RENDERER)
					as LayoutRendererFacet;
				
			if (layoutRenderer == null)
			{
				addFacet = true;
				layoutRenderer = new LayoutRendererFacet(renderer);
			}
			
			if (addFacet)
			{
				target.addFacet(layoutRenderer);
			}
			
			return layoutRenderer;
		}

	}
}