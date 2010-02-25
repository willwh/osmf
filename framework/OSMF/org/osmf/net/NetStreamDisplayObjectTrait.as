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
package org.osmf.net
{
	import flash.events.Event;
	import flash.media.Video;
	import flash.net.NetStream;
	
	import org.osmf.traits.DisplayObjectTrait;
	
	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class NetStreamDisplayObjectTrait extends DisplayObjectTrait
	{
		public function NetStreamDisplayObjectTrait(netStream:NetStream, view:Video, mediaWidth:Number=0, mediaHeight:Number=0)
		{
			super(view, mediaWidth, mediaHeight);
			
			this.netStream = netStream;
			NetClient(netStream.client).addHandler(NetStreamCodes.ON_META_DATA, onMetaData);
			view.addEventListener(Event.ADDED_TO_STAGE, onStage);
		}
		
		private function onStage(event:Event):void
		{
			displayObject.removeEventListener(Event.ADDED_TO_STAGE, onStage);
			displayObject.addEventListener(Event.RENDER, onRender);			
		}
				
		private function onRender(event:Event):void
		{				
			if (Video(displayObject).videoWidth != 0 &&
				Video(displayObject).videoHeight != 0)
			{				
				displayObject.width = Video(displayObject).videoWidth;
    			displayObject.height = Video(displayObject).videoHeight;
    				
				setMediaSize(displayObject.width, displayObject.height);
				displayObject.removeEventListener(Event.RENDER, onRender);		
			}
		}
	
		private function onMetaData(info:Object):void 
    	{       		
    		if (!isNaN(info.width) &&
    		    !isNaN(info.height))
    		{	    			
    			displayObject.removeEventListener(Event.RENDER, onRender);	
    			displayObject.removeEventListener(Event.ADDED_TO_STAGE, onStage);	
    			displayObject.width = info.width;
    			displayObject.height = info.height;
    				
				setMediaSize(info.width, info.height);
    		}
    	}
    	
		private var netStream:NetStream;
	}
}