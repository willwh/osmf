package org.osmf.net.httpstreaming
{
	import org.osmf.media.MediaResourceBase;
	
	[ExcludeClass]
	
	/**
	 * @private
	 */
	public class MockHTTPStreamingFactory extends HTTPStreamingFactory
	{
		override public function createFileHandler(resource:MediaResourceBase):HTTPStreamingFileHandlerBase
		{
			return new HTTPStreamingFileHandlerBase();
		}
		
		/**
		 * Creates a HTTPStreamingIndexHandlerBase instance. 
		 * 
		 * @see org.osmf.net.httpstreaming.HTTPStreamingIndexHandlerBase
		 */
		override public function createIndexHandler(resource:MediaResourceBase, fileHandler:HTTPStreamingFileHandlerBase):HTTPStreamingIndexHandlerBase
		{
			return new HTTPStreamingIndexHandlerBase();
		}
		
		/**
		 * Creates a HTTPStreamingMixerBase class. 
		 * 
		 * @see org.osmf.net.httpstreaming.HTTPStreamingMixerBase
		 */
		override public function createMixer(resource:MediaResourceBase):HTTPStreamingMixerBase
		{
			return new HTTPStreamingMixerBase();
		}
		
		/**
		 * Creates a HTTPStreamingIndexInfoBase instance.
		 * 
		 * @see org.osmf.net.httpstreaming.HTTPStreamingIndexInfoBase
		 */
		override public function createIndexInfo(resource:MediaResourceBase):HTTPStreamingIndexInfoBase
		{
			return new HTTPStreamingIndexInfoBase();
		}
	}
}