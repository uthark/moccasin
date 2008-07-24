package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Rectangle;
        
    [RemoteClass]
    public class Square extends WorldShape
    {
        [Bindable]
        public var size:Number;
 
 
        override public function get bounds():Rectangle
        {
            return new Rectangle(x, y, size, size);
        }
     }
}