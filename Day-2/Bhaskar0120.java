import java.io.FileReader;
import java.util.Scanner;
import java.io.IOException;

class Bhaskar0120{
  public static void main(String[] args){
    try{
      Scanner sc = new Scanner(new FileReader("inp.txt"));
      int score = 0;
      while(sc.hasNext()){
        int F = sc.next().charAt(0);
        int S = sc.next().charAt(0);
        F -= 65; S -= 88;
        int l = 0;
        score += S+1;
        while((S+l)%3 != F) l++;
        if(l == 2)
          score += 6;
        else if(l == 0)
          score += 3;
      }
      System.out.println("Easy: "+score);
      sc = new Scanner(new FileReader("inp.txt"));
      score = 0;
      while(sc.hasNext()){
        int F = sc.next().charAt(0);
        int S = sc.next().charAt(0);
        F -= 65;
        if(S == 88){
          F = ((F+2)%3)+1;
          score += F;
        }
        else if(S == 89){
          F += 1;
          score += 3+F;
        }
        else{
          F = ((F+1)%3)+1;
          score += 6+F;
        }
      }
      System.out.println("Hard: "+score);


    }
    catch(IOException e){
      System.out.println(e);
    }
  }
}
