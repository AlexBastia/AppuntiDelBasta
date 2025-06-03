package src.datastructure.unionfind;

/**
 * Generic Quick Find set class.
 * 
 * @param <D> type of the data object
 */
public class QFset<D> implements UFset {

  /** first son node */
  protected QFnode<D> first;

  /** last son node */
  protected QFnode<D> last;

  /**
   * Creates a Quick Find set with a given first son and last son
   * 
   * @param first data to insert
   * @param last  parent set
   */
  public QFset(QFnode<D> first, QFnode<D> last) {
    this.first = first;
    this.last = last;
  }

}
