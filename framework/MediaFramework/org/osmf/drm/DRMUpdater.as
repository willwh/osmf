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
package org.osmf.drm
{
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.SystemUpdater;
	import flash.system.SystemUpdaterType;

		

	public class DRMUpdater extends SystemUpdater
	{
		/**
		 * Singleton getter
		 */ 
		public static function getInstance():DRMUpdater
		{
			if (_instance == null)
			{
				_instance = new DRMUpdater();
			}
			
			return _instance;
		}
		
		/**
		 * Constructor for DRMUpdater, do not call directly
		 * use the getInstace() getter, this class is a singleton.
		 */ 
		public function DRMUpdater()
		{
			_updateInProgress = false;
			addEventListener(Event.COMPLETE, updateFinished);
			addEventListener(IOErrorEvent.IO_ERROR, updateFinished);
			addEventListener(SecurityErrorEvent.SECURITY_ERROR, updateFinished);
			addEventListener(Event.CANCEL, updateFinished);			
		}
		
		/**
		 * @inheritDoc
		 */ 
		override public function update(type:String):void
		{
			if (_updateInProgress)
			{
				return;
			}
			
			_updateInProgress = true;
							
			//Should dispatch the 'open' event.									
			super.update(type);
		}
		
		private function updateFinished(event:Event):void
		{
			_updateInProgress = false;
		}
		
		private var _updateInProgress:Boolean;		
		private static var _instance:DRMUpdater;
	}
}