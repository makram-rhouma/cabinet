package org.projet.cabinet.model; import java.io.Serializable; import java.time.LocalDateTime;
public class Visite implements Serializable {
    private int id; private Patient patient; private RendezVous rendezVous; private String motif; private LocalDateTime dateVisite;
    public Visite() {} public Visite(int id, Patient patient, RendezVous rendezVous, String motif, LocalDateTime dateVisite) { this.id = id; this.patient = patient; this.rendezVous = rendezVous; this.motif = motif; this.dateVisite = dateVisite; }
    public int getId() { return id; } public void setId(int id) { this.id = id; } public Patient getPatient() { return patient; } public void setPatient(Patient patient) { this.patient = patient; } public RendezVous getRendezVous() { return rendezVous; } public void setRendezVous(RendezVous rendezVous) { this.rendezVous = rendezVous; }
    public String getMotif() { return motif; } public void setMotif(String motif) { this.motif = motif; } public LocalDateTime getDateVisite() { return dateVisite; } public void setDateVisite(LocalDateTime dateVisite) { this.dateVisite = dateVisite; }
}