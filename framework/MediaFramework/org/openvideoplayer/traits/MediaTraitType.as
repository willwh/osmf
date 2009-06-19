/*************************************************************************
* 
*  Copyright (c) 2009, openvideoplayer.org
*  All rights reserved.
*  
*  Redistribution and use in source and binary forms, with or without 
*  modification, are permitted provided that the following conditions are 
*  met:
*  
*     * Redistributions of source code must retain the above copyright 
*  		notice, this list of conditions and the following disclaimer.
*     * Redistributions in binary form must reproduce the above 
*  		copyright notice, this list of conditions and the following 
*  		disclaimer in the documentation and/or other materials provided 
*  		with the distribution.
*     * Neither the name of the openvideoplayer.org nor the names of its 
*  		contributors may be used to endorse or promote products derived 
*  		from this software without specific prior written permission.
*  
*  THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS 
*  "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT 
*  LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR 
*  A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT 
*  HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, 
*  SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT 
*  LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, 
*  DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY 
*  THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT 
*  (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE 
*  OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
**************************************************************************/
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