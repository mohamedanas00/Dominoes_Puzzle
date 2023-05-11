package Api;
import java.util.Scanner;
import java.util.ArrayList;
import java.util.Set;


public class Main {
    static ArrayList<Integer>take_solution(String s) {
        ArrayList<Integer> gui = new ArrayList<>();
        for (int i = 0; i < s.length(); i++) {
            if (s.charAt(i) == '0' || s.charAt(i) == '1' || s.charAt(i) == '2' || s.charAt(i) == '6') {
                int c = (int) s.charAt(i) - 48;
                gui.add(c);
            }
        }
            return gui;

    }
    static void th_Gui(Set<String> sol, int l,int v){
        for(String gui:sol){
            ArrayList<Integer> g=take_solution(gui);
            GuiScreen guiScreen=new GuiScreen(g,l,v);
        }
    }





    public static void main(String[] args) {
        ApiQ apiQ=new ApiQ();
//        Scanner scanner = new Scanner(System.in);
//        System.out.print("    Enter the number of rows: ");
//        int Row = Integer.parseInt(scanner.nextLine());
//        System.out.print("    Enter the number of Columns: ");
//        int Columns = Integer.parseInt(scanner.nextLine());
//        System.out.print("    Enter the Position of Row for First Bomb: ");
//        int Brow1 = Integer.parseInt(scanner.nextLine());
//        System.out.print("    Enter the Position of Colum for First Bomb: ");
//        int BColum1 = Integer.parseInt(scanner.nextLine());
//        System.out.print("    Enter the Position of Row for Second Bomb: ");
//        int Brow2 = Integer.parseInt(scanner.nextLine());
//        System.out.print("    Enter the Position of Colum for Second Bomb: ");
//        int BColum2 = Integer.parseInt(scanner.nextLine());
//        Set<String> sol =apiQ.getSolution(Row,Columns,Brow1,BColum1,Brow2,BColum2);
        Set<String> sol =apiQ.getSolution(3,3,1,3,2,1);
        th_Gui(sol,3,3);
    }
}