/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dal;

import java.util.ArrayList;
import model.iam.User;
import java.sql.*;
import java.util.LinkedHashMap;
import java.util.Map;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;

/**
 *
 * @author sonnt
 */
public class UserDBContext extends DBContext<User> {

    public User get(String username, String password) {
        try {
            String sql = """
                                     SELECT
                                     u.uid,
                                     u.username,
                                     u.displayname,
                                     e.eid,
                                     e.ename
                                     FROM [User] u INNER JOIN [Enrollment] en ON u.[uid] = en.[uid]
                                     \t\t\t\t\tINNER JOIN [Employee] e ON e.eid = en.eid
                                     \t\t\t\t\tWHERE
                                     \t\t\t\t\tu.username = ? AND u.[password] = ?
                                     \t\t\t\t\tAND en.active = 1""";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setString(1, username);
            stm.setString(2, password);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                User u = new User();
                Employee e = new Employee();
                e.setId(rs.getInt("eid"));
                e.setName(rs.getString("ename"));
                u.setEmployee(e);

                u.setUsername(username);
                u.setId(rs.getInt("uid"));
                u.setDisplayname(rs.getString("displayname"));

                return u;
            }
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    public User loadRolesAndFeatures(User u) {
        if (u == null) {
            return null;
        }

        // map: rid -> Role (để gộp feature)
        Map<Integer, model.iam.Role> roleMap = new LinkedHashMap<>();
        try {
            String sql = """
            SELECT r.rid, r.rname,
                   f.fid, f.[url]
            FROM Enrollment en
            JOIN [Role] r            ON r.rid = en.rid
            LEFT JOIN RoleFeature rf ON rf.rid = r.rid
            LEFT JOIN Feature f      ON f.fid = rf.fid
            WHERE en.uid = ? AND en.active = 1
            ORDER BY r.rid, f.fid
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, u.getId());
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                int rid = rs.getInt("rid");
                String rname = rs.getString("rname");
                model.iam.Role role = roleMap.get(rid);
                if (role == null) {
                    role = new model.iam.Role();
                    role.setId(rid);
                    role.setName(rname);
                    role.setFeatures(new ArrayList<>());
                    roleMap.put(rid, role);
                }
                int fid = rs.getInt("fid");
                if (!rs.wasNull()) {
                    model.iam.Feature fea = new model.iam.Feature();
                    fea.setId(fid);
                    fea.setUrl(rs.getString("url"));
                    role.getFeatures().add(fea);
                }
            }
            u.setRoles(new ArrayList<>(roleMap.values()));
            return u;
        } catch (SQLException ex) {
            Logger.getLogger(UserDBContext.class.getName()).log(Level.SEVERE, null, ex);
            return u; // trả về bản hiện có để không crash luồng đăng nhập
        } finally {
            closeConnection();
        }
    }

    @Override
    public ArrayList<User> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public User get(int id) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void insert(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(User model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

}
