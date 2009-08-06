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
package org.openvideoplayer.traits
{
	/**
	 * MediaTraitType enumerates all available media trait types.
	 */	
	public class MediaTraitType
	{
		/**
		 * Identifies a trait that implements the IAudible interface. 
		 */		
		public static const AUDIBLE:MediaTraitType = new MediaTraitType(IAudible);
		
		/**
		 * Identifies a trait that implements the IBufferable interface. 
		 */
		public static const BUFFERABLE:MediaTraitType = new MediaTraitType(IBufferable);
		
		/**
		 * Identifies a trait that implements the ILoadable interface. 
		 */
		public static const LOADABLE:MediaTraitType = new MediaTraitType(ILoadable);
		
		/**
		 * Identifies a trait that implements the IPausible interface. 
		 */
		public static const PAUSIBLE:MediaTraitType = new MediaTraitType(IPausible);
		
		/**
		 * Identifies a trait that implements the IPlayable interface. 
		 */
		public static const PLAYABLE:MediaTraitType = new MediaTraitType(IPlayable);
		
		/**
		 * Identifies a trait that implements the ISeekable interface. 
		 */
		public static const SEEKABLE:MediaTraitType = new MediaTraitType(ISeekable);
		
		/**
		 * Identifies a trait that implements the ISpatial interface. 
		 */
		public static const SPATIAL:MediaTraitType = new MediaTraitType(ISpatial);
		
		/**
		 * Identifies a trait that implements the ITemporal interface. 
		 */
		public static const TEMPORAL:MediaTraitType = new MediaTraitType(ITemporal);
		
		/**
		 * Identifies a trait that implements the IViewable interface. 
		 */
		public static const VIEWABLE:MediaTraitType = new MediaTraitType(IViewable); 
		
		/**
		 * Constructor
		 * 
		 * @param traitInterface Specifies the trait interface class that this
		 * identifier implements.
		 */		 
		public function MediaTraitType(traitInterface:Class)
		{
			_traitInterface = traitInterface;	
		}

		/**
		 * The Class that implements the trait.
		 */		
		public function get traitInterface():Class
		{
			return _traitInterface;
		}

		/**
		 * Returns the string representation of the MediaTraitType.
		 */
		public function toString():String
		{
			return traitInterface.toString();
		}

		// Internals
		//
		
		private var _traitInterface:Class;
	}
}