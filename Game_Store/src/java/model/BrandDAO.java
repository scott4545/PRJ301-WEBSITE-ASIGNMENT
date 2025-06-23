package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class BrandDAO {
    public List<BrandDTO> getAllBrands() throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<BrandDTO> brands = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT BrandID, BrandName FROM Brand";
            ps = conn.prepareStatement(sql);
            rs = ps.executeQuery();
            while (rs.next()) {
                brands.add(new BrandDTO(
                    rs.getInt("BrandID"),
                    rs.getString("BrandName")
                ));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return brands;
    }
}