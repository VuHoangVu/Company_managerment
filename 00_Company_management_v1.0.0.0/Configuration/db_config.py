from dotenv import load_dotenv
import os

load_dotenv()

#------------------ DB CONFIGS ----------------
# DB_CONFIGS: cấu hình kết nối đến các cơ sở dữ liệu PostgreSQL.
#--------------------------------------------------
DB_CONFIGS = {
    "Account": {
        "host": os.getenv("DB_ACCOUNT_HOST"),
        "port": os.getenv("DB_ACCOUNT_PORT"),
        "database": os.getenv("DB_ACCOUNT_NAME"),
        "user": os.getenv("DB_ACCOUNT_USER"),
        "password": os.getenv("DB_ACCOUNT_PASSWORD")
    },
    "EQP": {
        "host": os.getenv("DB_EQP_HOST"),
        "port": os.getenv("DB_EQP_PORT"),
        "database": os.getenv("DB_EQP_NAME"),
        "user": os.getenv("DB_EQP_USER"),
        "password": os.getenv("DB_EQP_PASSWORD")
    },
    "QA": {
        "host": os.getenv("DB_QA_HOST"),
        "port": os.getenv("DB_QA_PORT"),
        "database": os.getenv("DB_QA_NAME"),
        "user": os.getenv("DB_QA_USER"),
        "password": os.getenv("DB_QA_PASSWORD")
    }
}

#-------------------------------------------
#-------------------------------------------
# Mapping role_id -> tên role
ROLE_MAP = {
    0: "Admin",
    10: "President",
    20: "CEO",
    30: "Manager",
    40: "Team Leader",
    50: "Leader",
    60: "Staff",
    70: "Employee",
}
# Mapping department_id -> tên phòng ban
DEPARTMENT_MAP = {
    0: "Admin",
    10: "Director",
    20: "HCNS",
    30: "PIE",
    40: "QA",
    50: "PD",
    60: "IT",
    70: "FAC",
    80: "KITTING",
    90: "EHS",
}

#------------------ execute_query ----------------
#execute_query: dùng cho insert/update/delete, trả về None.
#-------------------------------------------------
def execute_query(db_name, query, params=None, fetch=False):
    conn = DB_CONFIGS[db_name]
    cur = conn.cursor()
    cur.execute(query, params)
    data = cur.fetchall() if fetch else None
    conn.commit()
    cur.close()
    conn.close()
    return data
#------------------ fetch_query ----------------
#fetch_query: chỉ dùng cho select, trả về dữ liệu dạng list of tuples.
#insert/update/delete.
#-------------------------------------------------
def fetch_query(db_name, query, params=None):
    conn = DB_CONFIGS[db_name]
    cur = conn.cursor()
    cur.execute(query, params)
    data = cur.fetchall()
    cur.close()
    conn.close()
    return data

