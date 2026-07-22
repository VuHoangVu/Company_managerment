# sql_queries.py

#----------------------------------------
# ---------------- USERS ----------------
#----------------------------------------

#-------SElECT------
SQL_GET_ID_BY_USERNAME = """
SELECT id
FROM "users"
WHERE username=%s
"""

SQL_GET_USER_BY_USERNAME = """
SELECT id, role_id, password_hash 
FROM "users" 
WHERE username=%s AND approved=TRUE
"""

SQL_GET_PASSWORD_HASH_BY_ID = """
SELECT password_hash
FROM "users"
WHERE id=%s
"""

SQL_GET_ALL_USERS = """
SELECT id, username, department_id, role_id, created_at, approved, reset_requested
FROM "users"
ORDER BY created_at DESC
"""
#--------INSERT-------
SQL_INSERT_USER = """
INSERT INTO "users" (username, password_hash, approved) 
VALUES (%s, %s, %s)
"""

SQL_INSERT_ADMIN_USER = """
INSERT INTO "users" (username, password_hash, created_at, role_id, approved)
VALUES (%s, %s, NOW(), %s, %s)
"""
#--------UPDATE-------
SQL_UPDATE_USER_PASSWORD = """
UPDATE "users"
SET password_hash=%s
WHERE id=%s
"""

SQL_REQUEST_RESET_PASSWORD = """
UPDATE "users"
SET reset_requested=TRUE
WHERE id=%s
"""

SQL_COMMIT_RESET_PASSWORD = """
UPDATE "users"
SET password_hash=%s, reset_requested=FALSE
WHERE id=%s
"""

SQL_APPROVE_USER = """
UPDATE "users"
SET approved=TRUE, role_id=%s
WHERE id=%s
"""

SQL_REJECT_RESET_REQUEST = """
UPDATE "users"
SET reset_requested=FALSE
WHERE id=%s
"""

#--------- DELETE ----------
SQL_DELETE_USER = """
DELETE FROM "users"
WHERE id=%s
"""



#----------------------------------------
# ---------------- TOKENS ----------------
#----------------------------------------

#-------INSERT-------
SQL_INSERT_NEW_TOKEN = """
INSERT INTO user_tokens (user_id, token, device_id, valid) 
VALUES (%s, %s, %s, TRUE)
"""


#-------UPDATE-------
SQL_DISABLE_OLD_TOKENS = """
UPDATE user_tokens
SET valid=FALSE
WHERE user_id=%s AND device_id=%s
"""

SQL_DISABLE_TOKEN_BY_DEVICE = """
UPDATE user_tokens
SET valid=FALSE
WHERE token=%s AND device_id=%s
"""

#--------DELETE--------
SQL_DELETE_USER_TOKENS = """
DELETE FROM user_tokens
WHERE user_id=%s
"""