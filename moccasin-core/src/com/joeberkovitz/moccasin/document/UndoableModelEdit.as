package com.joeberkovitz.moccasin.document
{
    import com.joeberkovitz.moccasin.event.ModelEvent;
    
    public class UndoableModelEdit implements IUndoableEdit
    {
        // Set of edits that constitute the group 
        private var _event:ModelEvent;
        
        public function UndoableModelEdit(e:ModelEvent)
        {
            _event = e;
        }
        
        public function redo():void
        {
            switch (_event.kind)
            {
            case ModelEvent.ADD_CHILD_MODEL:
                _event.parent.addChildAt(_event.child, _event.index);
                break;
            
            case ModelEvent.REMOVE_CHILD_MODEL:
                _event.parent.removeChildAt(_event.index);
                break;
            }
        }

        public function undo():void
        {
            switch (_event.kind)
            {
            case ModelEvent.ADD_CHILD_MODEL:
                _event.parent.removeChildAt(_event.index);
                break;

            case ModelEvent.REMOVE_CHILD_MODEL:
                _event.parent.addChildAt(_event.child, _event.index); 
                break;
            }
        }
    }
}
