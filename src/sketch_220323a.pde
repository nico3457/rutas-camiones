Mapa mapa = new Mapa();
Mapa mapa1 = new Mapa();
int radio = 10;
int ancho;
int alto;
boolean dibujar = false;
ArrayList<Camion> camiones = new ArrayList<Camion>();
int X;
int Y;
int step = 0;
int capacidad;
int value = 0;
ArrayList<Carretera> carreteras = new ArrayList<Carretera>();
int [][] pantalla = new int[1080][1920];
int [][] indices = new int[1080][1920];
int [][] indices2 = new int[1080][1920];
ArrayList<Nodo> cruces = new ArrayList<Nodo>();
ArrayList visitados = null;
int ajuste = -1;
int numContenedores = 0;
int pixelX;
int pixelY;
int limite = 0;
boolean ocultar = false;
int mostrar = 0;
// 0 = vacio
// 1 = carretera
// 2 = nodo/contenedor
// 3 = boton negro 
// 4 = boton rojo 
// 5 = pixel de carretera con nodo
// 6 = cruce carreteras
// 7 = nodo cruce;
// 8 = random map
// 9 = routes step
// 10 = ocultar carreteras mostrar cruces
void setup() {
  size(1920,1080);
  ancho = 150;
  alto = 100;
  capacidad = 20;
  frameRate(10);
  for (int x = 0; x < 1920; x++) {
    for (int y = 0; y < 1080; y++) {
      indices[y][x] = -1;
      indices2[y][x] = -1;
      pantalla[y][x] = 0;
      if (x >= 1920/2-2*ancho && x < 1920/2-ancho && y >=0 && y < alto)
        pantalla[y][x] = 3;
      else if (x >= 1920/2-ancho && x < 1920/2 && y >=0 && y < alto)
        pantalla[y][x] = 4;
      else if (x >= 1920/2 && x < 1920/2+ancho && y >=0 && y < alto)
        pantalla[y][x] = 8;
      else if (x >= 1920/2+ancho && x < 1920/2+2*ancho && y >=0 && y < alto)
        pantalla[y][x] = 9;
      else if (x >= 1820 && x < 1920 && y >=0 && y < 50)
        pantalla[y][x] = 10;
    }
  }
}

void draw() {
  background(255,255,255);
  fill(0,252,39);
  rect(1920/2-2*ancho,0,ancho,alto);
  fill(255,0,0);
  rect(1920/2-ancho,0,ancho,alto);
  fill(0,0,0);
  rect(1920/2,0,ancho,alto);
  fill(52,94,13);
  rect(1920/2+ancho,0,ancho,alto);
  fill(255,255,255);
  textSize(40);
  text("Routes",1920/2-2*ancho+17,alto/2+10);
  fill(255,255,255);
  textSize(40);
  text("Reset",1920/2-ancho+20,alto/2+10);
  fill(255,255,255);
  textSize(40);
  text("Random",1920/2+3,alto/2+10);
  textSize(40);
  text("Step",1920/2+ancho+30,alto/2+10);
  fill(12,241,137);
  rect(1820,0,1920,50);
  updateIndices();
  if (!ocultar) {
     mapa.display(radio);
     for (Carretera carretera : carreteras) 
      carretera.display();
      if (mapa.getOrigen() != null) {
        mapa.getOrigen().display(30);
      }
      for (Nodo rotonda : cruces) {
        if (rotonda.getEstado() == 2) {
          rotonda.display(30);
        }
      }
     
     if (dibujar) {
       int i = 0;
       mapa1.display(radio);
        for (Camion camioncito : camiones) {
          pushStyle();
          strokeWeight(7);
          camioncito.displayLines(mapa.getOrigen());
          ArrayList<Contenedor> contenedores = camioncito.getContenedores();
          for (Contenedor contenedor : contenedores) {
            contenedor.display(10);
          }
           if (i == mostrar)
            break;
          i++;
      }
       mostrar++;
    } else if (!camiones.isEmpty()) {
        for (Camion camioncito : camiones) {
            ArrayList<Contenedor> contenedores = camioncito.getContenedores();
            for (Contenedor contenedor : contenedores) {
              contenedor.display(10);
            }
            ArrayList<Contenedor> contenedores1 = camioncito.getContenedores();
            for (Contenedor contenedor : contenedores1) {
              contenedor.display(10);
            }
        }
       
        pushStyle();
        strokeWeight(7);
        int j = 0;
        for (Camion camioncito : camiones) {
           if (j == step) {
              camioncito.displayLines(mapa.getOrigen());
              break;
           }
          j++;
        }
    }       
  } else {
       pushStyle();
      for (Nodo cruce : cruces) {
        if (cruce.getEstado() == 2)
          cruce.display(20);
        else {
          cruce.setColor(0,0,0);
          cruce.display(20);
        }  
        cruce.display();
      }
      popStyle();
  }
 
   
}

