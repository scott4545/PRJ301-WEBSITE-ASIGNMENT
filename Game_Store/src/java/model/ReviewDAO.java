package model;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import utils.DbUtils;

public class ReviewDAO {
    public List<ReviewDTO> getReviewsByProductId(String productId) throws SQLException, ClassNotFoundException {
        Connection conn = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        List<ReviewDTO> reviews = new ArrayList<>();
        try {
            conn = DbUtils.getConnection();
            String sql = "SELECT ReviewID, ProductID, Username, Rating, Comment, ReviewDate " +
                         "FROM Review WHERE ProductID = ?";
            ps = conn.prepareStatement(sql);
            ps.setInt(1, Integer.parseInt(productId));
            rs = ps.executeQuery();
            while (rs.next()) {
                reviews.add(new ReviewDTO(
                    rs.getInt("ReviewID"),
                    rs.getInt("ProductID"),
                    rs.getString("Username"),
                    rs.getInt("Rating"),
                    rs.getString("Comment"),
                    rs.getDate("ReviewDate")
                ));
            }
        } finally {
            DbUtils.closeConnection(conn, ps, rs);
        }
        return reviews;
    }
}