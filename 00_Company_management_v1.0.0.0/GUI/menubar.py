import streamlit as st
from streamlit_option_menu import option_menu


#------------------ MAIN MENU ----------------
# main_menu: hiển thị menu chính với các lựa chọn, sử dụng streamlit_option_menu.
#--------------------------------------------------
def sidebar_menu(role=1):
    if "eqp_open" not in st.session_state:
        st.session_state.eqp_open = False

    # Label có mũi tên
    eqp_label = "EQP Manager ▼" if st.session_state.eqp_open else "EQP Manager ▶"

    menu_items = [eqp_label, "Tool Manager", "Order", "Change Password"]
    icons = ["gear", "tools", "cart", "lock"]

    if role == 0:
        menu_items.append("Quản lý tài khoản")
        icons.append("people")

    menu_items.append("Đăng xuất")
    icons.append("box-arrow-right")

    with st.sidebar:
        selected = option_menu(
            "Menu",
            menu_items,
            icons=icons,
            menu_icon="list",
            default_index=0,
            orientation="vertical",
            key="sidebar_menu",
        )

        sub_selected = None
        if selected.startswith("EQP Manager"):
            st.session_state.eqp_open = True
            # render submenu ngay bên dưới
            sub_selected = option_menu(
                "",
                ["Overview", "ListEQP"],
                icons=["eye", "list"],
                menu_icon="",
                default_index=0,
                orientation="vertical",
                key="eqp_submenu",
                styles={
                    "container": {"padding": "0!important", "background-color": "#222"},
                    "icon": {"color": "white", "font-size": "14px"},
                    "nav-link": {
                        "font-size": "14px",
                        "text-align": "left",
                        "margin": "0px",
                        "--hover-color": "#333",
                    },
                    "nav-link-selected": {"background-color": "#a00"},
                }
            )
        else:
            st.session_state.eqp_open = False

    return selected, sub_selected
