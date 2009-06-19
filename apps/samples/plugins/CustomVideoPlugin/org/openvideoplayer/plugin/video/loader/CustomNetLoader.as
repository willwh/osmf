package org.openvideoplayer.plugin.video.loader
{
	import flash.events.NetStatusEvent;
	
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IURLResource;
	import org.openvideoplayer.netmocker.TracingNetLoader;
	
	public class CustomNetLoader extends TracingNetLoader
	{
		public function CustomNetLoader()
		{
			super();
		}
		
		override protected function onNetConnectionNetStatusEvent(event:NetStatusEvent):void
	    {   
	    	trace("Custome NetConnection: " + event.info.code + ": " + event.info.level);
	    }

	    override protected function onNetStreamNetStatusEvent(event:NetStatusEvent):void
	    {
	    	trace("Custome NetConnection: " + event.info.code + ": " + event.info.level); 
	    }
	    
	    /**
	 	*  Indicates whether the NetLoader can handle the specified IMediaResource.
	    *  The CustomNetLoader can handle only rtmp:// or http:// URL from flipside and mp3 from any server domain.
        *  
	    **/
	    
	    override public function canHandleResource(resource:IMediaResource):Boolean
	    {
	    	var res:IURLResource = resource as IURLResource;
	    	if (res)
	    	{
	    		return( res.url &&
		    		       (res.url.substr(0,30) ==	"http://flipside.corp.adobe.com" ||	    		
		    		    	res.url.substr(0,30) ==	"rtmp://flipside.corp.adobe.com" ||
		    		    	(res.url.indexOf("://") == -1) && res.url.indexOf(".mp3") > 0))
		    		    		// HACK: Currently NetLoader is used for loading
		    		    		// both types of audio (streaming and progressive).
		    		    		// We need a SoundLoader to handle the latter,
		    		    		// because the canHandleResource for the two types
		    		    		// should not overlap.  Until we have a SoundLoader,
		    		    		// I've added the last condition to allow for
		    		    		// playback of local MP3s.   		   		  
	    	}
	    	else
	    	{
				return false;
	    	}
	    }
	}
}