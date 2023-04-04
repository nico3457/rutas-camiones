import java.util.ArrayList;
import java.util.PriorityQueue;
import java.util.Collections;

class Mapa  {
    private ArrayList nodos;
    private ArrayList<Carretera> carreteras = new ArrayList<Carretera> ();
    private ArrayList<Nodo> cruces = new ArrayList<Nodo> ();
    private Nodo origen = null;
    public Mapa (ArrayList nodos){
        this.nodos = nodos;
    }   
    public Mapa () {
      nodos = new ArrayList();
    }
      public Mapa (Mapa mapa) {
        nodos = new ArrayList(mapa.getContenedores ());
        origen = mapa.getOrigen();
        carreteras = new ArrayList<Carretera> (mapa.getCarreteras());
        cruces = new ArrayList<Nodo> (mapa.getCruces());
    }
    public void setCruces (ArrayList<Nodo> cruces) {
      this.cruces = cruces;
    }
    public ArrayList getContenedores () {
        return nodos;
    }

    public ArrayList getContenedores(ArrayList<Camion> camiones) {
        ArrayList nodos = new ArrayList();
        for(Camion camion : camiones) {
            nodos.addAll(camion.getContenedores());
        }
        return nodos;
    }
   public void addContenedor(Contenedor contenedor) {
     if (nodos.size() == 0) {
       setOrigen(contenedor);
     }
     nodos.add(contenedor);
   }
   
   private ArrayList<Nodo> getCruces () {
     return cruces;
   }
   
  public int existeNodo(int x, int y, int radio) {
    int i = 0;
    int radio2 = radio;
    for(Object objetos : nodos) {
      int margenX = (int) (Math.abs(((Nodo)objetos).getX() - x));
      int margenY = (int) (Math.abs(((Nodo)objetos).getY() - y));
      if (origen.isEqualTo((Nodo)objetos))
        radio2 = 30;
      if (margenX <= radio2 && margenY <= radio2) {
        return i;
      }
      radio2 = radio;
      i++;
    }
    return -1;
  }
  public Nodo getOrigen () {
    return origen;
  }
  public void setOrigen (int origen, Carretera carretera) {
      this.origen = (Nodo) nodos.get(origen);
      this.origen.addCarretera(carretera);
  }
   public void setOrigen (int origen) {
      this.origen = (Nodo) nodos.get(origen);
      for (Carretera carretera : carreteras) {
        if (carretera.tieneContenedor((Contenedor) this.origen)) {
          this.origen.addCarretera(carretera);
        }
      }
  }
  public void setOrigen (Nodo origen) {
      this.origen = origen;
      for (Carretera carretera : carreteras) {
        if (carretera.tieneContenedor((Contenedor) this.origen)) {
          this.origen.addCarretera(carretera);
        }
      }
  }
  public void setContenedores (ArrayList contenedores) {
    nodos = contenedores;
  }
  public Nodo getNodo(int i) {
    return (Nodo) nodos.get(i);
  }
  
