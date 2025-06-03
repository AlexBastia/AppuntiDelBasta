package src.datastructure.graph;

/**
 * Generic vertex of graphs
 * 
 * @param <D> type of the data object in the graph vertexes
 */
public class Vertex<D> {

  /** data object */
  public D data;

  /**
   * Constructs a vertex
   * 
   * @param data data associated to the vertex
   */
  public Vertex(D data) {
    this.data = data;
  }

}
