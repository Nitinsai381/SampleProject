public abstract class ReparentAbstract {
  // public ReparentAbstract() {

  public abstract void reParentObject(
    Id parentId,
    List<Id> childIds,
    String objectType
  );
}