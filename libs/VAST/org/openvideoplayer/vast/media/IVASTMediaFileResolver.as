/*****************************************************
*  
*  Copyright 2009 Akamai Technologies, Inc.  All Rights Reserved.
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
*  The Initial Developer of the Original Code is Akamai Technologies, Inc.
*  Portions created by Akamai Technologies, Inc. are Copyright (C) 2009 Akamai 
*  Technologies, Inc. All Rights Reserved. 
*
*  Contributor(s): Adobe Systems Inc.
*
*****************************************************/
package org.openvideoplayer.vast.media
{
	import __AS3__.vec.Vector;
	
	import org.openvideoplayer.vast.model.VASTMediaFile;
	
	/**
	 * When multiple media files are found in a VAST document, an arbitration is needed to 
	 * pick the most suitable VASTMediaFile. This class encapsulates the details of how to 
	 * pick the right VASTMediaFile out all those available from the VAST document.
	 */
	public interface IVASTMediaFileResolver
	{
		/**
		 * Return the VASTMediaFile to use, from the input list.
		 */
		function resolveMediaFiles(mediaFiles:Vector.<VASTMediaFile>):VASTMediaFile;		
	}
}
