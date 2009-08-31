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
package org.openvideoplayer.composition
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.layout.DefaultLayoutRenderer;
	import org.openvideoplayer.layout.ILayoutContext;
	import org.openvideoplayer.layout.ILayoutRenderer;
	import org.openvideoplayer.layout.LayoutContextSprite;
	import org.openvideoplayer.layout.LayoutRendererFacet;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]
	
	/**
	 * Dispatched when the width and/or height of the trait's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]
	
	/**
	 * Implements IViewable and ISpatial.
	 * 
	 * The view property of the viewable trait of a composition refers to a
	 * DisplayObjectContainer implementing instance, that holds each of the composition's
	 * viewable children's DisplayObject.
	 * 
	 * The bounds of the container determine the ISpatial aspect of the composition, hence
	 * this class also implements that trait.
	 * 
	 * The viewable and/or spatial characteristics of a composite changing, influence
	 * the containers characteristics - hence the trait needs to watch these traits on
	 * its children.
	 */	
	internal class CompositeViewableTrait extends CompositeMediaTraitBase implements IViewable, ISpatial
	{
		public function CompositeViewableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			this.owner = owner as CompositeElement;
			
			// Prepare a container to hold our viewable children:
			container = constructLayoutContext();
			container.addEventListener
				( DimensionChangeEvent.DIMENSION_CHANGE
				, onLayoutDimensionChange
				);
			
			// Watch our owner's metadata for a layout class being set:
			MetadataUtils.watchFacet
				( owner.metadata
				, MetadataNamespaces.LAYOUT_RENDERER
				, layoutRendererFacetChangeCallback
				);
			
			super(MediaTraitType.VIEWABLE, traitAggregator);
		}
		
		// IViewable
		//
		
		public function get view():DisplayObject
		{
			// The aggregate view is the container holding the composite's
			// viewable children:
			return container.view;
		}
		
		// ISpatial
		//
		
		/**
		 * @inheritDoc
		 */		
		public function get width():int
		{
			return container.intrinsicWidth;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get height():int
		{
			return container.intrinsicHeight;
		}
		
		// Public API
		//
		
		public function get layoutRenderer():ILayoutRenderer
		{
			return _layoutRenderer;
		}
		
		// Protected API
		//
		
		protected function constructLayoutContext():ILayoutContext
		{
			return new LayoutContextSprite(owner.metadata);
		}
		
		protected function onLayoutDimensionChange(event:DimensionChangeEvent):void
		{
			// Re-dispatch the event, this time as ISpatial.
			dispatchEvent(event.clone());
		}
		
		// Internals
		//
		
		private function layoutRendererFacetChangeCallback(facet:IFacet):void
		{
			if (_layoutRenderer)
			{
				_layoutRenderer.context = null;
				_layoutRenderer = null;
			}
			
			var layoutRendererFacet:LayoutRendererFacet
				= facet as LayoutRendererFacet;
				
			if (layoutRendererFacet)
			{
				try
				{
					_layoutRenderer
						= new layoutRendererFacet.renderer()
						as ILayoutRenderer;
				}
				catch(e:*)
				{
					throw new IllegalOperationError(MediaFrameworkStrings.INVALID_LAYOUTRENDERER_CONSTRUCTOR);
				}
			}
			
			if (_layoutRenderer == null)
			{
				_layoutRenderer = new DefaultLayoutRenderer();
			}
			
			_layoutRenderer.context = container;
		}
		
		private var owner:CompositeElement;
		private var container:ILayoutContext;
		private var _layoutRenderer:ILayoutRenderer;
	}
}