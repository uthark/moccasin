package com.joeberkovitz.simpleworld.editor
{
    import com.joeberkovitz.moccasin.controller.IMoccasinController;
    import com.joeberkovitz.moccasin.document.MoccasinDocument;
    import com.joeberkovitz.moccasin.editor.AirMoccasinEditor;
    import com.joeberkovitz.moccasin.editor.EditorKeyMediator;
    import com.joeberkovitz.moccasin.model.ModelRoot;
    import com.joeberkovitz.moccasin.service.IMoccasinDocumentService;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.moccasin.view.IMoccasinView;
    import com.joeberkovitz.moccasin.view.ViewContext;
    import com.joeberkovitz.simpleworld.controller.AppController;
    import com.joeberkovitz.simpleworld.model.World;
    import com.joeberkovitz.simpleworld.service.AirAppDocumentService;
    import com.joeberkovitz.simpleworld.view.WorldView;
    

    /**
     * AIR version of the AppEditor/
     */
    public class AirAppEditor extends AirMoccasinEditor
    {
        override public function initializeEditor():void
        {
            super.initializeEditor();
            
            _document = new MoccasinDocument(new ModelRoot(new World()));
            controller.document = _document;
            documentData = new MoccasinDocumentData(_document.root, null);
            updateLayout();
        }
        
        /**
         * Override base class to create application-specific controller. 
         */
        override protected function createController():IMoccasinController
        {
            return new AppController(null);
        }
        
        /**
         * Override base class to create application-specific keystroke mediator. 
         */
        override protected function createKeyMediator(controller:IMoccasinController):EditorKeyMediator
        {
            return new AppKeyMediator(controller, this);
        }
        
        /**
         * Override base class to create application-specific top-level view of model. 
         */
        override protected function createDocumentView(context:ViewContext):IMoccasinView
        {
            return new WorldView(context, controller.document.root);
        } 

        /**
         * Override base class to instantiate application-specific service to load and save documents. 
         */
        override protected function createDocumentService():IMoccasinDocumentService
        {
            return new AirAppDocumentService();
        } 
    }
}