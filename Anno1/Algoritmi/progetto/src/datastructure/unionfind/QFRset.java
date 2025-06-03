package src.datastructure.unionfind;

/**
 * Generic set class for Quick Find with euristic on the size.
 * 
 * @param <D> type of the data object
 */
public class QFRset<D> extends QFset<D> {

  /** size of the set */
  protected int size;

  /**
   * Creates a Quick Find (with heuristic on the size) set with a given first son,
   * last son and size
   * 
   * @param first data to insert
   * @param last  parent set
   * @param size  next node
   */
  public QFRset(QFnode<D> first, QFnode<D> last, int size) {
    super(first, last);
    this.size = size;
  }

}
