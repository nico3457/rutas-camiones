

class Carretera {
  private int x;
  private int y;
  private int alto;
  private int indice;
  private int ancho;
  private int inclinacion;
  private int sentido = 0; // 0 sentido unico, 1 sentido doble
  private ArrayList<Contenedor> contenedoresDerecha = new ArrayList<Contenedor>();
  private ArrayList<Contenedor> contenedoresIzquierda = new ArrayList<Contenedor>();
  private ArrayList<Nodo> cruces = new ArrayList<Nodo>();
  public Carretera(int X, int Y, int newX, int newY, int indice) {
    this.indice = indice;
    int diferenciaX = X-newX;
    int diferenciaY = Y-newY;
    if (Math.abs(diferenciaX) > Math.abs(diferenciaY)) {
        ancho = Math.abs(diferenciaX);
        alto = 30;
        inclinacion = 0;
        if (diferenciaX < 0) {
              x = X;
              y = Y;
        } else {
          x = newX;
          y = newY;
        }
    } else {
      inclinacion = 90;
      ancho = 30;
      alto = Math.abs(diferenciaY);
      if (diferenciaY < 0) {
            x = X;
            y = Y;
      } else {
        x = newX;
        y = newY;
      }
    }
  }
  public Carretera(int X, int Y, int newX, int newY) {
    int diferenciaX = X-newX;
    int diferenciaY = Y-newY;
    if (Math.abs(diferenciaX) > Math.abs(diferenciaY)) {
        ancho = Math.abs(diferenciaX);
        alto = 30;
        inclinacion = 0;
        if (diferenciaX < 0) {
              x = X;
              y = Y;
        } else {
          x = newX;
          y = newY;
        }
    } else {
      inclinacion = 90;
      ancho = 30;
      alto = Math.abs(diferenciaY);
      if (diferenciaY < 0) {
            x = X;
            y = Y;
      } else {
        x = newX;
        y = newY;
      }
    }
  }
  public Carretera () {
  }
  public ArrayList<Contenedor> getContenedores (int lado) {
    if (lado == 0)
      return contenedoresDerecha;
    return contenedoresIzquierda;
  }
  public void setContenedores (ArrayList<Contenedor> contenedores,int lado) {
    if (lado == 0)
      contenedoresDerecha = contenedores;
    else
      contenedoresIzquierda = contenedores;
  }
  public int getIndice() {
    return indice;
  }
  public int getAncho() {
    return ancho;
  }
  public int getAlto(){
    return alto;
  }
  public int getX() {
    return x;
  }
  public int getY(){
    return y;
  }
  public int changeEstado() {
    sentido = (sentido+1);
    if (sentido == 2)
     return 1;
   return 0;
  }
  public boolean contiene (Contenedor contenedor, int lado) {
    ArrayList<Contenedor> contenedores = getContenedores(lado);
    for (Contenedor contenedor1 : contenedores) {
      if (contenedor.isEqualTo(contenedor1))
        return true;
    }
    return false;
  }
  public Contenedor addContenedor (Contenedor contenedor) {
    if (inclinacion == 0) {
      if (contenedor.getY() > y && contenedor.getY() < y + alto/2) {
        contenedor.setY(y+alto/4);
        contenedoresDerecha.add(contenedor);
      } else {
        contenedoresIzquierda.add(contenedor);
         contenedor.setY(y+3*alto/4);
      }
    } else {
        if (contenedor.getX() >= x && contenedor.getX() < x + ancho/2) {
          contenedor.setX(x+ancho/4);
          contenedoresDerecha.add(contenedor);
        } else {
          contenedor.setX(x+3*ancho/4);
          contenedoresIzquierda.add(contenedor);
        }
      }
      return contenedor;
  }
  public void deleteContenedor(Nodo eliminar) {
     for (int j = 0; j < contenedoresDerecha.size()-1 ; j++) {
        if (eliminar.isEqualTo(contenedoresDerecha.get(j))) {
          contenedoresDerecha.remove(j);
          break;
        }
     }
     for (int j = 0; j < contenedoresIzquierda.size()-1 ; j++) {
        if (eliminar.isEqualTo(contenedoresIzquierda.get(j))) {
          contenedoresIzquierda.remove(j);
          break;
        }
     }
  }
  public void ordenar() {
    Collections.sort(contenedoresDerecha, new distanciaCompare());
    Collections.sort(contenedoresIzquierda, new distanciaCompare());
    Collections.sort(cruces, new distanciaCompare());
  }
  public ArrayList<Nodo> getCruces() {
    return cruces;
  }
  public boolean existeCruce (Nodo cruce) {
    for (Nodo pos : cruces) {
      if (pos.isEqualTo(cruce))
        return true;
    }
    return false;
  }
  public void addCruce (Nodo nodo) {
    cruces.add(nodo);
  }
  public String toString() {
    String result = "Inclinacion:" + inclinacion + " X: " + x + " Y: " + y; 
    return result;
  }
  public void deleteCruce(int x,int y){
    Nodo nodo = new Nodo (x,y);
    int i = 0;
    for (Nodo cruce : cruces) {
      if (nodo.isEqualTo(cruce)){
        cruces.remove(i);
        break;
      }
      i++;
    }
  }
  public boolean tieneContenedor(Contenedor posible) {
    ArrayList<Contenedor> contenedores = new ArrayList<Contenedor>(contenedoresDerecha);
    contenedores.addAll(contenedoresIzquierda);
    for (Contenedor contenedor : contenedores) {
      if (contenedor.isEqualTo(posible))
        return true;
    }
    return false;
  }
  public boolean tieneCruce(){
    return cruces == null;
  }
  public boolean isEqual(Carretera carretera) {
    return x == carretera.getX() && y == carretera.getY() && ancho == carretera.getAncho() && alto == carretera.getAlto();
  }
  public int getLado (Nodo cruce) {
    if (inclinacion == 0) {
      if (cruce.getY() > this.y && cruce.getY() < this.y+alto/2)
        return 0; // derecha
      else if (cruce.getY() < this.y+ancho && cruce.getY() > this.y+alto/2)
        return 1; // izquierda
    } else {
      if (cruce.getX() > this.x && cruce.getX() < this.x+ancho/2)
        return 0; // derecha
      else if (cruce.getX() < this.x+ancho && cruce.getX() > this.x+ancho/2)
        return 1; // izquierda
    }
    return -1;
  }
  public void display () {
    fill (183,183,183,10);
    rect(x,y,ancho,alto);
    if (sentido == 1) {
      if (ancho >= alto) {
        int ajuste = 8;
        for (int X = x; X < x+ancho ; X+= 11) {
          if (ajuste > x+ancho-X) {
            ajuste = x + ancho - X;
          }
          line(X,y+alto/2,X+ajuste,y+alto/2);
         }
       } else {
            int ajuste = 8;
            for (int Y = y; Y < y+alto ; Y+= 11) {
              if (ajuste > y+alto-Y) {
                ajuste = y + alto - Y;
              }
              line(x+ancho/2,Y,x+ancho/2,Y+ajuste);
            }
        }    
      }
    }
}
