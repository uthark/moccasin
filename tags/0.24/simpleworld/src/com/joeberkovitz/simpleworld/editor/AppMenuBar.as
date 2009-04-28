package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.editor.EditorMenuBar;
    import com.joeberkovitz.moccasin.event.SelectEvent;
    import com.joeberkovitz.moccasin.model.MoccasinModel;
    import com.joeberkovitz.simpleworld.controller.AppController;
    import com.joeberkovitz.simpleworld.model.Square;
    
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
                    <menuitem id="rotateSquare" label="Rotate Square" />
                    <menuitem id="setColor" label="Change Color" enabled="false" />
                    <menuitem id="addLine" label="Add Line"/>
                    <menuitem id="addConnections" label="Connect Squares" />
                </menuitem>;
        }
        
        override protected function handleChangeSelection(evt:SelectEvent):void
        {
            var colorMenu:XMLList = menuBarDefinition[2].menuitem.(@id=="setColor");
            
            // Disable setColor menu item if nothing is selected
            if (evt.selection==null || evt.selection.selectedModels.length==0)
                colorMenu[0].@enabled="false";
            else
            {
                colorMenu[0].@enabled="true";
            }
        }
        
        override protected function handleCommand(commandName:String):void
        {
            switch(commandName)
            {
            case "addSquare":
                simpleController.document.undoHistory.openGroup("Add Square");
                simpleController.addObject();
                break;
            case "setColor":
                simpleController.document.undoHistory.openGroup("Change Color");
                simpleController.changeColor();
                break;
            case "rotateSquare":
                simpleController.document.undoHistory.openGroup("Rotate Square");
                simpleController.rotateSquare(Math.PI / 8);
                break;
/* 
            case "addLine":
                simpleController.document.undoHistory.openGroup("Add Line");
                simpleController.addLine();
                break;

 */
            case "addConnections":
                simpleController.document.undoHistory.openGroup("Connect Squares");
                simpleController.createConnections();
                break;
                
            default:
                super.handleCommand(commandName);
            }
        }
    }
}
