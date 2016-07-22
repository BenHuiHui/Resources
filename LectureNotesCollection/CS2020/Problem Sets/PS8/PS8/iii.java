public class iii implements Comparable {
  Integer _first, _second, _third;

   public iii(Integer f, Integer s, Integer t) {
     _first = f;
     _second = s;
     _third = t;
   }

   public int compareTo(Object o) {
     if (this.first() != ((iii)o).first()) // first priority: sort based on the first Integer 
       return this.first() - ((iii)o).first();
     else if (this.second() != ((iii)o).second()) // second priority: sort based on the second Integer 
       return this.second() - ((iii)o).second();
     else // last priority: sort based on the third Integer
       return this.third() - ((iii)o).third();
   }
   
   Integer first() { return _first; }
   Integer second() { return _second; }
   Integer third() { return _third; }
   
   public String toString() {
     return "[" + _first.toString() + ", " + _second.toString() + ", " + _third.toString() + "]"; 
   }
}
