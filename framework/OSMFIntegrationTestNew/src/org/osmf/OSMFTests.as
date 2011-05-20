package org.osmf
{
	import flexunit.framework.Test;
	
	import org.osmf.media.TestMediaPlayerWithAlternateAudio_HDS_SBR;
	import org.osmf.media.TestMediaPlayerWithAlternateAudio_HDS_SBR_MultipleSwitches;
	import org.osmf.media.TestMediaPlayerWithLegacy_HDS_SBR;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class OSMFTests
	{
		public var testLegacy_HDS_SBR:TestMediaPlayerWithLegacy_HDS_SBR;
		public var testAlternateAudio_HDS_SBR:TestMediaPlayerWithAlternateAudio_HDS_SBR;
		public var testAlternateAudio_HDS_SBR_MultipleSwitches:TestMediaPlayerWithAlternateAudio_HDS_SBR_MultipleSwitches;
	}
	
	
}