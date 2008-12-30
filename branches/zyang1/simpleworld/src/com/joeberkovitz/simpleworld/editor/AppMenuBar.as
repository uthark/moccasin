package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.editor.EditorMenuBar;
    import com.joeberkovitz.simpleworld.controller.AppController;
    
    /**
     * Application specific menu bar.
     */
    public class AppMenuBar extends EditorMenuBar
    {
        public function AppMenuBar()
        {
            super();
        }
        
        public function get simpleController():AppController
        {
            return editor.controller as AppController;
        }
        
        override protected function initializeMenuItems():void
        {
            super.initializeMenuItems();
            
            menuBarDefinition +=
                <menuitem id="simpleWorld" label="SimpleWorld">
                    <menuitem id="addSquare" label="Add Square"/>
                </menuitem>;
        }
        
        override protected function handleCommand(commandName:String):void
        {
            switch(commandName)
            {
            case "addSquare":
                simpleController.document.undoHistory.openGroup("Add Square");
                simpleController.addObject();           
               
            default:
                super.handleCommand(commandName);
            }
        }
    }
}