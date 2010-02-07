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
package org.osmf.containers
{
	import flash.errors.IllegalOperationError;
	import flash.geom.Rectangle;
	import flash.utils.Dictionary;
	
	import org.osmf.events.ContainerChangeEvent;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutRendererBase;
	import org.osmf.layout.LayoutTargetSprite;
	import org.osmf.layout.MediaElementLayoutTarget;
	import org.osmf.logging.ILogger;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.utils.OSMFStrings;

	/**
	 * MediaContainer defines a Sprite based IMediaContainer implementation.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class MediaContainer extends LayoutTargetSprite implements IMediaContainer
	{
		/**
		 * Constructor
		 *  
		 * @param metadata The metadata that elementLayoutRenderer and/or
		 * containersLayoutRenderer may be using on calculating their layouts using
		 * this container as their context.
		 * @param elementLayoutRenderer The layout renderer that will render
		 * the MediaElement instances that get added to this container. If no
		 * renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 * @param containersLayoutRenderer The layout renderer that will render
		 * the child MediaContainer instances that get added to this container. If
		 * no renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function MediaContainer(metadata:Metadata=null, layoutRenderer:LayoutRendererBase=null)
		{
			super(metadata);
			
			this.layoutRenderer = layoutRenderer || new LayoutRenderer();
			this.layoutRenderer.container = this; 
		}
		
		// IMediaContainer
		//
		
		/**
		 * @private
		 */
		public function addMediaElement(element:MediaElement):MediaElement
		{
			if (element == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (layoutTargets[element] == undefined)
			{
				// Media containers are under obligation to dispatch a container change event when
				// they add a media element:
				element.dispatchEvent
					( new ContainerChangeEvent
						( ContainerChangeEvent.CONTAINER_CHANGE
						, false, false
						, element.container, this
						)
					);
					
				CONFIG::LOGGING { logger.debug("addMediaElement: {0} to {1}", element.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
				var contentTarget:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(element);
				
				layoutTargets[element] = contentTarget;
				layoutRenderer.addTarget(contentTarget);
				
				element.addEventListener(ContainerChangeEvent.CONTAINER_CHANGE, onElementContainerChange);
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return element;
		}
		
		/**
		 * @private
		 */
		public function removeMediaElement(element:MediaElement):MediaElement
		{
			if (element == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			var result:MediaElement;
			var contentTarget:MediaElementLayoutTarget = layoutTargets[element];
			
			if (contentTarget)
			{
				CONFIG::LOGGING { logger.debug("removeMediaElement {0} from {1}", element.metadata.getFacet(MetadataNamespaces.ELEMENT_ID), metadata.getFacet(MetadataNamespaces.ELEMENT_ID)); }
				element.removeEventListener(ContainerChangeEvent.CONTAINER_CHANGE, onElementContainerChange);
				layoutRenderer.removeTarget(contentTarget);
				delete layoutTargets[element];
				result = element;
				
				// Media containers are under obligation to dispatch a container change event when
				// they remove a media element. See if we're still the element's container, though.
				// For if not, a change has already occured.
				if (element.container == this)
				{
					element.dispatchEvent
						( new ContainerChangeEvent
							( ContainerChangeEvent.CONTAINER_CHANGE
							, false, false
							, element.container, null
							)
						);
				}
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return result;
		}
		
		/**
		 * @private
		 */
		public function containsMediaElement(element:MediaElement):Boolean
		{
			return layoutTargets[element] != undefined
		}
		
		// Public API
		//
		
		/**
		 * Defines if the children of the container that display outside of its bounds 
		 * will be clipped or not.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function set clipChildren(value:Boolean):void
		{
			if (value && scrollRect == null)
			{
				scrollRect = new Rectangle(0, 0, layoutRenderer.measuredWidth, layoutRenderer.measuredHeight);
			}
			else if (value == false && scrollRect)
			{
				scrollRect = null;
			} 
		}
		
		public function get clipChildren():Boolean
		{
			return scrollRect != null;
		}
		
		// Overrides
		//
		
		override public function layout(availableWidth:Number, availableHeight:Number, deep:Boolean = true):void
		{
			super.layout(availableWidth, availableHeight, deep);
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, availableWidth, availableHeight);
			}
		}
				
		/**
		 * @private
		 */
		override public function validateNow():void
		{
			layoutRenderer.validateNow();
		}
		
		/**
		 * Defines the container's background color. By default, this value
		 * is set to NaN, which results in no background being drawn.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function set backgroundColor(value:Number):void
		{
			if (value != _backgroundColor)
			{
				_backgroundColor = value;
				drawBackground();
			}
		}
		public function get backgroundColor():Number
		{
			return _backgroundColor;
		}
		
		/**
		 * Defines the container's background alpha. By default, this value
		 * is set to 1, which results in the background being fully opaque.
		 * 
		 * Note that a container will not have a background drawn unless its
		 * backgroundColor property is set.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function set backgroundAlpha(value:Number):void
		{
			if (value != _backgroundAlpha)
			{
				_backgroundAlpha = value;
				drawBackground();
			}
		}
		public function get backgroundAlpha():Number
		{
			return _backgroundAlpha;
		}
		
		// Internals
		//
		
		private function drawBackground():void
		{
			graphics.clear();
			
			if	(	!isNaN(_backgroundColor)
				&& 	_backgroundAlpha != 0
				&&	layoutRenderer.measuredWidth
				&&	layoutRenderer.measuredHeight
				)
			{
				graphics.beginFill(_backgroundColor,_backgroundAlpha);
				graphics.drawRect(0, 0, layoutRenderer.measuredWidth, layoutRenderer.measuredHeight);
				graphics.endFill();
			}
		}
		
		private function onElementContainerChange(event:ContainerChangeEvent):void
		{
			if (event.oldValue == this)
			{
				removeMediaElement(event.target as MediaElement);
			}
		}
		
		/**
		 * @private
		 * 
		 * Dictionary of MediaElementLayoutTarget instances, index by the
		 * media elements that they wrap: 
		 */		
		private var layoutTargets:Dictionary = new Dictionary();
		
		private var layoutRenderer:LayoutRendererBase;
		
		private var _backgroundColor:Number;
		private var _backgroundAlpha:Number;
		
		CONFIG::LOGGING private static const logger:org.osmf.logging.ILogger = org.osmf.logging.Log.getLogger("MediaContainer");
	}
}