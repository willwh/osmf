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
package org.osmf.events
{
	/**
	 * A MediaError encapsulates an error.  Errors are represented as error
	 * codes with corresponding descriptions.  Error codes zero through 999
	 * are reserved for use by the framework.
	 * 
	 * <p>A list of all possible framework-level errors can be found in the
	 * <code>MediaErrorCodes</code> class.</p>
	 * 
	 * <p>For custom errors, clients should subclass MediaError and override
	 * <code>getDescriptionForErrorCode</code> to return descriptions for
	 * the custom errors.</p>
	 **/
	public class MediaError
	{
		/**
		 * Constructor.
		 * 
		 * @param errorCode The error code for the error.  Used to look up a
		 * corresponding description.  Error codes 0-999 are reserved for use
		 * by the framework.
		 * @param detail An optional string that contains supporting detail
		 * for the error.  Typically this string is simply the error detail
		 * provided by a Flash Player API.
		 **/
		public function MediaError(errorCode:int, detail:String=null)
		{
			_errorCode = errorCode;
			_detail = detail;
			_description = getDescriptionForErrorCode(errorCode);
		}
		
		/**
		 * The error code for the error.
		 * 
		 * <p>Framework error codes are defined in <code>MediaErrorCodes</code>.</p>
		 */
		public function get errorCode():int
		{
			return _errorCode;
		}
		
		/**
		 * The description for the error.
		 * 
		 * <p>Framework error descriptions are defined in <code>MediaErrorCodes</code>.</p>
		 */
		public function get description():String
		{
			return _description;
		}
		
		/**
		 * An optional string that contains supporting detail for the error.
		 * Typically this string is simply the error detail provided by a
		 * Flash Player API.
		 **/
		public function get detail():String
		{
			return _detail;
		}
		
		// Protected
		//
		
		/**
		 * Returns a description of the error for the specified error code.  If
		 * the error code is unknown, returns the empty string.
		 * 
		 * <p>Subclasses should override to provide descriptions for their
		 * custom errors, as this method returns the value that is exposed in
		 * the <code>description</code> property.</p>
		 * 
		 * @param errorCode The error code for the error.
		 * 
		 * @return A description of the error with the specified error code.
		 **/
		protected function getDescriptionForErrorCode(errorCode:int):String
		{
			return MediaErrorCodes.getDescriptionForErrorCode(errorCode);
		}
		
		// Internals
		//
		
		private var _errorCode:int;
		private var _description:String;
		private var _detail:String;
	}
}