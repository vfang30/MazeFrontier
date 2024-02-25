
import java.util.*;
public class Maze {
  private int[][]map;
  private int ticks;
  private static final int SPACE = -1;
  private static final int WALL = -2;
  private static final int START = 0;
  private static final int END = -3;
  private static final int PATH = -4;
  private static final int PENDING = -5;
  private Frontier frontier;

  //COMPLETE THE STACK/HEAP version of tick.
  
  /**Tick will process 1 or all nodes from the frontier, and for each: spread to neighboring nodes.
  */
  public void tick() {
    
    
    if (!done()) {
      if (MODE==Frontier.QUEUE) {
        int size = frontier.size();
        while (frontier.size() > 0 && size > 0) {
          Location place = frontier.remove();
          int r = place.row;
          int c = place.col;
          spread(r, c, ticks);
          size-=1;
        }
        
      } else if ((MODE==Frontier.STACK || MODE==Frontier.HEAP) && frontier.size() > 0) {
        /*Stack/Heap version only processes ONE node per tick. This is easier than the QUEUE version*/
        if (MODE == Frontier.STACK){
        Location place = frontier.deque.getLast();
        int r = place.row;
        int c = place.col;
        otherMove(r, c, ticks);
        }
        if (MODE == Frontier.HEAP){
        Location place = frontier.heap.peek();
        int r = place.row;
        int c = place.col;
        otherMove(r, c, ticks);
        }
      }
      ticks++;
    }
  }


  public boolean done() {
    return frontier.size() == 0;
  }

  //checks for the END location
  public boolean checkEnd(int row, int col) {
    try {
      if (map[row][col]==END) {
        frontier.clear();
        return true;
      }
    }
    catch(ArrayIndexOutOfBoundsException e) {
    };
    return false;
  }

  public int distToGoal(int row, int col) {
    return Math.abs(row - END_ROW) + Math.abs(col - END_COL);
  }

public void otherMove(int row, int col, int ticks){
  boolean placed = false;
  if (map[row][col] != START){
  map[row][col] = ticks;
  }
  fill(100, 100, 100);
  rect(col*SQUARESIZE, row*SQUARESIZE, SQUARESIZE, SQUARESIZE);

    if (
      checkEnd(row+1, col)||
      checkEnd(row-1, col)||
      checkEnd(row, col+1)||
      checkEnd(row, col-1)) {
      println("DONE!");
    } else {
      
  if (row > 0){
    if (map[row - 1][col] == SPACE){
      float d = distToGoal(row - 1, col);
      frontier.add(new Location(row - 1, col, d));
      map[row - 1][col] = PENDING;
      placed = true;
      }
    }
  if (row < map.length - 1){
    if (map[row + 1][col] == SPACE){
      float d = distToGoal(row + 1, col);
      frontier.add(new Location(row + 1, col, d));
      map[row + 1][col] = PENDING;
      placed = true;
    }
  }
  if (col > 0){
    if (map[row][col - 1] == SPACE){
      float d = distToGoal(row, col - 1);
      frontier.add(new Location(row, col - 1, d));
      map[row][col - 1] = PENDING;
      placed = true;
    }
  }
  if (col < map[0].length-1){
    if (map[row][col + 1] == SPACE){
      float d = distToGoal(row, col + 1);
      frontier.add(new Location(row, col + 1, d));
      map[row][col + 1] = PENDING;
      placed = true;
    }
  }
    if (!placed){
      frontier.remove();
    }
  }
}



