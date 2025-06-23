package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class CategoryDAO {
    public List<CategoryDTO> getAllCategories() throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<CategoryDTO> categories = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT CategoryID, CategoryName FROM Category";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                categories.add(new CategoryDTO(
                    rs.getInt("CategoryID"),
                    rs.getString("CategoryName")
                ));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return categories;
    }
}