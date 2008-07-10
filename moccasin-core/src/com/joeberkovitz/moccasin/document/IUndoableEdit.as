package com.joeberkovitz.moccasin.document
{
    public interface IUndoableEdit
    {
        function undo():void;
        function redo():void;
    }
}
