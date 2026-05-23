package Utils;

import jakarta.xml.bind.DatatypeConverter;
import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

/**
 * MD5 mật khẩu (hex chữ HOA) — dùng cho lưu DB và đăng nhập.
 */
public class MD5Hashing {

    public String hashPassword(String input) {
        if (input == null) {
            return "";
        }
        try {
            MessageDigest md = MessageDigest.getInstance("MD5");
            md.update(input.getBytes());
            byte[] digest = md.digest();
            return DatatypeConverter.printHexBinary(digest).toUpperCase();
        } catch (NoSuchAlgorithmException e) {
            System.out.println("Hashing error: " + e);
            return "";
        }
    }

    public static String hash(String plain) {
        return new MD5Hashing().hashPassword(plain);
    }

    /** So khớp mật khẩu nhập với giá trị trong DB (MD5 hoặc plain cũ). */
    public static boolean matches(String plain, String stored) {
        if (plain == null || stored == null) {
            return false;
        }
        String hashed = hash(plain);
        if (hashed.equalsIgnoreCase(stored.trim())) {
            return true;
        }
        return plain.equals(stored);
    }

    /** Hash plain text; giữ nguyên nếu đã là chuỗi MD5 32 ký tự hex. */
    public static String encodeForStorage(String password) {
        if (password == null || password.isEmpty()) {
            return password;
        }
        if (isMd5Hex(password)) {
            return password.toUpperCase();
        }
        return hash(password);
    }

    public static boolean isMd5Hex(String value) {
        return value != null && value.length() == 32 && value.matches("[0-9A-Fa-f]{32}");
    }
}
