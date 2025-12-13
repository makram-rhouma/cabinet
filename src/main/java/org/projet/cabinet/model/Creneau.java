package org.projet.cabinet.model; import java.io.Serializable; import java.time.LocalDate; import java.time.LocalTime;
public class Creneau implements Serializable {
    private int id; private LocalDate dateCreneau; private LocalTime heureCreneau; private int dureeMinutes; private boolean disponible;
    public Creneau() {} public Creneau(int id, LocalDate dateCreneau, LocalTime heureCreneau, int dureeMinutes, boolean disponible) { this.id = id; this.dateCreneau = dateCreneau; this.heureCreneau = heureCreneau; this.dureeMinutes = dureeMinutes; this.disponible = disponible; }
    public int getId() { return id; } public void setId(int id) { this.id = id; } public LocalDate getDateCreneau() { return dateCreneau; } public void setDateCreneau(LocalDate dateCreneau) { this.dateCreneau = dateCreneau; }
    public LocalTime getHeureCreneau() { return heureCreneau; } public void setHeureCreneau(LocalTime heureCreneau) { this.heureCreneau = heureCreneau; } public int getDureeMinutes() { return dureeMinutes; } public void setDureeMinutes(int dureeMinutes) { this.dureeMinutes = dureeMinutes; }
    public boolean isDisponible() { return disponible; } public void setDisponible(boolean disponible) { this.disponible = disponible; }
}