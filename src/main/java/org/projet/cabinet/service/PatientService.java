package org.projet.cabinet.service; import java.time.LocalDate; import java.util.List; import javax.servlet.ServletContext; import org.projet.cabinet.dao.PatientDao; import org.projet.cabinet.model.Patient;
public class PatientService {
    private final PatientDao patientDao;
    public PatientService(ServletContext contexte) { this.patientDao = new PatientDao(contexte); }
    public Patient creerPatient(Patient patient) { if (patient == null || patient.getUtilisateur() == null) { throw new IllegalArgumentException("Patient invalide"); } return patientDao.creer(patient); }
    public Patient trouverParId(int id) { return patientDao.trouverParId(id); }
    public Patient trouverParUtilisateurId(int utilisateurId) { return patientDao.trouverParUtilisateurId(utilisateurId); }
    public List<Patient> rechercherParNomEtDateNaissance(String nom, LocalDate dateNaissance) { if (nom == null || dateNaissance == null) { throw new IllegalArgumentException("Nom et date de naissance obligatoires"); } return patientDao.rechercherParNomEtDateNaissance(nom.trim(), dateNaissance); }
    public void modifier(Patient patient) { if (patient == null || patient.getId() <= 0) { throw new IllegalArgumentException("Patient invalide"); } patientDao.modifier(patient); }
    public void supprimer(int id) { patientDao.supprimer(id); }

    /** Nombre total de patients. */
    public long compterTous() {
        return patientDao.compterTous();
    }
}

