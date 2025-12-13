package org.projet.cabinet.model; import java.io.Serializable; import java.time.LocalDate;
public class Patient implements Serializable {
    private int id; private Utilisateur utilisateur; private LocalDate dateNaissance; private String telephone;
    public Patient() {} public Patient(int id, Utilisateur utilisateur, LocalDate dateNaissance, String telephone) { this.id = id; this.utilisateur = utilisateur; this.dateNaissance = dateNaissance; this.telephone = telephone; }
    public int getId() { return id; } public void setId(int id) { this.id = id; } public Utilisateur getUtilisateur() { return utilisateur; } public void setUtilisateur(Utilisateur utilisateur) { this.utilisateur = utilisateur; }
    public LocalDate getDateNaissance() { return dateNaissance; } public void setDateNaissance(LocalDate dateNaissance) { this.dateNaissance = dateNaissance; } public String getTelephone() { return telephone; } public void setTelephone(String telephone) { this.telephone = telephone; }
}