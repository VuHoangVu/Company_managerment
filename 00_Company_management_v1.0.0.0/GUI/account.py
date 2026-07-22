import streamlit as st
import bcrypt
from Configuration.db_config import execute_query, fetch_query, ROLE_MAP, DEPARTMENT_MAP
from Configuration.sql_queries import (
    SQL_APPROVE_USER,
    SQL_COMMIT_RESET_PASSWORD,
    SQL_DELETE_USER,
    SQL_DELETE_USER_TOKENS,
    SQL_GET_ALL_USERS,
    SQL_GET_ID_BY_USERNAME,
    SQL_INSERT_ADMIN_USER,
    SQL_REJECT_RESET_REQUEST,
)


#------------------ ACCOUNT MANAGER ----------------
# account_manager: trang quản lý tài khoản, chỉ admin có quyền truy cập.
#--------------------------------------------------
def user_info(uid, uname, role_id, department_id, created_at, approved, reset_requested):
    role_name = ROLE_MAP.get(role_id, "Unknown")
    department_name = DEPARTMENT_MAP.get(department_id, "Unknown") if 'department_id' in locals() else "Unknown"
    st.markdown(
        f"""
        **👤 {uname}**  
        - Role: **{role_name}**  
        - Phòng ban: **{department_name}**  
        - Ngày tạo: {created_at}  
        - Duyệt: {approved}  
        - Reset yêu cầu: {reset_requested}
        """
    )


def user_actions(uid, uname, role_id, department_id, approved, reset_requested):
    if not approved:
        new_role_name = st.selectbox(
            f"Role cho {uname}", list(ROLE_MAP.values()), key=f"role_{uid}"
        )
        new_role_id = [k for k, v in ROLE_MAP.items() if v == new_role_name][0]

        if st.button(f"✅ Phê duyệt", key=f"approve_{uid}"):
            execute_query("ACCOUNT", SQL_APPROVE_USER, (new_role_id, uid))
            st.success(f"Đã phê duyệt {uname} với role {new_role_name}")
            st.rerun()

        if st.button(f"❌ Reject", key=f"reject_{uid}"):
            execute_query("ACCOUNT", SQL_DELETE_USER_TOKENS, (uid,))
            execute_query("ACCOUNT", SQL_DELETE_USER, (uid,))
            st.warning(f"Đã xóa {uname}")
            st.rerun()

    elif reset_requested:
        if st.button(f"🔄 Phê duyệt reset", key=f"approve_reset_{uid}"):
            new_pw = bcrypt.hashpw("1".encode("utf-8"), bcrypt.gensalt()).decode("utf-8")
            execute_query("ACCOUNT", SQL_COMMIT_RESET_PASSWORD, (new_pw, uid))
            st.success(f"Đã reset mật khẩu cho {uname} về '1'")
            st.rerun()

        if st.button(f"🚫 Từ chối reset", key=f"reject_reset_{uid}"):
            execute_query("ACCOUNT", SQL_REJECT_RESET_REQUEST, (uid,))
            st.warning(f"Đã từ chối yêu cầu reset của {uname}")
            st.rerun()

    else:
        # Không hiển thị nút Xóa cho admin
        if uname.lower() != "admin" and role_id != 0:
            if not st.session_state.get(f"delete_mode_{uid}", False):
                if st.button(f"🗑️ Xóa", key=f"delete_{uid}"):
                    st.session_state[f"delete_mode_{uid}"] = True
                    st.rerun()
            else:
                st.warning(f"Bạn có chắc muốn xóa tài khoản {uname}?")
                col1, col2 = st.columns(2)
                with col1:
                    if st.button("✅ Đồng ý", key=f"confirm_delete_{uid}"):
                        execute_query("ACCOUNT", SQL_DELETE_USER_TOKENS, (uid,))
                        execute_query("ACCOUNT", SQL_DELETE_USER, (uid,))
                        st.success(f"Đã xóa {uname}")
                        del st.session_state[f"delete_mode_{uid}"]
                        st.rerun()
                with col2:
                    if st.button("❌ Hủy", key=f"cancel_delete_{uid}"):
                        del st.session_state[f"delete_mode_{uid}"]
                        st.info("Đã hủy xóa tài khoản")
                        st.rerun()


def account_manager():
    st.title("Quản lý tài khoản")

    users = fetch_query("ACCOUNT",SQL_GET_ALL_USERS)

    for user in users:
        uid, uname, department_id, role_id, created_at, approved, reset_requested = user
        with st.container():
            st.markdown("---")
            cols = st.columns([3, 2])
            with cols[0]:
                user_info(uid, uname, department_id, role_id, created_at, approved, reset_requested)
            with cols[1]:
                user_actions(uid, uname, department_id, role_id, approved, reset_requested)

def init_admin_account():
    # Kiểm tra xem đã có admin chưa
    existing_admin = execute_query("ACCOUNT", SQL_GET_ID_BY_USERNAME, ("admin",))

    if not existing_admin:  # chỉ tạo nếu chưa có
        username = "admin"
        password = "admin"  # mật khẩu mặc định
        hashed_pw = bcrypt.hashpw(password.encode("utf-8"), bcrypt.gensalt()).decode("utf-8")

        execute_query("ACCOUNT", SQL_INSERT_ADMIN_USER, (username, hashed_pw, 0, True))
        print("Admin account created: username=admin, password=admin123")
    else:
        print("Admin account already exists")