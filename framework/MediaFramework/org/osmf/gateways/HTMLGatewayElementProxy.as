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
package org.osmf.gateways
{
	import flash.external.ExternalInterface;
	
	import org.osmf.media.MediaElement;
	import org.osmf.proxies.ListenerProxyElement;
	import org.osmf.traits.LoadState;

	/**
	 * Utility class deriving from ListenerProxyElement, that captures events and
	 * forwards them to HTML.
	 */	
	internal class HTMLGatewayElementProxy extends ListenerProxyElement
	{
		public function HTMLGatewayElementProxy(wrappedElement:MediaElement, elementScriptPath:String)
		{
			this.elementScriptPath = elementScriptPath;
			
			super(wrappedElement);
		}
		
		// Overrides
		//
		
		// Playable
		
		override protected function processPlayingChange(playing:Boolean):void
		{
			ExternalInterface.call(elementScriptPath + "__onPlayingChange__", playing);
		}
		
		// Pausable
		
		override protected function processPausedChange(paused:Boolean):void
		{
			ExternalInterface.call(elementScriptPath + "__onPausedChange__", paused);
		}
		
		// Temporal
		
		override protected function processDurationChange(newDuration:Number):void
		{
			ExternalInterface.call(elementScriptPath + "__onDurationChange__", newDuration);
		}
		
		override protected function processDurationReached():void
		{
			ExternalInterface.call(elementScriptPath + "__onDurationReached__");
		}
		
		// Audible
		
		override protected function processVolumeChange(newVolume:Number):void
		{
			ExternalInterface.call(elementScriptPath + "__onVolumeChange__", newVolume);
		}
		
		override protected function processMutedChange(muted:Boolean):void
		{
			ExternalInterface.call(elementScriptPath + "__onMutedChange__", muted);
		}
		
		override protected function processPanChange(newPan:Number):void
		{
			ExternalInterface.call(elementScriptPath + "__onPanChange__", newPan);
		}
		
		// Internals
		//
		
		private var elementScriptPath:String;
	}
}