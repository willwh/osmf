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

package com.akamai.osmf.events
{
	import org.osmf.events.MediaError;

	/**
	 * An AkamaiMediaError encapsulates an error specific to Akamai plugins.  
	 * Errors are represented as error IDs with corresponding messages.  
	 * 
	 * <p>A list of all possible Akamai plugin-level errors can be found in the
	 * <code>AkamaiMediaErrorCodes</code> class.</p>
	 *
	 * @see AkamaiMediaErrorCodes 
	 **/
	public class AkamaiMediaError extends MediaError
	{
		/**
		 * Constructor. Takes an error id.
		 * 
		 * @see AkamaiMediaErrorCodes
		 */
		public function AkamaiMediaError(errorID:int)
		{
			super(errorID);
		}
		
		/**
		 * @inheritDoc
		 */
		override protected function getMessageForErrorID(errorID:int):String
		{
			return AkamaiMediaErrorCodes.getMessageForErrorID(errorID);
		}
	}
}
