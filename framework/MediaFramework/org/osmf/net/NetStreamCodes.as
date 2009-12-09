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
	/**
	 * The NetStreamCodes class provides static constants for event types
	 * that a NetStream dispatches as NetStatusEvents.
	 * <p>A NetClient uses some of these codes to register handlers for 		
	 * callbacks.</p>
	 * @see flash.events.NetStatusEvent
	 * @see flash.net.NetStream   
	 */ 
	public class NetStreamCodes
	{
		/**	
		 * "status"	
		 * Data is not being received quickly enough to fill the buffer. 
		 * Data flow will be interrupted until the buffer refills,
		 * at which time a NetStream.Buffer.Full message will be sent and the stream will begin playing again. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_BUFFER_EMPTY:String	  		= "NetStream.Buffer.Empty";
		
		/**	
		 * "status"	
		 * The buffer is full and the stream will begin playing. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_BUFFER_FULL:String 			= "NetStream.Buffer.Full";
		
		/** 
		 * "status"	
		 * Data has finished streaming, and the remaining buffer will be emptied. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_BUFFER_FLUSH:String 			= "NetStream.Buffer.Flush";
		
		/**
		 * This code is sent by the netstream when the DRM subsystem needs to be
		 * updated.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_DRM_UPDATE:String 			= "DRM.UpdateNeeded";
		
		/** 
		 * "error"	
		 * Flash Media Server only. An error has occurred for a reason other
		 *  than those listed in other event codes. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_FAILED:String 				= "NetStream.Failed"; 
		
		/** 
		 * "status"
		 * 	Publish was successful. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PUBLISH_START:String			= "NetStream.Publish.Start"; 
		
		/** 
		 * "error"
		 * 	Attempt to publish a stream which is already being published by someone else.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PUBLISH_BADNAME:String		= "NetStream.Publish.BadName";
		
		/** 
		 * "status"
		 * 	The publisher of the stream is idle and not transmitting data. */
		public static const NETSTREAM_PUBLISH_IDLE:String 			= "NetStream.Publish.Idle";
		
		/**
		 * "status"	
		 * The unpublish operation was successful. */
		public static const NETSTREAM_UNPUBLISH_SUCCESS:String		= "NetStream.Unpublish.Success"; 
		
		/** 
		 * "status"
		 * 	Playback has started. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_START:String				= "NetStream.Play.Start";
		
		/** 
		 * "status"
		 * 	Playback has stopped.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_STOP:String				= "NetStream.Play.Stop";
		
		/** "error"	An error has occurred in playback for a reason 
		 * other than those listed elsewhere in this table, such as the subscriber not having read access. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_FAILED:String			= "NetStream.Play.Failed";
		
		/** 
		 * "error"	
		 * The FLV passed to the play() method can't be found. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_STREAMNOTFOUND:String	= "NetStream.Play.StreamNotFound";
		
		/** 
		 * "status"	
		 * Caused by a play list reset.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_PLAY_RESET:String				= "NetStream.Play.Reset";
		
		/** 
		 * "status"	
		 * The initial publish to a stream is sent to all subscribers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_PUBLISHNOTIFY:String		= "NetStream.Play.PublishNotify"; 
		
		/** 
		 * "status"	
		 * An unpublish from a stream is sent to all subscribers.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_UNPUBLISHNOTIFY:String	= "NetStream.Play.UnpublishNotify";
		
		/** 
		 * "warning"	
		 * Flash Media Server only. The client does not have sufficient bandwidth to play the data at normal speed. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_INSUFFICIENTBW:String	= "NetStream.Play.InsufficientBW";
		
		/** "error"	
		 * The application detects an invalid file structure and will not try to play this type of file.
		 *  For AIR and for Flash Player 9.0.115.0 and later. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_FILESTRUCTUREINVALID:String= "NetStream.Play.FileStructureInvalid"; 
		
		 /** "error"	
		 * The application does not detect any supported tracks (video, audio or data) and 
		 * will not try to play the file. For AIR and for Flash Player 9.0.115.0 and later. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_NOSUPPORTEDTRACKFOUND:String= "NetStream.Play.NoSupportedTrackFound";		
		
		/**
		 * "status"	
		 * Flash Media Server 3.5 and later only. The server received the command to transition to another stream 
		 * as a result of bitrate stream switching. This code indicates a success status event for the NETSTREAM_play2()
		 * call to initiate a stream switch. If the switch does not succeed, the server sends a NETSTREAM_PLAY.Failed event instead.
		 * When the stream switch occurs, an onPlayStatus event with a code of "NetStream.Play.TransitionComplete" is dispatched. 
		 * For Flash Player 10 and later.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PLAY_TRANSITION:String		= "NetStream.Play.Transition"; 
		
		/** 
		 * "status"	
		 * The stream is paused.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_PAUSE_NOTIFY:String			= "NetStream.Pause.Notify"; 
		
		/** 
		 * "status"	
		 * The stream is resumed. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_UNPAUSE_NOTIFY:String			= "NetStream.Unpause.Notify";
		
		 /** 
		 * "status"	
		 * Recording has started. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_RECORD_START:String			= "NetStream.Record.Start";
		
		/**
		 * "error"	
		 * Attempt to record a stream that is still playing or the client has no access right. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_RECORD_NOACCESS:String		= "NetStream.Record.NoAccess";
		
		/** 
		 * "status"	
		 * Recording stopped. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_RECORD_STOP:String			= "NetStream.Record.Stop";
		
		/** 
		 * "error"
		 * 	An attempt to record a stream failed. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_RECORD_FAILED:String			= "NetStream.Record.Failed";
		
		/** 
		 * "error"	
		 * The seek fails, which happens if the stream is not seekable. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_SEEK_FAILED:String			= "NetStream.Seek.Failed";
		
		/** 
		 * "error"	
		 * For video downloaded with progressive download, 
		 * the user has tried to seek or play past the end of the video data that has downloaded thus far,
		 *  or past the end of the video once the entire file has downloaded. 
		 * The message.details property contains a time code that indicates the last valid position to which the user can seek. 
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const NETSTREAM_SEEK_INVALIDTIME:String		= "NetStream.Seek.InvalidTime";
		
		/** 
		 * "status"	
		 * The seek operation is complete.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_SEEK_NOTIFY:String			= "NetStream.Seek.Notify"; 
		
		//onPlayStatus
		
		/** 
		 * "status"	
		 * Playback has completed. Fires only for streaming connections.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_PLAY_COMPLETE:String			= "NetStream.Play.Complete"; 
		
		/** 
		 * "status"	
		 * The subscriber is switching to a new stream as a result of stream bit-rate switching. Fires only for streaming connections.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_PLAY_TRANSITION_COMPLETE:String = "NetStream.Play.TransitionComplete"; 
		
		/** 
		 * "status"	
		 * 	The subscriber is switching from one stream to another in a playlist.. Fires only for streaming connections.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const NETSTREAM_PLAY_SWITCH:String			= "NetStream.Play.Switch"; 
				
		//NetStream events
		
		/**
		 * Dispatched when the application receives descriptive information embedded in the video being played. 
		 * For information about video file formats supported by Flash Media Server, see the Flash Media Server documentation. 		
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ON_META_DATA:String						= "onMetaData";
		
		/**
		 * 	Establishes a listener to respond when an embedded cue point is reached while playing a video file.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const ON_CUE_POINT:String						= "onCuePoint";
		
		/**
		 * Establishes a listener to respond when Flash Player receives image data 
		 * as a byte array embedded in a media file that is playing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const ON_IMAGE_DATA:String					= "onImageData";
		
		/**		
		 *  * Establishes a listener to respond when a NetStream object has completely played a stream.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ON_PLAY_STATUS:String					= "onPlayStatus";
	
		/**
		 * Establishes a listener to respond when Flash Player receives text data embedded in a media file that is playing.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const ON_TEXT_DATA:String						= "onTextData";
		
		/**
		 * 	Establishes a listener to respond when Flash Player receives information specific to
		 *  Adobe Extensible Metadata Platform (XMP) embedded in the video being played.
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ON_XMP_DATA:String						= "onXMPData";	
		
		/**
		 * The ID3 information contained within a sound file
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */
		public static const ON_ID3:String							= "onID3Data"; 
		
		/**
		 * Called when the DRMContent data is encountered in a DRM encypyted file
		 *  
		 *  @langversion 3.0
		 *  @playerversion Flash 10
		 *  @playerversion AIR 1.0
		 *  @productversion OSMF 1.0
		 */ 
		public static const ON_DRM_CONTENT_DATA:String				= "onDRMContentData";
				
		

	}
}