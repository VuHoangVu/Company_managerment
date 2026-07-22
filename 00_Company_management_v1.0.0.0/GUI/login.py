import streamlit as st
import bcrypt
import secrets
import uuid
from Configuration.db_config import execute_query, fetch_query
from Configuration.sql_queries import (
    SQL_GET_ID_BY_USERNAME,
    SQL_GET_PASSWORD_HASH_BY_ID,
    SQL_GET_USER_BY_USERNAME,
    SQL_INSERT_USER,
    SQL_UPDATE_USER_PASSWORD,
    SQL_REQUEST_RESET_PASSWORD,
    SQL_DISABLE_OLD_TOKENS,
    SQL_INSERT_NEW_TOKEN,
    SQL_DISABLE_TOKEN_BY_DEVICE
)
from streamlit_cookies_manager import EncryptedCookieManager

#------------------ HASH PASSWORD ----------------
# hash_pw: tạo hash mật khẩu với salt.
#--------------------------------------------------
def hash_pw(password: str) -> str:
    # tạo salt và hash mật khẩu
    salt = bcrypt.gensalt()
    hashed = bcrypt.hashpw(password.encode("utf-8"), salt)
    return hashed.decode("utf-8")

#------------------ CHECK PASSWORD ----------------
# check_pw: kiểm tra mật khẩu nhập vào với hash trong DB.
#--------------------------------------------------
def check_pw(password: str, hashed_pw: str) -> bool:
    return bcrypt.checkpw(password.encode("utf-8"), hashed_pw.encode("utf-8"))

#------------------ LOGIN ----------------
# login_page: xử lý đăng nhập, kiểm tra username/password.
#--------------------------------------------------
cookies = EncryptedCookieManager(
    prefix="eqp_app_user",   # prefix riêng
    password="111111"
)

if not cookies.ready():
    st.stop()

# Khởi tạo device_id nếu chưa có
if "device_id" not in cookies or not cookies.get("device_id"):
    import uuid
    cookies["device_id"] = str(uuid.uuid4())
    cookies.save()

device_id = cookies.get("device_id")

def login_page(username, password):
    user = fetch_query("ACCOUNT", SQL_GET_USER_BY_USERNAME, (username,))
    if user and check_pw(password, user[0][2]):
        # Vô hiệu hóa token cũ của user trên thiết bị hiện tại
        execute_query("ACCOUNT", SQL_DISABLE_OLD_TOKENS, (user[0][0], device_id))

        # Sinh token mới cho thiết bị này
        token = secrets.token_hex(16)
        execute_query("ACCOUNT", SQL_INSERT_NEW_TOKEN, (user[0][0], token, device_id))

        cookies["token"] = token
        cookies.save()

        # Lưu thông tin vào session_state
        st.session_state.logged_in = True
        st.session_state.role = user[0][1]
        st.session_state.user_id = user[0][0]
        st.session_state.device_id = device_id
        st.success("Đăng nhập thành công!")
        st.rerun()
    else:
        st.error("Sai thông tin hoặc chưa được duyệt")
#------------------ REGISTER ----------------
# register_page: xử lý đăng ký tài khoản mới, lưu vào DB với trạng thái chưa được duyệt.
#--------------------------------------------------
def register_page():
    st.subheader("Tạo tài khoản mới")
    username = st.text_input("Nhập username")
    password = st.text_input("Nhập mật khẩu", type="password")

    if st.button("Đăng ký"):
        hashed_pw = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
        execute_query("ACCOUNT", SQL_INSERT_USER, (username, hashed_pw, False))
        st.info("Tài khoản đã được tạo. Vui lòng chờ admin duyệt.")

# ---------------- FORGOT PASSWORD ----------------
# forgot_password_page: xử lý yêu cầu quên mật khẩu, gửi thông báo để admin duyệt.
# --------------------------------------------------
def forgot_password_page():
    st.subheader("Quên mật khẩu")
    username = st.text_input("Nhập username cần reset")

    if st.button("Gửi yêu cầu reset"):
        # Kiểm tra username có tồn tại không
        user = fetch_query(SQL_GET_ID_BY_USERNAME, (username,))
        if not user:
            st.error("Không tìm thấy username này.")
        else:
            # Đánh dấu yêu cầu reset, không reset ngay
            execute_query(SQL_REQUEST_RESET_PASSWORD, (user[0][0],))
            st.info("Yêu cầu reset mật khẩu đã gửi đến admin để phê duyệt.")

#------------------ LOGOUT ----------------
# logout: xử lý đăng xuất, xóa token khỏi session_state và DB.
#--------------------------------------------------
def logout():
    token = cookies.get("token")
    device_id = cookies.get("device_id")
    if token and device_id:
        # Chỉ vô hiệu hóa token của thiết bị hiện tại
        execute_query(SQL_DISABLE_TOKEN_BY_DEVICE, (token, device_id))
        cookies["token"] = ""
        cookies.save()

    st.session_state.logged_in = False
    st.session_state.token = None
    st.session_state.role = None
    st.session_state.device_id = None
    st.rerun()

#------------------ CHANGE PASSWORD ----------------
# change_password_page: xử lý đổi mật khẩu cho user đã đăng nhập.
#--------------------------------------------------
def change_password_page():
    st.subheader("Đổi mật khẩu")

    old_pw = st.text_input("Mật khẩu cũ", type="password")
    new_pw = st.text_input("Mật khẩu mới", type="password")
    confirm_pw = st.text_input("Xác nhận mật khẩu mới", type="password")

    if st.button("Đổi mật khẩu"):
        user = fetch_query(SQL_GET_PASSWORD_HASH_BY_ID, (st.session_state.user_id,))
        if not user:
            st.error("Không tìm thấy tài khoản.")
            return

        stored_hash = user[0][0]

        if not bcrypt.checkpw(old_pw.encode("utf-8"), stored_hash.encode("utf-8")):
            st.error("Mật khẩu cũ không đúng.")
            return

        if new_pw != confirm_pw:
            st.error("Mật khẩu mới không khớp.")
            return

        new_hash = bcrypt.hashpw(new_pw.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
        execute_query(SQL_UPDATE_USER_PASSWORD, (new_hash, st.session_state.user_id))
        st.success("Đổi mật khẩu thành công!")