  public void spread(int row, int col, int ticks) {
    map[row][col]=ticks;
    fill(100, 100, 100);
    rect(col*SQUARESIZE, row*SQUARESIZE, SQUARESIZE, SQUARESIZE);
    if (
      checkEnd(row+1, col)||
      checkEnd(row-1, col)||
      checkEnd(row, col+1)||
      checkEnd(row, col-1)) {
      println("DONE!");
    } else {


      if (row > 0) {
        if (map[row-1][col]==SPACE) {
          float d = distToGoal(row-1, col);
          frontier.add(new Location(row-1, col, d));
          map[row-1][col]=PENDING;
        }
      }
      if (row < map.length-1) {
        if (map[row+1][col]==SPACE) {
          float d = distToGoal(row+1, col);
          frontier.add(new Location(row+1, col, d));
          map[row+1][col]=PENDING;
        }
      }
      if (col > 0) {
        if (map[row][col-1]==SPACE) {
          float d = distToGoal(row, col-1);
          frontier.add(new Location(row, col-1, d));
          map[row][col-1]=PENDING;
        }
      }
      if (col < map[0].length-1) {
        if (map[row][col+1]==SPACE) {
          float d = distToGoal(row, col+1);
          frontier.add(new Location(row, col+1, d));
          map[row][col+1]=PENDING;
        }
      }
    }
  }

    public boolean isBorder(int row, int col){
      return (row == 0 || row == map.length - 1 || col == 0 || col == map[0].length - 1);
     }
     
     public boolean exceedNeighbor(int row, int col){
      int neightboringSpaces = 0;
      //up
      if (map[row - 1][col] == SPACE){
        neightboringSpaces += 1;
      }
      //right
      if (map[row][col + 1] == SPACE){
        neightboringSpaces += 1;
      }
      //down
      if (map[row + 1][col] == SPACE){
        neightboringSpaces += 1;
      }
      //left
      if (map[row][col - 1] == SPACE){
        neightboringSpaces += 1;
      }
      return (neightboringSpaces > 1);
    }
    
     public boolean canCarve(int row, int col){
      return (!isBorder(row, col)
      && !exceedNeighbor(row, col)
      && map[row][col] != SPACE);
    }
    
        public void carve(int row, int col){
        if (canCarve(row, col)){
              map[row][col] = SPACE;
              ArrayList<String> directions = new ArrayList<String>();
              directions.add("up");
              directions.add("right");
              directions.add("down");
              directions.add("left");
                while (directions.size() > 0){
                  String direction = directions.get((int)(Math.random() * directions.size()));
                  directions.remove(direction);
                    if (direction.equals("up")){
                      carve(row - 1, col);
                    }
                    if (direction.equals("right")){
                      carve(row, col + 1);
                    }
                    if (direction.equals("down")){
                      carve(row + 1, col);
                    }
                    if (direction.equals("left")){
                      carve(row, col - 1);
                    }
                }
            }
          }

  //public Maze(int rows, int cols, double density, int mode) {
  //  frontier = new Frontier(mode);
  //  map = new int[rows][cols];
  //  for (int r=0; r<map.length; r++ ) {
  //    for (int c=0; c < map[r].length; c++ ) {
  //      if (Math.random() < density) {
  //        map[r][c]=SPACE;
  //      } else {
  //        map[r][c]=WALL;
  //      }
  //    }
  //  }
  //  start();
  //  end();
  //}
  
   public Maze(int rows, int cols, int mode){
   frontier = new Frontier(mode);
   map = new int[rows][cols];
   for (int r = 0; r < rows; r +=1){
     for (int c = 0; c < cols; c +=1){
       map[r][c] = WALL;
     }
   }
   carve(1, 1);
   start();
   end();
 }
 


  public void start() {
    for (int i = map.length/2 ; i >= 0  ; i--) {
      if (map[i][1]==SPACE) {
        map[i][1]= START;
        frontier.add(new Location(i, 1));
        return;
      }
    }
  }
  
  public void end() {
    for (int i = map.length/2 ; i >= 0  ; i--) {
      if (map[i][COLS-2]==SPACE) {
        map[i][COLS-2]=END;
        END_ROW=i;
        END_COL=COLS-2;
        return;
      }
    }
  }

  public int getTicks() {
    return ticks;
  }
}
