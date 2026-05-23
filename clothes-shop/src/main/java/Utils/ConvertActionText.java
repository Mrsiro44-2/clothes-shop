package Utils;

/**
 *
 * @author HP
 */
public class ConvertActionText {

    public String convertActionText(String act, int status) {
        String messange = "";
        switch (act) {
            case "add-new":
                if (status == 1) {
                    messange = "Thêm thành công";
                } else {
                    messange = "Thêm thất bại. Thử lại";
                }
                break;
            case "update-account":
                if (status == 1) {
                    messange = "Cập nhật tài khoản thành công";
                } else if (status == 2) {
                    messange = "Email đã được sử dụng. Vui lòng dùng email khác";
                } else {
                    messange = "Cập nhật thất bại. Vui lòng thử lại";
                }
                break;
            case "add-voucher":
                if (status == 1) {
                    messange = "Add voucher successfully";
                } else if (status == 0) {
                    messange = "Add voucher fail. Try again";
                } else {
                    messange = "Voucher is exist in system";
                }
                break;
            case "update-voucher":
                if (status == 1) {
                    messange = "Update successfully";
                } else if (status == 2) {
                    messange = "Voucher is exist in system";
                } else {
                    messange = "Update fail. Try again";
                }
                break;
            case "delete":
                if (status == 1) {
                    messange = "Delete successfully";
                } else if (status == 2) {
                    messange = "Please choose account to delete";
                } else {
                    messange = "Delete fail. Try again";
                }
                break;
            case "add-cart":
                if (status == 1) {
                    messange = "Đã thêm vào giỏ hàng";
                } else if (status == 2) {
                    messange = "Số lượng vượt quá tồn kho";
                } else {
                    messange = "Không thể thêm vào giỏ hàng";
                }
                break;
            case "update-cart":
                if (status == 1) {
                    messange = "Đã cập nhật giỏ hàng";
                } else if (status == 2) {
                    messange = "Số lượng vượt quá tồn kho";
                } else {
                    messange = "Cập nhật giỏ hàng thất bại";
                }
                break;
            case "remove-cart":
                if (status == 1) {
                    messange = "Đã xóa sản phẩm khỏi giỏ";
                } else {
                    messange = "Xóa sản phẩm thất bại. Thử lại";
                }
                break;
            case "add-staff":
            case "add-candidate":
                if (status == 2) {
                    messange = "Tài khoản này đã tồn tại";
                } else if (status == 1) {
                    messange = "Thêm tài khoản thành công";
                } else if (status == 3) {
                    messange = "Email này đã được sử dụng";
                } else {
                    messange = "Thêm tài khoản thất bại. Thử lại";
                }
                break;
            case "add-company":
                if (status == 2) {
                    messange = "Email này đã được sử dụng";
                } else if (status == 1) {
                    messange = "Thêm tài khoản thành công";
                } else {
                    messange = "Thêm tài khoản thất bại. Thử lại";
                }
                break;
            case "update-candidate":
            case "update-staff":
            case "update-company":
            case "update-profile":
                if (status == 2) {
                    messange = "Email này đã được sử dụng";
                } else if (status == 1) {
                    messange = "Cập nhật tài khoản thành công";
                } else {
                    messange = "Cập nhật tài khoản thất bại. Thử lại";
                }
                break;
            case "update":
                if (status == 1) {
                    messange = "Cập nhật thành công";
                } else {
                    messange = "Cập nhật thất bại. Thử lại";
                }
                break;
            case "update-password":
                if (status == 1) {
                    messange = "Cập nhật mật khẩu thành công";
                } else if (status == 2) {
                    messange = "Mật khẩu cũ không hợp lệ";
                } else {
                    messange = "Cập nhật mật khẩu thất bại. Thử lại";
                }
                break;
            case "update-name":
                if (status == 1) {
                    messange = "Cập nhật thành công";
                } else if (status == 2) {
                    messange = "Tên này đã được sử dụng";
                } else {
                    messange = "Cập nhật thất bại. Thử lại";
                }
                break;
            case "update-profile-candidate":
                if (status == 1) {
                    messange = "Cập nhật thành công";
                } else if (status == 2) {
                    messange = "Email này đã được sử dụng";
                } else if (status == 3) {
                    messange = "Hãy nhập email mới";
                } else {
                    messange = "Cập nhật thất bại. Thử lại";
                }
                break;
            case "send-mail":
                if (status == 1) {
                    messange = "Gửi liên hệ đến ứng viên thành công.";
                } else {
                    messange = "Gửi liên hệ đến ứng viên thất bại.";
                }
                break;
        }
        return messange;
    }
}
