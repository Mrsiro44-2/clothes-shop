package Model;

public class SizeOption {

    private int ID;
    private String code;
    private String label;
    private int sortOrder;
    private int status;
    private int sizeGroupID;

    public SizeOption() {
    }

    public SizeOption(int ID, String code, String label, int sortOrder, int status) {
        this(ID, code, label, sortOrder, status, 0);
    }

    public SizeOption(int ID, String code, String label, int sortOrder, int status, int sizeGroupID) {
        this.ID = ID;
        this.code = code;
        this.label = label;
        this.sortOrder = sortOrder;
        this.status = status;
        this.sizeGroupID = sizeGroupID;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getCode() {
        return code;
    }

    public void setCode(String code) {
        this.code = code;
    }

    public String getLabel() {
        return label;
    }

    public void setLabel(String label) {
        this.label = label;
    }

    public int getSortOrder() {
        return sortOrder;
    }

    public void setSortOrder(int sortOrder) {
        this.sortOrder = sortOrder;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public int getSizeGroupID() {
        return sizeGroupID;
    }

    public void setSizeGroupID(int sizeGroupID) {
        this.sizeGroupID = sizeGroupID;
    }
}
