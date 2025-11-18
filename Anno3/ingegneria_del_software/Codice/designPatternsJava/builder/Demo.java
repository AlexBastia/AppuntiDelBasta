package designPatternsJava.builder;

import designPatternsJava.builder.builders.HouseBuilder;
import designPatternsJava.builder.director.Director;
import designPatternsJava.builder.houses.House;

public class Demo {
  public static void main(){
    HouseBuilder builder = new HouseBuilder();
    Director director = new Director();

    director.makeHouseWithGarden(builder);
    House newHouse = builder.getHouse();
    System.out.println(newHouse.wallCount);
  }
}
