package Utils;

import java.util.regex.Pattern;

/** Validate form cập nhật tài khoản cá nhân (user / admin / staff). */
public final class AccountProfileValidator {

    private static final Pattern EMAIL = Pattern.compile(
            "^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}$");
    private static final Pattern PHONE_VN = Pattern.compile(
            "^(?:\\+?84|0)(3|5|7|8|9)[0-9]{8}$");

    private AccountProfileValidator() {
    }

    /**
     * @return null nếu hợp lệ; ngược lại thông báo lỗi tiếng Việt.
     */
    public static String validate(String fullname, String email, String phone,
            String newPassword, String confirmPassword) {
        Validation v = new Validation();
        if (v.isBlank(fullname)) {
            return "Họ tên không được để trống.";
        }
        if (fullname.trim().length() > 200) {
            return "Họ tên tối đa 200 ký tự.";
        }
        if (v.isBlank(email)) {
            return "Email không được để trống.";
        }
        String emailNorm = email.trim().toLowerCase();
        if (!EMAIL.matcher(emailNorm).matches()) {
            return "Email không đúng định dạng.";
        }
        if (v.isBlank(phone)) {
            return "Số điện thoại không được để trống.";
        }
        String phoneNorm = phone.trim().replaceAll("[\\s.-]", "");
        if (!PHONE_VN.matcher(phoneNorm).matches()) {
            return "Số điện thoại không hợp lệ (VD: 0912345678).";
        }
        boolean changingPwd = newPassword != null && !newPassword.trim().isEmpty();
        boolean hasConfirm = confirmPassword != null && !confirmPassword.trim().isEmpty();
        if (changingPwd) {
            if (newPassword.trim().length() < 6) {
                return "Mật khẩu mới tối thiểu 6 ký tự.";
            }
            if (!newPassword.equals(confirmPassword)) {
                return "Mật khẩu xác nhận không khớp.";
            }
        } else if (hasConfirm) {
            return "Vui lòng nhập mật khẩu mới nếu muốn đổi mật khẩu.";
        }
        return null;
    }

    public static String normalizePhone(String phone) {
        if (phone == null) {
            return "";
        }
        return phone.trim().replaceAll("[\\s.-]", "");
    }

    public static String normalizeEmail(String email) {
        return email == null ? "" : email.trim().toLowerCase();
    }
}
