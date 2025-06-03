package src.datastructure.graph;

import java.util.LinkedList;

/**
 * Vertex of graphs implemented using adjacent lists
 * 
 * @param <D> type of the data object in the graph vertexes
 */
public class VertexAL<D> extends Vertex<D> {

  /** the vertex index */
  protected int index;

  /** the adjacent list of the vertex */
  protected LinkedList<Edge<D>> adjac;

  /**
   * Constructs a vertex for a graph implemented using adjacent lists
   * 
   * @param data  data associated to the vertex
   * @param index the vertex index
   */
  public VertexAL(D data, int index) {
    super(data);
    this.index = index;
    adjac = new LinkedList<Edge<D>>();
  }

}
