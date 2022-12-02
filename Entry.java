import java.sql.*;
import java.util.Scanner;

public class Entry {
    private static final Scanner S = new Scanner(System.in);

    private static Connection c = null;
    private static ResultSet rs = null;
    public static void main(String[] args) {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
		    String url = "jdbc:mysql://localhost:3308/morgan";

            c = DriverManager.getConnection(url, "root", ""); 
		
            Statement s = c.createStatement(ResultSet.TYPE_SCROLL_INSENSITIVE, ResultSet.CONCUR_UPDATABLE);
            rs = s.executeQuery("select student.no,student.name,due from loan inner join student on student.no=loan.no where ret is NULL and YEAR(taken) = YEAR(CURRENT_DATE()) order by taken asc;"); // ToDo : Specify SELECT Statement !

           
            String choice = "";

            do {
                System.out.println("-- MAIN MENU --");
                System.out.println("1 - Browse ResultSet");
                System.out.println("2 - Invoke Procedure");
                System.out.println("Q - Quit");
                System.out.print("Pick : ");

                choice = S.next().toUpperCase();

                switch (choice) {
                    case "1" : {
                        browseResultSet();
                        break;
                    }
                    case "2" : {
                        invokeProcedure();
                        break;
                    }
                }
            } while (!choice.equals("Q"));

            c.close();

            System.out.println("Bye Bye :)");
        }
        catch (Exception e) {
            System.err.println(e.getMessage());
        }
    }

    private static void browseResultSet() throws Exception {
        // ToDo : Ensure ResultSet Contains Rows !
    	 
      // iterate through the java resultset
		  while (rs.next())
		  {
			int StudentNo = rs.getInt("no");
			String Name = rs.getString("name");
			Date dueDate = rs.getDate("due");
			
			// print the results
			System.out.format("%s, %s, %s \n", StudentNo,Name,dueDate);
		  }
		  rs.beforeFirst();

    }
    //call  check_loan_status(2001, "111-2-33-444444-5");
    private static void invokeProcedure() throws Exception {
    	try {
        // ToDo : Accept Book ISBN & Student No !
		System.out.println("Please Enter Book ISBN: ");
		String isbn = S.next();  // Read user input
		System.out.println("Please Enter Student No: ");
		int student_no=S.nextInt();
		String query = "{call  check_loan_status(?,?)}";
		CallableStatement stmt = c.prepareCall(query);
		stmt.setInt(1, student_no);
		stmt.setString(2, isbn);
		ResultSet r=stmt.executeQuery();
        

		stmt.close();
		}
        catch (Exception e) {
        	System.err.println(e.getMessage());
        }
        // ToDo : Declare, Configure & Invoke CallableStatement !
    }
}
