package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    public class UndoEvent extends Event
    {
        public static const UNDO_HISTORY_CHANGE:String = "undoHistoryChange";
        
        public function UndoEvent(type:String)
        {
            super(type);
        }
        
        override public function clone():Event
        {
            return new UndoEvent(type);
        }
    }
}
