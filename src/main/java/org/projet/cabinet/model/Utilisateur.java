package org.projet.cabinet.model; import java.io.Serializable;
public class Utilisateur implements Serializable {
    private int id; private String nom; private String prenom; private String email; private String motDePasse; private RoleUtilisateur role;
    public Utilisateur() {} public Utilisateur(int id, String nom, String prenom, String email, String motDePasse, RoleUtilisateur role) { this.id = id; this.nom = nom; this.prenom = prenom; this.email = email; this.motDePasse = motDePasse; this.role = role; }
    public int getId() { return id; } public void setId(int id) { this.id = id; } public String getNom() { return nom; } public void setNom(String nom) { this.nom = nom; } public String getPrenom() { return prenom; } public void setPrenom(String prenom) { this.prenom = prenom; }
    public String getEmail() { return email; } public void setEmail(String email) { this.email = email; } public String getMotDePasse() { return motDePasse; } public void setMotDePasse(String motDePasse) { this.motDePasse = motDePasse; } public RoleUtilisateur getRole() { return role; } public void setRole(RoleUtilisateur role) { this.role = role; }
}