-- MySQL dump 10.15  Distrib 10.0.24-MariaDB, for debian-linux-gnu (x86_64)
--
-- Host: localhost    Database: sbtphapp_db
-- ------------------------------------------------------
-- Server version	10.0.24-MariaDB-1~wheezy

/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40103 SET @OLD_TIME_ZONE=@@TIME_ZONE */;
/*!40103 SET TIME_ZONE='+00:00' */;
/*!40014 SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;

--
-- Table structure for table `calltype`
--

DROP TABLE IF EXISTS `calltype`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `calltype` (
  `extension` varchar(30) NOT NULL,
  `calltype` varchar(30) NOT NULL,
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `calltype`
--

LOCK TABLES `calltype` WRITE;
/*!40000 ALTER TABLE `calltype` DISABLE KEYS */;
INSERT INTO `calltype` VALUES ('100002','csd'),('100004','collection'),('100005','collection'),('10001','csd'),('10002','csd'),('10003','csd'),('2006','csd'),('2008','csd'),('2021','csd'),('2115','csd'),('2121','csd'),('2132','csd'),('2133','csd'),('2137','csd'),('2147','csd'),('2148','csd'),('2160','csd'),('2161','csd'),('2162','csd'),('6308','csd'),('6309','collection'),('6310','csd'),('6312','collection'),('6316','csd'),('6318','csd'),('6319','csd'),('6322','csd'),('6328','csd'),('6330','csd'),('6333','csd'),('6334','csd'),('6335','collection'),('6336','collection'),('63366336','csd'),('6338','csd'),('6339','csd'),('6340','collection'),('6342','csd'),('6348','csd'),('6353','csd'),('6364','csd'),('6367','csd'),('6369','collection'),('6370','collection'),('6373','collection'),('6379','collection'),('6381','csd'),('6395','csd'),('6404','csd'),('6411','csd'),('6437','csd'),('86444','csd'),('999999','csd'),('sdfasdfasdf','collection');
/*!40000 ALTER TABLE `calltype` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collectionteam`
--

DROP TABLE IF EXISTS `collectionteam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collectionteam` (
  `extension` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collectionteam`
--

LOCK TABLES `collectionteam` WRITE;
/*!40000 ALTER TABLE `collectionteam` DISABLE KEYS */;
INSERT INTO `collectionteam` VALUES ('6309','JAM','notrueemail@gmail.com'),('6335','CRISJAY','notrueemail@gmail.com'),('6338','CINDZ','notrueemail@gmail.com'),('6340','WILLIAM','notrueemail@gmail.com'),('6370','CHAD','notrueemail@gmail.com'),('6373','ABEN','notrueemail@gmail.com'),('6379','EMMZ','notrueemail@gmail.com');
/*!40000 ALTER TABLE `collectionteam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `collectionteam_callsummary`
--

DROP TABLE IF EXISTS `collectionteam_callsummary`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `collectionteam_callsummary` (
  `StartTimeStamp` varchar(100) NOT NULL,
  `EndTimeStamp` varchar(100) NOT NULL,
  `Duration` varchar(50) NOT NULL,
  `CallStatus` varchar(100) NOT NULL,
  `Caller` varchar(100) NOT NULL,
  `CalledNumber` varchar(100) NOT NULL,
  `getDate` varchar(100) NOT NULL,
  `recording_link` varchar(150) NOT NULL,
  `comment` text NOT NULL,
  `commentby` varchar(50) NOT NULL,
  `tag` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `collectionteam_callsummary`
--

LOCK TABLES `collectionteam_callsummary` WRITE;
/*!40000 ALTER TABLE `collectionteam_callsummary` DISABLE KEYS */;
/*!40000 ALTER TABLE `collectionteam_callsummary` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `csdinbound`
--

DROP TABLE IF EXISTS `csdinbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `csdinbound` (
  `extension` varchar(20) NOT NULL,
  `callerid` varchar(100) NOT NULL,
  `username` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `receive_calls` tinyint(1) NOT NULL DEFAULT '0',
  `serverip` varchar(50) NOT NULL,
  `serverstatus` varchar(10) NOT NULL,
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `csdinbound`
--

LOCK TABLES `csdinbound` WRITE;
/*!40000 ALTER TABLE `csdinbound` DISABLE KEYS */;
INSERT INTO `csdinbound` VALUES ('2137','','BEGIMAI','nottrueemail.com',0,'',''),('2147','','KAIR','nottrueemail.com',0,'',''),('2148','','GULIRA','nottrueemail.com',0,'',''),('2160','','Sovkhozbek','nottrueemail.com',0,'',''),('2161','','Madazimova','nottrueemail.com',0,'',''),('2162','','Orozaliev','nottrueemail.com',0,'',''),('6308','','JM','nottrueemail.com',0,'',''),('6310','','JOYANN','nottrueemail.com',0,'',''),('6316','Chiche','Chiche','nottrueemail.com',0,'',''),('6318','6318','KIMBERLY','nottrueemail.com',0,'',''),('6322','caller-6322','MARK','nottrueemail.com',0,'',''),('6330','','JANE','nottrueemail.com',1,'210.1.86.211','UP'),('6336','','Rogmer','nottrueemail.com',0,'',''),('6338','','CINDY','nottrueemail.com',0,'',''),('6339','6339','JERILYN','nottrueemail.com',0,'',''),('6342','6342','LAWRENCE','nottrueemail.com',0,'',''),('6348','6348','DONIE','nottrueemail.com',0,'',''),('6364','6364','DAISY','nottrueemail.com',1,'103.5.6.2','UP'),('6367','6367','ELLAYNE','nottrueemail.com',0,'',''),('6370','6370','CHAD','nottrueemail.com',0,'',''),('6395','6395','Ahlie','nottrueemail.com',0,'',''),('6411','6411','DHEN','nottrueemail.com',0,'',''),('6437','6437','TINE','nottrueemail.com',0,'',''),('999999','','test100','nottrueemail.com',0,'','');
/*!40000 ALTER TABLE `csdinbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `event_log`
--

DROP TABLE IF EXISTS `event_log`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `event_log` (
  `action` varchar(100) NOT NULL,
  `performed_by` varchar(100) NOT NULL,
  `description` text NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP,
  PRIMARY KEY (`timestamp`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `event_log`
--

LOCK TABLES `event_log` WRITE;
/*!40000 ALTER TABLE `event_log` DISABLE KEYS */;
/*!40000 ALTER TABLE `event_log` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `inbound_callstatus`
--

DROP TABLE IF EXISTS `inbound_callstatus`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `inbound_callstatus` (
  `StartTimeStamp` varchar(100) NOT NULL,
  `EndTimeStamp` varchar(100) NOT NULL,
  `CallStatus` varchar(100) NOT NULL,
  `Caller` varchar(100) NOT NULL,
  `CalledNumber` varchar(100) NOT NULL,
  `WhoAnsweredCall` varchar(100) NOT NULL,
  `getDate` varchar(50) NOT NULL,
  `comment` text NOT NULL,
  `commentby` varchar(50) NOT NULL,
  `tag` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `inbound_callstatus`
--

LOCK TABLES `inbound_callstatus` WRITE;
/*!40000 ALTER TABLE `inbound_callstatus` DISABLE KEYS */;
/*!40000 ALTER TABLE `inbound_callstatus` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `login` (
  `extension` varchar(20) NOT NULL,
  `secret` varchar(50) NOT NULL,
  `name` varchar(100) NOT NULL,
  `position` varchar(50) NOT NULL DEFAULT '0',
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `login`
--

LOCK TABLES `login` WRITE;
/*!40000 ALTER TABLE `login` DISABLE KEYS */;
INSERT INTO `login` VALUES ('2006','99999','BEMA','31'),('2008','99999','NIKA','31'),('2021','99999','NARISTE','31'),('2115','99999','AIBIKE','31'),('2121','99999','AZAT','31'),('2132','99999','Elmira','31'),('2133','99999','Urmat','31'),('2137','99999','BEGIMAI','31'),('2147','99999','kairg','31'),('2148','99999','GULIRAD','31'),('2160','99999','Sovkhozbek','31'),('2161','99999','Madazimova','31'),('2162','99999','Orozaliev','31'),('6304','99999','HACEL','10'),('6308','99999','JM','30'),('6309','99999','JAM','41'),('6310','99999','JOYANN','31'),('6311','99999','DANIELLE','1'),('6312','99999','MARK_ANGELO','10'),('6313','99999','LARAH','1'),('6316','99999','Chiche','31'),('6318','99999','Kimberly','31'),('6319','99999','ROCEL','31'),('6322','99999','Mark Erwin Hicks','20'),('6328','99999','Shaira ','31'),('6330','99999','JANE','31'),('6333','99999','JENNY_ANN','31'),('6334','99999','PATRIZIA','31'),('6335','99999','Crisjay','41'),('6336','99999','Rogmer Bulaclac','99'),('6338','99999','CINDZ','22'),('6339','99999','JERILYN','31'),('6340','99999','WILLIAM','41'),('6342','99999','LAWRENCE','31'),('6348','99999','DONIE','30'),('6353','99999','MARYJOYCE','31'),('6354','99999','PATRICIA','0'),('6358','99999','RUSTAN','1'),('6364','99999','DAISY','30'),('6367','99999','ELLAYNE','31'),('6369','99999','RLADDRAN','0'),('6370','99999','CHAD','40'),('6372','99999','MARIE','1'),('6373','99999','ABEN','40'),('6379','99999','EMMZ','41'),('6383','99999','ALOHA','0'),('6384','99999','France','1'),('6390','99999','JRICK','0'),('6395','99999','AHLIE','30'),('6404','99999','GAYANN','31'),('6411','99999','DHEN','31'),('6437','99999','TINE','31'),('9999','99999','AUDITORS','10');
/*!40000 ALTER TABLE `login` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `logs`
--

DROP TABLE IF EXISTS `logs`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `logs` (
  `extension` varchar(50) NOT NULL,
  `log` varchar(50) NOT NULL,
  `logdate` varchar(100) NOT NULL,
  `logtime` varchar(100) NOT NULL,
  `timestamp` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `logs`
--

LOCK TABLES `logs` WRITE;
/*!40000 ALTER TABLE `logs` DISABLE KEYS */;
/*!40000 ALTER TABLE `logs` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `outbound`
--

DROP TABLE IF EXISTS `outbound`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `outbound` (
  `StartTimeStamp` varchar(100) NOT NULL,
  `EndTimeStamp` varchar(100) NOT NULL,
  `Duration` varchar(50) NOT NULL,
  `CallStatus` varchar(100) NOT NULL,
  `Caller` varchar(100) NOT NULL,
  `CalledNumber` varchar(100) NOT NULL,
  `recording_link` varchar(100) NOT NULL,
  `getDate` varchar(100) NOT NULL,
  `comment` text NOT NULL,
  `commentby` varchar(50) NOT NULL,
  `tag` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `outbound`
--

LOCK TABLES `outbound` WRITE;
/*!40000 ALTER TABLE `outbound` DISABLE KEYS */;
/*!40000 ALTER TABLE `outbound` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `posistion_descriptions`
--

DROP TABLE IF EXISTS `posistion_descriptions`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `posistion_descriptions` (
  `position` varchar(10) NOT NULL,
  `description` varchar(50) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `posistion_descriptions`
--

LOCK TABLES `posistion_descriptions` WRITE;
/*!40000 ALTER TABLE `posistion_descriptions` DISABLE KEYS */;
INSERT INTO `posistion_descriptions` VALUES ('99','SuperAdmin/IT'),('10','HrAdmin'),('20','CSD-Manager'),('21','Collection/Csd Agent'),('30','CSD Team Leader'),('31','CSD Agent'),('40','Collection TeamLeader'),('41','Collection Agent'),('3','QC of All Agents'),('1','QC-Sales Agent'),('2','QC CSD/Collection'),('50','Sales Managers'),('51','Sales Team Leader'),('52','Sales Agent');
/*!40000 ALTER TABLE `posistion_descriptions` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `salesteam`
--

DROP TABLE IF EXISTS `salesteam`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `salesteam` (
  `extension` varchar(100) NOT NULL,
  `name` varchar(100) NOT NULL,
  `email` varchar(100) NOT NULL,
  `teamlead` varchar(100) NOT NULL,
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `salesteam`
--

LOCK TABLES `salesteam` WRITE;
/*!40000 ALTER TABLE `salesteam` DISABLE KEYS */;
INSERT INTO `salesteam` VALUES ('6211','Arlene','nottrueemail@gmail.com','RUSTAN'),('6326','Don','nottrueemail@gmail.com','RUSTAN'),('6331','Jhun','nottrueemail@gmail.com','RUSTAN'),('6346','MACEDO','nottrueemail@gmail.com','IVAN'),('6355','Chris','nottrueemail@gmail.com','JHUN'),('6358','Rustan','nottrueemail@gmail.com','RUSTAN'),('6366','Sally','nottrueemail@gmail.com','RUSTAN'),('6372','Marie','nottrueemail@gmail.com','RUSTAN'),('6374','RANDY','nottrueemail@gmail.com','MHEL'),('6375','ROMANO','nottrueemail@gmail.com','DON'),('6377','PJ','nottrueemail@gmail.com','BRY'),('6380','Mhel','nottrueemail@gmail.com','RUSTAN'),('6384','France','nottrueemail@gmail.com','JHUN'),('6385','Bry','nottrueemail@gmail.com','RUSTAN'),('6388','Darwin','nottrueemail@gmail.com','KEN'),('6392','Ivann','nottrueemail@gmail.com','RUSTAN'),('6396','Nel','nottrueemail@gmail.com','SALLY'),('6399','Joman','nottrueemail@gmail.com','RUSTAN'),('6401','Ruffy','nottrueemail@gmail.com','SALLY'),('6402','Ken','nottrueemail@gmail.com','RUSTAN'),('6403','Ccunanan','nottrueemail@gmail.com','JOMAN'),('6415','Vincent','nottrueemail@gmail.com','DON'),('6423','Xander','nottrueemail@gmail.com','RUSTAN'),('6446','Johncris','nottrueemail@gmail.com','DON');
/*!40000 ALTER TABLE `salesteam` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `sip_channels`
--

DROP TABLE IF EXISTS `sip_channels`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `sip_channels` (
  `extension` varchar(20) NOT NULL,
  `status` tinyint(1) NOT NULL DEFAULT '0',
  `counter` int(11) NOT NULL,
  PRIMARY KEY (`extension`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `sip_channels`
--

LOCK TABLES `sip_channels` WRITE;
/*!40000 ALTER TABLE `sip_channels` DISABLE KEYS */;
INSERT INTO `sip_channels` VALUES ('6308',0,0),('6316',0,0),('6318',0,0),('6322',0,0),('6328',0,0),('6333',0,0),('6335',0,0),('6336',0,0),('6338',0,0),('6339',0,0),('6342',0,0),('6348',0,0),('6353',0,0),('6354',0,0),('6364',0,0),('6367',0,0),('6370',0,0),('6381',0,0),('6383',0,0),('6395',0,0),('6404',0,0),('6411',0,0),('6437',0,0);
/*!40000 ALTER TABLE `sip_channels` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `tag`
--

DROP TABLE IF EXISTS `tag`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `tag` (
  `tagId` varchar(200) NOT NULL,
  `tagtype` varchar(100) NOT NULL,
  `tagname` varchar(100) NOT NULL,
  `createdby` varchar(100) NOT NULL,
  `createddate` varchar(100) NOT NULL,
  PRIMARY KEY (`tagId`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `tag`
--

LOCK TABLES `tag` WRITE;
/*!40000 ALTER TABLE `tag` DISABLE KEYS */;
INSERT INTO `tag` VALUES ('COLLECTION-ALLOCATION VERIFICATION','COLLECTION','ALLOCATION VERIFICATION','Mark Erwin Hicks','2020-8-25'),('COLLECTION-ALLOCATION VERIFICATION NO ANSWER/VOICEMAIL','COLLECTION','ALLOCATION VERIFICATION NO ANSWER/VOICEMAIL','Mark Erwin Hicks','2020-9-1'),('COLLECTION-BALANCE CALL','COLLECTION','BALANCE CALL','Mark Erwin Hicks','2020-8-25'),('COLLECTION-BALANCE CALL (DROPPED/NOT AVAILABLE)','COLLECTION','BALANCE CALL (DROPPED/NOT AVAILABLE)','Mark Erwin Hicks','2021-1-29'),('COLLECTION-BALANCE CALL NO ANSWER/VOICE MAIL','COLLECTION','BALANCE CALL NO ANSWER/VOICE MAIL','Mark Erwin Hicks','2020-9-1'),('COLLECTION-CANCEL ORDER (PAYMENT RECALL)','COLLECTION','CANCEL ORDER (PAYMENT RECALL)','Mark Erwin Hicks','2020-8-25'),('COLLECTION-CANCEL ORDER (PAYMENT RECALL) NO ANSWER/VOICE MAIL','COLLECTION','CANCEL ORDER (PAYMENT RECALL) NO ANSWER/VOICE MAIL','Mark Erwin Hicks','2020-9-1'),('COLLECTION-DEPOSIT CALL','COLLECTION','DEPOSIT CALL','Mark Erwin Hicks','2020-8-25'),('COLLECTION-DEPOSIT CALL (DROPPED/NOT AVAILABLE)','COLLECTION','DEPOSIT CALL (DROPPED/NOT AVAILABLE)','Mark Erwin Hicks','2020-10-12'),('COLLECTION-DEPOSIT CALL NO ANSWER/VOICEMAIL','COLLECTION','DEPOSIT CALL NO ANSWER/VOICEMAIL','Mark Erwin Hicks','2020-9-1'),('COLLECTION-PAYMENT ASSISTANCE','COLLECTION','PAYMENT ASSISTANCE','Mark Erwin Hicks','2020-8-25'),('COLLECTION-PAYMENT ASSISTANCE NO ANSWER/VOICE MAIL','COLLECTION','PAYMENT ASSISTANCE NO ANSWER/VOICE MAIL','Mark Erwin Hicks','2020-9-1'),('COLLECTION-PAYMENT REFUND','COLLECTION','PAYMENT REFUND','Mark Erwin Hicks','2020-11-6'),('COLLECTION-PAYMENT VERIFICATION CALL','COLLECTION','PAYMENT VERIFICATION CALL','Mark Erwin Hicks','2020-8-25'),('COLLECTION-PAYMENT VERIFICATION CALL NO ANSWER/VOICE MAIL','COLLECTION','PAYMENT VERIFICATION CALL NO ANSWER/VOICE MAIL','Mark Erwin Hicks','2020-9-1'),('CSDINBOUND-AMENDMENT','CSDINBOUND','AMENDMENT','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-CALL BACK REQUEST','CSDINBOUND','CALL BACK REQUEST','Mark Erwin Hicks','2020-8-25'),('CSDINBOUND-CAR CONCERN/STATUS','CSDINBOUND','CAR CONCERN/STATUS','Mark Erwin Hicks','2020-9-7'),('CSDINBOUND-CAR INQUIRY (REGISTERED)','CSDINBOUND','CAR INQUIRY (REGISTERED)','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-CAR INQUIRY (UNREGISTERED)','CSDINBOUND','CAR INQUIRY (UNREGISTERED)','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-COMPLAINTS','CSDINBOUND','COMPLAINTS','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-CONSIGNEE','CSDINBOUND','CONSIGNEE','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-COURIER','CSDINBOUND','COURIER','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-CUSTOMER ACCOUNT CONCERN','CSDINBOUND','CUSTOMER ACCOUNT CONCERN','Mark Erwin Hicks','2020-8-26'),('CSDINBOUND-DOCUMENTS','CSDINBOUND','DOCUMENTS','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-DROPPED CALL (MEMBER)','CSDINBOUND','DROPPED CALL (MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDINBOUND-DROPPED CALL (NON MEMBER)','CSDINBOUND','DROPPED CALL (NON MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDINBOUND-INVOICE','CSDINBOUND','INVOICE','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-OTHERS (NOT RELATED TO SBT TRANSACTION)','CSDINBOUND','OTHERS (NOT RELATED TO SBT TRANSACTION)','Mark Erwin Hicks','2020-9-17'),('CSDINBOUND-PAYMENT PROBLEM','CSDINBOUND','PAYMENT PROBLEM','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-PAYMENT REFUND','CSDINBOUND','PAYMENT REFUND','Mark Erwin Hicks','2020-11-6'),('CSDINBOUND-PAYMENT UPDATE','CSDINBOUND','PAYMENT UPDATE','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-RELEASE','CSDINBOUND','RELEASE','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-SALES ASSISTANCE','CSDINBOUND','SALES ASSISTANCE','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-SHIPMENT','CSDINBOUND','SHIPMENT','Rogmer Bulaclac','2020-8-22'),('CSDINBOUND-THIRD PARTY CUSTOMER CAR CONCERN','CSDINBOUND','THIRD PARTY CUSTOMER CAR CONCERN','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-CALL BACK REQUEST RETURN CALL','CSDOUTBOUND','CALL BACK REQUEST RETURN CALL','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-CAR CONCERN/STATUS','CSDOUTBOUND','CAR CONCERN/STATUS','Mark Erwin Hicks','2020-9-7'),('CSDOUTBOUND-CONSIGNEE CALL','CSDOUTBOUND','CONSIGNEE CALL','Rogmer Bulaclac','2020-8-22'),('CSDOUTBOUND-CONSIGNEE COURIER CALL','CSDOUTBOUND','CONSIGNEE COURIER CALL','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-COURIER CALL','CSDOUTBOUND','COURIER CALL','Rogmer Bulaclac','2020-8-22'),('CSDOUTBOUND-CUSTOMER ACCOUNT CONCERN CALLBACK','CSDOUTBOUND','CUSTOMER ACCOUNT CONCERN CALLBACK','Mark Erwin Hicks','2020-8-26'),('CSDOUTBOUND-DROPPED CALL (CB NO ANS, NOTIFIED DM OR SALES)','CSDOUTBOUND','DROPPED CALL (CB NO ANS, NOTIFIED DM OR SALES)','Mark Erwin Hicks','2020-9-17'),('CSDOUTBOUND-DROPPED CALL RETURN CALL (MEMBER)','CSDOUTBOUND','DROPPED CALL RETURN CALL (MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-DROPPED CALL RETURN CALL (NON MEMBER)','CSDOUTBOUND','DROPPED CALL RETURN CALL (NON MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-FOLLOW UP CALL AMENDMENT','CSDOUTBOUND','FOLLOW UP CALL AMENDMENT','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL COMPLAINT','CSDOUTBOUND','FOLLOW UP CALL COMPLAINT','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL CONCERN','CSDOUTBOUND','FOLLOW UP CALL CONCERN','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL DOCUMENTS','CSDOUTBOUND','FOLLOW UP CALL DOCUMENTS','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL INQUIRY','CSDOUTBOUND','FOLLOW UP CALL INQUIRY','Rogmer Bulaclac','2020-8-22'),('CSDOUTBOUND-FOLLOW UP CALL INVOICE','CSDOUTBOUND','FOLLOW UP CALL INVOICE','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL PAYMENT CONCERN','CSDOUTBOUND','FOLLOW UP CALL PAYMENT CONCERN','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-FOLLOW UP CALL RELEASE','CSDOUTBOUND','FOLLOW UP CALL RELEASE','Mark Erwin Hicks','2020-8-25'),('CSDOUTBOUND-FOLLOW UP CALL SHIPMENT','CSDOUTBOUND','FOLLOW UP CALL SHIPMENT','Rogmer Bulaclac','2020-8-22'),('CSDOUTBOUND-MISSED CALL RETURN CALL (MEMBER)','CSDOUTBOUND','MISSED CALL RETURN CALL (MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-MISSED CALL RETURN CALL (NO ANS/NOTIFIED DM OR SALES)','CSDOUTBOUND','MISSED CALL RETURN CALL (NO ANS/NOTIFIED DM OR SALES)','Mark Erwin Hicks','2020-9-16'),('CSDOUTBOUND-MISSED CALL RETURN CALL (NON MEMBER)','CSDOUTBOUND','MISSED CALL RETURN CALL (NON MEMBER)','Mark Erwin Hicks','2020-8-31'),('CSDOUTBOUND-OTHERS (WRONGLY DIALLED/NOT RELATED TO SBT)','CSDOUTBOUND','OTHERS (WRONGLY DIALLED/NOT RELATED TO SBT)','Mark Erwin Hicks','2020-11-9'),('CSDOUTBOUND-PAYMENT REFUND','CSDOUTBOUND','PAYMENT REFUND','Mark Erwin Hicks','2020-11-6');
/*!40000 ALTER TABLE `tag` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `voicemail`
--

DROP TABLE IF EXISTS `voicemail`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `voicemail` (
  `timestamp` varchar(100) NOT NULL,
  `caller` varchar(50) NOT NULL,
  `date` varchar(30) NOT NULL,
  `time` varchar(20) NOT NULL,
  `voicemail` varchar(100) NOT NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `voicemail`
--

LOCK TABLES `voicemail` WRITE;
/*!40000 ALTER TABLE `voicemail` DISABLE KEYS */;
/*!40000 ALTER TABLE `voicemail` ENABLE KEYS */;
UNLOCK TABLES;

--
-- Table structure for table `waiting_calls`
--

DROP TABLE IF EXISTS `waiting_calls`;
/*!40101 SET @saved_cs_client     = @@character_set_client */;
/*!40101 SET character_set_client = utf8 */;
CREATE TABLE `waiting_calls` (
  `waitingStarTime` varchar(50) NOT NULL,
  `caller` varchar(50) NOT NULL,
  `calledNumber` varchar(50) NOT NULL,
  `getDate` varchar(50) NOT NULL,
  PRIMARY KEY (`caller`)
) ENGINE=InnoDB DEFAULT CHARSET=latin1;
/*!40101 SET character_set_client = @saved_cs_client */;

--
-- Dumping data for table `waiting_calls`
--

LOCK TABLES `waiting_calls` WRITE;
/*!40000 ALTER TABLE `waiting_calls` DISABLE KEYS */;
/*!40000 ALTER TABLE `waiting_calls` ENABLE KEYS */;
UNLOCK TABLES;
/*!40103 SET TIME_ZONE=@OLD_TIME_ZONE */;

/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40014 SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;

-- Dump completed on 2023-08-31 22:14:37
