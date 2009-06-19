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
	import flash.events.MouseEvent;
	
	import org.openvideoplayer.events.LoadableStateChangeEvent;
	import org.openvideoplayer.media.IMediaTrait;
	import org.openvideoplayer.traits.ILoadable;
	import org.openvideoplayer.traits.LoadState;
	import org.openvideoplayer.traits.MediaTraitType;
	
	public class LoadableForm extends LoadableFormLayout
	{
		public function LoadableForm():void
		{
			traitType = MediaTraitType.LOADABLE;
			traitName = "ILoadable";
		}

		// Overrides
		//
		
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			loadButton.addEventListener(MouseEvent.CLICK, onLoadButtonClick);
			unloadButton.addEventListener(MouseEvent.CLICK, onUnloadButtonClick);
		}
		
		override protected function set description(value:String):void
		{
			formHeading.label = value;
		}

		override protected function processTraitAdded(trait:IMediaTrait):void
		{
			loadStateFormItem.visible = loadFormItem.visible = true;
			
			var loadable:ILoadable = trait as ILoadable;
			
			toggleLoadableEventListeners(loadable, true);
			updateControls(loadable);
		}
		
		override protected  function processTraitRemoved():void
		{
			loadStateFormItem.visible = loadFormItem.visible = false;
			
			toggleLoadableEventListeners(trait as ILoadable, false);
			updateControls(null);
		}
		
		// Internals
		//
		
		private function toggleLoadableEventListeners(value:ILoadable, on:Boolean):void
		{
			if (on)
			{
				value.addEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			}
			else
			{
				value.removeEventListener(LoadableStateChangeEvent.LOADABLE_STATE_CHANGE, onLoadableStateChange);
			}
		}
		
		private function onLoadableStateChange(event:LoadableStateChangeEvent):void
		{
			updateControls(trait as ILoadable);
		}
		
		private function updateControls(loadable:ILoadable):void
		{
			loadStateValue.text =  loadable != null
								 ? loadable.loadState.toString()
								 : null;
			
			loadButton.enabled =    loadable != null
								 && (  loadable.loadState == LoadState.CONSTRUCTED
								 	|| loadable.loadState == LoadState.LOAD_FAILED
								 	);

			unloadButton.enabled =    loadable != null
								   && loadable.loadState == LoadState.LOADED;
		}
		
		private function onLoadButtonClick(event:MouseEvent):void
		{
			var loadable:ILoadable = trait as ILoadable;
			loadable.load();
		}

		private function onUnloadButtonClick(event:MouseEvent):void
		{
			var loadable:ILoadable = trait as ILoadable;
			loadable.unload();
		}
	}
}