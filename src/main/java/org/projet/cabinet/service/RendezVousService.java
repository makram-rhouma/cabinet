package org.projet.cabinet.service; import java.time.LocalDate; import java.util.List; import javax.servlet.ServletContext; import org.projet.cabinet.dao.*; import org.projet.cabinet.model.*;
public class RendezVousService {
    private final RendezVousDao rendezVousDao; private final PatientDao patientDao; private final CreneauDao creneauDao;
    public RendezVousService(ServletContext contexte) { this.rendezVousDao = new RendezVousDao(contexte); this.patientDao = new PatientDao(contexte); this.creneauDao = new CreneauDao(contexte); }
    public RendezVous reserver(int idPatient, int idCreneau) {
        Patient patient = patientDao.trouverParId(idPatient); if (patient == null) { throw new IllegalArgumentException("Patient introuvable"); }
        Creneau creneau = creneauDao.trouverParId(idCreneau); if (creneau == null || !creneau.isDisponible()) { throw new IllegalArgumentException("Créneau indisponible"); }
        if (creneau.getDateCreneau().isBefore(LocalDate.now())) { throw new IllegalArgumentException("Impossible de réserver un créneau dans le passé"); }
        RendezVous rdv = new RendezVous(); rdv.setPatient(patient); rdv.setDateRdv(creneau.getDateCreneau()); rdv.setHeureRdv(creneau.getHeureCreneau()); rdv.setStatut(StatutRendezVous.EN_ATTENTE); rdv = rendezVousDao.creer(rdv); creneauDao.marquerIndisponible(idCreneau); return rdv; }
    public void confirmer(int idRdv) { rendezVousDao.confirmer(idRdv); }
    public void annuler(int idRdv) { rendezVousDao.annuler(idRdv); }
    public void marquerRealise(int idRdv) { rendezVousDao.marquerRealise(idRdv); }
    public List<RendezVous> trouverParPatientId(int patientId) { return rendezVousDao.trouverParPatientId(patientId); }
    public List<RendezVous> trouverParStatut(StatutRendezVous statut) { return rendezVousDao.trouverParStatut(statut); }
    public List<RendezVous> trouverConfirmes() { return rendezVousDao.trouverConfirmes(); }
    public List<RendezVous> trouverTous() { return rendezVousDao.trouverTous(); }
}

