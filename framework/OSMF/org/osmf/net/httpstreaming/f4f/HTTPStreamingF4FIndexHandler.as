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
package org.osmf.net.httpstreaming.f4f
{
	import __AS3__.vec.Vector;
	
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.osmf.elements.f4mClasses.BootstrapInfo;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.net.httpstreaming.HTTPStreamRequest;
	import org.osmf.net.httpstreaming.HTTPStreamingIndexHandlerBase;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataObject;

	CONFIG::LOGGING 
	{	
		import org.osmf.logging.Logger;
	}

	[ExcludeClass]
	
	/**
	 * @private
	 * 
	 * The actual implementation of HTTPStreamingFileIndexHandlerBase.  It
	 * handles the indexing scheme of an F4V file.
	 */	
	public class HTTPStreamingF4FIndexHandler extends HTTPStreamingIndexHandlerBase
	{
		/**
		 * Constructor.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		public function HTTPStreamingF4FIndexHandler(fragmentsThreshold:uint = DEFAULT_FRAGMENTS_THRESHOLD)
		{
			super();
			
			currentQuality = -1;
			currentFAI = null;
			fragmentRunTablesUpdating = false;			
			this.fragmentsThreshold = fragmentsThreshold;
		}
		
		/**
		 * @private
		 */
		override public function initialize(indexInfo:Object):void
		{
			// Make sure we have an info object of the expected type.
			f4fIndexInfo = indexInfo as HTTPStreamingF4FIndexInfo;
			if (f4fIndexInfo == null || f4fIndexInfo.streamInfos == null || f4fIndexInfo.streamInfos.length <= 0)
			{
				dispatchEvent(new HTTPStreamingIndexHandlerEvent(HTTPStreamingIndexHandlerEvent.NOTIFY_ERROR));
				return;					
			}
			bootstrapBoxes = new Vector.<AdobeBootstrapBox>(f4fIndexInfo.streamInfos.length);
			fragmentRunTablesUpdating= false;
			pendingIndexLoads = 0;
			
			serverBaseURL = f4fIndexInfo.serverBaseURL;			
			streamInfos = f4fIndexInfo.streamInfos;
			
			var bootstrapBox:AdobeBootstrapBox;
			for (var i:int = 0; i < streamInfos.length; i++)
			{
				var bootstrap:BootstrapInfo = streamInfos[i].bootstrapInfo;
				if (bootstrap == null || (bootstrap.url == null && bootstrap.data == null))
				{
					dispatchEvent(new HTTPStreamingIndexHandlerEvent(HTTPStreamingIndexHandlerEvent.NOTIFY_ERROR));
					return;					
				}
				if (bootstrap.data != null)
				{
					bootstrapBox = processBootstrapData(bootstrap.data, null);
					if (bootstrapBox == null)
					{
						dispatchEvent(new HTTPStreamingIndexHandlerEvent(HTTPStreamingIndexHandlerEvent.NOTIFY_ERROR));
						return;					
					}
					bootstrapBoxes[i] = bootstrapBox;
				}
				else
				{
					pendingIndexLoads++;
					dispatchEvent
						(	new HTTPStreamingIndexHandlerEvent
								( HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX 
								, false
								, false
								, false
								, NaN
								, null
								, null
								, new URLRequest(bootstrap.url + "?rand=" + new Date().getTime())
								, i
								, true
								)
						);
				}
			}
			
			if (pendingIndexLoads == 0)
			{
				dispatchEvent
					( new HTTPStreamingIndexHandlerEvent
						( HTTPStreamingIndexHandlerEvent.NOTIFY_RATES
						, false
						, false
						, false
						, NaN
						, getStreamNames(streamInfos)
						, getQualityRates(streamInfos)
						)
					);

				notifyIndexReady();
			}
		}
		
		/**
		 * @private
		 */
		override public function processIndexData(data:*, indexContext:Object):void
		{
			var index:int = indexContext as int;
			var bootstrapBox:AdobeBootstrapBox = processBootstrapData(data, index);
			
			delay = 0.05; 
			
			CONFIG::LOGGING
			{			
				logger.debug("processIndexData: " + index + " pendingIndexUpdates: " + pendingIndexUpdates);
				logger.debug("abst version: " + bootstrapBox.bootstrapVersion + 
					" fragments calculated: " + bootstrapBox.totalFragments +
					" fragments from segment run table: " + bootstrapBox.segmentRunTables[0].totalFragments);
			}
			
			if (bootstrapBox == null)
			{
				dispatchEvent(new HTTPStreamingIndexHandlerEvent(HTTPStreamingIndexHandlerEvent.NOTIFY_ERROR));
				return;					
			}

			if (!fragmentRunTablesUpdating) 
			{
				pendingIndexLoads--;
			}
			else
			{
				pendingIndexUpdates--;
				if (pendingIndexUpdates == 0)
				{
					fragmentRunTablesUpdating = false;
					notifyTotalDuration(bootstrapBox.totalDuration / bootstrapBox.timeScale, indexContext as int);
				}
			}
			
			bootstrapBoxes[index] = bootstrapBox;

			if (pendingIndexLoads == 0 && !fragmentRunTablesUpdating)
			{
				dispatchEvent
					( new HTTPStreamingIndexHandlerEvent
						( HTTPStreamingIndexHandlerEvent.NOTIFY_RATES
						, false
						, false
						, false
						, NaN
						, getStreamNames(streamInfos)
						, getQualityRates(streamInfos)
						)
					);

				notifyIndexReady();
			}
		}	
		
		/**
		 * @private
		 */
		override public function getFileForTime(time:Number, quality:int):HTTPStreamRequest
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[quality];
			var streamRequest:HTTPStreamRequest = null;
			
			checkMetadata(quality, abst);
			
			var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
			if (	time >= 0
				&&	time * abst.timeScale <= abst.totalDuration
				&& 	quality >= 0
				&&  quality < streamInfos.length
			   )
			{
				currentFAI = frt.findFragmentIdByTime(
					(time + (frt.fragmentDurationPairs)[0].durationAccrued / abst.timeScale) * abst.timeScale, abst.currentMediaTime);
				if (currentFAI == null)
				{
					if (abst.contentComplete())
					{
						return null;
					}
					else
					{
						if (delay < 1.0)
						{
							delay = delay * 2.0;
							if (delay > 1.0)
							{
								delay = 1.0;
							} 
						}
						
						refreshBootstrapInfo();
						return new HTTPStreamRequest(null, quality, 0, delay);
					}
				}
				
				var segId:uint = abst.findSegmentId(currentFAI.fragId);
				
				var requestUrl:String = "";
				if ((streamInfos[quality].streamName as String).indexOf("http") != 0)
				{
					requestUrl = serverBaseURL + "/" + streamInfos[quality].streamName + "Seg" + segId + "-Frag" + currentFAI.fragId;
				}
				else
				{
					requestUrl = streamInfos[quality].streamName + "Seg" + segId + "-Frag" + currentFAI.fragId;
				}
				
				CONFIG::LOGGING
				{
					logger.debug("getFileForTime URL = " + requestUrl);
				}

				streamRequest = new HTTPStreamRequest(requestUrl);
				checkQuality(quality);
				checkFragmentInventory(currentFAI.fragId, abst, frt);
				notifyFragmentDuration(currentFAI.fragDuration / abst.timeScale);
			}
			
			CONFIG::LOGGING
			{
				if (streamRequest == null)
				{
					logger.debug("getFileForTime No URL for time=" + time + " and quality=" + quality);
				}
			}
			
			return streamRequest;
		}
		
		/**
		 * @private
		 */
		override public function getNextFile(quality:int):HTTPStreamRequest
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[quality];
			var streamRequest:HTTPStreamRequest = null;
			
			checkMetadata(quality, abst);

			if (quality >= 0 && quality < streamInfos.length)
			{
				var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
				var oldCurrentFAI:FragmentAccessInformation = currentFAI;
				currentFAI = frt.validateFragment(currentFAI.fragId + 1, abst.currentMediaTime);
				if (currentFAI == null)
				{
					if (!abst.live || abst.contentComplete())
					{
						return null;
					}
					else
					{
						if (delay < 1.0)
						{
							delay = delay * 2.0;
							if (delay > 1.0)
							{
								delay = 1.0;
							} 
						}

						currentFAI = oldCurrentFAI;
						refreshBootstrapInfo();
						return new HTTPStreamRequest(null, quality, 0, delay);
					}
				}

				var segId:uint = abst.findSegmentId(currentFAI.fragId);
				var requestUrl:String = "";
				if ((streamInfos[quality].streamName as String).indexOf("http") != 0)
				{
					requestUrl = serverBaseURL + "/" + streamInfos[quality].streamName + "Seg" + segId + "-Frag" + currentFAI.fragId;
				}
				else
				{
					requestUrl = streamInfos[quality].streamName + "Seg" + segId + "-Frag" + currentFAI.fragId;
				}
			
				streamRequest = new HTTPStreamRequest(requestUrl);
				checkQuality(quality);
				checkFragmentInventory(currentFAI.fragId, abst, frt);
				notifyFragmentDuration(currentFAI.fragDuration / abst.timeScale);
					
				CONFIG::LOGGING
				{
					logger.debug("getNextFile URL = " + requestUrl);
				}
			}
			
			CONFIG::LOGGING
			{
				if (streamRequest == null)
				{
					logger.debug("getNextFile No URL for quality=" + quality);
				}
			}
			
			return streamRequest;
		}
		
		/**
		 * @private
		 * 
		 * Given timeBias, calculates the corresponding segment duration.
		 */
		internal function calculateSegmentDuration(abst:AdobeBootstrapBox, timeBias:Number):Number
		{
			var fragmentDurationPairs:Vector.<FragmentDurationPair> = (abst.fragmentRunTables)[0].fragmentDurationPairs;
			var fragmentId:uint = currentFAI.fragId;
			
			var index:int =  fragmentDurationPairs.length - 1;
			while (index >= 0)
			{
				var fragmentDurationPair:FragmentDurationPair = fragmentDurationPairs[index];
				if (fragmentDurationPair.firstFragment <= fragmentId)
				{
					var duration:Number = fragmentDurationPair.duration;
					var durationAccrued:Number = fragmentDurationPair.durationAccrued;
					durationAccrued += (fragmentId - fragmentDurationPair.firstFragment) * fragmentDurationPair.duration;
					if (timeBias > 0)
					{
						duration -= (timeBias - durationAccrued);
					}
					
					return duration;
				}
				else
				{
					index--;
				}
			}
			
			return 0;
		}

		// Internal
		//
		
		/**
		 * When there is an MBR switching and the switched-to fragment is DRM protected,
		 * we need to append the additionalHeader that contains the DRM metadata to the Flash Player
		 * for that fragment before any additional TCMessage can be appended to FP.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.5
		 *  @productversion OSMF 1.0
		 */
		private function checkQuality(quality:int):void
		{
			if (currentQuality != quality)
			{
				var prevAdditionalHeader:ByteArray = (currentQuality < 0)? null : streamInfos[currentQuality].additionalHeader;
				currentQuality = quality;
				var newAdditionalHeader:ByteArray = streamInfos[currentQuality].additionalHeader;
				
				// Strictly speaking, the != comparison of additional header is not enough. 
				// Ideally, we need to do bytewise comparison, however there might be a performance
				// hit considering the size of the additional header.
				if (newAdditionalHeader != prevAdditionalHeader && newAdditionalHeader != null)
				{
					var flvTag:FLVTagScriptDataObject = new FLVTagScriptDataObject();
					flvTag.data = newAdditionalHeader;
					dispatchEvent
						( new HTTPStreamingIndexHandlerEvent
							( HTTPStreamingIndexHandlerEvent.NOTIFY_SCRIPT_DATA
							, false
							, false
							, false
							, NaN
							, null
							, null
							, null
							, null
							, true
							, 0
							, flvTag
							, true
							, false
							)
						);
				}
			}
		}
		
		private function checkMetadata(quality:int, abst:AdobeBootstrapBox):void
		{
			if (currentQuality != quality)
			{
				notifyTotalDuration(abst.totalDuration / abst.timeScale, quality);
			}
		}
		
		private function checkFragmentInventory(
			fragId:uint, abst:AdobeBootstrapBox, frt:AdobeFragmentRunTable):void
		{
			CONFIG::LOGGING
			{
				logger.debug(
					"fragmentRunTablesUpdating: " + fragmentRunTablesUpdating + 
					" live: " + abst.live +
					" frt.tableComplete(): " + frt.tableComplete() + 
					" frt.fragmentsLeft: " + frt.fragmentsLeft(fragId, abst.currentMediaTime));
			}		
			
			if (fragmentRunTablesUpdating ||
				!abst.live || 
				frt.tableComplete() || 
				(frt.fragmentsLeft(fragId, abst.currentMediaTime) > fragmentsThreshold))
			{
				return;
			}
			
			refreshBootstrapInfo();			
		}
		
		private function refreshBootstrapInfo():void
		{
			fragmentRunTablesUpdating = true;
			pendingIndexUpdates = streamInfos.length;
			for (var i:uint = 0; i < streamInfos.length; i++)
			{
				CONFIG::LOGGING
				{
					logger.debug("refresh frt: " + (streamInfos[i] as HTTPStreamingF4FStreamInfo).bootstrapInfo.url);
				}
				
				dispatchEvent
					(	new HTTPStreamingIndexHandlerEvent
							( HTTPStreamingIndexHandlerEvent.REQUEST_LOAD_INDEX 
							, false
							, false
							, false
							, NaN
							, null
							, null
							, new URLRequest((streamInfos[i] as HTTPStreamingF4FStreamInfo).bootstrapInfo.url + "?rand=" + new Date().getTime())
							, i
							, true
							)
					);				
			}
		}
		
		private function processBootstrapData(data:*, indexContext:Object):AdobeBootstrapBox
		{
			var bootstrapBox:AdobeBootstrapBox = null;
			
			var parser:BoxParser = new BoxParser();
			data.position = 0;
			parser.init(data);
			try
			{
				var boxes:Vector.<Box> = parser.getBoxes();
			}
			catch (e:Error)
			{
				boxes = null;
			}
			
			if (boxes == null || boxes.length < 1)
			{
				return null;
			}
			
			bootstrapBox = boxes[0] as AdobeBootstrapBox;
			if (bootstrapBox == null)
			{
				return null;
			}
			
			if (serverBaseURL == null || serverBaseURL.length <= 0)
			{
				if (bootstrapBox.serverBaseURLs == null || bootstrapBox.serverBaseURLs.length <= 0)
				{
					// If serverBaseURL is not set from the external, we need to pick 
					// a server base URL from the bootstrap box. For now, we just
					// pick the first one. It is an error if the server base URL is null 
					// under this circumstance.
					return null;
				}
			}
			
			return bootstrapBox;
		}	

		private function getQualityRates(streamInfos:Vector.<HTTPStreamingF4FStreamInfo>):Array
		{
			var rates:Array = [];
			
			if (streamInfos.length >= 1)
			{
				for (var i:int = 0; i < streamInfos.length; i++)
				{
					var streamInfo:HTTPStreamingF4FStreamInfo = streamInfos[i] as HTTPStreamingF4FStreamInfo;
					rates.push(streamInfo.bitrate);
				}
			}
			
			return rates;
		}
		
		private function getStreamNames(streamInfos:Vector.<HTTPStreamingF4FStreamInfo>):Array
		{
			var streamNames:Array = [];
			
			if (streamInfos.length >= 1)
			{
				for (var i:int = 0; i < streamInfos.length; i++)
				{
					var streamInfo:HTTPStreamingF4FStreamInfo = streamInfos[i] as HTTPStreamingF4FStreamInfo;
					streamNames.push(streamInfo.streamName);
				}
			}
			
			return streamNames;
		}

		private function getFragmentRunTable(abst:AdobeBootstrapBox):AdobeFragmentRunTable
		{
			// For now, we assume that there is only one fragment run table.
			return abst.fragmentRunTables[0];
		}
		
		private function notifyTotalDuration(duration:Number, quality:int):void
		{
			var sdo:FLVTagScriptDataObject = new FLVTagScriptDataObject();
			var metaInfo:Object = this.f4fIndexInfo.streamInfos[quality].streamMetadata;
			if (metaInfo == null)
			{
				metaInfo = new Object();
				metaInfo.width = 500;
				metaInfo.height = 400;
			}
			metaInfo.duration = duration;
			
			sdo.objects = ["onMetaData", metaInfo];
			dispatchEvent
				( new HTTPStreamingIndexHandlerEvent
					( HTTPStreamingIndexHandlerEvent.NOTIFY_SCRIPT_DATA
					, false
					, false
					, false
					, NaN
					, null
					, null
					, null
					, null
					, false
					, 0
					, sdo
					, false
					, true
					)
				);
		}
		
		private function notifyFragmentDuration(duration:Number):void
		{
			dispatchEvent
				(	new HTTPStreamingIndexHandlerEvent
						( HTTPStreamingIndexHandlerEvent.NOTIFY_SEGMENT_DURATION 
						, false
						, false
						, false
						, NaN
						, null
						, null
						, null
						, null
						, true
						, duration
						)
				);				
		}
		
		private function notifyIndexReady():void
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[0];
			var offset:Number = 0;
			if (abst.live)
			{
				offset = (abst.currentMediaTime - offsetFromCurrent * abst.timeScale) > 0? abst.currentMediaTime / abst.timeScale - offsetFromCurrent : NaN
			}
			
			dispatchEvent
				( new HTTPStreamingIndexHandlerEvent
					( HTTPStreamingIndexHandlerEvent.NOTIFY_INDEX_READY
					, false
					, false
					, abst.live
					, offset 
					)
				);
		}

		private var pendingIndexLoads:int;
		private var pendingIndexUpdates:int;
		private var bootstrapBoxes:Vector.<AdobeBootstrapBox>;
		private var serverBaseURL:String;
		private var streamInfos:Vector.<HTTPStreamingF4FStreamInfo>;
		private var currentQuality:int;
		private var currentFAI:FragmentAccessInformation;
		private var fragmentsThreshold:uint;
		private var fragmentRunTablesUpdating:Boolean;
		private var f4fIndexInfo:HTTPStreamingF4FIndexInfo;
		
		private var offsetFromCurrent:Number = 20;
		private var delay:Number = 0.05;
		
		public static const DEFAULT_FRAGMENTS_THRESHOLD:uint = 5;
		
		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.HTTPStreamF4FIndexHandler");
		}
	}
}