package com.joeberkovitz.moccasin.service
{
    import com.joeberkovitz.moccasin.persistence.IDocumentDecoder;
    import com.joeberkovitz.moccasin.persistence.IDocumentEncoder;
    
    import flash.net.URLRequestMethod;
    
    import mx.core.Application;
    
    /**
     * Simple implementation of IScoreService that loads or saves only the score property of
     * a ScoreData object, and exposes an asset location.  All URLs are preceded by the
     * hostPrefix.  Load/save URLs append the loadLocation or saveLocation properties, while
     * the asset location appends the filePrefix property.
     * 
     * <p>Scores are posted with the XML body of the score either as a POST document (the default)
     * or as a POST request parameter (if scorePostVariable is set to that parameter's name). 
     */
    public class BasicHttpScoreService implements IMoccasinDocumentService
    {
        /** Overall host prefix for all service traffic. */
        [Bindable]
        public var hostPrefix:String = "";
        
        /** location URI for REST-style load service. */
        [Bindable]
        public var loadLocation:String = "";
        
        /** location URI for REST-style save service. */
        [Bindable]
        public var saveLocation:String = "";
        
        /** optional variable determining a POST request parameter for a saved score's XML. */
        [Bindable]
        public var scorePostVariable:String = null;
        
        private var _decoder:IDocumentDecoder;
        private var _encoder:IDocumentEncoder;
        
        public function BasicHttpScoreService(app:Application, decoder:IDocumentDecoder, encoder:IDocumentEncoder)
        {
            if (app != null)
            {
                hostPrefix = app.parameters["hostPrefix"];
            }
            else
            {
                hostPrefix = "";
            }
            _decoder = decoder;
            _encoder = encoder;
        }

        /**
         * @inheritDoc 
         */
        public function loadDocument(scoreUri:String):IOperation
        {
            var xmlHttpOp:XmlHttpOperation = new XmlHttpOperation(hostPrefix + loadLocation + scoreUri);
            return new BasicDocumentFilterOperation(xmlHttpOp, scoreUri, _decoder);
        }
        
        /**
         * @inheritDoc 
         */
        public function saveDocument(scoreData:MoccasinDocumentData):IOperation
        {
            var scoreXml:XML = _encoder.encodeDocument(scoreData.root) as XML;
            if (scorePostVariable != null)
            {
                var data:Object = {};
                data[scorePostVariable] = scoreXml;
                data["title"] = scoreData.documentDescriptor.title;
                data["composer"] = scoreData.documentDescriptor.composer;
                var xmlHttpOp:XmlHttpOperation = new XmlHttpOperation(hostPrefix + saveLocation + scoreData.documentId, data);
                xmlHttpOp.method = URLRequestMethod.POST;
                return xmlHttpOp;
            }
            else
            {
                return new XmlHttpOperation(hostPrefix + saveLocation + scoreData.documentId, scoreXml);
            }
        }
    }
}
