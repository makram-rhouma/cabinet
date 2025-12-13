package org.projet.cabinet.service; import java.util.List; import javax.servlet.ServletContext; import org.projet.cabinet.dao.BilanDao; import org.projet.cabinet.dao.PatientDao; import org.projet.cabinet.dao.UtilisateurDao; import org.projet.cabinet.model.*;
public class BilanService {
    private final BilanDao bilanDao; private final PatientDao patientDao; private final UtilisateurDao utilisateurDao;
    public BilanService(ServletContext contexte) { this.bilanDao = new BilanDao(contexte); this.patientDao = new PatientDao(contexte); this.utilisateurDao = new UtilisateurDao(contexte); }
    public Bilan creerBilan(int idPatient, int idMedecin, String motif, String observations, String diagnostic, String traitement) {
        Patient patient = patientDao.trouverParId(idPatient); if (patient == null) { throw new IllegalArgumentException("Patient introuvable"); }
        Utilisateur medecin = utilisateurDao.trouverParId(idMedecin); if (medecin == null || medecin.getRole() != RoleUtilisateur.MEDECIN) { throw new IllegalArgumentException("Médecin invalide"); }
        Bilan bilan = new Bilan(); bilan.setPatient(patient); bilan.setMedecin(medecin); bilan.setMotif(motif); bilan.setObservations(observations); bilan.setDiagnostic(diagnostic); bilan.setTraitement(traitement); return bilanDao.creer(bilan); }
    public List<Bilan> trouverParPatientId(int patientId) { return bilanDao.trouverParPatientId(patientId); }
    public List<Bilan> trouverParMedecinId(int medecinId) { return bilanDao.trouverParMedecinId(medecinId); }
    public void modifier(Bilan bilan) { if (bilan == null || bilan.getId() <= 0) { throw new IllegalArgumentException("Bilan invalide"); } bilanDao.modifier(bilan); }
    public void supprimer(int id) { bilanDao.supprimer(id); }
}
