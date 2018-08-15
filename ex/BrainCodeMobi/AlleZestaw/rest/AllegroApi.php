<?php

class AllegroApi {

    private $_client = NULL;
    private $_session = NULL;
    private $_versionKeys = array();
    
    private $OLD_ALLEGRO_API = 'https://webapi.allegro.pl/uploader.php?wsdl';
    private $NEW_ALLEGRO_API = 'https://webapi.allegro.pl/service.php?wsdl';
    

    function __construct() {
        //init soap client
        $options = array();
        $options['features'] = SOAP_SINGLE_ELEMENT_ARRAYS;
        $this->_client = new SoapClient($this->NEW_ALLEGRO_API, $options);
        $request = array(
            'countryId' => ALLEGRO_COUNTRY,
            'webapiKey' => ALLEGRO_KEY
        );
        //init main data
        $sys = $this->_client->doQueryAllSysStatus($request);
        $this->_versionKeys = array();
        foreach ($sys->sysCountryStatus->item as $row) {
            $this->_versionKeys[$row->countryId] = $row;
        }
    }

    function loginEnc() {
        $request = array(
            'userLogin' => ALLEGRO_LOGIN,
            'userHashPassword' => ALLEGRO_PASSWORD,
            'countryCode' => ALLEGRO_COUNTRY,
            'webapiKey' => ALLEGRO_KEY,
            'localVersion' => $this->_versionKeys[ALLEGRO_COUNTRY]->verKey,
        );
        $this->_session = $this->_client->doLoginEnc($request);
        if(!$this->_session){
            throw new Exception("Login session error", 504);
        }
    }

    function __call($name, $arguments) {
        $arguments = (array) $arguments[0];
        $sessionId = $this->_session->sessionHandlePart;
        $arguments['sessionId'] = $sessionId;
        $arguments['sessionHandle'] = $sessionId;
        $arguments['webapiKey'] = ALLEGRO_KEY;
        $arguments['countryId'] = ALLEGRO_COUNTRY;
        $fname = 'do'.ucfirst($name);
        return $this->_client->$fname($arguments);
    }
    
}
