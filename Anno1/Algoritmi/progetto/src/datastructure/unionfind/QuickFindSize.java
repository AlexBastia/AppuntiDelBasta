package src.datastructure.unionfind;

import java.util.*;

/**
 * Union find implementation based on Quick Find with heuristic on the size.
 * It modifies the Quick Find implementation of the uniong operation by changing
 * the parent set of the nodes in the smaller set.
 * In this way, the maximal number of changes in a sequence of n-1 union will
 * be O(n log n), hence the amortized cost of union is O(log n).
 *
 * @param <D> type of the data object
 */
public class QuickFindSize<D> extends QuickFind<D> {

  /**
   * Creates an union find structure following the QuickFind implementation
   * with heuristic on the size
   */
  public QuickFindSize() {
  }

  public QFnode<D> makeSet(D d) {
    QFnode<D> newNode = new QFnode<>(d, null, null);
    QFRset<D> newSet = new QFRset<>(newNode, newNode, 1);
    newNode.parent = newSet;
    return newNode;
  }

  public void union(QFset<D> s, QFset<D> t) {
    if (s == t)
      return;
    if (((QFRset<D>) s).size >= ((QFRset<D>) t).size) {
      super.union(s, t);
      ((QFRset<D>) s).size += ((QFRset<D>) t).size;
    } else {
      super.union(t, s);
      ((QFRset<D>) t).size += ((QFRset<D>) s).size;
    }
  }

}
