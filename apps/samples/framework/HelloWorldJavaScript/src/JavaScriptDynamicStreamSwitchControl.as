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
package
{
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.external.ExternalInterface;
	
	import org.osmf.media.MediaPlayerSprite;
	import org.osmf.media.URLResource;
	import org.osmf.net.DynamicStreamingItem;
	import org.osmf.net.DynamicStreamingResource;

	/**
	 * JavaScriptDynamicStreamSwitchControl
	 **/
	public class JavaScriptDynamicStreamSwitchControl extends Sprite
	{
		public function JavaScriptDynamicStreamSwitchControl()
		{		
 			sprite = new MediaPlayerSprite();
			addChild(sprite);
			sprite.resource = new URLResource("http://mediapm.edgesuite.net/osmf/content/test/manifest-files/dynamic_Streaming.f4m");
			
			if (ExternalInterface.available)
			{				
				// Register the javascript callback function
				ExternalInterface.addCallback("getAutoDynamicStreamSwitch", getAutoDynamicStreamSwitch);
				ExternalInterface.addCallback("setAutoDynamicStreamSwitch", setAutoDynamicStreamSwitch);
				ExternalInterface.addCallback("switchDynamicStreamIndex", switchDynamicStreamIndex);
				
				ExternalInterface.addCallback("getStreamItems", getStreamItems);
				ExternalInterface.addCallback("getCurrentDynamicStreamIndex", getCurrentDynamicStreamIndex);
				
				// Register the addEventListener callback function - will be used for re-routing events to 
				// the javascript layer.
				ExternalInterface.addCallback("addEventListener", javascriptAddEventListener);
				
				// Notify the hosting page that the player is ready to be controlled
				var callbackFunction:String = 
					"function(objectID) {" +
					"  if (typeof onHelloWorldJavaScriptLoaded == 'function') { " +
					"    onHelloWorldJavaScriptLoaded(objectID); " +
					"  } " +
					"} ";
				ExternalInterface.call(callbackFunction, ExternalInterface.objectID);
			}
		}
		
		/**
		 * Creates an URL resource and starts playing it.
		 */ 
		private function javascriptAddEventListener(eventName:String, callbackFunctionName:String):void
		{
			sprite.mediaPlayer.addEventListener(eventName,
				function(event:Event):void
				{			
					ExternalInterface.call(callbackFunctionName, ExternalInterface.objectID);				
				}
			);		
		}
		
		private function getAutoDynamicStreamSwitch():Boolean
		{
			return sprite.mediaPlayer.autoDynamicStreamSwitch;
		}
		
		private function setAutoDynamicStreamSwitch(value:Boolean):void
		{
			sprite.mediaPlayer.autoDynamicStreamSwitch = value;
		}
		
		private function switchDynamicStreamIndex(streamIndex:int):void
		{
			 sprite.mediaPlayer.switchDynamicStreamIndex(streamIndex);
		}
		
		private function getCurrentDynamicStreamIndex():int
		{
			return sprite.mediaPlayer.currentDynamicStreamIndex;
		}		
		
		private function getStreamItems():Vector.<DynamicStreamingItem>
		{
			var streamItems:Vector.<DynamicStreamingItem> = 
				(sprite.mediaPlayer.media["proxiedElement"].resource as DynamicStreamingResource).streamItems;
			return streamItems;
		}
	
		private var sprite:MediaPlayerSprite;
	}
}
