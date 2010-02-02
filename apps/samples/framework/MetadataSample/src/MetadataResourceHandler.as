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
	import org.osmf.media.MediaResourceBase;
	import org.osmf.metadata.KeyValueFacet;
	import org.osmf.metadata.MetadataNamespaces;
	import org.osmf.metadata.ObjectIdentifier;

	public class MetadataResourceHandler
	{
		public function MetadataResourceHandler(mediaType:String)
		{
			type = mediaType;
		}

		public function canHandleResource(resource:MediaResourceBase):Boolean
		{
			var metadata:KeyValueFacet = resource.metadata.getFacet(MetadataNamespaces.DEFAULT_METADATA) as KeyValueFacet;
			return (metadata.getValue(new ObjectIdentifier(MetadataNamespaces.METADATA_KEY_MEDIA_TYPE)) == type);	
		}
		
		private var type:String;
		
	}
}