import streamlit as st
from Configuration.db_config import fetch_query, ROLE_MAP


def show_greeting():
    # Lấy username và role từ DB
    user_info = fetch_query(
        "SELECT username, role_id FROM \"users\" WHERE id=%s",
        (st.session_state.user_id,)
    )
    if user_info:
        uname = user_info[0][0]
        role_id = user_info[0][1]
        role_name = ROLE_MAP.get(role_id, "Unknown")

        # Hiển thị lời chào ở góc trái trên sidebar
        with st.sidebar:
            st.markdown(
                f"""
                <div style="font-size:16px; color:white; margin-bottom:20px;">
                👋 Xin chào <b>{uname}</b><br>
                Quyền: <i>{role_name}</i>
                </div>
                """,
                unsafe_allow_html=True
            )




