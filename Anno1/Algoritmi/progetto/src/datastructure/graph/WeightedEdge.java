package src.datastructure.graph;

/**
 * Generic edge of weighted graphs
 * 
 * @param <D> type of the data object in the graph vertexes
 */
public class WeightedEdge<D> extends Edge<D> implements Comparable<WeightedEdge<D>> {

  /** vertex weight */
  public double weight;

  /**
   * Constructs an edge of a weighted graph
   * 
   * @param source the source vertex
   * @param dest   the destination vertex
   * @param weight edge weight
   */
  public WeightedEdge(Vertex<D> source, Vertex<D> dest, double weight) {
    super(source, dest);
    this.weight = weight;
  }

  @Override
  public int compareTo(WeightedEdge<D> altro) {
    if (this.weight == altro.weight)
      return 0;
    return this.weight < altro.weight ? -1 : 1;
  }

}
