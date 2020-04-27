CREATE TABLE IF NOT EXISTS {{ index .Options "Namespace" }}instances (
  id varchar(255) NOT NULL,
  uuid varchar(255) DEFAULT NULL,
  raw_base_config text,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL,
  PRIMARY KEY (id)
) ;