void mousePressed() {
  X = mouseX;
  Y = mouseY;
}
void reiniciarCruces() {
  for (Nodo cruce : cruces) {
    cruce.reiniciar();
  }
}
void mouseReleased() {
  int newX = mouseX;
  int newY = mouseY;
  int margenX = (int) Math.abs(X-newX);
  int margenY = (int) Math.abs(Y-newY);
  println("Contenedores: " + numContenedores);
  if (pantalla[Y][X] == 3) {
    if (dibujar) {
      dibujar = false;
    } else {
      calcularRutas();
    }
  } else if (pantalla[Y][X] == 4) {
      deleteAll();
  } else if (pantalla[Y][X] == 8) {
      generateRandom();
  } else if (pantalla[Y][X] == 9) {
      step++;
      if (step == camiones.size())
        step = 0;
  } else if (pantalla[Y][X] == 10) {
    if (ocultar)
      ocultar = false;
    else
      ocultar = true;
  }
  if (margenX < radio && margenY < radio) {
      int indice = mapa.existeNodo(X,Y,radio);
      if (indice != -1) {
        updateNodo(indice);
    }else if(pantalla[Y][X] == 1 && mouseButton == RIGHT) {
        cambiarEstadoCarretera(indices[Y][X]);
    }else {
      if (pantalla[Y][X] == 1) {
        crearContenedor(X,Y,(int) random(255),(int) random(255),(int) random(255));
      }
    }
    println("Dibujar: " + dibujar);
  } else {
      crearCarretera(X,Y,newX,newY);
  }
}

void updateIndices () {
  if (ajuste != -1) {
    for (int x = 0; x < 1920; x++) {
      for (int y = 0; y < 1080; y++) {
        if (indices[y][x] >= ajuste && indices[y][x] != -1)
          indices[y][x] -= 1;
        if (indices2[y][x] >= ajuste && indices2[y][x] != -1)
          indices2[y][x] -= 1;
      }
    }
    ajuste = -1;
  }
}
void deleteAll() {
  numContenedores = 0;
  capacidad = 20;
  mostrar = 0;
  step = 0;
  for (int x = 0; x < 1920; x++) {
    for (int y = 0; y < 1080; y++) {
      indices[y][x] = -1;
      indices2[y][x] = -1;
      pantalla[y][x] = 0;
      if (x >= 1920/2-2*ancho && x < 1920/2-ancho && y >=0 && y < alto)
        pantalla[y][x] = 3;
      else if (x >= 1920/2-ancho && x < 1920/2 && y >=0 && y < alto)
        pantalla[y][x] = 4;
      else if (x >= 1920/2 && x < 1920/2+ancho && y >=0 && y < alto)
        pantalla[y][x] = 8;
      else if (x >= 1920/2+ancho && x < 1920/2+2*ancho && y >=0 && y < alto)
        pantalla[y][x] = 9;
      else if (x >= 1820 && x < 1920 && y >=0 && y < 50)
        pantalla[y][x] = 10;
    }
  }
  if (dibujar)
      dibujar = false;
  mapa.deleteAll();
  cruces = new ArrayList<Nodo>();
  carreteras = new ArrayList<Carretera>();
  camiones = new ArrayList<Camion>();
}
void crearContenedor(int x, int y, int r, int g, int b){
  Contenedor contenedor = new Contenedor(x,y,r,g,b);
  pantalla[y][x] = 5;
  if (dibujar == true)
    calcularRutas();
  try {
    mapa.addContenedor(carreteras.get(indices[y][x]).addContenedor(contenedor));
  } catch (IndexOutOfBoundsException e) {
    println("Error al añadir contenedor");
  } 
  mapa.setCarreteras(carreteras);
}
void crearCarretera(int xx, int yy, int newX, int newY) {
  int indice2 = carreteras.size();
  Carretera carretera = new Carretera(xx,yy,newX,newY,indice2);
  carreteras.add(carretera);
  int limX = (carreteras.get(indice2).getX()+carreteras.get(indice2).getAncho());
  int limY = (carreteras.get(indice2).getY()+carreteras.get(indice2).getAlto());
  int startX = carreteras.get(indice2).getX();
  int startY =  carreteras.get(indice2).getY();
  boolean cruce = false, seguro = true;
  Nodo nodo = null;
  for (int x = startX; x <= limX ; x++) {
    for (int y = startY; y <= limY; y++) {
      if (pantalla[y][x] == 0) {
        pantalla[y][x] = 1;
        indices[y][x] = indice2;
        cruce = false;
        seguro = true;
      } else if(pantalla[y][x] == 5) {
        carreteras.get(indices[y][x]).deleteContenedor(new Contenedor(x,y));
        pantalla [y][x] = 1;
        if (mapa.existeNodo(x,y,10) != -1) {
          mapa.deleteNodo(mapa.existeNodo(x,y,10));
        }
      } else if (pantalla[y][x] == 1){
          if (!cruce) {
            float estado = noise(y,x);
            if (estado >= 0.6) 
              estado = 2;
            else
              estado = 1;
            nodo = new Nodo ((2*x+30)/2,(2*y+30)/2,0,255,0,(int)estado);
            nodo.addCarretera(carretera);
            nodo.addCarretera(carreteras.get(indices[y][x]));
            carreteras.get(indice2).addCruce(nodo);
            carreteras.get(indices[y][x]).addCruce(nodo);
             carreteras.get(indices[y][x]).ordenar();
            mapa.addCruce(nodo);
            cruces.add(nodo);
            
          }
          cruce = true;
          pantalla[y][x] = 6;
          indices2[y][x] = indice2;
      }
    }
  }
  if (cruce && seguro) {
    pantalla[nodo.getY()][nodo.getX()] = 7;
    cruce = seguro = false;;
  }
  carretera.ordenar();
  mapa.setCarreteras(carreteras);
}

