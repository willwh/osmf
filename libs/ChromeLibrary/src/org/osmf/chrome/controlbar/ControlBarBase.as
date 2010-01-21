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

package org.osmf.chrome.controlbar
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.utils.Dictionary;
	
	import org.osmf.chrome.events.RequestLayoutEvent;
	import org.osmf.chrome.utils.FadingSprite;
	import org.osmf.containers.MediaContainer;
	import org.osmf.layout.AbsoluteLayoutFacet;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	import org.osmf.metadata.ObjectFacet;
	import org.osmf.utils.URL;
	
	public class ControlBarBase extends FadingSprite
	{
		[Embed("../assets/images/controlBarBackdrop.png")]
		public var backdropType:Class;
		
		public static const METADATA_AUTO_HIDE_URL:URL = new URL("http://www.osmf.org.chrome/controlbar/autoHide");
		 
		public function ControlBarBase(backdrop:Class = null)
		{
			super();
			
			backdrop ||= backdropType;
			
			mouseChildren = true;
			mouseEnabled = true;
			
			addChild(new backdropType());
			
			addEventListener
				( Event.ADDED_TO_STAGE
				, function ():void
					{
						stage.addEventListener
							( MouseEvent.MOUSE_OVER
							, visibilityDeterminingEventHandler
							);
							
						stage.addEventListener
							( MouseEvent.MOUSE_OUT
							, visibilityDeterminingEventHandler
							);
					}
				)
		}
		
		public function set element(value:MediaElement):void
		{
			if (_element != value)
			{
				_element = value;
				
				setPropertiesOnMetadata();
				updateWidgets();
			}
		}
		
		public function get element():MediaElement
		{
			return _element;
		}
		
		public function set container(value:MediaContainer):void
		{
			if (_container != value)
			{
				if (regionSizeWatcher != null)
				{
					regionSizeWatcher.unwatch();
					regionSizeWatcher = null;
				}
				
				_container = value;
				
				if (_container != null)
				{
					regionSizeWatcher = MetadataUtils.watchFacet
						( _container.metadata
						, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS
						, onRegionAbsoluteLayoutChange
						);
				}
				
				visibilityDeterminingEventHandler();
			}
		}
		
		public function set autoHide(value:Boolean):void
		{
			if (value != _autoHide)
			{
				_autoHide = value;
				
				setPropertiesOnMetadata();
				visibilityDeterminingEventHandler();
			}
		}
		
		public function get autoHide():Boolean
		{
			return _autoHide;
		}
		
		public function addWidget(id:String, widget:ControlBarWidget):ControlBarWidget
		{
			widgets[id] = widget;
			widget.element = _element;
			widget.addEventListener
				( RequestLayoutEvent.REQUEST_LAYOUT
				, onWidgetLayoutRequest
				);
			
			addChild(widget);
			
			updateWidgets();
			
			return widget;
		}
		
		public function getWidget(id:String):ControlBarWidget
		{
			return widgets[id];
		}
		
		// Protected
		//
		
		protected function onRegionAbsoluteLayoutChange(parameters:AbsoluteLayoutFacet):void
		{
			if (parameters)
			{
				x = (parameters.width - width) / 2;
				y = (parameters.height - height) - BOTTOM_OFFSET;
			}
			else
			{
				x = 0;
				y = 0;
			}
		}
		
		// Internals
		//
		
		private static const BOTTOM_OFFSET:Number = 15;
		
		private var _element:MediaElement;
		private var widgets:Dictionary = new Dictionary();
		
		private var _container:MediaContainer
		private var regionSizeWatcher:MetadataWatcher;
		
		private var _autoHide:Boolean = true;
		private var mouseOver:Boolean = false;
	
		private function updateWidgets():void
		{
			for each (var widget:ControlBarWidget in widgets)
			{
				widget.element = _element;
				layoutWidget(widget);
			}
		}
		
		private function onWidgetLayoutRequest(event:RequestLayoutEvent):void
		{
			updateWidgets();
		}
		
		private function layoutWidget(widget:ControlBarWidget):void
		{
			var registrationWidget:ControlBarWidget 
				= widget.registrationTarget
					? widgets[widget.registrationTarget]
					: null;
			
			var x:Number, y :Number;
			
			if (registrationWidget)
			{
				layoutWidget(registrationWidget);
				switch(widget.registrationTargetDirection)
				{
					case Direction.LEFT:
						x 	= registrationWidget.x 
							- (widget.visible ? widget.width : 0)
							- widget.left;
						y	= registrationWidget.y
							+ widget.top;
						break;
					case Direction.RIGHT:
						x	= registrationWidget.x
							+ widget.left
							+	( registrationWidget.visible 
									? registrationWidget.width 
									: 0
								)
						y 	= registrationWidget.y
							+ widget.top;
						break;
					case Direction.BOTTOM:
						x 	= registrationWidget.x
							+ widget.left;
						y 	= registrationWidget.y
							+ (registrationWidget.visible ? registrationWidget.height : 0)
							+ widget.top;
						break;
					case Direction.TOP:
						x 	= registrationWidget.x
							+ widget.left;
						y 	= registrationWidget.y
							- (widget.visible ? widget.height : 0)
							- widget.top;
						break;	
					default: // OVER
						x 	= registrationWidget.x
							+ widget.left;
						y 	= registrationWidget.y
							+ widget.top;
						break;
				}
			
			}
			else
			{
				x = widget.left;
				y = widget.top;
			}
			
			widget.x = x;
			widget.y = y;
		}
		
		private function visibilityDeterminingEventHandler(event:MouseEvent = null):void
		{
			if (event)
			{
				mouseOver = event.type == MouseEvent.MOUSE_OVER;
			}
			
			visible
				= _autoHide
					? mouseOver
					: true; 
		}
		
		protected function setPropertiesOnMetadata():void
		{
			if (_element)
			{
				_element.metadata.addFacet(new ObjectFacet(METADATA_AUTO_HIDE_URL, _autoHide));
			}
		}
	}
}