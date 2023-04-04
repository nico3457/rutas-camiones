import java.util.ArrayList;
  public class Nodo implements Comparable<Nodo> {
    public ArrayList<Edge> neighbors = new ArrayList<Edge>();
    private ArrayList <Carretera> carreteras = new ArrayList<Carretera>();
    public Nodo parent = null;
    private int x,y;
    private int referenciaX;
    private int referenciaY;
    private int r;
    private int g;
    private int b;
    private int r2;
    private int g2;
    private int b2;
    private int estado; // 0 contenedor, 1 cruce 2 rotonda
    public double h;
    public double f =  Double.MAX_VALUE;
    public double G =  Double.MAX_VALUE;
    public double distanciaMax = 0;
    public void reiniciar() {
      f =  Double.MAX_VALUE;
      G =  Double.MAX_VALUE;
    }
    public Nodo () {
        x = (int) (Math.ceil(Math.random()*1900));
        y = (int) (Math.ceil(Math.random()*1000));
        referenciaX = 0;
        referenciaY = 0;
    }
    public Nodo(int x, int y){
        this.x = x;
        this.y = y;
        referenciaX = 0;
        referenciaY = 0;
    }
     public Nodo(int x, int y, int estado){
        this.x = x;
        this.y = y;
        this.estado = estado;
        referenciaX = 0;
        referenciaY = 0;
    }
    public Nodo(int x, int y, int r, int g, int b){
        this.x = x;
        this.y = y;
        referenciaX = 0;
        referenciaY = 0;
        this.setColor(r,g,b);
    }
    public Nodo(int x, int y, int r, int g, int b,int estado){
        this.estado = estado;
        this.x = x;
        this.y = y;
        referenciaX = 0;
        referenciaY = 0;
        this.setColor(r,g,b);
    }
      class Edge {
      public double weight;
      public Nodo Nodo;
            Edge(double weight, Nodo Nodo){
                  this.weight = weight;
                  this.Nodo = Nodo;
            }   
            public int getX() {
              return Nodo.getX();
            }
            public int getY() {
              return Nodo.getY();
            }
      }

      public void addBranch(double weight, Nodo Nodo){
            Edge newEdge = new Edge(weight, Nodo);
            neighbors.add(newEdge);
      }
      public void display() {
        stroke(r2,g2,b2);
        println("Vecinos: " + neighbors.size());
        for (Edge neighbor : neighbors) {
          line(x,y,neighbor.getX(),neighbor.getY());
        }
      }
      public void setColor2 (int r, int g, int b) {
        r2 = r;
        g2 = g;
        b2 = b;
      }
      public double calculateHeuristic(Nodo target){
            h = calcularDistancia(target);
            return this.h;
      }
    public void addCarretera (Carretera carretera) {
      carreteras.add(carretera);
    }
    @Override
    public int compareTo(Nodo n) {
          return Double.compare(this.f, n.f);
    }
    public void setDistanciaMax(double distancia) {
      distanciaMax = distancia;
    }
    public double getDistanciaMax () {
      return distanciaMax;
    }
    public ArrayList<Carretera> getCarretera() {
      return carreteras;
    }
    public int getEstado(){
      return estado;
    }
    
    public double calcularDistancia (Nodo origen) {
        return Math.sqrt(Math.abs((origen.getX()-this.x)*(origen.getX()-this.x)+(origen.getY()-this.y)*(origen.getY()-this.y)));
    }

    public int getX() {
        return x;
    }
    public int getR() {
        return r;
    }
    public int getG() {
        return g;
    }
    public int getB() {
        return b;
    }
    public int getY() {
        return y;
    }
    public Nodo getReferencia() {
        return new Nodo(referenciaX,referenciaY);
    }
    public void setX(int x) {
        this.x = x;
    }
    public void setY(int y) {
        this.y = y;
    }
    public void setReferencia(int referenciaX, int referenciaY) {
        this.referenciaX = referenciaX;
        this.referenciaY = referenciaY;
    }

    public String toString() {
        return "X:" + x + " Y:" + y;
    }
    void display (int radio) {
      fill(r,g,b);
      circle(x,y,radio);
    }
    void displayRadio (int radio) {
      noFill();
      circle(x,y,radio);
    }
    
    void setColor (int r, int g, int b) {
      this.r = r;
      this.g = g;
      this.b = b;
    }
    public boolean isEqualTo(Nodo nodo) {
      return (x == nodo.getX()) && (y == nodo.getY());
    }
    public Carretera mismaCarretera(Nodo cruce) {
      ArrayList<Carretera> carreteras = cruce.getCarretera();
      if (carreteras == null)
        return null;
      for (Carretera carretera : carreteras) {
        for (Carretera carretera2 : this.carreteras) {
          if (carretera.isEqual(carretera2)) 
            return carretera;
        }
      }
      return null;
    }
}
