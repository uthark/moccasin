package com.joeberkovitz.moccasin.event
{
    import com.joeberkovitz.moccasin.document.ISelection;
    
    import flash.events.Event;
    
    /**
     * Event indicating the incremental addition or removal of objects from the selection associated
     * with some document.  This event is not so much listened for, but plays a role in representing
     * selection changes within the UndoHistory.
     */
    public class SelectEvent extends Event
    {
        public static const ADD_SELECTION:String = "addSelection";
        public static const REMOVE_SELECTION:String = "removeSelection";
        
        public var selection:ISelection;
        
        public function SelectEvent(type:String, selection:ISelection)
        {
            super(type);
            this.selection = selection;
        }
        
        override public function clone():Event
        {
            return new SelectEvent(type, selection);
        }
    }
}
