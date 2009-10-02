package org.osmf.metadata
{
	import flash.events.EventDispatcher;
	
	import org.osmf.utils.URL;

	public class MediaTypeFacet extends EventDispatcher implements IFacet
	{
		public function MediaTypeFacet(mediaType:String = null, mimeType:String = null)
		{			
			_mediaType = mediaType;
			_mimeType = mimeType;			
		}
		
		public function get mediaType():String
		{
			return _mediaType;
		}
		
		public function get mimeType():String
		{
			return _mimeType;
		}

		public function get namespaceURL():URL
		{
			return MetadataNamespaces.MEDIATYPE_METADATA;
		}
		
		public function getValue(identifier:IIdentifier):*
		{
			return null;
		}
		
		public function merge(childFacet:IFacet):IFacet
		{
			return null;
		}
		
		private var _mediaType:String;
		private var _mimeType:String;	
	}
}