package src.algorithm.MST;

import src.datastructure.graph.WeightedGraph;

/**
 * This interface contains the methods that must be implemented by a class that
 * computes the Minimum Spanning Tree (MST) of a weighted graph.
 * 
 * @param <D> type of the data stored in the nodes of the graph
 */
public interface MST<D> {

  /**
   * Computes the Minimum Spanning Tree (MST) of the specified weighted graph.
   * 
   * @param graph the weighted graph
   */
  public void compute(WeightedGraph<D> graph);

  /**
   * Returns the Minimum Spanning Tree (MST) of the weighted graph.
   * 
   * @return the Minimum Spanning Tree (MST) of the weighted graph
   */
  public WeightedGraph<D> spanningTree();

  /**
   * Returns the total weight of the Minimum Spanning Tree (MST) of the weighted
   * graph.
   * 
   * @return the total weight of the Minimum Spanning Tree (MST) of the weighted
   *         graph
   */
  public double totalWeight();

}
