package designPatternsJava.builder.houses;

public class House {
  public int wallCount;
  public boolean hasGarden;

  public House(int wallCount, boolean hasGarden){
    this.wallCount = wallCount;
    this.hasGarden = hasGarden;
  }
}
