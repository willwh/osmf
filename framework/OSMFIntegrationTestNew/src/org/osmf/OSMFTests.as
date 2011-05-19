package org.osmf
{
	import flexunit.framework.Test;
	
	import org.osmf.media.TestMediaPlayerWithAlternateAudioHDSSBR;
	import org.osmf.media.TestMediaPlayerWithAlternateAudioHDSSBR_InitialIndex;
	import org.osmf.media.TestMediaPlayerWithLegacyHDSSBR;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class OSMFTests
	{
		public var testLegacyHDS:TestMediaPlayerWithLegacyHDSSBR;
		public var testAlternateAudioHDS:TestMediaPlayerWithAlternateAudioHDSSBR;
		public var testAlternateAudioHDS_InitialIndex:TestMediaPlayerWithAlternateAudioHDSSBR_InitialIndex;
	}
	
	
}