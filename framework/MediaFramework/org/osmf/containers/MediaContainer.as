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
	import org.osmf.layout.DefaultLayoutRenderer;
	import org.osmf.layout.ILayoutRenderer;
	import org.osmf.layout.LayoutContextSprite;
	import org.osmf.layout.MediaElementLayoutTarget;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.OSMFStrings;

	/**
	 * MediaContainer defines a Sprite based IMediaContainer implementation.
	 */	
	public class MediaContainer extends LayoutContextSprite implements IMediaContainer
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
		public function MediaContainer(metadata:Metadata=null, layoutRenderer:ILayoutRenderer=null)
		{
			super(metadata);
			
			this.layoutRenderer = layoutRenderer || new DefaultLayoutRenderer(); 
		}
		
		// IMediaContainerGateway
		//
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function addMediaElement(element:MediaElement):MediaElement
		{
			if (element == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (layoutTargets[element] == undefined)
			{
				var contentTarget:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(element);
				
				layoutTargets[element] = contentTarget;
				layoutRenderer.addTarget(contentTarget);
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			// Media containers are under obligation to dispatch a gateway change event when
			// they add a media element:
			element.dispatchEvent
				( new ContainerChangeEvent
					( ContainerChangeEvent.CONTAINER_CHANGE
					, false, false
					, element.container, this
					)
				);
			
			return element;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
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
				layoutRenderer.removeTarget(contentTarget);
				delete layoutTargets[element];
				result = element;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			// Media containers are under obligation to dispatch a gateway change event when
			// they remove a media element:
			element.dispatchEvent
				( new ContainerChangeEvent
					( ContainerChangeEvent.CONTAINER_CHANGE
					, false, false
					, element.container, null
					)
				);
			
			return result;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
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
				scrollRect = new Rectangle(0, 0, width, height);
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
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function set width(value:Number):void
		{
			super.width = value;
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function set height(value:Number):void
		{
			super.height = value;
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
		}
		
		/**
		 * @private
		 */
		public function validateNow():void
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
				&&	width
				&&	height
				)
			{
				graphics.beginFill(_backgroundColor,_backgroundAlpha);
				graphics.drawRect(0, 0, width, height);
				graphics.endFill();
			}
		}
		
		/**
		 * @private
		 * 
		 * Dictionary of MediaElementLayoutTarget instances, index by the
		 * media elements that they wrap: 
		 */		
		private var layoutTargets:Dictionary = new Dictionary();
		
		private var _backgroundColor:Number;
		private var _backgroundAlpha:Number;
	}
}