# CAS
A system for classes in middle school

#ABOUT THIS VERSION

THIS VERSION IS BASED ON MYSQL/MONO PLATFORM!

The core component - the SQL integrated class - is out of date

This version(branch) won't be maintained any more

Roughly, this version is similar with the one runing at https://cas.lyzde.com

#Requirement

MYSQY DYNAMIC LINKED LIB (.NET VERSION)

MYSQL DATABASE schema designs are as followed:


	CREATE DATABASE IF NOT EXISTS `CAS` DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;
	USE `CAS`;

	CREATE TABLE `CAS_Calendar` (
	  `ID` int(11) NOT NULL,
	  `GUID` varchar(50) NOT NULL,
	  `info` varchar(50) NOT NULL,
	  `sdate` date NOT NULL,
	  `edate` date DEFAULT NULL,
	  `UUID` varchar(50) NOT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `CAS_Notice` (
	  `ID` int(11) NOT NULL,
	  `GUID` varchar(50) NOT NULL,
	  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  `UUID` varchar(50) NOT NULL,
	  `info` text NOT NULL,
	  `title` varchar(50) NOT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `CAS_Photo` (
	  `ID` int(11) NOT NULL,
	  `GUID` varchar(50) NOT NULL,
	  `UUID` varchar(50) NOT NULL,
	  `title` varchar(50) NOT NULL,
	  `folder` varchar(50) DEFAULT NULL,
	  `date` datetime DEFAULT CURRENT_TIMESTAMP
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `CAS_Talk` (
	  `ID` int(11) NOT NULL,
	  `GUID` varchar(50) NOT NULL,
	  `UUID` varchar(50) NOT NULL,
	  `cont` text NOT NULL,
	  `date` datetime NOT NULL DEFAULT CURRENT_TIMESTAMP,
	  `type` char(10) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `CAS_Talklog` (
	  `ID` int(11) NOT NULL,
	  `UUID` varchar(50) NOT NULL,
	  `date` varchar(50) NOT NULL,
	  `TUID` varchar(50) NOT NULL,
	  `type` int(11) DEFAULT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;

	CREATE TABLE `CAS_User` (
	  `ID` int(11) NOT NULL,
	  `UUID` varchar(50) NOT NULL,
	  `username` varchar(50) NOT NULL,
	  `pwd` varchar(50) NOT NULL,
	  `name` varchar(50) NOT NULL,
	  `session` varchar(50) DEFAULT NULL,
	  `permission` varchar(50) NOT NULL,
	  `birthday` date DEFAULT NULL,
	  `QQ` varchar(50) DEFAULT NULL,
	  `mail` varchar(50) DEFAULT NULL,
	  `phone` varchar(50) DEFAULT NULL,
	  `university` varchar(50) NOT NULL
	) ENGINE=InnoDB DEFAULT CHARSET=utf8;


	ALTER TABLE `CAS_Calendar`
	  ADD PRIMARY KEY (`ID`);

	ALTER TABLE `CAS_Notice`
	  ADD PRIMARY KEY (`ID`),
	  ADD UNIQUE KEY `GUID_UNIQUE` (`GUID`);

	ALTER TABLE `CAS_Photo`
	  ADD PRIMARY KEY (`ID`);

	ALTER TABLE `CAS_Talk`
	  ADD PRIMARY KEY (`ID`),
	  ADD UNIQUE KEY `ID_UNIQUE` (`ID`),
	  ADD UNIQUE KEY `GUID_UNIQUE` (`GUID`);

	ALTER TABLE `CAS_Talklog`
	  ADD PRIMARY KEY (`ID`),
	  ADD UNIQUE KEY `ID_UNIQUE` (`ID`);

	ALTER TABLE `CAS_User`
	  ADD PRIMARY KEY (`ID`),
	  ADD UNIQUE KEY `username_UNIQUE` (`username`),
	  ADD UNIQUE KEY `ID_UNIQUE` (`ID`),
	  ADD UNIQUE KEY `UUID_UNIQUE` (`UUID`);


	ALTER TABLE `CAS_Calendar`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
	ALTER TABLE `CAS_Notice`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
	ALTER TABLE `CAS_Photo`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
	ALTER TABLE `CAS_Talk`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
	ALTER TABLE `CAS_Talklog`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;
	ALTER TABLE `CAS_User`
	  MODIFY `ID` int(11) NOT NULL AUTO_INCREMENT;

IF YOU NEED HELP, CONTACT ME USING EMAIL.
