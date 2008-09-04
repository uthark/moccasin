package com.joeberkovitz.moccasin.event
{
    import flash.events.Event;
    
    /**
     * Event dispatched by a MoccasinEditor to indicate significant changes in its content or view.
     */
    public class EditorEvent extends Event
    {
        public static const DOCUMENT_LAYOUT_CHANGE:String = "documentLayoutChange";
        
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
