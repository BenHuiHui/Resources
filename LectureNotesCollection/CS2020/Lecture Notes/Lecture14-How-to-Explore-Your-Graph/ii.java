public class ii implements Comparable {
  Integer _first, _second;

   public ii(Integer f, Integer s) {
     _first = f;
     _second = s;
   }

   public int compareTo(Object o) {
     if (this.first() != ((ii)o).first())
       return this.first() - ((ii)o).first();
     else
       return this.second() - ((ii)o).second();
   }

   Integer first() { return _first; }
   Integer second() { return _second; }
}
