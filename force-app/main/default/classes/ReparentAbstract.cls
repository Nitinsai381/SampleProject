public abstract class ReparentAbstract {
  // public ReparentAbstract() {

  protected abstract void reParentObject(
    Id parentId,
    List<Id> childIds,
    String objectType
  );
}
