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
package org.openvideoplayer.mast.traits
{
	import org.openvideoplayer.mast.adapter.MASTAdapter;
	import org.openvideoplayer.mast.loader.MASTDocumentProcessor;
	import org.openvideoplayer.mast.media.MASTProxyElement;
	import org.openvideoplayer.mast.model.*;
	import org.openvideoplayer.mast.types.MASTConditionType;
	import org.openvideoplayer.media.MediaElement;
	import org.openvideoplayer.traits.PlayableTrait;

	public class MASTPlayableTrait extends PlayableTrait
	{
		public function MASTPlayableTrait(owner:MediaElement)
		{
			super(owner);
			
			_playRequestPending = false;
		}
		
		
		public function get playRequestPending():Boolean
		{
			return _playRequestPending;
		}
		
		/**
		 * The purpose of this method is to allows us to wait until the MAST 
		 * source payload has completely loaded before calling play() on the wrappedElement.
		 */
		override protected function processPlayingChange(newPlaying:Boolean):void
		{
			_playRequestPending = false;
			
			if (newPlaying)
			{
				_playRequestPending = true;
			}
		}
				
		private var _playRequestPending:Boolean;	
	}
}
