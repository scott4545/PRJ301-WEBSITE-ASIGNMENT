package model;

import java.util.Date;

public class ReviewDTO {
    private int reviewId;
    private int productId;
    private String username;
    private int rating;
    private String comment;
    private Date reviewDate;

    public ReviewDTO() {
    }

    public ReviewDTO(int reviewId, int productId, String username, int rating, String comment, Date reviewDate) {
        this.reviewId = reviewId;
        this.productId = productId;
        this.username = username;
        this.rating = rating;
        this.comment = comment;
        this.reviewDate = reviewDate;
    }

    public int getReviewId() { return reviewId; }
    public void setReviewId(int reviewId) { this.reviewId = reviewId; }
    public int getProductId() { return productId; }
    public void setProductId(int productId) { this.productId = productId; }
    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }
    public int getRating() { return rating; }
    public void setRating(int rating) { this.rating = rating; }
    public String getComment() { return comment; }
    public void setComment(String comment) { this.comment = comment; }
    public Date getReviewDate() { return reviewDate; }
    public void setReviewDate(Date reviewDate) { this.reviewDate = reviewDate; }
}