import java.util.Comparator;

public class distanciaCompare implements Comparator<Nodo> {
    @Override
    public int compare(Nodo a, Nodo b) {
    if (a.calcularDistancia(a.getReferencia()) > b.calcularDistancia(b.getReferencia()))
      return 1;
        if (a.calcularDistancia(a.getReferencia()) < b.calcularDistancia(b.getReferencia()))
      return -1;
    return 0;
   }
}
