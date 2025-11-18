package designPatternsJava.builder.builders;

import designPatternsJava.builder.houses.House;

public class HouseBuilder implements Builder {
  private int wallCount;
  private boolean hasGarden;

  public HouseBuilder(){
    this.reset();
  }

  public void buildWalls(int wallCount){
    this.wallCount = wallCount;
  }

  public void buildGarden(){
    this.hasGarden = true;
  }

  public void reset(){
    this.wallCount = 4;
    this.hasGarden = false;
  }

  public House getHouse(){
    return new House(wallCount, hasGarden);
  } 
}
