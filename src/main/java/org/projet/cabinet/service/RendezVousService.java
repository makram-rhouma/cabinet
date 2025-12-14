package org.projet.cabinet.service; 
import java.time.LocalDate; 
import java.time.LocalDateTime; 
import java.util.List; 
import javax.servlet.ServletContext; 
import org.projet.cabinet.dao.*; 
import org.projet.cabinet.model.*;

public class RendezVousService {
    private final RendezVousDao rendezVousDao; 
    private final PatientDao patientDao; 
    private final CreneauDao creneauDao;

    public RendezVousService(ServletContext contexte) { 
        this.rendezVousDao = new RendezVousDao(contexte); 
        this.patientDao = new PatientDao(contexte); 
        this.creneauDao = new CreneauDao(contexte); 
    }

    public RendezVous reserver(int idPatient, int idCreneau) {
        Patient patient = patientDao.trouverParId(idPatient); 
        if (patient == null) { 
            throw new IllegalArgumentException("Patient introuvable"); 
        }
        Creneau creneau = creneauDao.trouverParId(idCreneau); 
        if (creneau == null || !creneau.isDisponible()) { 
            throw new IllegalArgumentException("Créneau indisponible"); 
        }
        LocalDateTime maintenant = LocalDateTime.now();
        LocalDateTime dateHeureCreneau = LocalDateTime.of(creneau.getDateCreneau(), creneau.getHeureCreneau());
        if (dateHeureCreneau.isBefore(maintenant)) { 
            throw new IllegalArgumentException("Impossible de réserver un créneau dans le passé"); 
        }
        RendezVous rdv = new RendezVous(); 
        rdv.setPatient(patient); 
        rdv.setDateRdv(creneau.getDateCreneau()); 
        rdv.setHeureRdv(creneau.getHeureCreneau()); 
        rdv.setStatut(StatutRendezVous.EN_ATTENTE); 
        rdv = rendezVousDao.creerAvecReservationCreneau(rdv, idCreneau);
        return rdv; 
    }

    public void confirmer(int idRdv) {
        RendezVous rdv = rendezVousDao.trouverParId(idRdv);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable");
        }
        if (rdv.getStatut() != StatutRendezVous.EN_ATTENTE) {
            throw new IllegalArgumentException("Statut invalide : seul un rendez-vous EN_ATTENTE peut être confirmé");
        }
        rendezVousDao.confirmer(idRdv);
    }

    public void annuler(int idRdv) {
        RendezVous rdv = rendezVousDao.trouverParId(idRdv);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable");
        }
        if (rdv.getStatut() == StatutRendezVous.REALISE) {
            throw new IllegalArgumentException("Statut invalide : un rendez-vous REALISE ne peut pas être annulé");
        }
        rendezVousDao.annuler(idRdv);
    }

    public void marquerRealise(int idRdv) {
        RendezVous rdv = rendezVousDao.trouverParId(idRdv);
        if (rdv == null) {
            throw new IllegalArgumentException("Rendez-vous introuvable");
        }
        if (rdv.getStatut() != StatutRendezVous.CONFIRME) {
            throw new IllegalArgumentException("Statut invalide : seul un rendez-vous CONFIRME peut être marqué REALISE");
        }
        rendezVousDao.marquerRealise(idRdv);
    }

    public List<RendezVous> trouverParPatientId(int patientId) { 
        return rendezVousDao.trouverParPatientId(patientId); 
    }

    public List<RendezVous> trouverParStatut(StatutRendezVous statut) { 
        return rendezVousDao.trouverParStatut(statut); 
    }

    public List<RendezVous> trouverConfirmes() { 
        return rendezVousDao.trouverConfirmes(); 
    }

    public List<RendezVous> trouverTous() { 
        return rendezVousDao.trouverTous(); 
    }
}
