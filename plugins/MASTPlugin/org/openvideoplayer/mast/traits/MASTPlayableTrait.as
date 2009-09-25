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
			
			this._mastProxyElement = owner as MASTProxyElement;
			_playRequestPending = false;
		}
		
		public function set mastDocument(value:MASTDocument):void
		{
			_mastDocument = value;
		}
		
		public function set documentProcessor(value:MASTDocumentProcessor):void
		{
			_processor = value;
		}
		
		public function get playRequestPending():Boolean
		{
			return _playRequestPending;
		}
		
		/**
		 * The purpose of this method is to check to see if a MAST start condition
		 * is present that would affect our order of media, such as an OnItemStart, 
		 * and if that condition is going to cause a source payload to be loaded. 
		 * If so, this class allows us to wait until the source payload has completely 
		 * loaded before calling play() on the wrappedElement.
		 */
		override protected function processPlayingChange(newPlaying:Boolean):void
		{
			_playRequestPending = false;
			
			if (newPlaying)
			{
				// See if there is a start condition
				for each (var trigger:MASTTrigger in _mastDocument.triggers)
				{	
					for each (var startCondition:MASTCondition in trigger.startConditions)
					{
						if (conditionCausesPendingPlayRequest(startCondition))
						{
							for each (var source:MASTSource in trigger.sources)
							{
								if (source.format == "vast")
								{
									_playRequestPending = true;
									_processor.loadVastDocument(source, startCondition);
								}
							}							
						}
					}
				}
				
				if (!_playRequestPending)
				{
					// We can remove this trait now
					_mastProxyElement.removeCustomPlayableTrait();
					
				}
			}
		}
		
		public static function conditionCausesPendingPlayRequest(cond:MASTCondition):Boolean
		{
			return (cond.type == MASTConditionType.EVENT && (conditionIsPreRoll(cond) || conditionIsPostRoll(cond)));
		}
		
		public static function conditionIsPreRoll(cond:MASTCondition):Boolean
		{
			return ((cond.name == MASTAdapter.ON_ITEM_START) || (cond.name == MASTAdapter.ON_PLAY));
		}
		
		public static function conditionIsPostRoll(cond:MASTCondition):Boolean
		{
			return ((cond.name == MASTAdapter.ON_ITEM_END) || (cond.name == MASTAdapter.ON_END) || (cond.name == MASTAdapter.ON_STOP));
		}
		
		private var _mastProxyElement:MASTProxyElement;
		private var _mastDocument:MASTDocument;
		private var _processor:MASTDocumentProcessor;
		private var _playRequestPending:Boolean;	
	}
}
