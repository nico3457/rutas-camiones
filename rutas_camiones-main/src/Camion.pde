import java.util.Collections;
class Camion {
    private int ocupado = 0;
    private int capacidad = 0;
    private int libre;
    private int referenciaX;
    private int referenciaY;
    private ArrayList contenedores = new ArrayList();
    private ArrayList<Nodo> cruces = new ArrayList<Nodo> ();
    private int r;
    private int g;
    private int b;
    public Camion (Contenedor contenedor,int capacidad,int ocupado) {
        contenedores.add(contenedor);
        this.capacidad = capacidad;
        this.ocupado = ocupado;
        libre = capacidad-ocupado;
    }


    public Camion (int capacidad,int ocupado) {
        this.capacidad = capacidad;
        this.ocupado = ocupado;
        libre = capacidad-ocupado;
    }
    public Camion (int capacidad) {
        this.capacidad = capacidad;
        libre = capacidad;
    }
 
    void setColor (int r, int g, int b) {
      this.r = r;
      this.g = g;
      this.b = b;
    }
    public void setReferencia (int x, int y) {
      X = x;
      Y = y;
    }
    public void recogerBasura(ArrayList<Contenedor> basura) {
      contenedores.addAll(basura);
    }
    public void addCruce (Nodo cruce) {
      cruces.add(cruce);
    }
    
    public int getCapacidad() {
        return capacidad;
    }

    public int getOcupado() {
        return ocupado;
    }
    public int getLibre() {
        return libre;
    }

    public ArrayList getContenedores() {
        return contenedores;
    }

    public void setCapacidad (int capacidad) {
        this.capacidad = capacidad;
    }

    public void addContenedor (Contenedor contenedor) {
        contenedores.add(contenedor);
        ocupado = ocupado + contenedor.getCapacidad();
        libre = libre-contenedor.getCapacidad();
    }

    public String toString() {
        String camion = "Camion: {";
        for(Object object: contenedores) {
            Contenedor contenedor = (Contenedor) object;
            camion = camion + contenedor.getCapacidad() + ",";
        }
        camion = camion + "}";
        return camion;
    }

   void displayLines (Nodo origen) {
     int x = origen.getX(), y = origen.getY();
      for (Nodo cruce : cruces) {
        stroke(r,g,b);
        line(x, y, cruce.getX(), cruce.getY());
        x = cruce.getX();
        y = cruce.getY();
      }
      popStyle();
      for (Object objeto : contenedores) {
        Contenedor contenedor = (Contenedor) objeto;
        contenedor.setColor(r,g,b);
      }
    }
    public void setRuta(ArrayList<Nodo> cruces) {
      this.cruces = cruces;
    }
    public ArrayList<Nodo> getCruces () {
      return cruces;
    }
    public void showCruces () {
      println(cruces);
    }
}
