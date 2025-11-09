package dal;

import java.util.ArrayList;
import model.RequestForLeave;
import java.sql.*;
import java.util.logging.Level;
import java.util.logging.Logger;
import model.Employee;
import model.RequestForLeaveHistory;

public class RequestForLeaveDBContext extends DBContext<RequestForLeave> {

    public ArrayList<RequestForLeave> getByEmployeeAndSubodiaries(int eid) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            String sql = """
                WITH Org AS (
                    SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ?
                    UNION ALL
                    SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid
                )
                SELECT r.[rid]
                     , r.[created_by]
                     , e.ename as [created_name]
                     , r.[created_time]
                     , r.[from]
                     , r.[to]
                     , r.[reason]
                     , r.[status]
                     , r.[processed_by], r.[reject_reason]
                     , p.ename as [processed_name]
                FROM Org e 
                INNER JOIN [RequestForLeave] r ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                ORDER BY r.rid DESC""";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, eid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();

                rfl.setId(rs.getInt("rid")); // <<< IMPORTANT
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setReject_reason(rs.getString("reject_reason"));
                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (!rs.wasNull() && processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(processed_by_id);
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }

    public ArrayList<RequestForLeave> listForManagerWithFilters(
            int managerEid,
            String nameLike, // nullable
            java.sql.Date from, // nullable
            java.sql.Date to, // nullable
            Integer status // nullable: 0/1/2; null = tất cả
    ) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            // last_action_time = MAX(history.acted_time) nếu có, ngược lại = r.created_time
            StringBuilder sql = new StringBuilder("""
            WITH Org AS (
                SELECT *, 0 AS lvl FROM Employee e WHERE e.eid = ?
                UNION ALL
                SELECT c.*, o.lvl + 1 AS lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid
            ),
            H AS (
                SELECT rid, MAX(acted_time) AS last_hist
                FROM RequestForLeaveHistory
                GROUP BY rid
            )
            SELECT r.rid, r.created_by, e.ename AS created_name, r.created_time,
                   r.[from], r.[to], r.reason, r.[status],
                   r.processed_by, p.ename AS processed_name, r.reject_reason,
                   COALESCE(h.last_hist, r.created_time) AS last_action_time
            FROM Org e
            JOIN RequestForLeave r ON r.created_by = e.eid
            LEFT JOIN Employee p ON p.eid = r.processed_by
            LEFT JOIN H h ON h.rid = r.rid
            WHERE 1=1
        """);

            ArrayList<Object> params = new ArrayList<>();
            params.add(managerEid);

            if (nameLike != null && !nameLike.trim().isEmpty()) {
                sql.append(" AND e.ename LIKE ? ");
                params.add("%" + nameLike.trim() + "%");
            }
            if (from != null) {
                sql.append(" AND r.[to] >= ? ");
                params.add(from);
            }
            if (to != null) {
                sql.append(" AND r.[from] <= ? ");
                params.add(to);
            }
            if (status != null) {
                sql.append(" AND r.[status] = ? ");
                params.add(status);
            }

            sql.append(" ORDER BY COALESCE(h.last_hist, r.created_time) DESC, r.rid DESC ");

