package org.projet.cabinet.service; 
import java.time.*; 
import java.util.List; 
import javax.servlet.ServletContext; 
import org.projet.cabinet.dao.CreneauDao; 
import org.projet.cabinet.model.Creneau;

public class CreneauService {
    private final CreneauDao creneauDao;
    public CreneauService(ServletContext contexte) { 
        this.creneauDao = new CreneauDao(contexte); 
    }
    public Creneau creerCreneau(LocalDate date, LocalTime heure, int dureeMinutes) {
        if (date == null || heure == null || dureeMinutes <= 0) { 
            throw new IllegalArgumentException("Date, heure et durée sont obligatoires"); 
        }
        Creneau c = new Creneau(); 
        c.setDateCreneau(date); 
        c.setHeureCreneau(heure); 
        c.setDureeMinutes(dureeMinutes); 
        c.setDisponible(true); 
        return creneauDao.creer(c); 
    }
    public List<Creneau> trouverDisponibles() { 
        return creneauDao.trouverCreneauxDisponibles(); 
    }
    public List<Creneau> trouverAvecFiltres(LocalDate dateDebut, LocalDate dateFin, LocalTime heureDebut, LocalTime heureFin) { 
        return creneauDao.trouverCreneauxDisponiblesAvecFiltres(dateDebut, dateFin, heureDebut, heureFin); 
    }
    public Creneau trouverParId(int id) {
        return creneauDao.trouverParId(id);
    }
    public List<Creneau> trouverParDate(LocalDate dateCreneau) { 
        return creneauDao.trouverParDate(dateCreneau); 
    }
    public int supprimerDisponiblesParDate(LocalDate dateCreneau) { 
        return creneauDao.supprimerDisponiblesParDate(dateCreneau); 
    }
    public int ajouterCreneauxJournee(LocalDate dateCreneau, LocalTime heureDebut, LocalTime heureFin, int dureeMinutes) {
        if (dateCreneau == null || heureDebut == null || heureFin == null) { 
            throw new IllegalArgumentException("Date et heures sont obligatoires"); 
        }
        if (dureeMinutes <= 0) { 
            throw new IllegalArgumentException("Durée invalide"); 
        }
        if (!heureFin.isAfter(heureDebut)) { 
            throw new IllegalArgumentException("Heure fin doit être après heure début"); 
        }
        int nbCrees = 0;
        LocalTime heureCourante = heureDebut;
        while (!heureCourante.plusMinutes(dureeMinutes).isAfter(heureFin)) {
            creerCreneau(dateCreneau, heureCourante, dureeMinutes);
            nbCrees++;
            heureCourante = heureCourante.plusMinutes(dureeMinutes);
        }
        return nbCrees;
    }
    public void marquerIndisponible(int idCreneau) { 
        creneauDao.marquerIndisponible(idCreneau); 
    }
    public void modifier(Creneau creneau) { 
        if (creneau == null || creneau.getId() <= 0) { 
            throw new IllegalArgumentException("Créneau invalide"); 
        } 
        creneauDao.modifier(creneau); 
    }
    public void supprimer(int id) { 
        creneauDao.supprimer(id); 
    }
}
