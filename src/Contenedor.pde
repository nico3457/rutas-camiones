
class Contenedor extends Nodo {
    private int capacidad = 0;
    private int ocupado;
    public Contenedor(int x, int y) {
        super(x,y);
        capacidad = (int) Math.ceil(random(2))+1;
    }
    public Contenedor(int x, int y, int r, int g, int b) {
        super(x,y,r,g,b);
        capacidad = (int) Math.ceil(random(2))+1;
    }

    public int getCapacidad() {
        return capacidad;
    }

    public int getOcupado() {
        return ocupado;
    }

    public void setOcupado (int ocupado) {
        this.ocupado = ocupado;
    }
    
}
