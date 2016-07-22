import java.util.*;

public class UVa657 { /* The die is cast */
  static int i, j, x, y, w, h, caseNo = 1, freq[] = new int[6];
  static int dr[] = new int[] {-1, 0, 1, 0}; // N/E/S/W 
  static int dc[] = new int[] { 0, 1, 0,-1};
  static char data[][] = new char[60][60];

  static int delete_dice(int x, int y, char d) {
    if (x < 0 || x >= h || y < 0 || y >= w || data[x][y] == '.')
      return 0;

    if (data[x][y] == d) {
      data[x][y] = '.'; // clean it
      int ans = 0;
      for (int dir = 0; dir < 4; dir++)
        ans += delete_dice(x + dr[dir], y + dc[dir], d);
      return ans;
    }
    else { // data[x][y] must be 'X' as we have pruned '.' earlier
      if (d == 'X')
        return 0;
      delete_dice(x, y, 'X'); // now clean 'X' and its surrounding
      return 1;
    }
  }

  public static void main(String[] args) {
    Scanner sc = new Scanner(System.in);
    while (true) {
      w = sc.nextInt(); h = sc.nextInt(); sc.nextLine();
      if (w == 0 && h == 0)
        break;
      
      // read the "picture"
      for (i = 0; i < h; i++)
        data[i] = sc.nextLine().toCharArray();

      // count frequency
      for (i = 0; i < 6; i++)
        freq[i] = 0;
      for (x = 0; x < h; x++)
        for (y = 0; y < w; y++)
          if (data[x][y] == '*') // a dice, so delete this dice and at the same time figure out the number on that dice
            freq[delete_dice(x, y, '*') - 1]++;

      // output
      System.out.printf("Throw %d\n", caseNo++);
      Boolean first = true;
      for (i = 0; i < 6; i++)
        for (j = 0; j < freq[i]; j++) {
          if (!first)
            System.out.printf(" ");
          first = false;
          System.out.printf("%d", i + 1);
        }
      System.out.printf("\n\n");
    }
  }
}