  public void deleteNodo(int indice) {
    Nodo nuevoOr = (Nodo) nodos.get(indice);
    if (indice <= nodos.size() -1) {
      nodos.remove(indice);
    }
    if (nodos.size() > 0) {
      if (nuevoOr.isEqualTo(origen))
        setOrigen((Contenedor) nodos.get(0));
    } else
      origen = null;
  }
  void display (int radio) {
    for (Object objeto : nodos ) {
      ((Nodo) objeto).display(radio);
    }
  }
  public void setCarreteras(ArrayList<Carretera> carreteras) {
    this.carreteras = carreteras;
  }
  public void addCruce (Nodo cruce) {
    cruces.add(cruce);
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
  public ArrayList<Contenedor> contenedoresCarretera(Carretera carretera,int lado) {
    ArrayList<Contenedor> contenedores = new ArrayList<Contenedor>();
    for (Object objeto : nodos) {
      Contenedor contenedor = (Contenedor) objeto;
      if (carretera.contiene(contenedor,lado))
        contenedores.add(contenedor);
    }
    return contenedores;
  }
  public void eliminarNodo (Contenedor contenedor) {
    int i = 0;
    for (Object objeto : nodos) {
      if (((Contenedor)objeto).isEqualTo(contenedor))
        break;
       i++;
    }
    nodos.remove(i);
  }
  public ArrayList<Carretera> getCarreteras() {
    return carreteras;
  }
  public void inicializar() {
      int posicion = 5;
      for (Nodo cruce1 : cruces) {
        double distanciaDerecha = Double.MAX_VALUE, distanciaIzquierda = Double.MAX_VALUE, distanciaArriba = Double.MAX_VALUE, distanciaAbajo = Double.MAX_VALUE;
        double distancia;
        Nodo abajo = null, arriba = null, derecha = null, izquierda = null;
        cruce1.setColor2((int) random(255),(int) random(255),(int) random(255));
        for (Nodo cruce2 : cruces) {
          if (cruce1.isEqualTo(cruce2))
            continue;
          if (cruce1.mismaCarretera(cruce2) != null) {
            distancia = cruce1.calcularDistancia(cruce2);
            if (cruce2.getX() > cruce1.getX())
               posicion = 0;
            else if (cruce2.getY() > cruce1.getY())
               posicion = 1;
            else if (cruce2.getX() < cruce1.getX())
               posicion = 2;
            else if (cruce2.getY() < cruce1.getY())
               posicion = 3;
            if (posicion == 0 && distancia < distanciaDerecha) {
                distanciaDerecha = distancia;
                derecha = cruce2;
            } else if (posicion == 1 && distancia < distanciaAbajo) {
               distanciaAbajo = distancia;
               abajo = cruce2;
           }else if (posicion == 2 && distancia < distanciaIzquierda) {
               distanciaIzquierda = distancia;
               izquierda = cruce2;
           } else if (posicion == 3 && distancia < distanciaArriba) {
               distanciaArriba = distancia;
               arriba = cruce2;
           }   
          }
        }
         if (abajo != null)
           cruce1.addBranch(cruce1.calcularDistancia(abajo),abajo);
         if (arriba != null)
           cruce1.addBranch(cruce1.calcularDistancia(arriba),arriba);
         if (derecha != null)
           cruce1.addBranch(cruce1.calcularDistancia(derecha),derecha);
         if (izquierda != null)
           cruce1.addBranch(cruce1.calcularDistancia(izquierda),izquierda);
      }
      Nodo origen1 = origen.getCarretera().get(0).getCruces().get(origen.getCarretera().get(0).getCruces().size()-1);
      for (Object objetito : nodos) {
        Nodo target = (Nodo) objetito;
        Nodo targetCruce = target;
       
        Carretera currentCarretera = null;
        ArrayList<Carretera> carreteras1 = mapa.getCarreteras();
        for (Carretera carretera : carreteras1 ) {
          if (carretera.tieneContenedor((Contenedor) target)) {
            currentCarretera = carretera;
          }
        }
        double minDist = Double.MAX_VALUE;
        ArrayList<Nodo> cruces1 = currentCarretera.getCruces();
        for (Nodo cruce : cruces1) {
          double dist = cruce.calcularDistancia(target);
          if (dist < minDist) {
             targetCruce = cruce;
             minDist = dist;
          }
        }
        ArrayList<Nodo> camino = mapa.aStar(origen1,targetCruce);
        double distancia = 0;
        Nodo actual = origen;
        for (Nodo siguiente : camino) {
          distancia += actual.calcularDistancia(siguiente);
          actual = siguiente;
        }
        distancia+= targetCruce.calcularDistancia(target);
        target.setDistanciaMax(distancia);
        reiniciarCruces();
      }
  
  }
  public ArrayList<Camion> rutas2 (int capacidad) {
    inicializar();
    ArrayList<Camion> camiones = new ArrayList<Camion>();
    Nodo origen1 = origen.getCarretera().get(0).getCruces().get(origen.getCarretera().get(0).getCruces().size()-1);
     while (nodos.size() > 1) {
        Nodo target = null;
        double minDist = 0;
        for (Object objeto : nodos) {
          Nodo contenedor = (Nodo) objeto;
          double dist = contenedor.getDistanciaMax();
          if (dist > minDist) {
             target = contenedor;
             minDist = dist;
          }
        }
        Nodo targetCruce = target;
        minDist = Double.MAX_VALUE;
        Carretera currentCarretera = null;
        ArrayList<Carretera> carreteras1 = mapa.getCarreteras();
        for (Carretera carretera : carreteras1 ) {
          if (carretera.tieneContenedor((Contenedor) target)) {
            currentCarretera = carretera;
          }
        }
        ArrayList<Nodo> cruces1 = currentCarretera.getCruces();
        for (Nodo cruce : cruces1) {
          double dist = cruce.calcularDistancia(target);
          if (dist < minDist) {
             targetCruce = cruce;
             minDist = dist;
          }
        }
        Camion camion = new Camion(capacidad);
        
        camion.setRuta(mapa.aStar(origen1,targetCruce));
        reiniciarCruces();
        camion.setColor((int)random(255),(int)random(255),(int)random(255));
        
        camion.recogerBasura(mapa.recogerBasura(camion.getCruces(),target));
        
        camion.addContenedor((Contenedor) target);
        if (camion.getLibre() > camion.getCapacidad()*0.1) {
          for (Object objeto : nodos) {
            Contenedor contenedor = (Contenedor) objeto;
            if (target.calcularDistancia(contenedor) < 20 && contenedor.getCapacidad() + camion.getOcupado() < camion.getLibre()) {
               target = contenedor;
               camion.addContenedor((Contenedor) target);
            }
              
          }
        }
        if (mapa.existeNodo(target.getX(),target.getY(),10) != -1)
          mapa.eliminarNodo((Contenedor) target);
          
        camiones.add(camion);  
        
        }
    return camiones;
  }
  public ArrayList<Nodo> aStar(Nodo start, Nodo target){
    PriorityQueue<Nodo> closedList = new PriorityQueue<>();
    PriorityQueue<Nodo> openList = new PriorityQueue<>();
    start.G = 0;
    start.f = start.G + start.calculateHeuristic(target);
    openList.add(start);
    while(!openList.isEmpty()){
        Nodo n = openList.peek();
        if(n.isEqualTo(target)){
          closedList.add(n);
          break;
        }

        for(Nodo.Edge edge : n.neighbors){
            Nodo m = edge.Nodo;
            double totalWeight = n.G + edge.weight;

            if(!openList.contains(m) && !closedList.contains(m)){
                m.parent = n;
                m.G = totalWeight;
                m.f = m.G + m.calculateHeuristic(target);
                openList.add(m);
            } else {
                if(totalWeight < m.G){
                    m.parent = n;
                    m.G = totalWeight;
                    m.f = m.G + m.calculateHeuristic(target);

                    if(closedList.contains(m)){
                        closedList.remove(m);
                        openList.add(m);
                    }
                }
            }
        }
        openList.remove(n);
        closedList.add(n);
    }
    if (!closedList.isEmpty()) {
       ArrayList<Nodo> camino = new ArrayList<>();
        Nodo n = target;
        while(n.parent != null){
            camino.add(n);
            n = n.parent;
        }
        camino.add(n);
        Collections.reverse(camino);
        return camino;
    }
    return null;
  }
  public ArrayList<Contenedor> recogerBasura (ArrayList<Nodo> cruces1, Nodo target) {
    int i = 0;
    int capacidad = 50;
    ArrayList<Contenedor> solucion = new ArrayList<Contenedor>();
    cruces1.add(target);
    ArrayList<Nodo> cruces = new ArrayList<Nodo>();
    for (int p = cruces1.size() -1; p > -1; p--) {
      cruces.add(cruces1.get(p));
      }
    int lleno = 0;
    for (Nodo cruce : cruces ) {
      if (i==0) {
        i++;
        continue;
      }
      
     ArrayList<Contenedor> solucionIntermedia = new ArrayList<Contenedor>();
      Nodo a = cruce;
      Nodo b = cruces.get(i-1);
      Nodo mayor = null;
      Nodo menor = null;
      boolean recta = Math.abs((a.getY()-b.getY()))<10;
      if (a.getX() > b.getX() || a.getY() > b.getY()) {
        mayor = a;
        menor = b;
      } else {
        mayor = b;
        menor = a;
      }
      for (Object objeto : nodos) {
        Contenedor contenedor = (Contenedor) objeto;
        if (recta) {
          if (Math.abs(contenedor.getY()-mayor.getY()) < 25 ) {
            if (contenedor.getX() <= mayor.getX() && contenedor.getX() >= menor.getX() && lleno + contenedor.getCapacidad() <= capacidad){
                 lleno += contenedor.getCapacidad();
                 solucionIntermedia.add(contenedor);
              } 
            }
        } else {
          if (Math.abs(contenedor.getX()-mayor.getX()) < 25) {
            if (contenedor.getY() <= mayor.getY() && contenedor.getY() >= menor.getY() && lleno + contenedor.getCapacidad() <= capacidad) {
               lleno += contenedor.getCapacidad();
               solucionIntermedia.add(contenedor);
            }
          }
        }
      }
      for (Contenedor contenedor : solucionIntermedia) {
        solucion.add(contenedor);
        eliminarNodo(contenedor);
      }
      if (i >= cruces.size()-2)
        break;
      i++;
    }
    return solucion;  
  }
  public void deleteAll() {
    nodos = new ArrayList();
    visitados = new ArrayList();
    origen = null;
    cruces = new ArrayList<Nodo>();
  }
}
