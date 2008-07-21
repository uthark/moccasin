package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    /**
     * Event indicating that the dispatcher's selection status has changed in some way
     * that may require a refresh of any interested view objects.
     */
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
