package src.algorithm.MST;

import src.datastructure.graph.*;
import src.datastructure.unionfind.*;

import java.util.ArrayList;

import src.algorithm.sorting.Sorting;

/**
 * This class contains the implementation of the Kruskal's algorithm for the
 * construction of a Minimum Spanning Tree (MST) of a weighted graph.
 * 
 * @param <D> type of the data stored in the nodes of the graph
 */
public class Kruskal<D> implements MST<D> {

  // The WeightedGraph on which the MST is computed
  private WeightedGraph<D> t;

  // The total weight of the MST
  private double weight;

  /**
   * Computes the Minimum Spanning Tree (MST) of the specified weighted graph.
   * 
   * @param g the weighted graph
   */
  public void compute(WeightedGraph<D> g) {
    this.t = new WeightedGraphAL<D>();
    UnionFind<D, QFnode<D>, QFset<D>> UF = new QuickFindSize<D>();

    int numNodiTot = g.vertexNum();
    ArrayList<QFnode<D>> nodiQF = new ArrayList<>(numNodiTot);

    // Crea un nodo UF per ogni nodo del grafo g e aggiunge lo stesso numero di nodi
    // a t (l'MST finale)
    // NOTE: ho supposto che i nodi di g abbiano sempre valore intero crescente da 0
    // a numNodi - 1
    for (Integer i = 0; i < numNodiTot; i++) {
      nodiQF.add(UF.makeSet((D) i));
      t.addVertex((D) i);
    }
    ArrayList<Edge<D>> archi = g.edges();
    int numArchi = archi.size();

    // Converte l'ArrayList di archi in un array di archi pesati
    WeightedEdge<D>[] archiPesati = (WeightedEdge<D>[]) new WeightedEdge[numArchi];
    archiPesati = archi.toArray(archiPesati);

    // Ordina in modo crescente (secondo il peso) l'array di archi pesati
    Sorting.mergesort(archiPesati);

    for (int i = 0; i < numArchi; i++) {
      Vertex<D> u = archiPesati[i].source;
      Vertex<D> v = archiPesati[i].dest;

      QFset<D> Tu = UF.find(nodiQF.get((Integer) u.data));
      QFset<D> Tv = UF.find(nodiQF.get((Integer) v.data));

      double edgeWeight = archiPesati[i].weight;

      if (Tu != Tv) {
        this.weight += edgeWeight;

        // Aggiungo il nuovo arco al MST
        WeightedEdge<D> newArco = new WeightedEdge<>(u, v, edgeWeight);
        t.addEdge(newArco);

        UF.union(Tu, Tv);
      }
    }
  }

  /**
   * Returns the Minimum Spanning Tree (MST) of the weighted graph.
   * 
   * @return the Minimum Spanning Tree (MST) of the weighted graph
   */
  public WeightedGraph<D> spanningTree() {
    return this.t;
  }

  /**
   * Returns the total weight of the Minimum Spanning Tree (MST) of the weighted
   * graph.
   * 
   * @return the total weight of the Minimum Spanning Tree (MST) of the weighted
   *         graph
   */
  public double totalWeight() {
    return this.weight;
  }
}
