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
package org.osmf.composition
{
	/**
	 * Enumeration of different modes for composite media elements.
	 **/
	public final class CompositionMode
	{
		/**
		 * The PARALLEL composition mode represents media compositions whose
		 * elements are presented in parallel.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const PARALLEL:CompositionMode = new CompositionMode("parallel");

		/**
		 * The SERIAL composition mode represents media compositions whose
		 * elements are presented serially.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */	
		public static const SERIAL:CompositionMode = new CompositionMode("serial");
		
		// Public interface
		//
		
		/**
		 * Constructor
		 * 
		 * @param token The token that identifies the composition mode.
		 * 
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function CompositionMode(token:String)
		{
			this.token = token;
		}
		
		/**
		 * @inheritDoc
		 */
		public function toString():String
		{
			return token;
		}
		
		// Internals
		//
		
		private var token:String;
	}
}