September 7, 2026

## Lecture 1: When and why does GREEDY work?

Notes by Ola Svensson1

## 1 Introduction

- Welcome

- Michael Kapralov (michael.kapralov@epfl.ch)

- CS-450 staff email: CS-450-staff@epfl.ch

- Join the moodle page!

- Show cool introductory slides

## 1.1 Grading

- 2 homeworks [20%] (please form groups with up to three students)

- Midterm exam [35%]

- Final exam [45%]

## 2 Warmup: Greedy Algorithm for Max Weight Spanning Trees

In this lecture, we will better understand perhaps the easiest of algorithms: always select the best available option in a greedy way. We first describe the algorithm when considering the spanning tree problem or rather the maximum weight forest problem. First recall the definition of the maximum weight 2 spanning tree problem:

Definition 1 Given a connected undirected graph G = (V, E) with edge weights w : E → R, find a spanning tree T ⊆ E of maximum total weight w(T) := e∈T w(e).

Example 1 The following undirected edge-weighted graph has two maximum spanning trees: {{A,B}, {B, C}, {B,D}} and {{A,C}, {B, C}, {B,D}}.

We are now going to describe the most basic greedy algorithm there is: repeatedly add the edge of largest weight that does not create a cycle. When considering the spanning tree problem this is known as Kruskal’s algorithm (named after its inventor).


Greedy(G,w):

Input: A connected undirected graph G = (V, E) and weights (we)e∈E. Output: A maximum weight spanning tree S.

1. Sort and relabel the edges so that we1 ≥ we2 ≥ · · · ≥ we|E| .

2. S ← ∅.

3. for i = 1 to |E|:

if S + ei is acyclic then S ← S + ei.

4.

5. return S.

Runtime analysis. Steps 3-4 can be implemented in almost linear time using the UNION-FIND (also called DISJOINT-SET) data structure that I hope you have seen during your Bachelor studies. The running time is thus dominated by the sorting of Step 1. Using e.g. Merge-Sort this step runs in time Θ(|E| log |E|). The total running time is thus Θ(|E| log |E|).

Why does it work? The correctness of the algorithm follows from the following lemma.

Lemma 2 Greedy returns a maximum-weight spanning tree.

Proof Suppose not. Let S = {s1, s2, . . . , sn−1} be the set (spanning tree) returned by the algorithm and suppose that a solution T has a higher weight, where T = {t1, t2, . . . , tn−1} (indexed in decreasing weight). Let p be the first index such that w(tp) > w(sp). Let A = {t1, . . . , tp} and B = {s1, . . . , sp−1}.

Now we have the following key property of acyclic graphs.

Key property: As |A| > |B|, there exists e ∈ A \ B such that B + e is acyclic.

The key property follows from that an acyclic graph with k edges has n − k components3. Thus the graph (V, A) has fewer components than (V, B) and so at least one edge e ∈ A must connect two different components of (V, B). It follows that e ∈ B and that B + e is acyclic.

Having proved the key property, we conclude as follows. Since w(e) ≥ w(tp) > w(sp), e should have been selected when it was considered.

To be more precise and detailed, when e was considered, the greedy algorithm checked whether e could be added to the current set at the time, say B. But since B ⊆ B, adding e to B would have resulted in an acyclic graph (a subset of acyclic edges is also acyclic) since its addition to B results in an acyclic graph.

This gives a contradiction and completes the proof.

## 3 Matroids: The exact set of problems for which basic greedy algorithm works

Note that in the correctness of the Greedy algorithm for max-weight spanning trees (Lemma 2) we used two properties of acyclic graphs: (i) a subset of acyclic edges is acyclic and (ii) for two acyclic edge sets A,B on the same vertex-set with |A| > |B| there is e ∈ A \ B such that B + e is acyclic.

Matroids are defined to satisfy these two properties and we will see that they define the set of problems for which the basic greedy algorithm works. It also generalizes the notion of linear independence in matrices. There are many equivalent definitions. We use the one that focus on its independent sets.

Definition 3 A matroid M = (E, I) is defined on a finite ground set E and a family I of subsets of E that are called independent sets satisfying two axioms:


(I1) if X ⊆ Y and Y ∈ I then X ∈ I.

