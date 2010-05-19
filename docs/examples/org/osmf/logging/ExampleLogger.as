package
{
	import org.osmf.logging.Logger;

	/*
	 * This is an extremely simple logger. It only overrides the debug method.
	 */
	public class ExampleLogger extends Logger
	{
		public function ExampleLogger(category:String)
		{
			super(category);
		}
		
		override public function debug(message:String, ... rest):void
		{
			trace(message);
		}
	}
}