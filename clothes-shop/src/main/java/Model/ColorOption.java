package Model;

public class ColorOption {

    private int ID;
    private String name;
    private String hexCode;
    private int sortOrder;
    private int status;

    public ColorOption() {
    }

    public ColorOption(int ID, String name, String hexCode, int sortOrder, int status) {
        this.ID = ID;
        this.name = name;
        this.hexCode = hexCode;
        this.sortOrder = sortOrder;
        this.status = status;
    }

    public int getID() {
        return ID;
    }

    public void setID(int ID) {
        this.ID = ID;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getHexCode() {
        return hexCode;
    }

    public void setHexCode(String hexCode) {
        this.hexCode = hexCode;
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
