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
package org.osmf.mast.traits
{
	import org.osmf.mast.adapter.MASTAdapter;
	import org.osmf.mast.loader.MASTDocumentProcessor;
	import org.osmf.mast.media.MASTProxyElement;
	import org.osmf.mast.model.*;
	import org.osmf.mast.types.MASTConditionType;
	import org.osmf.media.MediaElement;
	import org.osmf.traits.PlayableTrait;

	/**
	 * The purpose of this class is to provide a PlayableTrait
	 * that can inform another class that a play request
	 * is pending. For example if a proxy class were to 
	 * override the PlayableTrait, it could use this class
	 * to determine whether or not to call play() on the original
	 * PlayableTrait when removing this trait.
	 */
	public class MASTPlayableTrait extends PlayableTrait
	{
		/**
		 * @inheritDoc
		 */
		public function MASTPlayableTrait(owner:MediaElement)
		{
			super(owner);
			
			_playRequestPending = false;
		}
		
		/**
		 * Returns true if a play request was made on this trait.
		 */
		public function get playRequestPending():Boolean
		{
			return _playRequestPending;
		}
		
		/**
		 * @inheritDoc
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
