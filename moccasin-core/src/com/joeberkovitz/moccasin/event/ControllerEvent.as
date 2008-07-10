package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    public class ControllerEvent extends Event
    {
        public static const DOCUMENT_CHANGE:String = "documentChange";
        
        public function ControllerEvent(type:String)
        {
            super(type);
        }
        
        override public function clone():Event
        {
            return new ControllerEvent(type);
        }
    }
}
