package com.joeberkovitz.simpleworld.model
{
    import flash.geom.Rectangle;
    
    [RemoteClass]
    public class WorldShape
    {
        [Bindable]
        public var x:Number;

        [Bindable]
        public var y:Number;
        
        public function get bounds():Rectangle
        {
            throw new Error("bounds() not overridden");
        }
    }
}