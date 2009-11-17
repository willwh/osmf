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
package org.osmf.metadata
{
	import flash.errors.IllegalOperationError;
	
	/**
	 * StringIdentifier implements a string value based IIdentifier. 
	 */	
	public class StringIdentifier implements IIdentifier
	{
		/**
		 * Constructor
		 * 
		 * @param string The string value that this identifier wraps.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function StringIdentifier(string:String)
		{
			if (string == null)
			{
				throw new IllegalOperationError();
			}
			
			_string = string;
		}
		
		// IIdentifier
		//
		
		/**
		 * StringIdentifier will match any other StringIdentifier instance
		 * that wraps a string value that is equal to its own.
		 * 
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public function equals(value:IIdentifier):Boolean
		{
			return value is StringIdentifier
				&& StringIdentifier(value).string == _string;
		}
		
		// Public Interface
		//
		
		/**
		 * The string value that this identifier wraps.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get string():String
		{
			return _string;
		}
		
		// Internals
		//
		
		private var _string:String;
	}
}