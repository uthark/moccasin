package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    public class ModelStatusEvent extends Event
    {
        public static const STATUS_CHANGE:String = "statusChange";
        
        public function ModelStatusEvent(type:String)
        {
            super(type);
        }
        
        override public function clone():Event
        {
            return new ModelStatusEvent(type);
        }
    }
}
