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
package org.osmf.smil.media
{
	import org.osmf.media.MediaElement;
	import org.osmf.media.MediaFactory;

	import org.osmf.smil.model.SMILDocument;	
	/**
	 * This interface represents a SMIL media generator and
	 * allows a plugin developer the means to create a custom
	 * SMIL plugin using a custom media generator.
	 */
	public interface ISMILMediaGenerator
	{
		/**
		 * Creates a single MediaElement based on the contents of the
		 * SMIL document object model.
		 * 
		 * @param smilDocument The SMIL file's root level object created
		 * by the SMIL parser.
		 * @param factory The MediaFactory object that will be used to
		 * create MediaElement objects.
		 */
		function createMediaElement(smilDocument:SMILDocument, factory:MediaFactory):MediaElement;		
	}
}
