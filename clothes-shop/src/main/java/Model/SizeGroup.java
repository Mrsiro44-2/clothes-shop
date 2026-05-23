package Model;

public class SizeGroup {

    private int ID;
    private String code;
    private String name;
    private int sortOrder;
    private int status;

    public SizeGroup() {
    }

    public SizeGroup(int ID, String code, String name, int sortOrder, int status) {
        this.ID = ID;
        this.code = code;
        this.name = name;
        this.sortOrder = sortOrder;
        this.status = status;
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
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
}
