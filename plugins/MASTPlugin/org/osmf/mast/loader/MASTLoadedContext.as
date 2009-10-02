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
*  Contributor(s): Akamai Technologies
*  
*****************************************************/
package org.osmf.mast.loader
{
	import org.osmf.mast.model.MASTDocument;
	import org.osmf.traits.ILoadedContext;
	
	/**
	 * Loaded context for the MASTProxyElement.
	 **/
	public class MASTLoadedContext implements ILoadedContext
	{
		/**
		 * Constructor.
		 * 
		 * @param document The MASTDocument object representing
		 * the root level of the MAST document object model.
		 */
		public function MASTLoadedContext(document:MASTDocument)
		{
			_document = document;
		}

		/**
		 * Get the MASTDocument object that was supplied to
		 * the constructor.
		 */
		public function get document():MASTDocument
		{
			return _document;
		}
		
		private var _document:MASTDocument;
	}
}
