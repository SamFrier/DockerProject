CREATE DATABASE IF NOT EXISTS uDeploy;
CREATE USER 'udeploy'@'localhost' IDENTIFIED BY 'urbancode';
GRANT ALL ON uDeploy.* TO 'udeploy'@'localhost' WITH GRANT OPTION;
