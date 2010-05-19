package
{
	import org.osmf.logging.Logger;
	import org.osmf.logging.LoggerFactory;

	/*
	 * This is an extremely simple logger factory. It only overrides the getLogger method.
	 */
	public class ExampleLoggerFactory extends LoggerFactory
	{
		public function ExampleLoggerFactory()
		{
			super();
		}
		
		override public function getLogger(category:String):Logger
		{
			return new ExampleLogger(category);
		}
	}
}