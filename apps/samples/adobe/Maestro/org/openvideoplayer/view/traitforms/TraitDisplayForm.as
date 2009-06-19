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
package org.openvideoplayer.view.traitforms
{
	import mx.binding.utils.BindingUtils;
	import mx.containers.Form;
	
	import org.openvideoplayer.events.TraitsChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.model.Model;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class TraitDisplayForm extends Form
	{
		public function set traitType(value:MediaTraitType):void
		{
			_traitType = value;
		}

		public function get traitType():MediaTraitType
		{
			return _traitType;
		}
		
		public function set traitName(value:String):void
		{
			if (value != _traitName)
			{
				_traitName = value;
				traitNameChanged = true;
			
				invalidateProperties();
			}
		}
		
		public function get traitName():String
		{
			return _traitName;
		}
		
		// Protected
		//
		
		protected function set description(value:String):void
		{
			// Subclasses can override.
		}
		
		protected function processTraitAdded(trait:IMediaTrait):void
		{
			// Subclasses can override.
		}

		protected function processTraitRemoved():void
		{
			// Subclasses can override.
		}
		
		protected function get trait():IMediaTrait
		{
			return _trait;
		}
		
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			BindingUtils.bindProperty(this, "mediaElement", Model.getInstance(), "mediaElement");
		}
		
		override protected function commitProperties():void
		{
			super.commitProperties();
			
			if (traitNameChanged)
			{
				traitNameChanged = false;
				
				description = _traitName + ": None";
			}
		}

		// Internals
		//

		/**
		 * @private
		 **/
		public function set mediaElement(value:MediaElement):void
		{
			if (value != _mediaElement)
			{
				toggleMediaElementEventListeners(_mediaElement, false);
				
				setTrait(value.getTrait(_traitType), value);
				
				_mediaElement = value;
				
				toggleMediaElementEventListeners(_mediaElement, true);
			}
		}
		
		private function setTrait(value:IMediaTrait, mediaElement:MediaElement):void
		{
			if (value != _trait)
			{
				if (_trait != null)
				{
					processTraitRemoved();
					
					description = _traitName + ": None";
				}
				
				_trait = value;
				
				if (_trait != null)
				{
					processTraitAdded(_trait);
					
					description = _traitName;
				}
			}
		}
		
		private function toggleMediaElementEventListeners(value:MediaElement, on:Boolean):void
		{
			if (value != null)
			{
				if (on)
				{
					value.addEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					value.addEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				}
				else
				{
					value.removeEventListener(TraitsChangeEvent.TRAIT_ADD, onTraitAdd);
					value.removeEventListener(TraitsChangeEvent.TRAIT_REMOVE, onTraitRemove);
				}
			}
		}
		
		private function onTraitAdd(event:TraitsChangeEvent):void
		{
			if (event.traitType == _traitType)
			{
				setTrait(event.media.getTrait(_traitType), event.media);
			}
		}

		private function onTraitRemove(event:TraitsChangeEvent):void
		{
			if (event.traitType == _traitType)
			{
				setTrait(null, event.media);
			}
		}
		
		private var _mediaElement:MediaElement;
		private var _trait:IMediaTrait;
		private var _traitType:MediaTraitType;
		private var _traitName:String;
		private var traitNameChanged:Boolean = false;
	}
}