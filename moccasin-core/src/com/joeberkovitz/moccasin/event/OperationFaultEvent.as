package com.joeberkovitz.moccasin.event
{
    import flash.events.ErrorEvent;
    import flash.events.Event;
    
    public class OperationFaultEvent extends Event
    {
        public static const FAULT:String = "fault"
        
        public var error:ErrorEvent;
        
        public function OperationFaultEvent(type:String, error:ErrorEvent)
        {
            super(type);
            this.error = error;
        }
        
        override public function clone():Event
        {
            return new OperationFaultEvent(type, error);
        }
    }
}
