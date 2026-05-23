package Model;

import java.sql.Date;

public class Voucher {

    private int ID;
    private String name;
    private String code;
    /** 0 = giảm cố định (VND), 1 = giảm % */
    private int discountType;
    private float value;
    private float minOrderAmount;
    private Float maxDiscount;
    private Integer usageLimit;
    private int used;
    private Date start;
    private Date end;
    private int status;

    public Voucher() {
    }

    public Voucher(int ID, String name, String code, int discountType, float value,
            float minOrderAmount, Float maxDiscount, Integer usageLimit,
            Date start, Date end, int status) {
        this.ID = ID;
        this.name = name;
        this.code = code;
        this.discountType = discountType;
        this.value = value;
        this.minOrderAmount = minOrderAmount;
        this.maxDiscount = maxDiscount;
        this.usageLimit = usageLimit;
        this.start = start;
        this.end = end;
        this.status = status;
    }

    public int getId() {
        return ID;
    }

    public void setId(int id) {
        this.ID = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public int getDiscountType() {
        return discountType;
    }

    public void setDiscountType(int discountType) {
        this.discountType = discountType;
    }

    /** Alias cho JSP admin cũ (${voucher.type}) */
    public int getType() {
        return discountType;
    }

    public void setType(int type) {
        this.discountType = type;
    }

    public float getValue() {
        return value;
    }

    public void setValue(float value) {
        this.value = value;
    }

    public float getMinOrderAmount() {
        return minOrderAmount;
    }

    public void setMinOrderAmount(float minOrderAmount) {
        this.minOrderAmount = minOrderAmount;
    }

    /** @deprecated dùng minOrderAmount */
    public float getLimit() {
        return minOrderAmount;
    }

    public void setLimit(float limit) {
        this.minOrderAmount = limit;
    }

    public Float getMaxDiscount() {
        return maxDiscount;
    }

    public void setMaxDiscount(Float maxDiscount) {
        this.maxDiscount = maxDiscount;
    }

    public Integer getUsageLimit() {
        return usageLimit;
    }

    public void setUsageLimit(Integer usageLimit) {
        this.usageLimit = usageLimit;
    }

    public int getUsed() {
        return used;
    }

    public void setUsed(int used) {
        this.used = used;
    }

    public Date getStart() {
        return start;
    }

    public void setStart(Date start) {
        this.start = start;
    }

    public Date getEnd() {
        return end;
    }

    public void setEnd(Date end) {
        this.end = end;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }
}
