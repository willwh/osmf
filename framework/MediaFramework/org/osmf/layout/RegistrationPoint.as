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
package org.osmf.layout
{
	/**
	 * Defines an enumeration of registration point values as supported by the
	 * default layour renderer.
	 */	
	public class RegistrationPoint
	{
		/**
		 * Defines the top left registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const TOP_LEFT:RegistrationPoint = new RegistrationPoint("topLeft");
		
		/**
		 * Defines the top-middle registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const TOP_MIDDLE:RegistrationPoint = new RegistrationPoint("topMiddle");
		
		/**
		 * Defines the top-right registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const TOP_RIGHT:RegistrationPoint = new RegistrationPoint("topRight");
		
		/**
		 * Defines the middle-left registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const MIDDLE_LEFT:RegistrationPoint = new RegistrationPoint("middleLeft");
		
		/**
		 * Defines the center registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const CENTER:RegistrationPoint = new RegistrationPoint("center");
		
		/**
		 * Defines the middle-right registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const MIDDLE_RIGHT:RegistrationPoint = new RegistrationPoint("middleRight");
		
		/**
		 * Defines the bottom-left registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const BOTTOM_LEFT:RegistrationPoint = new RegistrationPoint("bottomLeft");
		
		/**
		 * Defines the bottom-middle registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const BOTTOM_MIDDLE:RegistrationPoint = new RegistrationPoint("bottomMiddle");
		
		/**
		 * Defines the bottom-right registration point.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const BOTTOM_RIGHT:RegistrationPoint = new RegistrationPoint("bottomRight");
		
		/**
		 * Constructor.
		 * 
		 * @private
		 */		
		public function RegistrationPoint(token:String)
		{
			_token = token;
		}
		
		/**
		 * @inheritDoc
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function toString():String
		{
			return _token;
		}

		// Internals
		//
		
		private var _token:String
	}
}