package org.osmf
{
	import flexunit.framework.Test;
	
	import org.osmf.elements.f4mClasses.TestManifestParser;
	import org.osmf.elements.f4mClasses.TestMultiLevelManifestParser;
	import org.osmf.media.TestMediaPlayerHelper;
	import org.osmf.media.TestMediaPlayerWithAlternateAudio_HDS_SBR;
	import org.osmf.media.TestMediaPlayerWithAlternateAudio_HDS_SBR_MultipleSwitches;
	import org.osmf.media.TestMediaPlayerWithAlternateAudio_HDS_SBR_Operations;
	import org.osmf.media.TestMediaPlayerWithLegacy_HDS_SBR;
	
	[Suite]
	[RunWith("org.flexunit.runners.Suite")]
	public class OSMFTests
	{
		public var testManifestParser:TestManifestParser;
		public var testMultilevelManifestParser:TestMultiLevelManifestParser;

		public var testLegacy_HDS_SBR:TestMediaPlayerWithLegacy_HDS_SBR;
		public var testAlternateAudio_HDS_SBR:TestMediaPlayerWithAlternateAudio_HDS_SBR;
		public var testAlternateAudio_HDS_SBR_MultipleSwitches:TestMediaPlayerWithAlternateAudio_HDS_SBR_MultipleSwitches;
		public var testAlternateAudio_HDS_SBR_Operations:TestMediaPlayerWithAlternateAudio_HDS_SBR_Operations;
	}
}