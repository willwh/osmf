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
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	import org.openvideoplayer.events.DimensionChangeEvent;
	import org.openvideoplayer.events.RegionChangeEvent;
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.metadata.IFacet;
	import org.openvideoplayer.metadata.Metadata;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.MetadataUtils;
	import org.openvideoplayer.metadata.MetadataWatcher;
	import org.openvideoplayer.regions.IRegion;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;

	/**
	 * Dispatched when a layout child's view has changed.
	 * 
	 * @eventType org.openvideoplayer.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.openvideoplayer.events.ViewChangeEvent")]
	
	/**
	 * Dispatched when a layout element's intrinsical width and height changed.
	 * 
	 * @eventType org.openvideoplayer.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.openvideoplayer.events.DimensionChangeEvent")]

	/**
	 * Dispatched when a layout element's 'regionTarget' metadata value changed. 
	 */	
	[Event(name="regionChange",type="org.openvideoplayer.events.RegionChangeEvent")]

	/**
	 * Class wraps a MediaElement into a ILayoutChild.
	 */	
	public class MediaElementLayoutTarget extends EventDispatcher implements ILayoutTarget
	{
		public function MediaElementLayoutTarget(_mediaElement:MediaElement)
		{
			this._mediaElement = _mediaElement;
			
			_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onMediaElementTraitsChange);
			_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onMediaElementTraitsChange);
			
			regionTargetWatcher
				= MetadataUtils.watchFacet
					( _mediaElement.metadata
					, MetadataNamespaces.REGION_TARGET
					, regionTargetChangeCallback
					);
			
			updateViewableTrait();
			updateSpatialTrait();
		}

		// ILayoutTarget
		//

		/**
		 * @inheritDoc
		 */
		public function get metadata():Metadata
		{
			return _mediaElement.metadata;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get view():DisplayObject
		{
			return viewableTrait ? viewableTrait.view : null;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicWidth():Number
		{
			return spatialTrait ? spatialTrait.width : NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicHeight():Number
		{
			return spatialTrait ? spatialTrait.height : NaN;
		}
		
		// Public interface
		//
		
		public function get mediaElement():MediaElement
		{
			return _mediaElement;
		}
		
		public function get regionTarget():IRegion
		{
			return _regionTarget;
		}
		
		// Internals
		//
		
		private function onMediaElementTraitsChange(event:TraitsChangeEvent):void
		{
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				updateViewableTrait();
			}
			else if (event.traitType == MediaTraitType.SPATIAL)
			{
				updateSpatialTrait();
			}
		}
		
		private function updateViewableTrait():void
		{
			var oldTrait:IViewable = viewableTrait;
			var oldView:DisplayObject = view;
			
			viewableTrait = _mediaElement.getTrait(MediaTraitType.VIEWABLE) as IViewable;
			
			if (oldTrait)
			{
				oldTrait.removeEventListener(ViewChangeEvent.VIEW_CHANGE, redispatchingEventHandler);
			}
			
			if (viewableTrait)
			{
				viewableTrait.addEventListener(ViewChangeEvent.VIEW_CHANGE, redispatchingEventHandler, false, 0, true);
			}
			
			if 	(oldView != view)
			{
				dispatchEvent(new ViewChangeEvent(oldView, view));
			}
		}
		
		private function updateSpatialTrait():void
		{
			var oldTrait:ISpatial = spatialTrait;
			var oldWidth:Number = intrinsicWidth;
			var oldHeight:Number = intrinsicHeight;
			
			spatialTrait = _mediaElement.getTrait(MediaTraitType.SPATIAL) as ISpatial;
			
			if (oldTrait)
			{
				oldTrait.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, redispatchingEventHandler);
			}
			
			if (spatialTrait)
			{
				spatialTrait.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, redispatchingEventHandler, false, 0, true);
			}
			
			if 	(	oldWidth != intrinsicWidth
				||	oldHeight != intrinsicHeight
				)
			{
				dispatchEvent(new DimensionChangeEvent(oldWidth, oldHeight, intrinsicWidth, intrinsicHeight));
			}
		}
		
		private function redispatchingEventHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private function regionTargetChangeCallback(facet:IFacet):void
		{
			var newTarget:IRegion 
				= 	( facet 
						? facet.getValue(null)
						: null
					)
					as IRegion;
					
			if (newTarget != _regionTarget)
			{
				var event:RegionChangeEvent	= new RegionChangeEvent(_regionTarget, newTarget);
				
				_regionTarget = newTarget;
				
				dispatchEvent(event);
			}
		}
		
		private var _mediaElement:MediaElement;
		
		private var viewableTrait:IViewable;
		private var spatialTrait:ISpatial;
		
		private var regionTargetWatcher:MetadataWatcher;
		private var _regionTarget:IRegion;
	}
}