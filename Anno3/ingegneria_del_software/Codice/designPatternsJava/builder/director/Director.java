package designPatternsJava.builder.director;

import designPatternsJava.builder.builders.Builder;

public class Director {
  public void makeHouseWithGarden(Builder builder){
      builder.buildGarden();
      builder.buildWalls(8);
  }
}
