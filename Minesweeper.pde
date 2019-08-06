PImage block;
PImage mine;
PImage flag;
ArrayList<PImage> nums = new ArrayList<PImage>();

int boxSize = 16;
int sideLength = 30;
int cellsLeft;
int flagsLeft;

boolean dead = false;
boolean deadNextFrame = true;
boolean won = false;
boolean wonNextFrame = false;

Minefield field;

void setup(){
  frameRate(60);
  
  field = new Minefield();
  
  block = loadImage("block.png");
  mine = loadImage("mine.png");
  flag = loadImage("flagged.png");
  for(int i = 0; i < 9; i++){
    String name = str(i);
    name += ".png";
    nums.add(loadImage(name));
  }
}

void draw(){
  flagsLeft = sideLength * 4;
  cellsLeft = sideLength * sideLength;
  
  if(!dead && !won){
    settings();
    background(255);
    for(int i = 0; i < sideLength; i++){
      for(int j = 0; j < sideLength; j++){
        if(field.unturned[i][j] == 1){
          cellsLeft--;
          if(field.fieldMat[i][j] == -1){
            image(mine, j * boxSize, i * boxSize);
          }
          else{
            image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
          }
        }
        else if(field.unturned[i][j] == 2){
          image(flag, j * boxSize, i * boxSize);
          cellsLeft--;
          flagsLeft--;
        }
        else{
          image(block, j * boxSize, i * boxSize);
        }
      }
    }
    fill(0);
    textSize(15);
    text("Cells Left: " + cellsLeft, 5, boxSize * sideLength + 20);
    text("Flags Left: " + flagsLeft, width - (85 + (str(flagsLeft)).length() * 10), boxSize * sideLength + 20);
    if(cellsLeft == 0){
      won = true;
    }
  }
  else if(won && !wonNextFrame){
    for(int i = 0; i < sideLength; i++){
      for(int j = 0; j < sideLength; j++){
        if(field.unturned[i][j] == 1){
          cellsLeft--;
          if(field.fieldMat[i][j] == -1){
            image(mine, j * boxSize, i * boxSize);
          }
          else{
            image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
          }
        }
        else if(field.unturned[i][j] == 2){
          image(flag, j * boxSize, i * boxSize);
          cellsLeft--;
        }
        else{
          image(block, j * boxSize, i * boxSize);
        }
      }
    }
    fill(0);
    textSize(15);
    text("You Won!", width / 2 - 40, boxSize * sideLength + 20);
    wonNextFrame = true;
  }
  else if(dead){
    if(deadNextFrame){
      for(int i = 0; i < sideLength; i++){
        for(int j = 0; j < sideLength; j++){
          if(field.unturned[i][j] == 1){
            cellsLeft--;
            if(field.fieldMat[i][j] == -1){
              image(mine, j * boxSize, i * boxSize);
            }
            else{
              image(nums.get(field.bombsAroundMe(i, j)), j * boxSize, i * boxSize);
            }
          }
          else if(field.unturned[i][j] == 2){
            image(flag, j * boxSize, i * boxSize);
            cellsLeft--;
            flagsLeft--;
          }
          else{
            image(block, j * boxSize, i * boxSize);
          }
        }
      }
      fill(0);
      textSize(15);
      text("You Lost!", width / 2 - 40, boxSize * sideLength + 20);
    }
    deadNextFrame = false;
  }
}

public void settings(){
  size(boxSize * sideLength, boxSize * sideLength + 30);
}

void mousePressed(){
  int y = mouseY / boxSize;
  int x = mouseX / boxSize;
  
  if(mouseButton == LEFT){
    if(field.unturned[y][x] != 2){
      if(field.fieldMat[y][x] == -1){
        dead = true;
        for(int i = 0; i < sideLength; i++){
          for(int j = 0; j < sideLength; j++){
            if(field.fieldMat[i][j] == -1){
              field.unturned[i][j] = 1;
            }
          }
        }
      }
      revealBlocks(y, x);
    }
  }
  else if(mouseButton == RIGHT){
    if(field.unturned[y][x] != 1){
      if(field.unturned[y][x] == 2){
        field.unturned[y][x] = 0;
      }
      else{
        field.unturned[y][x] = 2;
      }
    }
  }
}

void revealBlocks(int row, int col){
  if(field.bombsAroundMe(row, col) == 0){
    if(field.unturned[row][col] != 1){
      if(row == 0 && col == 0){
        for(int i = row; i <= row + 1; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == 0 && col == sideLength - 1){
        for(int i = row; i <= row + 1; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == 0){
        for(int i = row - 1; i <= row; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1 && col == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == 0){
        for(int i = row; i <= row + 1; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(col == 0){
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(row == sideLength - 1){
        for(int i = row - 1; i <= row; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else if(col == sideLength - 1){
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col - 1; j <= col; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
      else{
        for(int i = row - 1; i <= row + 1; i++){
          for(int j = col - 1; j <= col + 1; j++){
            if(!(i == row && j == col) && field.fieldMat[i][j] != -1){
              field.unturned[row][col] = 1;
              revealBlocks(i, j);
            }
          }
        }
      }
    }
  }
  else{
    field.unturned[row][col] = 1;
  }
}

void keyReleased(){
  switch(key){
    case 'r': for(int i = 0; i < field.fieldMat.length; i++){
                for(int j = 0; j < field.fieldMat[0].length; j++){
                  if(field.fieldMat[i][j] != -1){
                    field.unturned[i][j] = (field.unturned[i][j] + 1) % 2;
                  }
                }
              }
  }
}
