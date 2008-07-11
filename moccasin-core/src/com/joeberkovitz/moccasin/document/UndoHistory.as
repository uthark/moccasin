package com.joeberkovitz.moccasin.document
{
    import com.joeberkovitz.moccasin.event.UndoEvent;
    
    import flash.events.EventDispatcher;
    
    public class UndoHistory extends EventDispatcher
    {
        // Set of UndoableEditGroups that constitute the history 
        private var _groups:Array;

        // Index pointing just after the group which has
        // the last-executed actions in the application state.
        private var _cursor:int;
        
        // The groupOpen flag indicates that the last group is an empty group
        // that is not yet in the history, to which new edits can be added.
        private var _groupOpen:Boolean;
        
        // Maximum number of groups allowed.
        private var _maxGroups:uint;
        
        // Enabled flag is normally true, but temporarily cleared during undo/redo.
        private var _enabled:Boolean;
        
        public function UndoHistory(maxEntries:uint = 20)
        {
            _maxGroups = maxEntries;
            clear();
        }

        public function get numGroups():uint
        {
            return _groupOpen ? (_groups.length - 1) : _groups.length;
        }
        
        public function get canUndo():Boolean
        {
            return _cursor > 0;
        }
        
        public function get canRedo():Boolean
        {
            return _cursor < numGroups;
        }
        
        public function get undoName():String
        {
            return canUndo ? getGroupAt(_cursor - 1).name : "";
        }
        
        public function get redoName():String
        {
            return canRedo ? getGroupAt(_cursor).name : "";
        }
        
        public function get enabled():Boolean
        {
            return _enabled;
        }
        
        public function set enabled(value:Boolean):void
        {
            _enabled = value;
        }
        
        public function clear():void
        {
            _groupOpen = false;
            _enabled = true;
            _groups = [];
            _cursor = 0;

            dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
        }
        
        public function getGroupAt(index:uint):UndoableEditGroup
        {
            return _groups[index] as UndoableEditGroup;
        }
        
        public function undo():void
        {
            if (canUndo)
            {
                _groupOpen = false;
                _enabled = false;
                getGroupAt(--_cursor).undo();
                _enabled = true;
                
                dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
            }
        }
        
        public function redo():void
        {
            if (canRedo)
            {
                _groupOpen = false;
                _enabled = false;
                getGroupAt(_cursor++).redo();
                _enabled = true;
                
                dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
            }
        }
        
        public function addEdit(edit:IUndoableEdit):void
        {
            if (_enabled)
            {
                if (_groupOpen)
                {
                    // If there is an open group, start to use it.
                    _cursor++;
                    _groupOpen = false;

                    dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
                }
                
                if (numGroups > 0)
                {
                    getGroupAt(numGroups - 1).addEdit(edit);
                }
            }
        }
        
        /**
         * Add a new UndoableEditGroup at the cursor index, tossing any entries
         * that were already existing at or after that index.  The cursor is not advanced
         * over this empty group, however, so it is not undoable until the first edit is added
         * to it.
         */
        public function openGroup(name:String):void
        {
            // force the history to be enabled at this point
            _enabled = true;
            
            _groups = _groups.slice(0, _cursor);
            _groupOpen = false;
            if (numGroups == _maxGroups)
            {
                // constrain the total number of undo entries.
                _groups.shift();
                _cursor--;
            }
            _groups.push(new UndoableEditGroup(name));
            _groupOpen = true;
                
            dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
        }
        
        /**
         * Set the name of the current group. 
         */
        public function setGroupName(name:String):void
        {
            // force the history to be enabled at this point
            _enabled = true;

            getGroupAt(_groups.length - 1).name = name;
            dispatchEvent(new UndoEvent(UndoEvent.UNDO_HISTORY_CHANGE));
        }
    }
}
