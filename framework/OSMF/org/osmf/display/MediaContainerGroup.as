/*****************************************************
*  
*  Copyright 2009 Adobe Systems Incorporated.  All Rights Reserved.
*  
*****************************************************
*  The mediaContainers of this file are subject to the Mozilla Public License
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
package org.osmf.display
{
	import flash.display.DisplayObject;
	import flash.errors.IllegalOperationError;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.DefaultLayoutRenderer;
	import org.osmf.layout.LayoutRenderer;
	import org.osmf.layout.LayoutTargetSprite;
	import org.osmf.metadata.Metadata;
	import org.osmf.utils.OSMFStrings;

	/**
	 * MediaContainerGroup defines a d
	 * more child groups.
	 *  
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.5
	 *  @productversion OSMF 1.0
	 */	
	public class MediaContainerGroup extends LayoutTargetSprite
	{
		/**
		 * Constructor
		 *  
		 * @param metadata The metadata that groupsLayoutRenderer and/or
		 * containerLayoutRenderer may be using on calculating their layouts using
		 * this group as their context.
		 
		 * @param groupsLayoutRenderer The layout renderer that will render
		 * the child MediaContainer instances that get added to this group. If
		 * no renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 * 
		 * @param containerLayoutRenderer The layout renderer that will render
		 * the MediaElement instances that get added to this group. If no
		 * renderer is specified, a DefaultLayoutRenderer instance will be
		 * used.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function MediaContainerGroup
							( metadata:Metadata=null
							, groupsLayoutRenderer:LayoutRenderer=null
							, containerLayoutRenderer:LayoutRenderer=null
							)
		{
			super(metadata);
			
			// Setup a MediaContainer to hold media elements:
			_mediaContainer = new MediaContainer(this.metadata, containerLayoutRenderer);
			super.addChild(_mediaContainer);
			
			// Setup the layout renderer that will govern the layout of child
			// groups:
			var layoutRenderer:LayoutRenderer
				=	groupsLayoutRenderer
				||	new DefaultLayoutRenderer();
				
			layoutRenderer.container = this; 
		}
		
		// Public API
		//

		public function get mediaContainer():MediaContainer
		{
			return _mediaContainer;
		}
		
		/**
		 * Defines if the children of the group that display outside of its bounds 
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
			_mediaContainer.clipChildren = value;
			
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
		
		/**
		 * Adds the specified group group as a child group.
		 * 
		 * If the group contains metadata, then it will be layed out using this
		 * instance's groups layout renderer.
		 *  
		 * @param group The child group to add.
		 * @throws IllegalOperationError if group is null, or already a child group.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function addChildGroup(group:MediaContainerGroup):MediaContainerGroup
		{
			var result:MediaContainerGroup;
			
			if (group == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (layoutRenderer.targets(group) == false)
			{
				layoutRenderer.addTarget(group);
				result = group;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return result;
		}
		
		/**
		 * Removes a child group.
		 *  
		 * @param group The group to remove.
		 * @throws IllegalOperationErrror if group is null, or not a child group.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function removeChildGroup(group:MediaContainerGroup):MediaContainerGroup
		{
			var result:MediaContainerGroup;
			
			if (group == null)
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.NULL_PARAM));
			}
			
			if (layoutRenderer.targets(group))
			{
				layoutRenderer.removeTarget(group);
				result = group;
			}
			else
			{
				throw new IllegalOperationError(OSMFStrings.getString(OSMFStrings.INVALID_PARAM));
			}
			
			return result;
		}
		
		/**
		 * Verifies if a group is a child group of this MediaContainer.
		 *  
		 * @param group Container to verify.
		 * @return True if target is a child group of this MediaContainer.
		 * 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */		
		public function containsChildGroup(group:MediaContainerGroup):Boolean
		{
			return layoutRenderer.targets(group);
		}
		
		/**
		 * @private
		 */		
		public function validateNow():void
		{
			layoutRenderer.validateNow();
			_mediaContainer.validateNow();
		}
		
		// Overrides
		//
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject
		{
			return super.addChildAt(child, index + 1);
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void
		{
			super.setChildIndex(child, index + 1);
		}
		
		override public function removeChildAt(index:int):DisplayObject
		{
			return super.removeChildAt(index + 1);
		}
		
		override public function measureMedia():void
		{
			_mediaContainer.measureMedia();
			
			super.measureMedia();
		}
		
		override public function updateMediaDisplay(availableWidth:Number, availableHeight:Number):void
		{
			if (availableWidth)
			{
				_mediaContainer.width = availableWidth;
			}
			
			if (availableHeight)
			{
				_mediaContainer.height = availableHeight;
			}
			
			if (scrollRect)
			{
				scrollRect = new Rectangle(0, 0, availableWidth, availableHeight);
			}
			
			super.updateMediaDisplay(availableWidth, availableHeight);
		}
		
		// Internals
		//
		
		private var _mediaContainer:MediaContainer;
	}
}