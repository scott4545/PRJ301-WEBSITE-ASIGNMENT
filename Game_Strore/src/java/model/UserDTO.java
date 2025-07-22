package model;

public class UserDTO {

    private int userID;
    private String username;
    private String password;
    private String userRole;

    public UserDTO() {
    }

    public UserDTO(int userID, String username, String password, String userRole) {
        this.userID = userID;
        this.username = username;
        this.password = password;
        this.userRole = userRole;
    }

    public int getUserID() {
        return userID;
    }

    public void setUserID(int userID) {
        this.userID = userID;
    }

    public String getUsername() {
        return username;
    }

    public void setUsername(String username) {
        this.username = username;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getUserRole() {
        return userRole;
    }

    public void setUserRole(String userRole) {
        this.userRole = userRole;
    }

}
