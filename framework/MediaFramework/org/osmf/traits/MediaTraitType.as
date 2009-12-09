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
package org.osmf.traits
{
	import __AS3__.vec.Vector;
	
	/**
	 * MediaTraitType enumerates all available media trait types.
	 * 
	 * <p>The set of traits in the system are fixed:  clients are not expected
	 * to introduce their own, as they form the core vocabulary of the system.</p>
	 */	
	public final class MediaTraitType
	{
		/**
		 * Identifies a trait that implements the IAudible interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public static const AUDIBLE:MediaTraitType = new MediaTraitType(IAudible);
		
		/**
		 * Identifies a trait that implements the IBufferable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const BUFFERABLE:MediaTraitType = new MediaTraitType(IBufferable);
		
		/**
		 * Identifies a trait that implements the ILoadable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const LOADABLE:MediaTraitType = new MediaTraitType(ILoadable);
		
		/**
		 * Identifies a trait that implements the IPausable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const PAUSABLE:MediaTraitType = new MediaTraitType(IPausable);
		
		/**
		 * Identifies a trait that implements the IPlayable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const PLAYABLE:MediaTraitType = new MediaTraitType(IPlayable);
		
		/**
		 * Identifies a trait that implements the ISeekable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const SEEKABLE:MediaTraitType = new MediaTraitType(ISeekable);
		
		/**
		 * Identifies a trait that implements the ISpatial interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const SPATIAL:MediaTraitType = new MediaTraitType(ISpatial);
		
		/**
		 * Identifies a trait that implements the ITemporal interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const TEMPORAL:MediaTraitType = new MediaTraitType(ITemporal);
		
		/**
		 * Identifies a trait that implements the IViewable interface. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const VIEWABLE:MediaTraitType = new MediaTraitType(IViewable); 
		
		/**
		 * Identifies a trait that implements the ISwitchable interface.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const SWITCHABLE:MediaTraitType = new MediaTraitType(ISwitchable);
		
		/**
		 * Identifies a trait that implements the ISwitchable interface.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const CONTENT_PROTECTABLE:MediaTraitType = new MediaTraitType(IContentProtectable);
		
		/**
		 * Identifies a trait that implements the IDownloadable interface.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const DOWNLOADABLE:MediaTraitType = new MediaTraitType(IDownloadable);

		/**
		 * Array containing all trait types in the system.  Useful for clients
		 * who want to iterate over all traits.
		 **/
		public static const ALL_TYPES:Vector.<MediaTraitType> = 
			Vector.<MediaTraitType>
				( 
				  [   AUDIBLE
					, BUFFERABLE
					, LOADABLE
					, PAUSABLE
					, PLAYABLE
					, SEEKABLE
					, SPATIAL
					, TEMPORAL
					, VIEWABLE
					, SWITCHABLE
					, DOWNLOADABLE
				  ]
				);

		/**
		 * Constructor
		 * 
		 * @param traitInterface Specifies the trait interface class that this
		 * identifier implements.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		 
		public function MediaTraitType(traitInterface:Class)
		{
			_traitInterface = traitInterface;	
		}

		/**
		 * The Class that implements the trait.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */		
		public function get traitInterface():Class
		{
			return _traitInterface;
		}

		/**
		 * Returns the string representation of the MediaTraitType.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
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