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
package org.osmf.net
{
	import flash.net.NetStream;
	
	import org.osmf.media.MediaElement;
	import org.osmf.traits.PausableTrait;
	
	/**
	 * The NetStreamPausableTrait class implements an IPausable interface that uses a NetStream.
	 * This trait is used by AudioElements and VideoElements.
	 * @private
	 * @see flash.net.NetStream
	 */  
	public class NetStreamPausableTrait extends PausableTrait
	{
		/**
		 * Constructor.
		 * @param netStream NetStream created for the ILoadable that belongs to the media element
		 * that uses this trait.
		 * @see NetLoader
		 */ 
		public function NetStreamPausableTrait(owner:MediaElement, netStream:NetStream)
		{
			super(owner);
			
			this.netStream = netStream;
		}
		
		/**
		 * @private
		 * Communicates a <code>paused</code> change to the media through the NetStream. 
		 *
		 * @param newPaused New <code>paused</code> value.
		 */						
		override protected function processPausedChange(newPaused:Boolean):void
		{
			if (newPaused)
			{
				netStream.pause();
			}
		}
		
		private var netStream:NetStream;
	}
}