package com.adobe.videoperformance.model
{
	public class PerformancePoll
	{
		public function PerformancePoll(time:Number,currFPS:Number,videoID:int,bufferLength:Number,downloaded:Boolean)
		{
			this.time = time;
			this.currFPS = currFPS;
			this.videoID = videoID;
			this.bufferLength = bufferLength;
			this.downloaded = downloaded ? 1 : 0;
		}

		public var time:Number;
		public var currFPS:Number;
		public var videoID:int;
		public var bufferLength:Number;
		public var downloaded:int;
	}
}