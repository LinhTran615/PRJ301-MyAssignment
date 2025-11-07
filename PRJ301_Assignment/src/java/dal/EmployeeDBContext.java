package dal;

import java.sql.*;
import java.util.ArrayList;
import model.Employee;
import java.util.logging.Level;
import java.util.logging.Logger;

public class EmployeeDBContext extends DBContext<Employee> {

    public ArrayList<Employee> listAll() {
        ArrayList<Employee> list = new ArrayList<>();
        try {
            String sql = "SELECT eid, ename FROM Employee";
            PreparedStatement stm = connection.prepareStatement(sql);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                list.add(e);
            }
        } catch (SQLException ex) {
            Logger.getLogger(EmployeeDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return list;
    }

    @Override
    public ArrayList<Employee> list() { return listAll(); }
    @Override
    public Employee get(int id) { throw new UnsupportedOperationException(); }
    @Override
    public void insert(Employee model) { throw new UnsupportedOperationException(); }
    @Override
    public void update(Employee model) { throw new UnsupportedOperationException(); }
    @Override
    public void delete(Employee model) { throw new UnsupportedOperationException(); }
}
