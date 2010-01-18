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
	
	import org.osmf.events.MediaElementEvent;
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.logging.ILogger;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Dispatched when a layout child's displayObject has changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
	 */	
	[Event(name="displayObjectChange",type="org.osmf.events.DisplayObjectEvent")]
	
	/**
	 * Dispatched when a layout element's intrinsical width and height changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.MEDIA_SIZE_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="mediaSizeChange",type="org.osmf.events.DisplayObjectEvent")]

	/**
	 * Class wraps a MediaElement into a ILayoutChild.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
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
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.ILLEGAL_CONSTRUCTOR_INVOKATION));
			}
			else
			{
				this._mediaElement = mediaElement;
				
				_mediaElement.addEventListener(MediaElementEvent.TRAIT_ADD, onMediaElementTraitsChange);
				_mediaElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onMediaElementTraitsChange);
				
				updatedisplayObjectTrait();
			}
		}
		
		// ILayoutTarget
		//

		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get layoutRenderer():LayoutRenderer
		{
			return displayObjectLayoutTarget ? displayObjectLayoutTarget.layoutRenderer : null;
		}
		
		public function set layoutRenderer(value:LayoutRenderer):void
		{
			if (displayObjectLayoutTarget)
			{
				displayObjectLayoutTarget.layoutRenderer = value;
			}
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get metadata():Metadata
		{
			return _mediaElement.metadata;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get container():DisplayObjectContainer
		{
			return displayObjectLayoutTarget ? displayObjectLayoutTarget.container : null; 
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get firstChildIndex():uint
		{
			return displayObjectLayoutTarget ? displayObjectLayoutTarget.firstChildIndex : 0;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get intrinsicWidth():Number
		{
			return displayObjectLayoutTarget
					? displayObjectLayoutTarget.intrinsicWidth
				 	: displayObjectTrait 
				 		? displayObjectTrait.mediaWidth
				 		: NaN;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function get intrinsicHeight():Number
		{
			return displayObjectLayoutTarget
					? displayObjectLayoutTarget.intrinsicHeight
					: displayObjectTrait
						? displayObjectTrait.mediaHeight
						: NaN;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function updateIntrinsicDimensions():void
		{
			if (displayObjectLayoutTarget)
			{
				displayObjectLayoutTarget.updateIntrinsicDimensions();
			}
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
	 	public function set calculatedWidth(value:Number):void
	 	{
	 		if (displayObjectLayoutTarget)
	 		{
	 			displayObjectLayoutTarget.calculatedWidth = value;
	 		}
	 		else
	 		{
	 			_calculatedWidth = value;
	 		}
	 	}
	 	
	 	public function get calculatedWidth():Number
	 	{
	 		return displayObjectLayoutTarget
	 				? displayObjectLayoutTarget.calculatedWidth
	 				: _calculatedWidth;
	 	}
	 	
	 	/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set calculatedHeight(value:Number):void
		{
			_calculatedHeight = value;
			if (displayObjectLayoutTarget)
	 		{
	 			displayObjectLayoutTarget.calculatedHeight = value;
	 		}
		}
		public function get calculatedHeight():Number
		{
			return displayObjectLayoutTarget
					? displayObjectLayoutTarget.calculatedHeight
					: _calculatedHeight;
		}
		
		/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set projectedWidth(value:Number):void
	 	{
	 		if (displayObjectLayoutTarget)
	 		{
	 			displayObjectLayoutTarget.projectedWidth = value;
	 		}
	 		else
	 		{
	 			_projectedWidth = value;
	 		}
	 	}
	 	public function get projectedWidth():Number
	 	{
	 		return displayObjectLayoutTarget
	 				? displayObjectLayoutTarget.projectedWidth
	 				: _projectedWidth;
	 	}
	 	
	 	/**
		 * @private
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set projectedHeight(value:Number):void
		{
	 		_projectedHeight = value;
			if (displayObjectLayoutTarget)
	 		{
	 			displayObjectLayoutTarget.projectedHeight = value;
	 		}
		}
		public function get projectedHeight():Number
		{
			return displayObjectLayoutTarget
					? displayObjectLayoutTarget.projectedHeight
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
		
		private function onMediaElementTraitsChange(event:MediaElementEvent):void
		{
			if (event.traitType == MediaTraitType.DISPLAY_OBJECT)
			{
				updatedisplayObjectTrait();
			}
		}
		
		private function updatedisplayObjectTrait():void
		{
			var oldTrait:DisplayObjectTrait = displayObjectTrait;
			var oldView:DisplayObject = _displayObject;
			var oldWidth:Number = intrinsicWidth;
			var oldHeight:Number = intrinsicHeight;
			
			displayObjectTrait = _mediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
			
			if (oldTrait)
			{
				oldTrait.removeEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, displayObjectChangeEventHandler);
				oldTrait.removeEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, mediaSizeChangeEventHandler);
			}
			
			if (displayObjectTrait)
			{
				processViewChange(displayObjectTrait.displayObject);
				displayObjectTrait.addEventListener(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, displayObjectChangeEventHandler, false, 0, true);
				displayObjectTrait.addEventListener(DisplayObjectEvent.MEDIA_SIZE_CHANGE, mediaSizeChangeEventHandler, false, 0, true);
			}
			else
			{
				processViewChange(null);
			}
			
			if (oldView != _displayObject)
			{
				dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.DISPLAY_OBJECT_CHANGE, false, false, oldView, _displayObject));
			}

			if 	(	oldWidth != intrinsicWidth
				||	oldHeight != intrinsicHeight
				)
			{
				dispatchEvent(new DisplayObjectEvent(DisplayObjectEvent.MEDIA_SIZE_CHANGE, false, false, null, null, oldWidth, oldHeight, intrinsicWidth, intrinsicHeight));
			}
		}
		
		private function displayObjectChangeEventHandler(event:DisplayObjectEvent):void
		{
			processViewChange(event.newDisplayObject);
			
			dispatchEvent(event.clone());
		}
		
		private function mediaSizeChangeEventHandler(event:Event):void
		{
			dispatchEvent(event.clone());
		}
		
		private function processViewChange(newView:DisplayObject):void
		{
			_displayObject = newView;
			displayObjectLayoutTarget = _displayObject as ILayoutContext;
		}
		
		private var _mediaElement:MediaElement;
		private var _displayObject:DisplayObject;
		private var displayObjectLayoutTarget:ILayoutContext;
		
		private var displayObjectTrait:DisplayObjectTrait;
		
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
 *  
 *  @langversion 3.0
 *  @playerversion Flash 10
 *  @playerversion AIR 1.5
 *  @productversion OSMF 1.0
 */
class ConstructorLock
{
}