            PreparedStatement stm = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof java.sql.Date) {
                    stm.setDate(i + 1, (java.sql.Date) p);
                } else {
                    stm.setObject(i + 1, p);
                }
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave r = new RequestForLeave();
                r.setId(rs.getInt("rid"));
                r.setCreated_time(rs.getTimestamp("created_time"));
                r.setFrom(rs.getDate("from"));
                r.setTo(rs.getDate("to"));
                r.setReason(rs.getString("reason"));
                r.setStatus(rs.getInt("status"));
                r.setReject_reason(rs.getString("reject_reason"));

                Employee created = new Employee();
                created.setId(rs.getInt("created_by"));
                created.setName(rs.getString("created_name"));
                r.setCreated_by(created);

                int processedId = rs.getInt("processed_by");
                if (!rs.wasNull() && processedId != 0) {
                    Employee pb = new Employee();
                    pb.setId(processedId);
                    pb.setName(rs.getString("processed_name"));
                    r.setProcessed_by(pb);
                }

                // Bạn có thể muốn lưu last_action_time vào BaseModel nếu có field; nếu không, bỏ qua.
                rfls.add(r);
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
                SELECT r.[rid]
                     , r.[created_by]
                     , e.ename as [created_name]
                     , r.[created_time]
                     , r.[from]
                     , r.[to]
                     , r.[reason]
                     , r.[status]
                     , r.[processed_by]
                         ,r.reject_reason
                     , p.ename as [processed_name]
                FROM [RequestForLeave] r
                INNER JOIN Employee e ON e.eid = r.created_by
                LEFT JOIN Employee p ON p.eid = r.processed_by
                WHERE r.rid = ?""";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, rid);
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));
                rfl.setReject_reason(rs.getString("reject_reason"));
                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (!rs.wasNull() && processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(processed_by_id);
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }
                return rfl;
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return null;
    }

    @Override
    public void insert(RequestForLeave model) {
        try {
            String sql = """
                INSERT INTO [RequestForLeave]
                    ([created_by],[created_time],[from],[to],[reason],[status],[processed_by])
                VALUES ( ?, GETDATE(), ?, ?, ?, 0, NULL)""";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getCreated_by().getId());
            stm.setDate(2, model.getFrom());
            stm.setDate(3, model.getTo());
            stm.setString(4, model.getReason());
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    // NEW: chèn vào RequestForLeaveDBContext (giữ nguyên insert(...) cũ)
    public int insertReturningId(RequestForLeave model) {
        int newId = -1;
        try {
            String sql = """
            INSERT INTO [RequestForLeave] ([created_by],[created_time],[from],[to],[reason],[status],[processed_by])
            OUTPUT INSERTED.rid
            VALUES ( ?, GETDATE(), ?, ?, ?, 0, NULL)
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, model.getCreated_by().getId());
            stm.setDate(2, model.getFrom());
            stm.setDate(3, model.getTo());
            stm.setString(4, model.getReason());
            ResultSet rs = stm.executeQuery();
            if (rs.next()) {
                newId = rs.getInt(1);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return newId;
    }

    public ArrayList<RequestForLeave> findOverlaps(int createdByEid, Date from, Date to) {
        ArrayList<RequestForLeave> res = new ArrayList<>();
        try {
            String sql = """
            SELECT r.rid, r.[from], r.[to], r.[status]
            FROM RequestForLeave r
            WHERE r.created_by = ?
              AND r.[to]   >= ?
              AND r.[from] <= ?
            ORDER BY r.rid DESC
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, createdByEid);
            stm.setDate(2, from);
            stm.setDate(3, to);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave x = new RequestForLeave();
                x.setId(rs.getInt("rid"));
                x.setFrom(rs.getDate("from"));
                x.setTo(rs.getDate("to"));
                x.setStatus(rs.getInt("status"));
                res.add(x);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return res;
    }

    public void insertHistory(int rid, int actedByEid, String action, String note) {
        try {
            String sql = """
            INSERT INTO RequestForLeaveHistory(rid, action, note, acted_by)
            VALUES(?,?,?,?)
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, rid);
            stm.setString(2, action);   // 'create' | 'approve' | 'reject'
            stm.setString(3, note);     // ví dụ 'rejected: lý do ...'
            stm.setInt(4, actedByEid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    public ArrayList<RequestForLeaveHistory> listHistory(int rid) {
        ArrayList<RequestForLeaveHistory> ls = new ArrayList<>();
        try {
            String sql = """
            SELECT h.id, h.action, h.note, h.acted_time, e.eid, e.ename
            FROM RequestForLeaveHistory h
            JOIN Employee e ON e.eid = h.acted_by
            WHERE h.rid = ?
            ORDER BY h.acted_time DESC, h.id DESC
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, rid);
            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeaveHistory h = new RequestForLeaveHistory();
                h.setId(rs.getInt("id"));
                h.setAction(rs.getString("action"));
                h.setNote(rs.getString("note"));
                h.setActed_time(rs.getTimestamp("acted_time"));
                Employee by = new Employee();
                by.setId(rs.getInt("eid"));
                by.setName(rs.getString("ename"));
                h.setActed_by(by);
                ls.add(h);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return ls;
    }

    public void updateStatus(int rid, int status, int processedByEid, String rejectReason) {
        try {
            String sql = """
                UPDATE [RequestForLeave]
                SET [status] = ?, [processed_by] = ?, [reject_reason] = ?
                WHERE [rid] = ?""";
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setInt(1, status);
            stm.setInt(2, processedByEid);
            if (rejectReason == null || rejectReason.isBlank()) {
                stm.setNull(3, Types.VARCHAR);
            } else {
                stm.setString(3, rejectReason);
            }
            stm.setInt(4, rid);
            stm.executeUpdate();
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
    }

    public ArrayList<RequestForLeave> getAgendaForManager(int managerEid, java.sql.Date from, java.sql.Date to, String nameLike) {
        ArrayList<RequestForLeave> rfls = new ArrayList<>();
        try {
            StringBuilder sql = new StringBuilder("""
            WITH Org AS (
                SELECT *, 0 as lvl FROM Employee e WHERE e.eid = ?
                UNION ALL
                SELECT c.*, o.lvl + 1 as lvl FROM Employee c JOIN Org o ON c.supervisorid = o.eid
            )
            SELECT r.[rid]
                 , r.[created_by]
                 , e.ename as [created_name]
                 , r.[created_time]
                 , r.[from]
                 , r.[to]
                 , r.[reason]
                 , r.[status]
                 , r.[processed_by]
                 , p.ename as [processed_name]
            FROM Org e
            INNER JOIN [RequestForLeave] r ON e.eid = r.created_by
            LEFT JOIN Employee p ON p.eid = r.processed_by
            WHERE 1=1
        """);

            ArrayList<Object> params = new ArrayList<>();
            params.add(managerEid);

            // Lọc theo overlap ngày: r.to >= from && r.from <= to
            if (from != null) {
                sql.append(" AND r.[to] >= ?");
                params.add(from);
            }
            if (to != null) {
                sql.append(" AND r.[from] <= ?");
                params.add(to);
            }

            // Lọc theo tên nhân sự
            if (nameLike != null && !nameLike.trim().isEmpty()) {
                sql.append(" AND e.ename LIKE ?");
                params.add("%" + nameLike.trim() + "%");
            }

            sql.append(" ORDER BY r.[from] DESC, r.[rid] DESC");

            PreparedStatement stm = connection.prepareStatement(sql.toString());
            for (int i = 0; i < params.size(); i++) {
                Object p = params.get(i);
                if (p instanceof java.sql.Date) {
                    stm.setDate(i + 1, (java.sql.Date) p);
                } else {
                    stm.setObject(i + 1, p);
                }
            }

            ResultSet rs = stm.executeQuery();
            while (rs.next()) {
                RequestForLeave rfl = new RequestForLeave();
                rfl.setId(rs.getInt("rid"));
                rfl.setCreated_time(rs.getTimestamp("created_time"));
                rfl.setFrom(rs.getDate("from"));
                rfl.setTo(rs.getDate("to"));
                rfl.setReason(rs.getString("reason"));
                rfl.setStatus(rs.getInt("status"));

                Employee created_by = new Employee();
                created_by.setId(rs.getInt("created_by"));
                created_by.setName(rs.getString("created_name"));
                rfl.setCreated_by(created_by);

                int processed_by_id = rs.getInt("processed_by");
                if (!rs.wasNull() && processed_by_id != 0) {
                    Employee processed_by = new Employee();
                    processed_by.setId(processed_by_id);
                    processed_by.setName(rs.getString("processed_name"));
                    rfl.setProcessed_by(processed_by);
                }

                rfls.add(rfl);
            }
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return rfls;
    }
// Chủ đơn sửa khi đang Processing: cập nhật nội dung (giữ status=0)

    public boolean updateDraftByOwner(int rid, int ownerEid, Date from, Date to, String reason) {
        try {
            String sql = """
            UPDATE RequestForLeave
               SET [from] = ?, [to] = ?, [reason] = ?
             WHERE rid = ? AND created_by = ? AND [status] = 0
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setDate(1, from);
            stm.setDate(2, to);
            stm.setString(3, reason);
            stm.setInt(4, rid);
            stm.setInt(5, ownerEid);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return false;
    }

    // Chủ đơn sửa khi đã Rejected: cập nhật + chuyển về Processing, xoá processed_by/reject_reason
    public boolean resubmitByOwner(int rid, int ownerEid, Date from, Date to, String reason) {
        try {
            String sql = """
            UPDATE RequestForLeave
               SET [from] = ?, [to] = ?, [reason] = ?,
                   [status] = 0, [processed_by] = NULL, [reject_reason] = NULL
             WHERE rid = ? AND created_by = ? AND [status] = 2
        """;
            PreparedStatement stm = connection.prepareStatement(sql);
            stm.setDate(1, from);
            stm.setDate(2, to);
            stm.setString(3, reason);
            stm.setInt(4, rid);
            stm.setInt(5, ownerEid);
            return stm.executeUpdate() > 0;
        } catch (SQLException ex) {
            Logger.getLogger(RequestForLeaveDBContext.class.getName()).log(Level.SEVERE, null, ex);
        } finally {
            closeConnection();
        }
        return false;
    }

    @Override
    public ArrayList<RequestForLeave> list() {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void update(RequestForLeave model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }

    @Override
    public void delete(RequestForLeave model) {
        throw new UnsupportedOperationException("Not supported yet."); // Generated from nbfs://nbhost/SystemFileSystem/Templates/Classes/Code/GeneratedMethodBody
    }
}
