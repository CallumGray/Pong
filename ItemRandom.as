package
{
	import flash.display.MovieClip;
	
	public class ItemRandom extends MovieClip
	{
		public var types:String = "Random";
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function ItemRandom(xvv:Number = 0,yvv:Number = 0):void
		{
			xv = xvv;
			yv = yvv;
		}
	}
}