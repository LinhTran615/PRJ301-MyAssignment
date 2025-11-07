package model;

import java.util.ArrayList;

public class Department extends BaseModel {
    private String name;
    private String description;
    private Employee manager;
    private ArrayList<Employee> employees = new ArrayList<>();

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public Employee getManager() { return manager; }
    public void setManager(Employee manager) { this.manager = manager; }

    public ArrayList<Employee> getEmployees() { return employees; }
    public void setEmployees(ArrayList<Employee> employees) { this.employees = employees; }
}
