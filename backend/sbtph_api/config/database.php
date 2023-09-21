<?php

class Database{

    //database properties

    private $host = "127.0.0.1";
    private $dbname = "sbtphapp_db";
    // private $dbname = "restore_data";
    private $username = "SBTPHAPP_USER_HERE";
    private $password = "SBTPHAPP_PWD_HERE";

 
    private $db;

    //database method/function

    public function getConnection(){

    		$conn = NULL;
    	
    	try{
    			$conn = new PDO("mysql:host=$this->host;dbname=$this->dbname", "$this->username", "$this->password");
    			$conn->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

    	}catch (PDOExeption $e){
    		echo 'ERROR: ' . $e->getMessage();
    	}

    	$this->db = $conn;
    	return $this->db;

    }




}