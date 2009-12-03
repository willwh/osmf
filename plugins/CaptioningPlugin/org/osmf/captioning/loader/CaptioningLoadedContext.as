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
*****************************************************/
package org.osmf.captioning.loader
{
	import org.osmf.captioning.model.CaptioningDocument;
	import org.osmf.traits.ILoadedContext;

	/**
	 * Loaded context for the CaptioningProxyElement.
	 *
	 *  @langversion 3.0
	 *  @playerversion Flash 10
	 *  @playerversion AIR 1.0
	 *  @productversion OSMF 1.0
	 */
	public class CaptioningLoadedContext implements ILoadedContext
	{
		/**
		 * Constructor.
		 * 
		 * @param document The CaptioningDocument representing the root level
		 * object in the Captioning document object model.
		 *
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function CaptioningLoadedContext(document:CaptioningDocument)
		{
			_document = document;
		}
		
		/**
		 * Get the CaptioningDocument that was supplied to the 
		 * constructor.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function get document():CaptioningDocument
		{
			return _document;
		}

		private var _document:CaptioningDocument;
	}
}
