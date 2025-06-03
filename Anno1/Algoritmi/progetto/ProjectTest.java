/* ************************************************
 * Algorithms and Data Structures Project
 * 
 * ProjectTest.java
 * 
 * Main class for the project.
 * 
 * The program reads a file containing a list of edges with their weights
 * and computes the Minimum Spanning Tree of the graph.
 * 
 * The input file must contain one edge per line in the format:
 * N1   N2    W
 * where N1 and N2 are the nodes of the edge and W is the weight of the edge.
 * The columns N1 and N2 must be composed of integer numbers ordered in ascending order.
 * The column W must be composed of double numbers.
 * Those three columns must be separated by a tab.
 * 
 * The program writes the reslt of the computation in the file output.txt.
 * 
 * To compile:
 * javac ProjectTest.java
 * 
 * To run:
 * java ProjectTest grafoMST.txt
 * *************************************************/

import java.io.*;
import java.util.*;

import src.algorithm.MST.*;
import src.datastructure.graph.*;

public class ProjectTest {

  public static void main(String[] args) {

    try {

      long start_t, end_t, elapsed, min;
      double sec;

      File file = new File(args[0]);

      BufferedReader br = new BufferedReader(new FileReader(file));
      ArrayList<Integer> src = new ArrayList<Integer>();
      ArrayList<Integer> dst = new ArrayList<Integer>();
      ArrayList<Double> pesi = new ArrayList<Double>();
      String st, strest;
      int max = 0, s, d, v, v2;
      double p;
      while ((st = br.readLine()) != null) {
        v = st.indexOf("\t");
        s = Integer.valueOf(st.substring(0, v));
        strest = st.substring(v + 1);
        v2 = strest.indexOf("\t");
        d = Integer.valueOf(strest.substring(0, v2));
        p = Double.valueOf(strest.substring(v2 + 1));
        if (s > max)
          max = s;
        if (d > max)
          max = d;
        src.add(s);
        dst.add(d);
        pesi.add(p);
      }

      WeightedGraph<Integer> g = new WeightedGraphAL<Integer>();

      ArrayList<Vertex<Integer>> nodi = new ArrayList<Vertex<Integer>>(max + 1);
      for (int i = 0; i <= max; i++)
        nodi.add(g.addVertex(i));
      for (int j = 0; j < src.size(); j++) {
        g.addEdge(new WeightedEdge<Integer>(nodi.get(src.get(j)),
            nodi.get(dst.get(j)), pesi.get(j)));
        g.addEdge(new WeightedEdge<Integer>(nodi.get(dst.get(j)),
            nodi.get(src.get(j)), pesi.get(j)));
      }

      MST<Integer> mst = new Kruskal<Integer>();
      start_t = System.currentTimeMillis();
      mst.compute(g);
      end_t = System.currentTimeMillis();
      elapsed = end_t - start_t;
      min = elapsed / 60000;
      sec = (double) (elapsed % 60000) / 1000.0;

      File fout = new File("output.txt");
      FileOutputStream fos = new FileOutputStream(fout);
      BufferedWriter bw = new BufferedWriter(new OutputStreamWriter(fos));

      WeightedGraph<Integer> t = mst.spanningTree();

      ArrayList<Vertex<Integer>> vert = t.vertexes();
      for (int i = 0; i < t.vertexNum(); i++) {
        bw.write("Adiacenti a: " + (vert.get(i)).data);
        ArrayList<Edge<Integer>> archi = t.outEdges(vert.get(i));
        for (int j = 0; j < g.outDegree(vert.get(i)); j++) {
          bw.write("  " + ((archi.get(j)).dest).data + " " +
              ((WeightedEdge) (archi.get(j))).weight);
        }
        bw.newLine();
      }
      bw.write("Costo tot: " + mst.totalWeight());
      bw.newLine();
      bw.write("Elapsed time: " + min + " minuti e " + sec + " secondi");
      bw.close();

    } catch (Exception e) {
      e.printStackTrace();

    }
  }
}
