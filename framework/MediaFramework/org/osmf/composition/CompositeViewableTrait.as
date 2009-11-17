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
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	
	import org.osmf.events.DimensionEvent;
	import org.osmf.events.ViewEvent;
	import org.osmf.layout.DefaultLayoutRenderer;
	import org.osmf.layout.ILayoutContext;
	import org.osmf.layout.ILayoutRenderer;
	import org.osmf.layout.LayoutContextSprite;
	import org.osmf.layout.LayoutRendererFacet;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.IFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when the trait's view has changed.
	 * 
	 * @eventType org.osmf.events.ViewEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewEvent")]
	
	/**
	 * Dispatched when the width and/or height of the trait's view has changed.
	 * 
	 * @eventType org.osmf.events.DimensionEvent.DIMENSION_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionEvent")]
	
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
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */	
	internal class CompositeViewableTrait extends CompositeMediaTraitBase implements IViewable, ISpatial
	{
		public function CompositeViewableTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			this.owner = owner as CompositeElement;
			
			// Prepare a container to hold our viewable children:
			container = constructLayoutContext();
			container.addEventListener
				( DimensionEvent.DIMENSION_CHANGE
				, onContainerDimensionChange
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
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get width():Number
		{
			return container.intrinsicWidth;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get height():Number
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
		
		protected function onContainerDimensionChange(event:DimensionEvent):void
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
						= new layoutRendererFacet.rendererType()
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
			
			container.layoutRenderer = _layoutRenderer;
			_layoutRenderer.context = container;
		}
		
		private var owner:CompositeElement;
		private var container:ILayoutContext;
		private var _layoutRenderer:ILayoutRenderer;
	}
}