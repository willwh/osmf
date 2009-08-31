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
package org.openvideoplayer.parsers
{
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.events.TimerEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	import flash.utils.Timer;
	
	import org.openvideoplayer.utils.FMSURL;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingItem;
	import org.openvideoplayer.net.dynamicstreaming.DynamicStreamingResource;
	
	[Event (name="error", type="flash.events.IOErrorEvent")]
	[Event (name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event (name="parsed", type="flash.events.Event")]
	[Event (name="busy", type="flash.events.Event")]
	
	public class SMILParser extends EventDispatcher
	{
		public function SMILParser()
		{
			_busy = false;
			_timeoutTimer = new Timer(LOAD_TIMEOUT, 1);
			_timeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onLoadTimeout);
		}
		
		private function onLoadTimeout(e:TimerEvent):void
		{
			dispatchEvent(new IOErrorEvent("error", false, false, "Loading SMIL file timed out!"));
		}
		
		public function load(url:String):void
		{
			if (!_busy)
			{
				_busy = true;
				_timeoutTimer.reset();
				_timeoutTimer.start();
				
				var xmlLoader:URLLoader = new URLLoader();
				xmlLoader.addEventListener(Event.COMPLETE, onXMLLoaded);
				xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
				xmlLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
				xmlLoader.load(new URLRequest(url));
			}
			else
			{
				dispatchEvent(new Event("busy"));
			}
		}
		
		public function get dynamicStreamingResource():DynamicStreamingResource
		{
			return _dynamicStreamingResource;
		}
		
		private function onXMLLoaded(e:Event):void
		{
			_timeoutTimer.stop();
			_rawData = e.currentTarget.data.toString();
			
			try
			{
				_xml = new XML(_rawData);
				parseXML();
			}
			catch(e:Error)
			{
				_busy = false;
				throw(e);
			}
		}
		
		private function onSecurityError(e:SecurityErrorEvent):void
		{
			_timeoutTimer.stop();
			_busy = false;
			dispatchEvent(e.clone());
		}

		private function onIOError(e:IOErrorEvent):void
		{
			_timeoutTimer.stop();
			_busy = false;
			dispatchEvent(e.clone());
		}
		
		private function parseXML():void
		{
			_busy = false;
			
			if (!verifySMIL())
			{
				dispatchEvent(new IOErrorEvent("error", false, false, "SMIL file is malformed!"));
				return;
			}
			
			var ns:Namespace = _xml.namespace();
			var hostURL:String = _xml.ns::head.ns::meta.@base;
			
			_dynamicStreamingResource = new DynamicStreamingResource(new FMSURL(hostURL));
			parseItems();
			dispatchEvent(new Event("parsed"));
		}
		
		private function verifySMIL():Boolean
		{
			var ns:Namespace = _xml.namespace();
			var ok:Boolean = false;
			
			if (_xml.ns::body.ns::["switch"] != undefined)
			{
				ok = !(_xml.ns::head.ns::meta.@base == undefined || _xml.ns::body.ns::["switch"].ns::video.length() < 1);
			}
			
			return ok;
		}
		
		private function parseItems():void
		{
			var ns:Namespace = _xml.namespace();
			
			for (var i:int = 0; i < _xml.ns::body.ns::["switch"].ns::video.length(); i++)
			{
				var streamName:String = _xml.ns::body.ns::["switch"].ns::video[i].@src;
				var bitrate:Number = Number(_xml.ns::body.ns::["switch"].ns::video[i].@["system-bitrate"])/1000;
				
				_dynamicStreamingResource.addItem(new DynamicStreamingItem(streamName, bitrate));
			}
		}
		
		private var _xml:XML;
		private var _busy:Boolean;
		private var _timeoutTimer:Timer;
		private var _rawData:String;
		private var _dynamicStreamingResource:DynamicStreamingResource;
		
		private const LOAD_TIMEOUT:uint = 15000;
		
		public static const ERROR:String = "error";
		public static const PARSED:String = "parsed";
		public static const BUSY:String = "busy";
	}
}
