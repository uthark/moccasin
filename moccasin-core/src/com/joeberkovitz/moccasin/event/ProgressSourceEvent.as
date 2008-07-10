package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    import flash.events.IEventDispatcher;
    
    public class ProgressSourceEvent extends Event
    {
        public static const PROGRESS_START:String = "progressStart";
        
        public var source:IEventDispatcher;
        
        public var sourceName:String;
        
        public function ProgressSourceEvent(type:String, source:IEventDispatcher, sourceName:String)
        {
            super(type);
            this.source = source;
            this.sourceName = sourceName;
        }
        
        override public function clone():Event
        {
            return new ProgressSourceEvent(type, source, sourceName);
        }
    }
}
