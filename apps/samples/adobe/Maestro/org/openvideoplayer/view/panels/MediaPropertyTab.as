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
package org.openvideoplayer.view.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import org.openvideoplayer.composition.CompositeElement;
	import org.openvideoplayer.events.NewMediaInfoEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaInfo;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.media.URLResource;
	import org.openvideoplayer.model.MediaElementDescriptor;
	import org.openvideoplayer.model.Model;
	import org.openvideoplayer.utils.ParseUtils;
	
	public class MediaPropertyTab extends MediaPropertyTabLayout
	{
		// Overrides
		//
				
		override protected function childrenCreated():void
		{
			super.childrenCreated();
			
			initMediaInfosList();
			
			Model.getInstance().addEventListener(NewMediaInfoEvent.NEW_MEDIA_INFO, onNewMediaInfo);
						
			mediaElementsList.dataProvider = Model.getInstance().descriptors;
			mediaElementsList.labelField = "mediaElementClassName";
			
			loadersList.labelField = "loaderClassName";
			
			mediaElementsList.addEventListener(ListEvent.CHANGE, onMediaElementsListChange);
			resourceInput.addEventListener(TextEvent.TEXT_INPUT, onTextInput);
			resourceInput.addEventListener(Event.CHANGE, onTextChange);
			createButton.addEventListener(MouseEvent.CLICK, onCreateButtonClick);
			tree.addEventListener(ListEvent.ITEM_CLICK, onTreeItemClick);
			addToCompositionButton.addEventListener(MouseEvent.CLICK, onAddToCompositionButtonClick);
			
			tree.labelFunction = createTreeItemLabel;
			tree.dataDescriptor = new CompositeElementTreeDataDescriptor();
			
			// Give it a default URL to start.
			resourceInput.text = REMOTE_STREAM;
			
			onMediaElementsListChange(null);
		}
					
		// Internals
		//
		
		private function initMediaInfosList():void
		{
			var model:Model = Model.getInstance();
			var dataProvider:ArrayCollection = new ArrayCollection();
			
			for (var i:int = 0; i < model.mediaIds.length; i++)
			{
				var mediaInfo:IMediaInfo = model.mediaFactory.getMediaInfoById(model.mediaIds[i]);
				if (mediaInfo != null)
				{
					var dataItem:Object = new Object();
					dataItem["label"] = mediaInfo.id;
					dataItem["data"] = mediaInfo;
					dataProvider.addItem(dataItem);
				}
			}
			
			dataProvider.addItem({label:"Other", data:null}); 
			mediaInfoList.dataProvider = dataProvider;
			mediaInfoList.selectedIndex = dataProvider.length - 1;
			mediaInfoList.addEventListener(ListEvent.CHANGE, onMediaInfosListChange);
		}
		
		private function onMediaInfosListChange(event:ListEvent):void
		{
			var mediaInfo:IMediaInfo = mediaInfoList.dataProvider[mediaInfoList.selectedIndex]["data"];
			mediaElementsList.visible = (mediaInfo == null);
			loadersList.visible = (mediaInfo == null);
			if (mediaInfo != null)
			{
				resourceInput.enabled = true;
			}
		}
		
		private function onMediaElementsListChange(event:ListEvent):void
		{
			var currentDescriptor:MediaElementDescriptor = Model.getInstance().descriptors[mediaElementsList.selectedIndex];
			 
			loadersList.dataProvider = currentDescriptor.loaderDescriptors;
			loadersList.enabled = currentDescriptor.loaderDescriptors.length > 0;
			resourceInput.enabled = currentDescriptor.requiresResource;
			
			// Clear the input field if no resource is required.
			if (currentDescriptor.requiresResource == false)
			{
				resourceInput.text = "";
			} 
			
			checkEnablement();
		}
		
		private function onTextChange(event:Event):void
		{
			checkEnablement();
		}
		
		private function onTextInput(event:TextEvent):void
		{
			checkEnablement();
		}
		
		private function checkEnablement():void
		{
			var currentDescriptor:MediaElementDescriptor = mediaElementsList.selectedIndex != -1
														 ? Model.getInstance().descriptors[mediaElementsList.selectedIndex]
														 : null;
			
			createButton.enabled = 		currentDescriptor != null
									&&	currentDescriptor.mediaElementClass != null
									&&  (  currentDescriptor.requiresResource == false
										|| resourceInput.text.length > 0
										);
			addToCompositionButton.enabled =   createButton.enabled
										 	&& tree.selectedItem is CompositeElement;
			
			addToCompositionButton.visible = Model.getInstance().mediaElement is CompositeElement;
		}
		
		private function onCreateButtonClick(event:MouseEvent):void
		{
			var mediaInfo:IMediaInfo = mediaInfoList.dataProvider[mediaInfoList.selectedIndex]["data"];
			if (mediaInfo != null)
			{
				var mediaElement:MediaElement = mediaInfo.createMediaElement(new URLResource(resourceInput.text));
				setMediaElement(mediaElement);
			}
			else
			{
				setMediaElement(createMediaElement());
			}
						
			// Show it.
			vrule.visible = treeBox.visible = true;
		}
		
		private function onTreeItemClick(event:ListEvent):void
		{
			checkEnablement();
		}
		
		private function onAddToCompositionButtonClick(event:MouseEvent):void
		{
			var compositeElement:CompositeElement = tree.selectedItem as CompositeElement;
			compositeElement.addChild(createMediaElement());
			
			tree.invalidateList();
			
			checkEnablement();
		}
		
		private function createMediaElement():MediaElement
		{
			var currentDescriptor:MediaElementDescriptor = Model.getInstance().descriptors[mediaElementsList.selectedIndex];
			var loader:ILoader = loadersList.selectedIndex >= 0 ? new currentDescriptor.loaderDescriptors[loadersList.selectedIndex].loaderClass() : null;
			var mediaElement:MediaElement = loader ? new currentDescriptor.mediaElementClass(loader) : new currentDescriptor.mediaElementClass();
			mediaElement.resource = new URLResource(resourceInput.text);
			return mediaElement;
		} 
		
		private function setMediaElement(mediaElement:MediaElement):void
		{
			Model.getInstance().mediaElement = mediaElement;
			
			// Assign to our tree.
			tree.dataProvider = mediaElement;
			
			checkEnablement();
		}
		
		private function createTreeItemLabel(mediaElement:MediaElement):String
		{
			var label:String = ParseUtils.parseObjectForClass(mediaElement); 
			
			if (mediaElement.resource != null &&
				mediaElement.resource is URLResource)
			{
				label += " (" + URLResource(mediaElement.resource).url + ")";
			}
			return label;  
		}
		
		private function onNewMediaInfo(event:NewMediaInfoEvent):void
		{
			var dataItem:Object = new Object();
			dataItem["label"] = event.mediaInfo.id;
			dataItem["data"] = event.mediaInfo;
			var dataProvider:ArrayCollection = mediaInfoList.dataProvider as ArrayCollection;
			dataProvider.addItemAt(dataItem, dataProvider.length - 2);
		}
		
		private static const REMOTE_PROGRESSIVE:String 		= "http://mediapm.edgesuite.net/strobe/content/test/AFaerysTale_sylviaApostol_640_500_short.flv";
		private static const REMOTE_STREAM:String 			= "rtmp://cp67126.edgefcs.net/ondemand/mediapm/strobe/content/test/SpaceAloneHD_sounas_640_500_short.flv";

	}
}