package com.joeberkovitz.simpleworld.service
{
    import com.joeberkovitz.moccasin.service.BasicDocumentFilterOperation;
    import com.joeberkovitz.moccasin.service.IMoccasinDocumentService;
    import com.joeberkovitz.moccasin.service.IOperation;
    import com.joeberkovitz.moccasin.service.MoccasinDocumentData;
    import com.joeberkovitz.moccasin.service.XmlFileWriteOperation;
    import com.joeberkovitz.moccasin.service.XmlHttpOperation;
    
    public class AppDocumentService implements IMoccasinDocumentService
    {
        public function AppDocumentService()
        {
        }

        public function loadDocument(documentUri:String):IOperation
        {
            var xmlHttpOp:XmlHttpOperation = new XmlHttpOperation(documentUri);
            return new BasicDocumentFilterOperation(xmlHttpOp, documentUri, null /* Need a marshaller here */);
        }
        
        /**
         * @inheritDoc 
         */
        public function saveDocument(documentData:MoccasinDocumentData):IOperation
        {
            var xml:XML = null;  // need to unmarshal document
            return new XmlFileWriteOperation(documentData.documentId, xml);
        }
    }
}