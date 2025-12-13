package org.projet.cabinet.model; import java.io.Serializable; import java.time.LocalDate; import java.time.LocalTime;
public class RendezVous implements Serializable {
    private int id; private Patient patient; private LocalDate dateRdv; private LocalTime heureRdv; private StatutRendezVous statut;
    public RendezVous() {} public RendezVous(int id, Patient patient, LocalDate dateRdv, LocalTime heureRdv, StatutRendezVous statut) { this.id = id; this.patient = patient; this.dateRdv = dateRdv; this.heureRdv = heureRdv; this.statut = statut; }
    public int getId() { return id; } public void setId(int id) { this.id = id; } public Patient getPatient() { return patient; } public void setPatient(Patient patient) { this.patient = patient; }
    public LocalDate getDateRdv() { return dateRdv; } public void setDateRdv(LocalDate dateRdv) { this.dateRdv = dateRdv; } public LocalTime getHeureRdv() { return heureRdv; } public void setHeureRdv(LocalTime heureRdv) { this.heureRdv = heureRdv; } public StatutRendezVous getStatut() { return statut; } public void setStatut(StatutRendezVous statut) { this.statut = statut; }
}