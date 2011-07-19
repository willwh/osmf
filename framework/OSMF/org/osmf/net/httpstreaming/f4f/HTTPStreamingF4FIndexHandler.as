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
	
	import flash.events.TimerEvent;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import org.osmf.elements.f4mClasses.BootstrapInfo;
	import org.osmf.events.DVRStreamInfoEvent;
	import org.osmf.events.HTTPStreamingEvent;
	import org.osmf.events.HTTPStreamingFileHandlerEvent;
	import org.osmf.events.HTTPStreamingIndexHandlerEvent;
	import org.osmf.net.dvr.DVRUtils;
	import org.osmf.net.httpstreaming.HTTPStreamRequest;
	import org.osmf.net.httpstreaming.HTTPStreamingFileHandlerBase;
	import org.osmf.net.httpstreaming.HTTPStreamingIndexHandlerBase;
	import org.osmf.net.httpstreaming.HTTPStreamingUtils;
	import org.osmf.net.httpstreaming.flv.FLVTagScriptDataMode;
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
		public function HTTPStreamingF4FIndexHandler(fileHandler:HTTPStreamingFileHandlerBase, fragmentsThreshold:uint = DEFAULT_FRAGMENTS_THRESHOLD)
		{
			super();
			
			currentQuality = -1;
			currentFAI = null;
			fragmentRunTablesUpdating = false;		
			this.fileHandler = fileHandler;	
			this.fragmentsThreshold = fragmentsThreshold;
			dvrGetStreamInfoCall = false;
			
			fileHandler.addEventListener(HTTPStreamingFileHandlerEvent.NOTIFY_BOOTSTRAP_BOX, onNewBootstrapBox);
		}
		
		/**
		 * @private
		 */
		public function get bootstrapInfo():AdobeBootstrapBox
		{
			return currentQuality < 0? null : bootstrapBoxes[currentQuality];
		}
		
		/**
		 * @private
		 */
		override public function dvrGetStreamInfo(indexInfo:Object):void
		{
			dvrGetStreamInfoCall = true;
			playInProgress = false;
			initialize(indexInfo);
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
				CONFIG::LOGGING
				{			
					logger.error("f4fIndexInfo: " + f4fIndexInfo );
					logger.error( "******* F4M wrong or contains insufficient information!" );
				}
				
				dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.INDEX_ERROR));
				return;					
			}
			
			bootstrapBoxes = new Vector.<AdobeBootstrapBox>(f4fIndexInfo.streamInfos.length);
			fragmentRunTablesUpdating= false;
			playInProgress = false;
			pendingIndexLoads = 0;
			pureLiveOffset = NaN;
			
			serverBaseURL = f4fIndexInfo.serverBaseURL;			
			streamInfos = f4fIndexInfo.streamInfos;
			
			var bootstrapBox:AdobeBootstrapBox;
			for (var i:int = 0; i < streamInfos.length; i++)
			{
				var bootstrap:BootstrapInfo = streamInfos[i].bootstrapInfo;
				if (bootstrap == null || (bootstrap.url == null && bootstrap.data == null))
				{
					CONFIG::LOGGING
					{			
						logger.error("bootstrap: " + bootstrap );
						logger.error( "******* bootstrap null or contains inadequate information!" );
					}
					
					dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.INDEX_ERROR));
					return;					
				}
				if (bootstrap.data != null)
				{
					bootstrapBox = processBootstrapData(bootstrap.data, null);
					if (bootstrapBox == null)
					{
						CONFIG::LOGGING
						{			
							logger.error("bootstrap.data: " + bootstrap.data );
							logger.error( "******* bootstrapBox is null, potentially from bad bootstrap data!" );
						}
						
						dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.INDEX_ERROR));
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
								, new URLRequest(HTTPStreamingUtils.normalizeURL(bootstrap.url))
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
						( HTTPStreamingIndexHandlerEvent.RATES_READY
						, false
						, false
						, false
						, NaN
						, getStreamNames(streamInfos)
						, getQualityRates(streamInfos)
						)
					);

				notifyIndexReady(0);
			}
		}
		
		/**
		 * @private
		 */
		override public function dispose():void
		{
			//close the bootstrap update timer
			destroyBootstrapUpdateTimer();
		}
		
		/**
		 * @private
		 */
		override public function processIndexData(data:*, indexContext:Object):void
		{
			var index:int = indexContext as int;
			var bootstrapBox:AdobeBootstrapBox = processBootstrapData(data, index);

			if (bootstrapBox == null)
			{
				CONFIG::LOGGING
				{			
					logger.error( "******* bootstrapBox is null when attempting to process index data during a bootstrap update for" +
						"live or live+dvr stream!" );
				}
				
				dispatchEvent(new HTTPStreamingEvent(HTTPStreamingEvent.INDEX_ERROR));
				return;					
			}
			
			CONFIG::LOGGING
			{			
				logger.debug("processIndexData: " + index + " pendingIndexUpdates: " + pendingIndexUpdates);
				logger.debug("abst version: " + bootstrapBox.bootstrapVersion + 
					" fragments calculated: " + bootstrapBox.totalFragments +
					" fragments from segment run table: " + bootstrapBox.segmentRunTables[0].totalFragments);
			}
			
			if (!fragmentRunTablesUpdating) 
			{
				pendingIndexLoads--;
			}
			else
			{
				pendingIndexUpdates--;
				
				var streamInfo:HTTPStreamingF4FStreamInfo = streamInfos[index] as HTTPStreamingF4FStreamInfo;
				if (streamInfo != null)
				{
					var requestedUrl:String = streamInfo.bootstrapInfo.url;
					if (requestedUrl != null && pendingUrlLoads.hasOwnProperty(requestedUrl))
					{
						pendingUrlLoads[requestedUrl].active = false;
					}
				}
				
				if (pendingIndexUpdates == 0)
				{
					fragmentRunTablesUpdating = false;
// FM-924, onMetadata is called twice on http streaming live/dvr content 
// It is really unnecessary to call onMetadata multiple times. The change of
// media length is fixed for VOD, and is informed by the call dispatchDVRStreamInfo
// for DVR. For "pure live", it does not really matter. Whenever MBR switching
// happens, onMetadata will be called by invoking checkMetadata method.
// 
//					notifyTotalDuration(bootstrapBox.totalDuration / bootstrapBox.timeScale, indexContext as int);
					dispatchDVRStreamInfo(bootstrapBox);
				}
			}
			
			if (bootstrapBoxes[index] == null || 
				bootstrapBoxes[index].bootstrapVersion < bootstrapBox.bootstrapVersion ||
				bootstrapBoxes[index].currentMediaTime < bootstrapBox.currentMediaTime)
			{
				delay = 0.05; 		
				bootstrapBoxes[index] = bootstrapBox;
			}

			if (pendingIndexLoads == 0 && !fragmentRunTablesUpdating)
			{
				dispatchEvent
					( new HTTPStreamingIndexHandlerEvent
						( HTTPStreamingIndexHandlerEvent.RATES_READY
						, false
						, false
						, false
						, NaN
						, getStreamNames(streamInfos)
						, getQualityRates(streamInfos)
						)
					);

				notifyIndexReady(index);
			}
		}	
		
		override public function getFragmentDurationFromUrl(fragmentUrl:String):Number
		{
			// we assume that there is only one afrt in bootstrap
			
			var tempFragmentId:String = fragmentUrl.substr(fragmentUrl.indexOf("Frag")+4, fragmentUrl.length);
			var fragId:uint = uint(tempFragmentId);
			var abst:AdobeBootstrapBox = bootstrapBoxes[currentQuality];
			var afrt:AdobeFragmentRunTable = abst.fragmentRunTables[0];
			return afrt.getFragmentDuration(fragId);
		}

		/**
		 * @private
		 */
		override public function getFileForTime(time:Number, quality:int):HTTPStreamRequest
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[quality];
			if (abst == null)
				return null;
			
			var streamRequest:HTTPStreamRequest = null;

			if (!playInProgress && stopPlaying(abst))
			{
				destroyBootstrapUpdateTimer();
				return null;
			}
							
			checkMetadata(quality, abst);
			
			var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
			if (	time >= 0
				&& 	quality >= 0
				&&  quality < streamInfos.length
			   )
			{
				if (time * abst.timeScale <= abst.currentMediaTime)
				{
					currentFAI = frt.findFragmentIdByTime(
						time * abst.timeScale, abst.currentMediaTime, abst.contentComplete()? false : abst.live);
					if (currentFAI == null || fragmentOverflow(abst, currentFAI.fragId))
					{
						if (abst.contentComplete())
						{
							if (abst.live) // live/DVR playback stops
							{
								return new HTTPStreamRequest(null, quality, -1, -1, true);
							}
							else
							{
								return null;
							}
						}
						else
						{
							adjustDelay();
							refreshBootstrapInfo(quality);
							return new HTTPStreamRequest(null, quality, 0, delay);
						}
					}
					
					playInProgress = true;
					var fdp:FragmentDurationPair = frt.fragmentDurationPairs[0];
					var segId:uint = abst.findSegmentId(currentFAI.fragId - fdp.firstFragment + 1);
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
						logger.debug("The url for ( time=" + time +", quality=" + quality + ") = " + requestUrl);
					}
	
					streamRequest = new HTTPStreamRequest(requestUrl);
					checkQuality(quality);
					notifyFragmentDuration(currentFAI.fragDuration / abst.timeScale);
				}
				else
				{
					if (abst.live)
					{
						adjustDelay();
						refreshBootstrapInfo(quality);
						return new HTTPStreamRequest(null, quality, 0, delay);
					}
				}
			}
			
			CONFIG::LOGGING
			{
				if (streamRequest == null)
				{
					logger.debug("The url for ( time=" + time + ", quality=" + quality + ") = none");
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
/*
			if (quality != this.currentQuality)
			{
				var curAbst:AdobeBootstrapBox = bootstrapBoxes[currentQuality];
				if (currentFAI == null || (currentFAI.fragmentEndTime*abst.timeScale/curAbst.timeScale > abst.currentMediaTime))
				{
					adjustDelay();
					refreshBootstrapInfo(quality);					
					return new HTTPStreamRequest(null, quality, 0, delay);
				}

				return getFileForTime(currentFAI.fragmentEndTime / curAbst.timeScale, quality); 
			}
*/			
			if (!playInProgress && stopPlaying(abst))
			{
				destroyBootstrapUpdateTimer();
				return null;
			}

			checkMetadata(quality, abst);

			if (quality >= 0 && quality < streamInfos.length)
			{
				var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
				if (frt == null)
					return null;
				
				var oldCurrentFAI:FragmentAccessInformation = currentFAI;
				if (oldCurrentFAI == null)
				{
//					var fragId:uint = frt.fragmentDurationPairs[frt.fragmentDurationPairs.length - 1].firstFragment;
//					currentFAI = frt.validateFragment(fragId + 1, abst.currentMediaTime, abst.contentComplete()? false : abst.live);
					currentFAI = null;
				}
				else
					currentFAI = frt.validateFragment(oldCurrentFAI.fragId + 1, abst.currentMediaTime, abst.contentComplete()? false : abst.live);
				
				if (currentFAI == null || fragmentOverflow(abst, currentFAI.fragId))
				{
					if (!abst.live || abst.contentComplete())
					{
						if (abst.live) // live/DVR playback stops
						{
							return new HTTPStreamRequest(null, quality, -1, -1, true);
						}
						else
						{
							return null;
						}
					}
					else
					{
						adjustDelay();
						currentFAI = oldCurrentFAI;
						refreshBootstrapInfo(quality);
						return new HTTPStreamRequest(null, quality, 0, delay);
					}
				}

				playInProgress = true;
				var fdp:FragmentDurationPair = frt.fragmentDurationPairs[0];
				var segId:uint = abst.findSegmentId(currentFAI.fragId - fdp.firstFragment + 1);
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
						( new HTTPStreamingEvent
							( HTTPStreamingEvent.SCRIPT_DATA
							, false
							, false
							, 0
							, flvTag
							, FLVTagScriptDataMode.FIRST
							)
						);
				}
			}
		}
		
		private function checkMetadata(quality:int, abst:AdobeBootstrapBox):void
		{
			if (currentQuality != quality && abst != null)
			{
				notifyTotalDuration(abst.totalDuration / abst.timeScale, quality);
			}
		}

		private function refreshBootstrapInfo(quality:uint):void
		{
			var streamInfo:HTTPStreamingF4FStreamInfo = streamInfos[quality] as HTTPStreamingF4FStreamInfo;
			if (streamInfo == null)
				return;
			var requestedUrl:String = streamInfo.bootstrapInfo.url;
			if (requestedUrl == null)
				return;

			var pendingUrlRequest:Object = null;
			if (pendingUrlLoads.hasOwnProperty(requestedUrl))
			{
				pendingUrlRequest = pendingUrlLoads[requestedUrl];
			}
			else
			{
				pendingUrlRequest = new Object();
				pendingUrlRequest["active"] = false;
				pendingUrlRequest["date"] = null;
				pendingUrlLoads[requestedUrl] = pendingUrlRequest;
			}
			
			if (pendingUrlRequest.active)
				return;
			
			// XXX this must be extracted so that a developer can overwrite it. 
			var previousRequestDate:Date = pendingUrlRequest["date"];
			var newRequestDate:Date = new Date();
			if (BOOTSTRAP_REFRESH_INTERVAL && previousRequestDate != null && (newRequestDate.valueOf() - previousRequestDate.valueOf() < BOOTSTRAP_REFRESH_INTERVAL))
				return;
			pendingUrlLoads[requestedUrl].date = newRequestDate;
			pendingUrlLoads[requestedUrl].active = true;
			pendingIndexUpdates++;
			fragmentRunTablesUpdating = true;
			CONFIG::LOGGING
			{
				logger.debug("refresh frt: " + requestedUrl);
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
						, new URLRequest(HTTPStreamingUtils.normalizeURL(requestedUrl))
						, quality
						, true
						)
				);				
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
			if (abst == null)
				return null;
			
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
			}
			metaInfo.duration = duration;

			sdo.objects = ["onMetaData", metaInfo];
			dispatchEvent
				( new HTTPStreamingEvent
					( HTTPStreamingEvent.SCRIPT_DATA
					, false
					, false
					, 0
					, sdo
					, FLVTagScriptDataMode.IMMEDIATE
					)
				);
		}
		
		private function notifyFragmentDuration(duration:Number):void
		{
			// Update the bootstrap update interval; we set its value to the fragment duration
			bootstrapUpdateInterval = duration * 1000;
			if (bootstrapUpdateInterval < BOOTSTRAP_REFRESH_INTERVAL)
			{
				bootstrapUpdateInterval = BOOTSTRAP_REFRESH_INTERVAL;
			}
			
			dispatchEvent
				(	new HTTPStreamingEvent
						( HTTPStreamingEvent.FRAGMENT_DURATION 
						, false
						, false
						, duration
						, null
						, null
						)
				);				
		}
		
		private function notifyIndexReady(quality:int):void
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[quality];
			var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);

			dispatchDVRStreamInfo(abst);

			if (!dvrGetStreamInfoCall)
			{
				if (abst.live && f4fIndexInfo.dvrInfo == null && isNaN(pureLiveOffset))
				{
					pureLiveOffset = (abst.currentMediaTime - offsetFromCurrent * abst.timeScale) > 0? abst.currentMediaTime / abst.timeScale - offsetFromCurrent : NaN
				}
				
				// If the stream is live, initialize the bootstrap update timer
				if (abst.live)
				{
					initializeBootstrapUpdateTimer();
				}
				
				// Destroy the timer if the stream is no longer recording
				if (frt.tableComplete())
				{
					destroyBootstrapUpdateTimer();
				}
				

				dispatchEvent
					( new HTTPStreamingIndexHandlerEvent
						( HTTPStreamingIndexHandlerEvent.INDEX_READY
						, false
						, false
						, abst.live
						, pureLiveOffset 
						)
					);
			}
			dvrGetStreamInfoCall = false;
		}

		private function stopPlaying(abst:AdobeBootstrapBox):Boolean
		{
			var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
			if ((f4fIndexInfo.dvrInfo == null && abst != null && abst.live && frt != null && frt.tableComplete()) ||
				(f4fIndexInfo.dvrInfo != null && f4fIndexInfo.dvrInfo.offline))
			{
				return true;
			}
			
			return false;
		}
		
		private function onNewBootstrapBox(event:HTTPStreamingFileHandlerEvent):void
		{
			var abst:AdobeBootstrapBox = bootstrapBoxes[currentQuality];
			if (abst.bootstrapVersion < event.bootstrapBox.bootstrapVersion || 
				abst.currentMediaTime < event.bootstrapBox.currentMediaTime)
			{
				bootstrapBoxes[currentQuality] = event.bootstrapBox;
				dispatchDVRStreamInfo(event.bootstrapBox);
			}			
		}
		
		private function dispatchDVRStreamInfo(abst:AdobeBootstrapBox):void
		{
			var frt:AdobeFragmentRunTable = getFragmentRunTable(abst);
			
			if (f4fIndexInfo.dvrInfo != null)
			{
				f4fIndexInfo.dvrInfo.isRecording = !frt.tableComplete();
				if (isNaN(f4fIndexInfo.dvrInfo.startTime))
				{
					f4fIndexInfo.dvrInfo.startTime = 
						frt.tableComplete()? 0 : DVRUtils.calculateOffset(
							((f4fIndexInfo.dvrInfo.beginOffset < 0) || isNaN(f4fIndexInfo.dvrInfo.beginOffset))? 0 : f4fIndexInfo.dvrInfo.beginOffset, 
							((f4fIndexInfo.dvrInfo.endOffset < 0) || isNaN(f4fIndexInfo.dvrInfo.endOffset))? 0 : f4fIndexInfo.dvrInfo.endOffset, 
							abst.totalDuration/abst.timeScale);
					f4fIndexInfo.dvrInfo.startTime += (frt.fragmentDurationPairs)[0].durationAccrued/abst.timeScale;
							
					if (f4fIndexInfo.dvrInfo.startTime > abst.currentMediaTime / abst.timeScale)
					{
						f4fIndexInfo.dvrInfo.startTime = abst.currentMediaTime / abst.timeScale;
					}
				}
				
				f4fIndexInfo.dvrInfo.curLength = abst.currentMediaTime/abst.timeScale - f4fIndexInfo.dvrInfo.startTime;
				
				if 
					(
						(f4fIndexInfo.dvrInfo.windowDuration != -1) && 
						(f4fIndexInfo.dvrInfo.curLength > f4fIndexInfo.dvrInfo.windowDuration)
					)
				{
					f4fIndexInfo.dvrInfo.startTime += f4fIndexInfo.dvrInfo.curLength - f4fIndexInfo.dvrInfo.windowDuration;
					f4fIndexInfo.dvrInfo.curLength = f4fIndexInfo.dvrInfo.windowDuration;
				}
				
				dispatchEvent(new DVRStreamInfoEvent(DVRStreamInfoEvent.DVRSTREAMINFO, false, false, f4fIndexInfo.dvrInfo)); 								
			}	
		}
		
		private function fragmentOverflow(abst:AdobeBootstrapBox, fragId:uint):Boolean
		{
			var fragmentRunTable:AdobeFragmentRunTable = abst.fragmentRunTables[0];
			var fdp:FragmentDurationPair = fragmentRunTable.fragmentDurationPairs[0];
			var segmentRunTable:AdobeSegmentRunTable = abst.segmentRunTables[0];
			return ((segmentRunTable == null) || ((segmentRunTable.totalFragments + fdp.firstFragment - 1) < fragId));
		}
		
		private function adjustDelay():void
		{
			if (delay < 1.0)
			{
				delay = delay * 2.0;
				if (delay > 1.0)
				{
					delay = 1.0;
				} 
			}
		}
		
		
		private function initializeBootstrapUpdateTimer():void
		{
			if (bootstrapUpdateTimer == null)
			{
				// This will regularly update the bootstrap information;
				// We just initialize the timer here; we'll start it in the first call of the getFileForTime method
				// or in the first call of getNextFile
				// The initial delay is 4000 (recommended fragment duration)
				bootstrapUpdateTimer = new Timer(bootstrapUpdateInterval);
				bootstrapUpdateTimer.addEventListener(TimerEvent.TIMER, onBootstrapUpdateTimer);
				bootstrapUpdateTimer.start();
			}
		}
		
		private function destroyBootstrapUpdateTimer():void
		{
			if (bootstrapUpdateTimer != null)
			{
				bootstrapUpdateTimer.removeEventListener(TimerEvent.TIMER, onBootstrapUpdateTimer);
				bootstrapUpdateTimer = null;
			}
		}
		
		private function onBootstrapUpdateTimer(event:TimerEvent):void
		{ 
			if (currentQuality != -1)
			{
				refreshBootstrapInfo(currentQuality);
				bootstrapUpdateTimer.delay = bootstrapUpdateInterval;
			}
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
		private var fileHandler:HTTPStreamingFileHandlerBase;
		private var dvrGetStreamInfoCall:Boolean;
		private var playInProgress:Boolean;
		
		private var offsetFromCurrent:Number = 5;
		private var delay:Number = 0.05;
		private var pureLiveOffset:Number = NaN;
		
		private var bootstrapUpdateTimer:Timer;
		private var bootstrapUpdateInterval:Number = 4000;
		
		public static const DEFAULT_FRAGMENTS_THRESHOLD:uint = 5;
		
		public static const BOOTSTRAP_REFRESH_INTERVAL:uint = 2000;
		
		private var pendingUrlLoads:Object = new Object();

		CONFIG::LOGGING
		{
			private static const logger:org.osmf.logging.Logger = org.osmf.logging.Log.getLogger("org.osmf.net.httpstreaming.f4f.HTTPStreamF4FIndexHandler");
		}
	}
}