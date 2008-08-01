package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Rectangle;
        
    /**
     * Value object representing a Square in the world. 
     */
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