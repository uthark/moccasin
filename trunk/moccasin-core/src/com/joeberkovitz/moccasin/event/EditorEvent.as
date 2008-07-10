package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    public class EditorEvent extends Event
    {
        public static const SCORE_LAYOUT_CHANGE:String = "scoreLayoutChange";
        
        public function EditorEvent(type:String)
        {
            super(type);
        }
        
        override public function clone():Event
        {
            return new EditorEvent(type);
        }
    }
}
