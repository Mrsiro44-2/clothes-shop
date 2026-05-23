package Utils;

public class ProductPriceRange {

    private float minEffective;
    private float maxEffective;
    private float minOld;
    private float maxOld;
    private boolean hasRange;
    private boolean hasSale;

    public float getMinEffective() {
        return minEffective;
    }

    public void setMinEffective(float minEffective) {
        this.minEffective = minEffective;
    }

    public float getMaxEffective() {
        return maxEffective;
    }

    public void setMaxEffective(float maxEffective) {
        this.maxEffective = maxEffective;
    }

    public float getMinOld() {
        return minOld;
    }

    public void setMinOld(float minOld) {
        this.minOld = minOld;
    }

    public float getMaxOld() {
        return maxOld;
    }

    public void setMaxOld(float maxOld) {
        this.maxOld = maxOld;
    }

    public boolean isHasRange() {
        return hasRange;
    }

    public void setHasRange(boolean hasRange) {
        this.hasRange = hasRange;
    }

    public boolean isHasSale() {
        return hasSale;
    }

    public void setHasSale(boolean hasSale) {
        this.hasSale = hasSale;
    }
}
