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
	import flash.display.Sprite;
	import flash.utils.Dictionary;
	
	import org.osmf.chrome.events.RequestLayoutEvent;
	import org.osmf.gateways.RegionGateway;
	import org.osmf.layout.AbsoluteLayoutFacet;
	import org.osmf.media.MediaElement;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.MetadataUtils;
	import org.osmf.metadata.MetadataWatcher;
	
	public class ControlBar extends Sprite
	{
		[Embed("../assets/images/controlBarBackdrop.png")]
		public var backdropType:Class;
		 
		public function ControlBar()
		{
			super();
			
			mouseChildren = true;
			mouseEnabled = true;
			
			addChild(new backdropType());
		}
		
		public function set element(value:MediaElement):void
		{
			if (_element != value)
			{
				_element = value;
				updateWidgets();
			}
		}
		
		public function get element():MediaElement
		{
			return _element;
		}
		
		public function set region(value:RegionGateway):void
		{
			if (_region != value)
			{
				if (regionSizeWatcher != null)
				{
					regionSizeWatcher.unwatch();
					regionSizeWatcher = null;
				}
				
				_region = value;
				
				if (_region != null)
				{
					regionSizeWatcher = MetadataUtils.watchFacet
						( _region.metadata
						, MetadataNamespaces.ABSOLUTE_LAYOUT_PARAMETERS
						, onRegionAbsoluteLayoutChange
						);
				}
			}
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
				y = (parameters.height - height) - 50;
			}
			else
			{
				x = 0;
				y = 0;
			}
		}
		
		// Internals
		//
	
		private var _element:MediaElement;
		private var widgets:Dictionary = new Dictionary();
		
		private var _region:RegionGateway;
		private var regionSizeWatcher:MetadataWatcher;
	
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
							+	( registrationWidget.visible 
									? registrationWidget.width + widget.left
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
	}
}