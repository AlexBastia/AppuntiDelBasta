package src.algorithm.sorting;

/**
 * This class contains various sorting algorithms
 */
public class Sorting {

  /**
   * Sorts the specified array according to the ordering induced by the
   * compareTo() method in &Theta;(nlogn)
   * <P>
   * Implements the mergesort algorithm.
   * <ul>
   * <li>Worst/Average/Best-case cost: &Theta;(nlogn)
   * </ul>
   * 
   * @param A   the array to be sorted
   * @param <T> class of the object in the array
   */
  public static <T extends Comparable<T>> void mergesort(T[] A) {
    mergesort_rec(A, 0, A.length - 1);
  }

  public static <T extends Comparable<T>> void mergesort_rec(T[] A, int l, int r) {
    if (r <= l)
      return;
    int m = (r + l) / 2;
    mergesort_rec(A, l, m);
    mergesort_rec(A, m + 1, r);
    merge(A, l, m, r);
  }

  public static <T extends Comparable<T>> void merge(T[] A, int l, int m, int r) {
    int dim = r - l + 1, i = l, j = m + 1, k = 0;
    T[] B = (T[]) new Comparable[dim];
    while (i <= m && j <= r) {
      if (A[i].compareTo(A[j]) <= 0) {
        B[k] = A[i];
        i++;
      } else {
        B[k] = A[j];
        j++;
      }
      k++;
    }
    while (i <= m) {
      B[k] = A[i];
      i++;
      k++;
    }
    while (j <= r) {
      B[k] = A[j];
      j++;
      k++;
    }
    for (int t = 0; t < k; t++) {
      A[l + t] = B[t];
    }
  }
}
