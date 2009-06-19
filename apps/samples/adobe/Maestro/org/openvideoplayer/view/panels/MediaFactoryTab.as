package org.openvideoplayer.view.panels
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import mx.collections.ArrayCollection;
	import mx.events.ListEvent;
	
	import org.openvideoplayer.events.NewMediaInfoEvent;
	import org.openvideoplayer.loaders.ILoader;
	import org.openvideoplayer.media.IMediaResourceHandler;
	import org.openvideoplayer.media.MediaInfo;
	import org.openvideoplayer.model.MediaElementDescriptor;
	import org.openvideoplayer.model.Model;
	
	public class MediaFactoryTab extends MediaFactoryTabLayout
	{
		public function MediaFactoryTab()
		{
			super();
			
			mediaIdError= false;
		}

		override protected function childrenCreated():void
		{
			super.childrenCreated();
		
			initMediaInfosList();
			initMediaElementsList();

			loadersList.labelField = "loaderClassName";
			mediaInfoId.addEventListener(Event.CHANGE, onMediaInfoIdChange);
			
			onMediaElementsListChange(null);
			
			saveMediaInfoButton.addEventListener(MouseEvent.CLICK, onSaveMediaInfoButtonClick);
			Model.getInstance().addEventListener(NewMediaInfoEvent.NEW_MEDIA_INFO, onNewMediaInfo);
		}
		
		private function initMediaInfosList():void
		{
			var model:Model = Model.getInstance();
			var mediaInfoIds:Array = new Array();
			for (var i:int = 0; i < model.mediaIds.length; i++)
			{
				mediaInfoIds.push(model.mediaIds[i]);
			}
			
			mediaInfoList.dataProvider = mediaInfoIds;
			mediaInfoList.selectedIndex = 0;
		}
		
		private function initMediaElementsList():void
		{
			mediaElementsList.dataProvider = Model.getInstance().descriptors;
			mediaElementsList.labelField = "mediaElementClassName";
			mediaElementsList.addEventListener(ListEvent.CHANGE, onMediaElementsListChange);
		}
		
		private function onMediaElementsListChange(event:ListEvent):void
		{
			var currentDescriptor:MediaElementDescriptor = Model.getInstance().descriptors[mediaElementsList.selectedIndex];
			 
			loadersList.dataProvider = currentDescriptor.loaderDescriptors;
			loadersList.enabled = currentDescriptor.loaderDescriptors.length > 0;
			
			checkEnablement();
		}

		private function checkEnablement():void
		{
			var currentDescriptor:MediaElementDescriptor = mediaElementsList.selectedIndex != -1
														 ? Model.getInstance().descriptors[mediaElementsList.selectedIndex]
														 : null;
			
			saveMediaInfoButton.enabled = 		currentDescriptor != null
									&&	currentDescriptor.mediaElementClass != null
									&&	mediaInfoId.text != null
									&& mediaInfoId.text.length > 0
									&& mediaIdError == false
										;
		}
		
		private function onMediaInfoIdChange(event:Event):void
		{
			checkMediaInfoId();
			checkEnablement();
		}
		
		private function checkMediaInfoId():void
		{
			if (Model.getInstance().mediaInfoIdExist(mediaInfoId.text))
			{
				mediaInfoIdError.text = "MediaInfo Id \"" + mediaInfoId.text + "\" has been used, please pick a different one.";
				mediaInfoIdError.visible = true;
				mediaIdError = true;
			}
			else
			{
				mediaInfoIdError.visible = false;
				mediaIdError = false;
			}
		}
		
		private function onSaveMediaInfoButtonClick(event:MouseEvent):void
		{
			var currentDescriptor:MediaElementDescriptor = Model.getInstance().descriptors[mediaElementsList.selectedIndex];
			var loader:ILoader = loadersList.selectedIndex >= 0 ? new currentDescriptor.loaderDescriptors[loadersList.selectedIndex].loaderClass() : null;
			
			var mediaInfo:MediaInfo = new MediaInfo
				( mediaInfoId.text
				, loader ? loader as IMediaResourceHandler : null
				, currentDescriptor.mediaElementClass
				, loader ? [currentDescriptor.loaderDescriptors[loadersList.selectedIndex].loaderClass] : []
				);
				
			Model.getInstance().addMediaInfo(mediaInfo);
			mediaInfoId.text = "";
			checkEnablement();			
		}
		
		private function onNewMediaInfo(event:NewMediaInfoEvent):void
		{
			(mediaInfoList.dataProvider as ArrayCollection).addItem(event.mediaInfo.id);
		}
		
		private var mediaIdError:Boolean;
	}
}