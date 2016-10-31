CREATE DATABASE IF NOT EXISTS ibm_ucd character set utf8 collate utf8_bin;
CREATE USER IF NOT EXISTS 'ibm_ucd'@'localhost' IDENTIFIED BY 'password';
GRANT ALL ON ibm_ucd.* TO 'ibm_ucd'@'%' IDENTIFIED BY 'password' WITH GRANT OPTION;
FLUSH PRIVILEGES;
