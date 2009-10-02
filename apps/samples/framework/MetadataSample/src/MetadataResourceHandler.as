package
{
	import org.osmf.media.IMediaResource;
	import org.osmf.media.IMediaResourceHandler;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;
	import org.osmf.utils.MediaFrameworkStrings;

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