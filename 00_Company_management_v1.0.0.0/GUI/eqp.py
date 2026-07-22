import streamlit as st
from streamlit_option_menu import option_menu
from Configuration.db_config import execute_query, fetch_query
#------------------ EQP MANAGER ----------------
# eqp_manager: trang quản lý thiết bị, chỉ admin và manager có quyền truy cập
#--------------------------------------------------
def eqp_manager(role):
    st.title("EQP Manager")

    # Menu con cho EQP Manager
    sub_menu = option_menu(
        menu_title=None,
        options=["EQP List", "EQP Report"],
        icons=["list", "file-earmark-text"],
        orientation="horizontal",
        key="eqp_submenu"
    )

    if sub_menu == "EQP List":
        eqp_list_page(role)
    elif sub_menu == "EQP Report":
        st.write("Trang báo cáo thiết bị")

#------------------ EQP LIST PAGE ----------------
# eqp_list_page: hiển thị danh sách thiết bị, cho phép thêm/xóa
#--------------------------------------------------
def render_eqp_item(eid, name, code, quantity, status, note, image, role):
    with st.container():
        st.markdown("---")
        cols = st.columns([3, 2])
        with cols[0]:
            st.markdown(
                f"""
                **🔧 {name}**  
                - Mã: {code}  
                - Số lượng: {quantity}  
                - Trạng thái: {status}  
                - Ghi chú: {note}
                """
            )
            if image:
                st.image(image, width=150)

        with cols[1]:
            if role in [0, 1, 2]:
                # Nếu chưa bật chế độ xác nhận xóa
                if not st.session_state.get(f"delete_mode_{eid}", False):
                    if st.button("🗑️ Xóa", key=f"delete_{eid}"):
                        st.session_state[f"delete_mode_{eid}"] = True
                        st.rerun()
                else:
                    st.warning(f"Bạn có chắc muốn xóa thiết bị {name}?")
                    col1, col2 = st.columns(2)
                    with col1:
                        if st.button("✅ Đồng ý", key=f"confirm_delete_{eid}"):
                            execute_query("DELETE FROM eqplist WHERE id=%s", (eid,))
                            st.success(f"Đã xóa thiết bị {name}")
                            del st.session_state[f"delete_mode_{eid}"]
                            st.rerun()
                    with col2:
                        if st.button("❌ Hủy", key=f"cancel_delete_{eid}"):
                            del st.session_state[f"delete_mode_{eid}"]
                            st.info("Đã hủy xóa thiết bị")
                            st.rerun()

                if st.button("✏️ Sửa", key=f"edit_{eid}"):
                    st.session_state[f"edit_mode_{eid}"] = True



def render_edit_form(eid, name, code, quantity, status, note, image):
    st.markdown("### ✏️ Chỉnh sửa thiết bị")
    new_name = st.text_input("Tên thiết bị", value=name, key=f"edit_name_{eid}")
    new_code = st.text_input("Mã thiết bị", value=code, key=f"edit_code_{eid}")
    new_quantity = st.number_input("Số lượng", min_value=0, step=1, value=quantity, key=f"edit_quantity_{eid}")
    new_status = st.selectbox("Trạng thái", ["Hoạt động", "Ngừng", "Bảo trì"],
                              index=["Hoạt động","Ngừng","Bảo trì"].index(status), key=f"edit_status_{eid}")
    new_note = st.text_area("Ghi chú", value=note, key=f"edit_note_{eid}")
    new_image = st.file_uploader("Ảnh thiết bị (chọn để thay)", type=["png","jpg","jpeg"], key=f"edit_image_{eid}")

    col1, col2 = st.columns(2)
    with col1:
        if st.button("💾 Lưu", key=f"save_{eid}"):
            image_path = image
            if new_image is not None:
                import os
                os.makedirs("static/images", exist_ok=True)
                image_path = f"static/images/{new_image.name}"
                with open(image_path, "wb") as f:
                    f.write(new_image.getbuffer())

            existing = fetch_query("SELECT id FROM eqplist WHERE code=%s AND id<>%s", (new_code, eid))
            if existing:
                st.error(f"❌ Mã thiết bị {new_code} đã tồn tại.")
            else:
                execute_query(
                    "UPDATE eqplist SET name=%s, code=%s, quantity=%s, status=%s, note=%s, image=%s WHERE id=%s",
                    (new_name, new_code, new_quantity, new_status, new_note, image_path, eid),
                )
                st.success(f"✅ Đã cập nhật thiết bị {new_name}")
                del st.session_state[f"edit_mode_{eid}"]
                st.rerun()

    with col2:
        if st.button("❌ Hủy", key=f"cancel_{eid}"):
            del st.session_state[f"edit_mode_{eid}"]
            st.info("Đã hủy chỉnh sửa")
            st.rerun()


