package utils;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;

public class AuthUtils {
    public static String hashPassword(String password) {
        try {
            MessageDigest md = MessageDigest.getInstance("SHA-256");
            md.update(password.getBytes());
            byte[] bytes = md.digest();
            StringBuilder result = new StringBuilder();
            for (byte b : bytes) {
                result.append(String.format("%02x", b));
            }
            return result.toString().substring(0, 50); 
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
            return password; 
        }
    }
}