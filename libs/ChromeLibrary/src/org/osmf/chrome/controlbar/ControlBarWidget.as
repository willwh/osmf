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
	import __AS3__.vec.Vector;
	
	import flash.display.Sprite;
	
	import org.osmf.chrome.events.RequestLayoutEvent;
	import org.osmf.events.MediaElementEvent;
	import org.osmf.media.MediaElement;

	[Event(name="requestLayout", type="org.osmf.samples.controlbar.RequestLayoutEvent")]
	
	public class ControlBarWidget extends Sprite
	{
		public function ControlBarWidget()
		{
			super();
			
			processElementChange(null);
			onElementTraitsChange(null);
		}
		
		public function set element(value:MediaElement):void
		{
			if (value != _element)
			{
				var oldElement:MediaElement = _element;
				_element = null;
				
				if (oldElement)
				{
					oldElement.removeEventListener(MediaElementEvent.TRAIT_ADD, onElementTraitsChange);
					oldElement.removeEventListener(MediaElementEvent.TRAIT_REMOVE, onElementTraitsChange);
					onElementTraitsChange(null);
				}
				
				_element = value;
				
				if (_element)
				{
					_element.addEventListener(MediaElementEvent.TRAIT_ADD, onElementTraitsChange);
					_element.addEventListener(MediaElementEvent.TRAIT_REMOVE, onElementTraitsChange);
				}
				
				processElementChange(oldElement);
				
				onElementTraitsChange(null);
			}	
		}
		
		public function get element():MediaElement
		{
			return _element;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value != _enabled)
			{
				_enabled = value;
				processEnabledChange();
			}
		}
		
		public function get enabled():Boolean
		{
			return _enabled;
		}
		
		public function setRegistrationTarget(targetId:String, direction:String = Direction.OVER):void
		{
			if	(	_registrationTarget != targetId
				||	_registrationTargetDirection != direction
				)
			{
				_registrationTarget = targetId;
				_registrationTargetDirection = direction;
				
				requestLayout();
			}
		}
		
		public function setPosition(left:Number, top:Number):void
		{
			if (left != _left || top != _top)
			{
				_left = left;
				_top = top;
				
				requestLayout();		
			}
		}
		
		public function get left():Number
		{
			return _left;
		}
		
		public function get top():Number
		{
			return _top;
		}
		
		public function get registrationTarget():String
		{
			return _registrationTarget;
		}
		
		public function get registrationTargetDirection():String
		{
			return _registrationTargetDirection;
		}
		
		public function requestLayout():void
		{
			dispatchEvent(new RequestLayoutEvent(RequestLayoutEvent.REQUEST_LAYOUT));
		}
		
		// Overrides
		//
		
		override public function set visible(value:Boolean):void
		{
			if (visible != value)
			{
				super.visible = value;
				
				requestLayout();
			}
		}
		
		// Protected (Stubs)
		//
		
		protected function get requiredTraits():Vector.<String>
		{
			return null;
		}
		
		protected function processElementChange(oldElement:MediaElement):void
		{
			
		}
		
		protected function processEnabledChange():void
		{
			
		}
		
		protected function onElementTraitAdd(event:MediaElementEvent):void
		{
			
		}
		
		protected function onElementTraitRemove(event:MediaElementEvent):void
		{
			
		}
		
		protected function processRequiredTraitsAvailable(element:MediaElement):void
		{
			
		}
		
		protected function processRequiredTraitsUnavailable(element:MediaElement):void
		{
			
		}
		
		// Internals
		//
		
		private function onElementTraitsChange(event:MediaElementEvent = null):void
		{
			var element:MediaElement= event ? event.target as MediaElement : _element;
			var priorRequiredTraitsAvailable:Boolean = _requiredTraitsAvailable;
			
			if (element)
			{
				_requiredTraitsAvailable = true;
				for each (var type:String in requiredTraits)
				{
					if (element.hasTrait(type) == false)
					{
						_requiredTraitsAvailable = false;
						break;
					}
				}
			}
			else
			{
				_requiredTraitsAvailable = false;
			}
			
			if	(	event == null // always invoke handlers, if change is not event driven.
				||	_requiredTraitsAvailable != priorRequiredTraitsAvailable
				)
			{
				_requiredTraitsAvailable
					? processRequiredTraitsAvailable(element)
					: processRequiredTraitsUnavailable(element);
			}
			
			if (event)
			{
				event.type == MediaElementEvent.TRAIT_ADD
					? onElementTraitAdd(event)
					: onElementTraitRemove(event);
			}
		}
		
		private var _element:MediaElement;
		private var _enabled:Boolean = true;
		private var _left:Number = 0;
		private var _top:Number = 0;
		private var _registrationTarget:String;
		private var _registrationTargetDirection:String;
		private var _requiredTraitsAvailable:Boolean;
	}
}