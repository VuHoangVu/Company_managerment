import streamlit as st
from utils import show_greeting
from GUI.account import account_manager
from GUI.menubar import sidebar_menu
from GUI.eqp import eqp_list_page
from GUI.tools import tool_manager
from GUI.oder import order_page
from GUI.login import login_page, register_page, forgot_password_page, cookies, logout, change_password_page
from Configuration.db_config import fetch_query

st.set_page_config(page_title="📝 EQP", layout="wide")

#--------------------------------
# Khởi tạo trạng thái đăng nhập và thông tin người dùng
#--------------------------------
if "logged_in" not in st.session_state:
    st.session_state.logged_in = False
    st.session_state.role = None
    st.session_state.token = None
    st.session_state.user_id = None

# Gọi init_admin_account nếu cần
#init_admin_account()

#--------------------------------
# Kiểm tra token trong cookies và xác thực người dùng
#--------------------------------
token = cookies.get("token")
device_id = cookies.get("device_id")

if token and device_id:
    token_data = fetch_query(
        "SELECT u.id, u.role_id FROM user_tokens t "
        "JOIN \"users\" u ON t.user_id = u.id "
        "WHERE t.token=%s AND t.device_id=%s AND t.valid=TRUE",
        (token, device_id)
    )
    if token_data:
        st.session_state.logged_in = True
        st.session_state.user_id = token_data[0][0]
        st.session_state.role = token_data[0][1]
        st.session_state.device_id = device_id   # lưu device_id vào session_state
        st.session_state.token = token           # lưu token vào session_state
    else:
        # Token không hợp lệ hoặc đã bị vô hiệu hóa cho thiết bị này
        st.session_state.logged_in = False
        st.session_state.user_id = None
        st.session_state.role = None
        st.session_state.device_id = None
        st.session_state.token = None
        cookies["token"] = ""
        cookies.save()
        st.warning("Phiên đăng nhập của bạn đã kết thúc.")

#--------------------------------
# Nếu người dùng chưa đăng nhập, hiển thị trang đăng nhập
#--------------------------------
if not st.session_state.logged_in:
    st.title("Đăng nhập hệ thống")
    tab1, tab2, tab3 = st.tabs(["Đăng nhập", "Tạo tài khoản mới", "Quên mật khẩu"])

    with tab1:
        username = st.text_input("Username")
        password = st.text_input("Password", type="password")
        if st.button("Đăng nhập"):
            login_page(username, password)

    with tab2:
        register_page()

    with tab3:
        forgot_password_page()

else:
    if st.session_state.logged_in:
        # Hiển thị lời chào
        show_greeting()
        menu, sub_menu = sidebar_menu(st.session_state.role)

        if menu.startswith("EQP Manager"):
            if sub_menu == "Overview":
                st.title("EQP Overview")
                st.write("Trang tổng quan thiết bị")
            elif sub_menu == "ListEQP":
                eqp_list_page(st.session_state.role)
        elif menu == "Tool Manager":
            tool_manager()
        elif menu == "Order":
            order_page()
        elif menu == "Change Password":
            change_password_page()
        elif menu == "Quản lý tài khoản":
            account_manager()
        elif menu == "Đăng xuất":
            logout()
            st.session_state.logged_in = False


