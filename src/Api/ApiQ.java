package Api;
import org.jpl7.*;

import java.util.HashSet;
import java.util.Map;
import java.util.Set;

public class ApiQ {
    Set<String> getSolution(int r, int c, int x1r, int x1c, int x2r, int x2c) {
        Query q = new Query("consult('Final_Q2.pl')");
        q.hasSolution();
        String query = "create_Board(" + r + "," + c + "," + x1r + "," + x1c + "," + x2r + "," + x2c + ",State)";
        q = new Query(query);
        Map<String, Term>[] allsoulutions = q.allSolutions();
        Set<String> usolution=new HashSet<>();
        for (Map<String,Term> s :allsoulutions){
        Term term=s.get("State");
        usolution.add(term.toString());
        }
        return usolution;
    }

}

