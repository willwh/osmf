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
	import flash.errors.IllegalOperationError;
	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;
	
	import org.osmf.events.DisplayObjectEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.layout.ILayoutTarget;
	import org.osmf.logging.ILogger;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.traits.DisplayObjectTrait;
	import org.osmf.traits.MediaTraitType;
	import org.osmf.utils.OSMFStrings;

	/**
	 * Dispatched when a layout child's displayObject has changed.
	 * 
	 * @eventType org.osmf.events.DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	[Event(name="displayObjectChange",type="org.osmf.events.DisplayObjectEvent")]
	
	/**
	 * Dispatched when a layout element's mediaal width and height changed.
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
	 * Dispatched when a layout target's layoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="layoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]

	/**
	 * Dispatched when a layout target's parentLayoutRenderer property changed.
	 * 
	 * @eventType org.osmf.layout.LayoutTargetEvent.PARENT_LAYOUT_RENDERER_CHANGE
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */
	[Event(name="parentLayoutRendererChange",type="org.osmf.layout.LayoutRendererChangeEvent")]

	/**
	 * @private
	 * 
	 * Class wraps a MediaElement into a ILayoutChild.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class MediaElementLayoutTarget extends EventDispatcher implements ILayoutTarget
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
				_mediaElement = mediaElement;
				_mediaElement.addEventListener(MediaElementEvent.TRAIT_ADD, onMediaElementTraitsChange);
				_mediaElement.addEventListener(MediaElementEvent.TRAIT_REMOVE, onMediaElementTraitsChange);
				
				onMediaElementTraitsChange();
			}
		}
		
		public function get mediaElement():MediaElement
		{
			return _mediaElement;
		}
		
		// ILayoutTarget
		//

		/**
		 * @private
		 */
		public function get layoutRenderer():LayoutRenderer
		{
			return _layoutRenderer;
		}
		
		/**
		 * @private
		 */
		public function get parentLayoutRenderer():LayoutRenderer
		{
			return _parentLayoutRenderer;
		}
		
		/**
		 * @private
		 */
		public function get metadata():Metadata
		{
			return _mediaElement.metadata;
		}
		
		/**
		 * @private
		 */
		public function get displayObject():DisplayObject
		{
			return _displayObject;
		}
		
		/**
		 * @private
		 */
		public function get measuredWidth():Number
		{
			return displayObjectTrait
				 ? displayObjectTrait.mediaWidth
				 : NaN;
		}
		
		/**
		 * @private
		 */
		public function get measuredHeight():Number
		{
			return displayObjectTrait
				 ? displayObjectTrait.mediaHeight
				 : NaN;
		}
		
		/**
		 * @private
		 */
		public function measure():void
		{
			// No action required. Layout renderers will invoke measurement
			// directly via the layoutRenderer property.
		}
		
		/**
		 * @private
		 */
		public function layout(availableWidth:Number, availableHeight:Number):void
		{
			if (_displayObject != null && _layoutRenderer == null)
			{
				_displayObject.width = availableWidth;
				_displayObject.height = availableHeight;
			}
			else
			{
				
			}
		}
		
		// Public interface
		//
		
		public static function getInstance(mediaElement:MediaElement):MediaElementLayoutTarget
		{
			var instance:* = layoutTargets[mediaElement];
			
			/*
			CONFIG::LOGGING 
			{
				logger.debug
					( "getInstance, elem.ID: {0}, instance: {1}"
					, mediaElement.metadata.getFacet(MetadataNamespaces.ELEMENT_ID)
					, instance
					);
			}
			*/
			
			if (instance == undefined)
			{
				instance = new MediaElementLayoutTarget(mediaElement, ConstructorLock);
				layoutTargets[mediaElement] = instance;
			}
			
			return instance;
		}
		
		// Internals
		//
		
		private var _mediaElement:MediaElement;
		private var displayObjectTrait:DisplayObjectTrait;
		private var _displayObject:DisplayObject;
		private var _layoutRenderer:LayoutRenderer;
		private var _parentLayoutRenderer:LayoutRenderer;
		
		// Event Handlers
		//
		
		private function onMediaElementTraitsChange(event:MediaElementEvent = null):void
		{
			var newDisplayObjectTrait:DisplayObjectTrait
				= 	(	event
					&&	event.type == MediaElementEvent.TRAIT_REMOVE
					&&	event.traitType == MediaTraitType.DISPLAY_OBJECT
					)	?	null
						:	_mediaElement.getTrait(MediaTraitType.DISPLAY_OBJECT) as DisplayObjectTrait;
							
			if (newDisplayObjectTrait != displayObjectTrait)
			{
				if (displayObjectTrait)
				{
					displayObjectTrait.removeEventListener
						( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
						, onDisplayObjectTraitDisplayObjecChange
						);
					
					displayObjectTrait.removeEventListener
						( DisplayObjectEvent.MEDIA_SIZE_CHANGE
						, onDisplayObjectTraitMediaSizeChange
						);
				}
				
				displayObjectTrait = newDisplayObjectTrait;
				
				if (displayObjectTrait)
				{
					displayObjectTrait.addEventListener
						( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
						, onDisplayObjectTraitDisplayObjecChange
						);
					
					displayObjectTrait.addEventListener
						( DisplayObjectEvent.MEDIA_SIZE_CHANGE
						, onDisplayObjectTraitMediaSizeChange
						);
				}
				
				updateDisplayObject
					( displayObjectTrait
						? displayObjectTrait.displayObject
						: null
					);
			}
		}
		
		private function updateDisplayObject(newDisplayObject:DisplayObject):void
		{
			var oldDisplayObject:DisplayObject = _displayObject;
			if (newDisplayObject != displayObject)
			{
				_displayObject = newDisplayObject;
				dispatchEvent
					( new DisplayObjectEvent
						( DisplayObjectEvent.DISPLAY_OBJECT_CHANGE
						, false, false
						, oldDisplayObject
						, newDisplayObject
						)
					);
				
				if (oldDisplayObject is ILayoutTarget)
				{
					oldDisplayObject.removeEventListener
						( LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE
						, onLayoutRendererChange
						);
						
					oldDisplayObject.removeEventListener
						( LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE
						, onParentLayoutRendererChange
						);
				}
				
				if (newDisplayObject is ILayoutTarget)
				{
					newDisplayObject.addEventListener
						( LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE
						, onLayoutRendererChange
						);
						
					newDisplayObject.addEventListener
						( LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE
						, onParentLayoutRendererChange
						);
				}
				
				var layoutTarget:ILayoutTarget = newDisplayObject as ILayoutTarget;
				
				setLayoutRenderer(layoutTarget ? layoutTarget.layoutRenderer : null);
				setParentLayoutRenderer(layoutTarget ? layoutTarget.parentLayoutRenderer : null);
			}
		}
		
		private function onDisplayObjectTraitDisplayObjecChange(event:DisplayObjectEvent):void
		{
			updateDisplayObject(event.newDisplayObject);
		}
		
		private function onDisplayObjectTraitMediaSizeChange(event:DisplayObjectEvent):void
		{
			dispatchEvent(event.clone());	
		}
		
		private function onLayoutRendererChange(event:LayoutRendererChangeEvent):void
		{
			setLayoutRenderer(event.newValue);
		}
		
		private function onParentLayoutRendererChange(event:LayoutRendererChangeEvent):void
		{
			setParentLayoutRenderer(event.newValue);
		}
		
		private function setLayoutRenderer(value:LayoutRenderer):void
		{
			if (value != _layoutRenderer)
			{
				var oldRenderer:LayoutRenderer = _layoutRenderer;
				_layoutRenderer = value;
				dispatchEvent
					( new LayoutRendererChangeEvent
						( LayoutRendererChangeEvent.LAYOUT_RENDERER_CHANGE
						, false, false
						, oldRenderer
						, value
						)
					); 
			} 
		}
		
		private function setParentLayoutRenderer(value:LayoutRenderer):void
		{
			if (value != _parentLayoutRenderer)
			{
				var oldRenderer:LayoutRenderer = _parentLayoutRenderer;
				_parentLayoutRenderer = value;
				dispatchEvent
					( new LayoutRendererChangeEvent
						( LayoutRendererChangeEvent.PARENT_LAYOUT_RENDERER_CHANGE
						, false, false
						, oldRenderer
						, value
						)
					); 
			} 
		}
		
		/* Static */
		
		private static const layoutTargets:Dictionary = new Dictionary(true);
		
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