void cambiarEstadoCarretera(int indice){
  try {
    int estado = carreteras.get(indice).changeEstado();
    if (estado == 1) {
      int indice2 = indice;
      for (int x = carreteras.get(indice2).getX(); x <= carreteras.get(indice2).getX()+carreteras.get(indice2).getAncho(); x++) {
        for (int y = carreteras.get(indice2).getY(); y <= carreteras.get(indice2).getY()+carreteras.get(indice2).getAlto(); y++) {
          if (pantalla[y][x] == 5) {
            if (mapa.existeNodo(x,y,10) != -1)  {
              mapa.deleteNodo(mapa.existeNodo(x,y,10));
            }
          } else if (pantalla[y][x] == 7) {
              mapa.deleteCruce(x,y);
              cruces = null;
              cruces = mapa.getCruces();
              if (indices [y][x] == indice2) {
                 carreteras.get(indices2[y][x]).deleteCruce(x,y);
              } else {
                carreteras.get(indices[y][x]).deleteCruce(x,y);
              }
          }
          if (indices2[y][x] == -1)
             pantalla[y][x] = 0;
          else
            pantalla[y][x] = 1;
          if (indices [y][x] == indice2) {
             indices[y][x] = indices2[y][x];
          }
          indices2[y][x] = -1;
        }
      }
      carreteras.remove(indice2);
      mapa.setCarreteras(carreteras);
      if (indice2 != carreteras.size())
        ajuste = indice2;
    }
  } catch(IndexOutOfBoundsException e) {
    println("Ha ocurrido un error");
  }
}
void updateNodo(int indice) {
  if (mouseButton == RIGHT){
    Nodo nodo = mapa.getNodo(indice);
    int x = nodo.getX();
    int y = nodo.getY();
    pantalla[y][x] = 1;
    mapa.deleteNodo(indice);
    carreteras.get(indices[y][x]).deleteContenedor(new Contenedor(x,y));
    if (dibujar == true)
      calcularRutas();
  } else {
    mapa.setOrigen(indice,carreteras.get(indices[Y][X]));
  }   
}
void calcularRutas () {
  if (mapa.getOrigen() != null) {

    println("Empezado");
    dibujar = true;
    mapa.inicializar();
    if (!camiones.isEmpty()){
      mapa.setContenedores(mapa1.getContenedores ());
    }
    
    if (mapa1.getOrigen() != null) {
      if (!mapa1.getOrigen().isEqualTo(mapa.getOrigen())) {
        mostrar = 0;
      }
    }
    mapa1 = new Mapa(mapa);
    camiones = mapa.rutas2(50);
    println("finalizado");
  }
  else {
    dibujar = false;
  }   
}
void randomContenedores() {
  for (int x = 15; x < 1900; x+=25) {
    for (int y = 120; y < 1040; y+=30) {
      if (noise(x,y) > 0.4 && pantalla[y][x] == 1) {
         crearContenedor(x,y,3,93,6);
         numContenedores++;
      } 
    }
  }
}
void generateRandom() {
  deleteAll();
  ArrayList<Integer> anchos = new ArrayList<Integer>();
  for (int j = 0; j < 63; j++) {
    anchos.add(30+ j*30);
  }

  Collections.shuffle(anchos);
  Integer [] anchosInt = new Integer [63];
  anchos.toArray(anchosInt);
  for (int y = 0; y < 35; y++) {
    if (random(1) >= 0.3)
      crearCarretera(15+y*50,120,25+y*50,1040);
  }
  for (int x = 0; x < 18; x++) {
    crearCarretera(15,120+x*50,15+anchosInt[x],150+x*50);
  }
  ArrayList<Carretera> carreteras1 = new ArrayList<Carretera>();
  for (Carretera carretera : carreteras){
    carretera.changeEstado();
    carretera.ordenar();
    if (!carretera.getCruces().isEmpty())
      carreteras1.add(carretera);
  }
  carreteras = carreteras1;
  randomContenedores();
  mapa.setCarreteras(carreteras);
}
