package src.datastructure.graph;

/**
 * Generic edge of graphs
 * 
 * @param <D> type of the data object in the graph vertexes
 */
public class Edge<D> {

  /** edge source */
  public Vertex<D> source;

  /** edge destination */
  public Vertex<D> dest;

  /**
   * Constructs an edge
   * 
   * @param source the source vertex
   * @param dest   the destination vertex
   */
  public Edge(Vertex<D> source, Vertex<D> dest) {
    this.source = source;
    this.dest = dest;
  }

}
