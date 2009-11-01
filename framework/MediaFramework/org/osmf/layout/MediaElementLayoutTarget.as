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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.errors.IllegalOperationError;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.DimensionChangeEvent;
	import org.osmf.events.TraitsChangeEvent;
	import org.osmf.events.ViewChangeEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.ISpatial;
	import org.osmf.traits.IViewable;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.MediaFrameworkStrings;

	/**
	 * Dispatched when a layout child's _view has changed.
	 * 
	 * @eventType org.osmf.events.ViewChangeEvent.VIEW_CHANGE
	 */	
	[Event(name="viewChange",type="org.osmf.events.ViewChangeEvent")]
	
	/**
	 * Dispatched when a layout element's intrinsical width and height changed.
	 * 
	 * @eventType org.osmf.events.DimensionChangeEvent.DIMENSION_CHANGE
	 */	
	[Event(name="dimensionChange",type="org.osmf.events.DimensionChangeEvent")]

	/**
	 * Class wraps a MediaElement into a ILayoutChild.
	 */	
	public class MediaElementLayoutTarget extends EventDispatcher implements ILayoutTarget, ILayoutContext
	{
		/**
		 * @private
		 * 
		 * Constructor. For internal use only: to obtain a MediaElementLayoutTarget instance
		 * use the getInstance method. This ensures that there's no more than one MediaElementLayoutTarget
		 * instance per MediaElement instance.
		 * 
		 * @param mediaElement
		 * @param constructorLock
		 */		
		public function MediaElementLayoutTarget(mediaElement:MediaElement, constructorLock:Class)
		{
			if (constructorLock != ConstructorLock)
			{
				throw new IllegalOperationError(MediaFrameworkStrings.ILLEGAL_CONSTRUCTOR_INVOKATION);
			}
			else
			{
				this._mediaElement = mediaElement;
				
				_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_ADD, onMediaElementTraitsChange);
				_mediaElement.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onMediaElementTraitsChange);
				
				updateViewableTrait();
				updateSpatialTrait();
			}
		}
		
		// ILayoutTarget
		//

		/**
		 * @inheritDoc
		 */
		public function get layoutRenderer():ILayoutRenderer
		{
			return viewLayoutTarget ? viewLayoutTarget.layoutRenderer : null;
		}
		
		public function set layoutRenderer(value:ILayoutRenderer):void
		{
			if (viewLayoutTarget)
			{
				viewLayoutTarget.layoutRenderer = value;
			}
		}
		
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
			return _view;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get container():DisplayObjectContainer
		{
			return viewLayoutTarget ? viewLayoutTarget.container : null; 
		}
		
		/**
		 * @inheritDoc
		 */
		public function get firstChildIndex():uint
		{
			return viewLayoutTarget ? viewLayoutTarget.firstChildIndex : 0;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicWidth():Number
		{
			return viewLayoutTarget
					? viewLayoutTarget.intrinsicWidth
				 	: spatialTrait 
				 		? spatialTrait.width
				 		: NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function get intrinsicHeight():Number
		{
			return viewLayoutTarget
					? viewLayoutTarget.intrinsicHeight
					: spatialTrait
						? spatialTrait.height
						: NaN;
		}
		
		/**
		 * @inheritDoc
		 */
		public function updateIntrinsicDimensions():void
		{
			if (viewLayoutTarget)
			{
				viewLayoutTarget.updateIntrinsicDimensions();
			}
		}
		
		/**
		 * @inheritDoc
		 */
	 	public function set calculatedWidth(value:Number):void
	 	{
	 		if (viewLayoutTarget)
	 		{
	 			viewLayoutTarget.calculatedWidth = value;
	 		}
	 		else
	 		{
	 			_calculatedWidth = value;
	 		}
	 	}
	 	public function get calculatedWidth():Number
	 	{
	 		return viewLayoutTarget
	 				? viewLayoutTarget.calculatedWidth
	 				: _calculatedWidth;
	 	}
	 	
	 	/**
		 * @inheritDoc
		 */
		public function set calculatedHeight(value:Number):void
		{
			_calculatedHeight = value;
			if (viewLayoutTarget)
	 		{
	 			viewLayoutTarget.calculatedHeight = value;
	 		}
		}
		public function get calculatedHeight():Number
		{
			return viewLayoutTarget
					? viewLayoutTarget.calculatedHeight
					: _calculatedHeight;
		}
		
		/**
		 * @inheritDoc
		 */
		public function set projectedWidth(value:Number):void
	 	{
	 		if (viewLayoutTarget)
	 		{
	 			viewLayoutTarget.projectedWidth = value;
	 		}
	 		else
	 		{
	 			_projectedWidth = value;
	 		}
	 	}
	 	public function get projectedWidth():Number
	 	{
	 		return viewLayoutTarget
	 				? viewLayoutTarget.projectedWidth
	 				: _projectedWidth;
	 	}
	 	
	 	/**
		 * @inheritDoc
		 */
		public function set projectedHeight(value:Number):void
		{
	 		_projectedHeight = value;
			if (viewLayoutTarget)
	 		{
	 			viewLayoutTarget.projectedHeight = value;
	 		}
		}
		public function get projectedHeight():Number
		{
			return viewLayoutTarget
					? viewLayoutTarget.projectedHeight
					: _projectedHeight;
		}
		
		// Public interface
		//
		
		/* Static */
		
		public static function getInstance(mediaElement:MediaElement):MediaElementLayoutTarget
		{
			var instance:* = layoutTargets[mediaElement];
			
			CONFIG::LOGGING 
			{
				logger.debug
					( "getInstance, elem.ID: {0}, instance: {1}"
					, mediaElement.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, instance
					);
			}
			
			if (instance == undefined)
			{
				instance = new MediaElementLayoutTarget(mediaElement, ConstructorLock);
				layoutTargets[mediaElement] = instance;
			}
			
			return instance;
		}
		
		public function get mediaElement():MediaElement
		{
			return _mediaElement;
		}
		
		// Internals
		//
		
		/* Static */
		
		private static const layoutTargets:Dictionary = new Dictionary(true);
		
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
			var oldView:DisplayObject = _view;
			
			viewableTrait = _mediaElement.getTrait(MediaTraitType.VIEWABLE) as IViewable;
			
			if (oldTrait)
			{
				oldTrait.removeEventListener(ViewChangeEvent.VIEW_CHANGE, viewChangeEventHandler);
			}
			
			if (viewableTrait)
			{
				processViewChange(viewableTrait.view);
				viewableTrait.addEventListener(ViewChangeEvent.VIEW_CHANGE, viewChangeEventHandler, false, 0, true);
			}
			else
			{
				processViewChange(null);
			}
			
			if 	(oldView != _view)
			{
				dispatchEvent(new ViewChangeEvent(oldView, _view));
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
				oldTrait.removeEventListener(DimensionChangeEvent.DIMENSION_CHANGE, dimensionChangeEventHandler);
			}
			
			if (spatialTrait)
			{
				spatialTrait.addEventListener(DimensionChangeEvent.DIMENSION_CHANGE, dimensionChangeEventHandler, false, 0, true);
			}
			
			if 	(	oldWidth != intrinsicWidth
				||	oldHeight != intrinsicHeight
				)
			{
				dispatchEvent(new DimensionChangeEvent(oldWidth, oldHeight, intrinsicWidth, intrinsicHeight));
			}
		}
		
		private function viewChangeEventHandler(event:ViewChangeEvent):void
		{
			processViewChange(event.newView);
			
			dispatchEvent(event.clone());
		}
		
		private function dimensionChangeEventHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private function processViewChange(newView:DisplayObject):void
		{
			_view = newView;
			viewLayoutTarget = _view as ILayoutContext;
		}
		
		private var _mediaElement:MediaElement;
		private var _view:DisplayObject;
		private var viewLayoutTarget:ILayoutContext;
		
		private var viewableTrait:IViewable;
		private var spatialTrait:ISpatial;
		
		private var _calculatedWidth:Number;
		private var _calculatedHeight:Number;
		
		private var _projectedWidth:Number;
		private var _projectedHeight:Number;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("MediaElementLayoutTarget");
	}
}

/**
 * Internal class, used to prevent the MediaElementLayoutTarget constructor
 * to run successfully on being invoked outside of this class.
 */
class ConstructorLock
{
}