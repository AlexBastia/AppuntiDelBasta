package src.datastructure.unionfind;

/**
 * Generic Quick Find node class
 * 
 * @param <D> type of the data object
 */
public class QFnode<D> implements UFnode {

  /** data value */
  protected D elem;

  /** parent set */
  protected QFset<D> parent;

  /** next node */
  protected QFnode<D> next;

  /**
   * Creates a Quick Find node with a given data object, a parent set and a next
   * node
   * 
   * @param data   data to insert
   * @param parent parent set
   * @param next   next node
   */
  public QFnode(D data, QFset<D> parent, QFnode<D> next) {
    this.elem = data;
    this.parent = parent;
    this.next = next;
  }

}
