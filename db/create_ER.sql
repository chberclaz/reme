SET @OLD_UNIQUE_CHECKS=@@UNIQUE_CHECKS, UNIQUE_CHECKS=0;
SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0;
SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='TRADITIONAL';

CREATE SCHEMA IF NOT EXISTS re_me DEFAULT CHARACTER SET latin1 COLLATE latin1_swedish_ci ;
USE re_me ;

-- -----------------------------------------------------
-- Table re_me.benutzer
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.benutzer (
  UID INT NOT NULL ,
  VName VARCHAR(45) NULL ,
  NName VARCHAR(45) NULL ,
  Email VARCHAR(255) NULL ,
  pwdHash CHAR(32) NULL ,
  PRIMARY KEY (UID) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.re_me
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.re_me (
  UID INT NOT NULL ,
  RID INT NOT NULL ,
  Title VARCHAR(32) NULL ,
  content VARCHAR(160) NULL ,
  createDate TIMESTAMP NULL ,
  PRIMARY KEY (UID, RID) ,
  INDEX UID (UID ASC) ,
  CONSTRAINT UID
    FOREIGN KEY (UID )
    REFERENCES re_me.benutzer (UID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.beinhaltet
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.beinhaltet (
  UID INT NOT NULL ,
  ownerUID INT NOT NULL ,
  RID INT NOT NULL ,
  PRIMARY KEY (UID, ownerUID, RID) ,
  INDEX beinhaltet_re_me (ownerUID ASC, RID ASC) ,
  INDEX beinhaltet_Benutzer (UID ASC) ,
  CONSTRAINT beinhaltet_Benutzer
    FOREIGN KEY (UID )
    REFERENCES re_me.benutzer (UID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT beinhaltet_re_me
    FOREIGN KEY (ownerUID , RID )
    REFERENCES re_me.re_me (UID , RID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.benutzergruppe
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.benutzergruppe (
  UID INT NOT NULL ,
  GID INT NOT NULL ,
  GroupName VARCHAR(45) NULL ,
  PRIMARY KEY (UID, GID) ,
  INDEX UID_user (UID ASC) ,
  CONSTRAINT UID_user
    FOREIGN KEY (UID )
    REFERENCES re_me.benutzer (UID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.zugehoerig
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.zugehoerig (
  ownerUID INT NOT NULL ,
  GID INT NOT NULL ,
  RID INT NOT NULL ,
  PRIMARY KEY (ownerUID, GID, RID) ,
  INDEX zugehoerig_re_me (ownerUID ASC, RID ASC) ,
  INDEX zugehoerig_Bgruppe (GID ASC, ownerUID ASC) ,
  CONSTRAINT zugehoerig_Bgruppe
    FOREIGN KEY (GID , ownerUID )
    REFERENCES re_me.benutzergruppe (GID , UID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT zugehoerig_re_me
    FOREIGN KEY (ownerUID , RID )
    REFERENCES re_me.re_me (UID , RID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.gruppenzugehoerigkeit
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.gruppenzugehoerigkeit (
  ownerUID INT NOT NULL ,
  GID INT NOT NULL ,
  UID INT NOT NULL ,
  PRIMARY KEY (ownerUID, GID, UID) ,
  INDEX userID (UID ASC) ,
  INDEX owner (ownerUID ASC, GID ASC) ,
  CONSTRAINT owner
    FOREIGN KEY (ownerUID , GID )
    REFERENCES re_me.benutzergruppe (UID , GID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT userID
    FOREIGN KEY (UID )
    REFERENCES re_me.benutzer (UID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB
COMMENT = 'Benutzer_UID';


-- -----------------------------------------------------
-- Table re_me.inhalt
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.inhalt (
  InhaltName VARCHAR(255) NOT NULL ,
  PRIMARY KEY (InhaltName) )
ENGINE = InnoDB;


-- -----------------------------------------------------
-- Table re_me.attrInhalt
-- -----------------------------------------------------
CREATE  TABLE IF NOT EXISTS re_me.attrInhalt (
  UID INT NOT NULL ,
  RID INT NOT NULL ,
  InhaltName VARCHAR(255) NOT NULL ,
  InhaltWert VARCHAR(255) NULL ,
  PRIMARY KEY (UID, RID, InhaltName) ,
  INDEX inhaltAtr (InhaltName ASC) ,
  INDEX re_me_ID (UID ASC, RID ASC) ,
  CONSTRAINT re_me_ID
    FOREIGN KEY (UID , RID )
    REFERENCES re_me.re_me (UID , RID )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION,
  CONSTRAINT inhaltAtr
    FOREIGN KEY (InhaltName )
    REFERENCES re_me.inhalt (InhaltName )
    ON DELETE NO ACTION
    ON UPDATE NO ACTION)
ENGINE = InnoDB;



SET SQL_MODE=@OLD_SQL_MODE;
SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS;
SET UNIQUE_CHECKS=@OLD_UNIQUE_CHECKS;
