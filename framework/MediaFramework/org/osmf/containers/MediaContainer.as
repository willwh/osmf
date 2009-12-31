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
		public function MediaContainer
							( metadata:Metadata=null
							, contentLayoutRenderer:ILayoutRenderer=null
							, containersLayoutRenderer:ILayoutRenderer=null
							)
		{
			super(metadata);
			
			// Setup a content sprite for holding the assigned MediaElement(s):
			
			content = new LayoutContextSprite(this.metadata);
			addChild(content);
			
			this.contentLayoutRenderer = contentLayoutRenderer || new DefaultLayoutRenderer();
			this.contentLayoutRenderer.context = content;
			content.layoutRenderer = this.contentLayoutRenderer;
			
			// Setup the layout renderer that will govern sub-containers:
			
			this.containersLayoutRenderer = containersLayoutRenderer || new DefaultLayoutRenderer();
			this.containersLayoutRenderer.context = this;
			layoutRenderer = this.containersLayoutRenderer; 
		}
		
		// IContainerGateway
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
			
			if (contentLayoutTargets[element] == undefined)
			{
				var contentTarget:MediaElementLayoutTarget = MediaElementLayoutTarget.getInstance(element);
				
				contentLayoutTargets[element] = contentTarget;
				contentLayoutRenderer.addTarget(contentTarget);
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
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
			var contentTarget:MediaElementLayoutTarget = contentLayoutTargets[element];
			
			if (contentTarget)
			{
				contentLayoutRenderer.removeTarget(contentTarget);
				delete contentLayoutTargets[element];
				result = element;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
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
			return contentLayoutTargets[element] != undefined
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
		 * Returns 1, for index 0 is occupied by the LayoutContextSprite instance
		 * that holds sub-containers.
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function get firstChildIndex():uint
		{
			// The content sprite is at index 0, add sub-containers
			// at index 1 and up:
			return 1;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function set calculatedWidth(value:Number):void
		{
			content.calculatedWidth = value;
			super.calculatedWidth = value;
		}
		
		override public function set calculatedHeight(value:Number):void
		{
			content.calculatedHeight = value;
			super.calculatedHeight = value;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function set projectedWidth(value:Number):void
		{
			content.projectedWidth = value;
			super.projectedWidth = value;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		override public function set projectedHeight(value:Number):void
		{
			content.projectedHeight = value;
			super.projectedHeight = value;
		}
		
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
			super.width = content.width = value;
			
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
			super.height = content.height = value;
			
			if (!isNaN(backgroundColor))
			{
				drawBackground();
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, width, height);
			}
		}
		
		// Public Interface
		//
		
		/**
		 * Adds the specified container as a sub-container.
		 * 
		 * If the container contains metadata, then it will be layed out using this
		 * instance's containers layout renderer.
		 *  
		 * @param container The child container to add.
		 * @throws IllegalOperationError if container is null, or already a sub-container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function addChildContainer(container:MediaContainer):MediaContainer
		{
			var result:MediaContainer;
			
			if (container == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (containersLayoutRenderer.targets(container) == false)
			{
				containersLayoutRenderer.addTarget(container);
				result = container;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return result;
		}
		
		/**
		 * Removes a sub-container.
		 *  
		 * @param container The container to remove.
		 * @throws IllegalOperationErrror if container is null, or not a sub-container.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function removeChildContainer(container:MediaContainer):MediaContainer
		{
			var result:MediaContainer;
			
			if (container == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (containersLayoutRenderer.targets(container))
			{
				containersLayoutRenderer.removeTarget(container);
				result = container;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return result;
		}
		
		/**
		 * Verifies if a container is a sub-container of this MediaContainer.
		 *  
		 * @param container Container to verify.
		 * @return True if target is a sub-container of this MediaContainer.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function containsContainer(container:MediaContainer):Boolean
		{
			return containersLayoutRenderer.targets(container);
		}
		
		public function validateContentNow():void
		{
			contentLayoutRenderer.validateNow();
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
		 * Dictionary of MediaElementLayoutTarget instances, index by the
		 * media elements that they wrap: 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		private var contentLayoutTargets:Dictionary = new Dictionary();
		private var content:LayoutContextSprite;
		
		private var contentLayoutRenderer:ILayoutRenderer;
		private var containersLayoutRenderer:ILayoutRenderer;
		
		private var _backgroundColor:Number;
		private var _backgroundAlpha:Number;
	}
}