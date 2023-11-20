<?php
$h = $_ENV["DB_HOST"];
$d = $_ENV['DB_NAME'] ;
$u = $_ENV['DB_USER'];
$p = $_ENV['DB_PASSWORD'];
class Database{

    //database properties

    private $host =  "mariadb";
    private $dbname = "sbtphcsd";
    // private $dbname = "restore_data";
    private $username = "python" ; //"python";
    private $password = "sbtph@2018"; //"sbtph@2018";

 
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