package com.joeberkovitz.moccasin.service
{
    import mx.core.Application;

    public class BasicConfigurationService implements IConfigurationService
    {
        private var _parameters:Object;
        private var _scoreUri:String;
        
        public function BasicConfigurationService(app:Application, scoreUri:String)
        {
            if (app != null)
            {
                _parameters = app.parameters;
            }
            else
            {
                _parameters = { hostPrefix: "", filePrefix: "" };
            }
            _scoreUri = scoreUri;
        }
        
        public function get documentUri():String
        {
            return _scoreUri;
        }

        public function get assetLocation():String
        {
            return _parameters["hostPrefix"] + _parameters["filePrefix"];
        }
        
        public function get viewScale():Number
        {
            return 1;
        }
    }
}
