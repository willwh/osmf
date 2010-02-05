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
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.layout.DefaultLayoutRenderer;
	import org.osmf.layout.ILayoutTarget;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutTargetSprite;
	import org.osmf.logging.ILogger;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Facet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.ObjectFacet;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.utils.OSMFStrings;
	
	/**
	 * Composite CompositeDisplayObjectTrait.
	 * 
	 * The displayObject property of the composite trait refers to a
	 * DisplayObjectContainer implementing instance, that holds each of the composite trait
	 * children's display objects.
	 * 
	 * The bounds of the childrenContainer determine the media size of the composition.
	 * 
	 * The characteristics of a composite trait changing influence
	 * the childrenContainer's characteristics - hence the trait needs to watch these traits on
	 * its children.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	internal class CompositeDisplayObjectTrait extends DisplayObjectTrait
	{
		public function CompositeDisplayObjectTrait(traitAggregator:TraitAggregator, owner:MediaElement)
		{
			super(null);
			
			_traitAggregator = traitAggregator;
			_owner = owner as CompositeElement;
			
			// Prepare a childrenContainer to hold our viewable children:
			_childrenContainer = constructChildrenContainer();
			_childrenContainer.addEventListener
				( DisplayObjectEvent.MEDIA_SIZE_CHANGE
				, onContainerDimensionChange
				);
			
			// Watch our owner's metadata for a layout class being set:
			MetadataUtils.watchFacet
				( owner.metadata
				, MetadataNamespaces.LAYOUT_RENDERER_TYPE
				, layoutRendererFacetChangeCallback
				);
		}
		
		/**
		 * @private
		 */
		override public function get displayObject():DisplayObject
		{
			// The aggregate displayObject is the childrenContainer holding the composite
			// trait's children:
			return _childrenContainer.displayObject;
		}

		/**
		 * @private
		 */		
		override public function get mediaWidth():Number
		{
			return _childrenContainer.mediaWidth;
		}
		
		/**
		 * @private
		 */		
		override public function get mediaHeight():Number
		{
			return _childrenContainer.mediaHeight;
		}
		
		// Protected API
		//
		
		protected function get layoutRenderer():LayoutRenderer
		{
			return _layoutRenderer;
		}
		
		protected function get traitAggregator():TraitAggregator
		{
			return _traitAggregator;
		}
		
		protected function get owner():CompositeElement
		{
			return _owner;
		}
		
		protected function get childrenContainer():ILayoutTarget
		{
			return _childrenContainer;
		}
		
		// Internals
		//
		
		private function constructChildrenContainer():ILayoutTarget
		{
			return new LayoutTargetSprite(_owner.metadata);
		}

		private function onContainerDimensionChange(event:DisplayObjectEvent):void
		{
			// Re-dispatch the event.
			dispatchEvent(event.clone());
		}

		private function layoutRendererFacetChangeCallback(facet:Facet):void
		{
			if (_layoutRenderer)
			{
				_layoutRenderer.container = null;
				_layoutRenderer = null;
			}
			
			var layoutRendererFacet:ObjectFacet	= facet as ObjectFacet;
				
			if (layoutRendererFacet)
			{
				try
				{
					_layoutRenderer
						= new (Class(layoutRendererFacet.object))()
						as LayoutRenderer;
				}
				catch (e:*)
				{
					throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_LAYOUTRENDERER_CONSTRUCTOR));
				}
			}
			
			if (_layoutRenderer == null)
			{
				_layoutRenderer = new DefaultLayoutRenderer();
			}
			
			_layoutRenderer.container = _childrenContainer;
		}

		private var _traitAggregator:TraitAggregator;		
		private var _owner:CompositeElement;
		private var _childrenContainer:ILayoutTarget;
		private var _layoutRenderer:LayoutRenderer;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("CompositeDisplayObjectTrait");
	}
}