CREATE TABLE IF NOT EXISTS {{ index .Options "Namespace" }}refresh_tokens (
  instance_id varchar(255) DEFAULT NULL,
  id BIGSERIAL PRIMARY KEY,
  token varchar(255) DEFAULT NULL,
  user_id varchar(255) DEFAULT NULL,
  revoked BOOLEAN DEFAULT FALSE,
  created_at timestamp NULL DEFAULT NULL,
  updated_at timestamp NULL DEFAULT NULL
) ;

CREATE INDEX  IF NOT EXISTS users_instance_id_idx  ON {{ index .Options "Namespace" }}refresh_tokens (instance_id);

CREATE INDEX  IF NOT EXISTS refresh_tokens_instance_id_user_id_idx  ON {{ index .Options "Namespace" }}refresh_tokens (instance_id, user_id);

CREATE INDEX  IF NOT EXISTS refresh_tokens_token_idx  ON {{ index .Options "Namespace" }}refresh_tokens (token);

