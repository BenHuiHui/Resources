public class ii implements Comparable {
  Integer _first, _second;

   public ii(Integer f, Integer s) {
     _first = f;
     _second = s;
   }

   public int compareTo(Object o) {
     if (this.first() != ((ii)o).first()) // first priority: sort based on the first Integer 
       return this.first() - ((ii)o).first();
     else // second priority: sort based on the second Integer 
       return this.second() - ((ii)o).second();
   }

   Integer first() { return _first; }
   Integer second() { return _second; }
   
   public String toString() {
     return "[" + _first.toString() + ", " + _second.toString() + "]"; 
   }
}