def render_add_form(role):
    if role in [0, 1, 2]:
        st.markdown("### ➕ Thêm thiết bị mới")

        new_name = st.text_input("Tên thiết bị", key="new_name")
        new_code = st.text_input("Mã thiết bị", key="new_code")
        new_quantity = st.number_input("Số lượng", min_value=0, step=1, key="new_quantity")
        new_status = st.selectbox("Trạng thái", ["Hoạt động", "Ngừng", "Bảo trì"], key="new_status")
        new_note = st.text_area("Ghi chú", key="new_note")
        new_image = st.file_uploader("Ảnh thiết bị", type=["png", "jpg", "jpeg"], key="new_image")

        col1, col2 = st.columns(2)
        with col1:
            if st.button("Thêm thiết bị"):
                if not new_name or not new_code or new_quantity is None or not new_status or not new_note or new_image is None:
                    st.error("⚠️ Vui lòng nhập đầy đủ tất cả các mục và chọn ảnh thiết bị.")
                else:
                    existing = fetch_query("SELECT id FROM eqplist WHERE code=%s", (new_code,))
                    if existing:
                        st.error(f"❌ Thiết bị với mã {new_code} đã tồn tại. Vui lòng nhập mã khác.")
                    else:
                        import os
                        os.makedirs("static/images", exist_ok=True)
                        image_path = f"static/images/{new_image.name}"
                        with open(image_path, "wb") as f:
                            f.write(new_image.getbuffer())

                        execute_query(
                            "INSERT INTO eqplist (name, code, quantity, status, note, image) VALUES (%s, %s, %s, %s, %s, %s)",
                            (new_name, new_code, new_quantity, new_status, new_note, image_path),
                        )
                        st.session_state["add_success"] = f"✅ Đã thêm thiết bị {new_name}"
                        for key in ["new_name", "new_code", "new_quantity", "new_status", "new_note", "new_image"]:
                            if key in st.session_state:
                                del st.session_state[key]
                        st.rerun()

        with col2:
            if st.button("❌ Hủy thêm mới"):
                for key in ["new_name", "new_code", "new_quantity", "new_status", "new_note", "new_image"]:
                    if key in st.session_state:
                        del st.session_state[key]
                st.info("Đã hủy thêm thiết bị")
                st.rerun()

        if "add_success" in st.session_state:
            st.success(st.session_state["add_success"])
            del st.session_state["add_success"]


def eqp_list_page(role):
    st.subheader("Quản lý thiết bị")
    tab1, tab2 = st.tabs(["📋 Danh sách thiết bị", "➕ Thêm thiết bị"])

    with tab1:
        eqps = fetch_query("SELECT id, name, code, quantity, status, note, image FROM eqplist ORDER BY id")
        search_text = st.text_input("🔍 Tìm kiếm theo tên hoặc mã")
        eqp_names = [name for _, name, _, _, _, _, _ in eqps]
        selected_eqp = st.selectbox("Chọn thiết bị", ["-- Tất cả --"] + eqp_names)

        filtered_eqps = []
        for eid, name, code, quantity, status, note, image in eqps:
            if search_text and (search_text.lower() in name.lower() or search_text.lower() in code.lower()):
                filtered_eqps.append((eid, name, code, quantity, status, note, image))
            elif selected_eqp != "-- Tất cả --" and name == selected_eqp:
                filtered_eqps.append((eid, name, code, quantity, status, note, image))
            elif not search_text and selected_eqp == "-- Tất cả --":
                filtered_eqps.append((eid, name, code, quantity, status, note, image))

        for eid, name, code, quantity, status, note, image in filtered_eqps:
            render_eqp_item(eid, name, code, quantity, status, note, image, role)
            if st.session_state.get(f"edit_mode_{eid}", False):
                render_edit_form(eid, name, code, quantity, status, note, image)

    with tab2:
        render_add_form(role)
