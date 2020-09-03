package
{
	import flash.display.MovieClip;
	
	public class ItemBall extends MovieClip
	{
		public var types:String = "Ball";
		public var xv:Number = 0;
		public var yv:Number = 0;
		
		public function ItemBall(xvv:Number = 0,yvv:Number = 0):void
		{
			xv = xvv;
			yv = yvv;
		}
	}
}