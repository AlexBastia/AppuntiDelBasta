package src.datastructure.unionfind;

/**
 * Generic union find interface.
 * 
 * @param <D> type of the data object
 * @param <N> type of the union find node object
 * @param <S> type of the union find set object
 */
public interface UnionFind<D, N extends UFnode, S extends UFset> {

  /**
   * Inserts a node with a given data object and creates a set containing only
   * such node
   * 
   * @param data data to insert
   * @return the inserted node
   */
  public N makeSet(D data);

  /**
   * Performs the union of two sets
   * 
   * @param set1 the first set
   * @param set2 the second set
   */
  public void union(S set1, S set2);

  /**
   * Returns the set of a given node
   * 
   * @param node the node to consider
   * @return the set of the given node
   */
  public S find(N node);

}
