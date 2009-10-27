package org.osmf.traits
{
	public class TestContentProtectable extends TestIContentProtectable
	{
		public function TestContentProtectable()
		{
			super();
		}
		
		override protected function createInterfaceObject(... args):Object
		{			
			return new ContentProtectableTrait();
		}
		
		
	}
}