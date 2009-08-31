package
{
	import org.openvideoplayer.media.IMediaResource;
	import org.openvideoplayer.media.IMediaResourceHandler;
	import org.openvideoplayer.metadata.KeyValueFacet;
	import org.openvideoplayer.metadata.MetadataNamespaces;
	import org.openvideoplayer.metadata.ObjectIdentifier;
	import org.openvideoplayer.utils.MediaFrameworkStrings;

	public class MetadataResourceHandler implements IMediaResourceHandler
	{
		public function MetadataResourceHandler(mediaType:String)
		{
			type = mediaType;
		}

		public function canHandleResource(resource:IMediaResource):Boolean
		{
			var metadata:KeyValueFacet = resource.metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA) as KeyValueFacet;
			return (metadata.getValue(new ObjectIdentifier(MediaFrameworkStrings.METADATA_KEY_MEDIA_TYPE)) == type);	
		}
		
		private var type:String;
		
	}
}