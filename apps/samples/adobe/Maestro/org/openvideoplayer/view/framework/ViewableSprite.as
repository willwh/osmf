/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
package org.openvideoplayer.view.framework
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.events.ViewChangeEvent;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.ISpatial;
	import org.openvideoplayer.traits.IViewable;
	import org.openvideoplayer.traits.MediaTraitType;
	import org.openvideoplayer.traits.SpatialTrait;
	
	/**
	 * Sprite class which implements the IViewable trait.
	 **/
	public class ViewableSprite extends Sprite
	{
		// Public interface
		//
		
		public function ViewableSprite()
		{
			_spatial = new SpatialTrait();
			SpatialTrait(_spatial).setDimensions(320,240);
		}
		
		public function set source(value:MediaElement):void
		{
			if (value != _media)
			{
				if (_media != null)
				{
					_media.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					_media.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				}
				
				var viewable:IViewable 
					= value 
						? value.getTrait(MediaTraitType.VIEWABLE) as IViewable
						: null;
	
				setViewable(value,viewable);
				
				_media = value;
				
				var spatial:ISpatial
					= value
						? value.getTrait(MediaTraitType.SPATIAL) as ISpatial
						: null;
						
				setSpatial(spatial);
				
				if (value != null)
				{
					value.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					value.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				}

			}
		}
		
		public function get viewable():IViewable
		{
			return _viewable;
		}
		
		public function set dimensions(value:Point):void
		{
			if (_spatial != null && value != null)
			{
				_spatial = new SpatialTrait();
				SpatialTrait(_spatial).setDimensions(value.x, value.y);

				updateRepresentationDimensions();
			}
		}
		
		public function get dimensions():Point
		{
			return new Point(_spatial.width, _spatial.height);
		}
		 
		public function set scaleMode(value:ScaleMode):void
		{
			_scaleMode = value;
			updateRepresentationDimensions();
		}
		
		public function get scaleMode():ScaleMode
		{
			return _scaleMode || DEFAULT_SCALE_MODE;
		}
		
		protected function setViewable(media:MediaElement,value:IViewable):void
		{
			if (_viewable != value)
			{
				if (_viewable != null)
				{
					_viewable.removeEventListener(ViewChangeEvent.VIEW_CHANGE, onViewChanged);
				}
				
				var oldViewableView:DisplayObject 
					= _viewable
						? _viewable.view
						: null;
						
				_viewable = value;
				
				if (_viewable != null)
				{
					_viewable.addEventListener(ViewChangeEvent.VIEW_CHANGE, onViewChanged);
				}
					
				// This tool method will update the viewable's
				// current stage represtation:
				representViewableOnStage
					( _viewable ? _viewable.view : null
					, oldViewableView
					);
			}
		}
		
		protected function setSpatial(value:ISpatial):void
		{
			if (_spatial != value)
			{
				_spatial = value;
				
				updateRepresentationDimensions();
			}
		}
		
		// Internals
		//
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				setViewable(_media, event.media.getTrait(MediaTraitType.VIEWABLE) as IViewable);
			}
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			if (event.traitType == MediaTraitType.VIEWABLE)
			{
				setViewable(_media, null);
			}
		}
		
		private function onViewChanged(event:ViewChangeEvent):void
		{
			representViewableOnStage(event.newView,event.oldView);
		}
		
		// Tools
		//
		
		private function representViewableOnStage(newView:DisplayObject,oldView:DisplayObject):void
		{
			if (oldView && contains(oldView))
			{
				removeChild(oldView);
			}
			
			if (newView != null)
			{
				addChild(newView);
			}
			
			updateRepresentationDimensions();
		}
		
		private function updateRepresentationDimensions():void
		{
			if	(	_viewable != null
				&&	_spatial != null
				&&	_viewable.view != null
				)
			{
				// Clip anything outside of our assigned area:
				scrollRect = new Rectangle(0,0,_spatial.width,_spatial.height);
				
				// Get our scaled dimensions:
				var scaledDimensions:Point
					= (_scaleMode || DEFAULT_SCALE_MODE)
					. getScaledSize
						( 0
						, 0
						, _spatial.width
						, _spatial.height
						);
				
				// Get the true bounds of the viewable:
				var bounds:Rectangle = _viewable.view.getBounds(_viewable.view);
				bounds.width = Math.min(bounds.width,_spatial.width);
				bounds.height = Math.min(bounds.height,_spatial.height);
				
				// Apply calculated dimensions:		
				_viewable.view.scaleX = scaledDimensions.x / bounds.width; 
				_viewable.view.scaleY = scaledDimensions.y / bounds.height;
				
				// Center:
				_viewable.view.x = Math.round((_spatial.width - scaledDimensions.x) / 2);
				_viewable.view.y = Math.round((_spatial.height - scaledDimensions.y) / 2);
			}
		}
		
		private static const DEFAULT_SCALE_MODE:ScaleMode = ScaleMode.NONE;
		
		private var _media:MediaElement;
		private var _viewable:IViewable;
		private var _spatial:ISpatial;
		
		private var _scaleMode:ScaleMode;
	}
}