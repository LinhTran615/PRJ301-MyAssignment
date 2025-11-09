package model;

import java.util.Date;

public class RequestForLeaveHistory extends BaseModel {

    private String action;      // create | approve | reject | edit
    private String note;
    private Date acted_time;
    private Employee acted_by;

    public String getAction() {
        return action;
    }

    public void setAction(String action) {
        this.action = action;
    }

    public String getNote() {
        return note;
    }

    public void setNote(String note) {
        this.note = note;
    }

    public Date getActed_time() {
        return acted_time;
    }

    public void setActed_time(Date acted_time) {
        this.acted_time = acted_time;
    }

    public Employee getActed_by() {
        return acted_by;
    }

    public void setActed_by(Employee acted_by) {
        this.acted_by = acted_by;
    }
}
