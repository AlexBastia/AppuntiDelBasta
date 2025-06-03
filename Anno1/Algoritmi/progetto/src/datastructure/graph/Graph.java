package src.datastructure.graph;

import java.util.ArrayList;

/**
 * Generic graph interface
 * 
 * @param <D> type of the data object in the graph vertexes
 */
public interface Graph<D> {

  /**
   * Returns the number of vertexes of the graph
   * 
   * @return the number of vertexes
   */
  public int vertexNum();

  /**
   * Returns the number of edges of the graph
   * 
   * @return the number of edges
   */
  public int edgeNum();

  /**
   * Returns the list of vertexes of the graph
   * 
   * @return the list of vertexes
   */
  public ArrayList<Vertex<D>> vertexes();

  /**
   * Returns the list of edges of the graph
   * 
   * @return the list of edges
   */
  public ArrayList<Edge<D>> edges();

  /**
   * Returns the out degree of a vertex
   * 
   * @param v vertex
   * @return the out degree of the vertex v
   */
  public int outDegree(Vertex<D> v);

  /**
   * Returns the list of edges exiting a vertex
   * 
   * @param v vertex
   * @return the list of edges of the vertex v
   */
  public ArrayList<Edge<D>> outEdges(Vertex<D> v);

  /**
   * Returns the edge connecting two given vertexes
   * (returns null if the edge does not exist)
   * 
   * @param x source vertex
   * @param y destination vertex
   * @return the edge connecting x and y (null otherwise)
   */
  public Edge<D> areAdjacent(Vertex<D> x, Vertex<D> y);

  /**
   * Add a vertex containing the datum data
   * 
   * @param data the datum to insert in the new vertex
   * @return the new vertex
   */
  public Vertex<D> addVertex(D data);

  /**
   * Add an edge
   * 
   * @param e the edge to add
   */
  public void addEdge(Edge<D> e);

  /**
   * Remove a vertex
   * 
   * @param v the vertex to remove
   */
  public void removeVertex(Vertex<D> v);

  /**
   * Remove an edge
   * 
   * @param e the edge to remove
   */
  public void removeEdge(Edge<D> e);

}