- (I2) if X ∈ I and Y ∈ I and |Y| > |X| then ∃e ∈ Y \ X : X ∪ {e} ∈ I.

## Remarks:

- Letting E be the edges of a graph and I = {F ⊆ E : F is acyclic} defines a so-called graphic matroid. Note that it satisfies (I1) since the subset of an acyclic set of edges is acyclic and it satisfies (I2) due to the key property used in the proof of Lemma 2. We see more examples of matroids in Section 3.1.

- The family I may be exponential in the size of the ground set E (as is the case for example for graphic matroids of complete graphs). One therefore often assumes that I is given implicitly by having a membership oracle: an algorithm that given I ⊆ E efficiently answers whether I ∈ I.

- The second axiom implies that every maximal independent set is of maximum cardinality. In other words, all maximal independent sets have the same cardinality. A maximal cardinality set is called a base of the matroid.

With the more abstract notation of matroids, the basic greedy algorithm becomes

Greedy(M, w):

Input: A matroid M = (E, I) and weights (we)e∈E.

Output: A maximum weight base S.

1. Sort and relabel the elements so that w1 ≥ w2 ≥ · · · ≥ w|E|.

3. for i = 1 to |E|:

5. return S.

The concept of matroids was defined so as to enable the correctness analysis of the basic greedy algorithm. Perhaps more surprisingly, it is if and only if.

Theorem 4 (Rado’57/Gale’68/Edmonds’71) For any ground set E = {1, 2, . . . , n}, and a family of subsets I, Greedy finds a maximum weight base4 for any set of weights w : E → R if and only if M = (E, I) is a matroid.

The if direction (⇐ part) follows from Lemma 2. For the only if direction we have the following

claim.

Claim 5 (⇒ part) Suppose (E, I) is not a matroid. There exists an assignment of weights w : E → R so that Greedy does not return a maximum weight base.

Proof If (E, I) is not a matroid, then it violates at least one of the two axioms.

First suppose I is not a downward-closed family of sets, i.e., it violates (I1). Therefore, there exist two sets S ⊂ T such that S ∈ I and T ∈ I. Consider the following weights:


By the weight assignment, the algorithm first considers the elements of S, then the elements of T, and then the rest of the elements. Suppose the algorithm selects a subset S1 of S. Since S ∈ I, S1 is a strict subset. Out of the remaining elements the algorithm can select at most T \ S. So the weight of the independent set that the algorithm returns is at most 2|S1| + |T \ S| which is less than w(T) so it is not a maximum weight independent set.

Second suppose that the extension axiom is violated (but downwardness is satisfied). In particular, let S, T ∈ I be two independent sets such that |S| < |T|, and for all i ∈ T \ S, S + i ∈ I. Now use the following weights

Because of downwardness the algorithm would select all elements in S and return an independent set of value |S| + 1/2 where as the optimal set would have value at least |T| > |S| + 1/2.

## 3.1 Examples of matroids

We already saw the graphic matroids. Other basic matroids are as follows:

## 3.1.1 k-Uniform matroid

A matroid M = (E, I) is k-Uniform if I satisfies:

## 3.1.2 Partition matroid

A matroid M = (E, I) is a partition matroid if E is partitioned into disjoint sets E1, E2, ..., E and

## 3.1.3 Linear matroid

A matroid M = (E, I) is a linear matroid when it is defined from a matrix A. Let E be the index set of the columns and for X ⊆ E let AX be the matrix consisting of the columns indexed by X. Define I by

## 3.1.4 Truncated matroid

A truncated matroid Mk = (E, Ik) is defined from a matroid M = (E, I) such that

It is quite easy to verify that the axioms still hold for Mk, as X ∈ Ik implies X ∈ I for all X ⊆ E.

(I1) holds because B ∈ Ik means that |B| ≤ k and A ⊆ B thus means |A| ≤ k as well. We know that M is a matroid so I1 holds for M, which implies A ∈ I. We conclude that A ∈ Ik

The same reasoning can verify I2: if A,B ∈ Ik and |B| > |A|, then |B| ≤ k and |A| ≤ k − 1. We know that I2 holds for M, so the inclusion of Ik in I tells us that ∃e ∈ B \ A such that A + e ∈ I. The fact that |A+ e| ≤ k − 1 + 1 = k allows us to conclude.
