package dal;

import java.sql.*;
import java.util.ArrayList;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.RequestForLeave;

public class RequestForLeaveDBContext extends DBContext<RequestForLeave> {

    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql = """
                WITH Org AS (
                    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ?
                    UNION ALL
                    SELECT c.*, o.lvl + 1 as lvl
                    FROM Employee c JOIN Org o ON c.supervisorid = o.eid
                )
                SELECT
                       r.rid,
                       r.created_by,
                       c.ename as created_name,
                       r.created_time,
                       r.[from],
                       r.[to],
                       r.reason,
                       r.status,
                       r.processed_by,
                       p.ename as processed_name
                FROM Org o
                     INNER JOIN RequestForLeave r ON o.eid = r.created_by
                     INNER JOIN Employee c ON c.eid = r.created_by
                     LEFT JOIN Employee p ON p.eid = r.processed_by
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                rfls.add(extract(rs));
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    @Override
    public RequestForLeave get(int rid) {
        try {
            String sql = """
                SELECT r.rid,
                       r.created_by,
                       c.ename AS created_name,
                       r.created_time,
                       r.[from],
                       r.[to],
                       r.reason,
                       r.status,
                       r.processed_by,
                       p.ename AS processed_name
                FROM RequestForLeave r
                     INNER JOIN Employee c ON c.eid = r.created_by
                     LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, rid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                return extract(rs);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(RequestForLeave m) {
        try {
            String sql = """
                INSERT INTO RequestForLeave
                    (created_by, created_time, [from], [to], reason, status, processed_by)
                VALUES (?, GETDATE(), ?, ?, ?, 0, NULL)
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, m.getCreated_by().getId());
            stm.setDate(2, m.getFrom());
            stm.setDate(3, m.getTo());
            stm.setString(4, m.getReason());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    // dùng bởi ReviewController
    public void updateStatus(int rid, int status, int processedBy) {
        try {
            String sql = """
                UPDATE RequestForLeave
                SET status = ?,
                    processed_by = ?
                WHERE rid = ?
            """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            stm.setInt(2, processedBy);
            stm.setInt(3, rid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    @Override
    public ArrayList<RequestForLeave> list() {
        return null;
    }

    @Override
    public void update(RequestForLeave model) {
        throw new UnsupportedOperationException();
    }

    @Override
    public void delete(RequestForLeave model) {
        throw new UnsupportedOperationException();
    }

    private RequestForLeave extract(ResultSet rs) throws SQLException {
        RequestForLeave r = new RequestForLeave();
        r.setId(rs.getInt("rid"));
        r.setCreated_time(rs.getTimestamp("created_time"));
        r.setFrom(rs.getDate("from"));
        r.setTo(rs.getDate("to"));
        r.setReason(rs.getString("reason"));
        r.setStatus(rs.getInt("status"));

        Employee c = new Employee();
        c.setId(rs.getInt("created_by"));
        c.setName(rs.getString("created_name"));
        r.setCreated_by(c);

        int pid = rs.getInt("processed_by");
        if (!rs.wasNull()) {
            Employee p = new Employee();
            p.setId(pid);
            p.setName(rs.getString("processed_name"));
            r.setProcessed_by(p);
        }

        return r;
    }
}
