package org.projet.cabinet.servlet;

import java.io.IOException;
import java.time.LocalDate;
import java.time.LocalTime;
import java.util.List;

import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.projet.cabinet.model.*;
import org.projet.cabinet.service.CreneauService;
import org.projet.cabinet.service.PatientService;
import org.projet.cabinet.service.RendezVousService;
import org.projet.cabinet.service.VisiteService;

public class SecretaireServlet extends HttpServlet {

    private CreneauService creneauService;
    private VisiteService visiteService;
    private RendezVousService rendezVousService;
    private PatientService patientService;

    @Override
    public void init() {
        ServletContext c = getServletContext();
        this.creneauService = new CreneauService(c);
        this.visiteService = new VisiteService(c);
        this.rendezVousService = new RendezVousService(c);
        this.patientService = new PatientService(c);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "patientsArrives":
                afficherPatientsArrives(req, resp);
                break;
            case "creneaux":
                afficherGestionCreneaux(req, resp);
                break;
            case "rechercherPatient":
                afficherRecherchePatient(req, resp);
                break;
            default:
                afficherDashboard(req, resp);
                break;
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if ("enregistrerVisite".equals(action)) {
            enregistrerVisite(req, resp);
        } else if ("confirmerRdv".equals(action)) {
            confirmerRdv(req, resp);
        } else if ("ajouterCreneauxJournee".equals(action)) {
            ajouterCreneauxJournee(req, resp);
        } else if ("supprimerCreneauxJournee".equals(action)) {
            supprimerCreneauxJournee(req, resp);
        } else if ("modifierCreneau".equals(action)) {
            modifierCreneau(req, resp);
        } else if ("supprimerCreneau".equals(action)) {
            supprimerCreneau(req, resp);
        } else if ("rechercherPatient".equals(action)) {
            rechercherPatient(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private void afficherGestionCreneaux(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String dateStr = req.getParameter("date");
        LocalDate dateCreneau = !isBlank(dateStr) ? LocalDate.parse(dateStr) : LocalDate.now();
        req.setAttribute("dateCreneau", dateCreneau);
        req.setAttribute("creneauxJournee", creneauService.trouverParDate(dateCreneau));
        req.getRequestDispatcher("/jsp/secretaire/creneaux.jsp").forward(req, resp);
    }

    private void ajouterCreneauxJournee(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        LocalDate dateCreneau = LocalDate.parse(req.getParameter("dateCreneau"));
        LocalTime heureDebut = LocalTime.parse(req.getParameter("heureDebut"));
        LocalTime heureFin = LocalTime.parse(req.getParameter("heureFin"));
        int dureeMinutes = Integer.parseInt(req.getParameter("dureeMinutes"));
        try {
            if (!heureFin.isAfter(heureDebut)) {
                throw new IllegalArgumentException("L'heure de fin doit être après l'heure de début");
            }
            creneauService.ajouterCreneauxJournee(dateCreneau, heureDebut, heureFin, dureeMinutes);
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau);
        } catch (RuntimeException e) {
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau + "&erreur=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void supprimerCreneauxJournee(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        LocalDate dateCreneau = LocalDate.parse(req.getParameter("dateCreneau"));
        creneauService.supprimerDisponiblesParDate(dateCreneau);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau);
    }

    private void modifierCreneau(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        LocalDate dateCreneau = LocalDate.parse(req.getParameter("dateCreneau"));
        int idCreneau = Integer.parseInt(req.getParameter("idCreneau"));
        int dureeMinutes = Integer.parseInt(req.getParameter("dureeMinutes"));
        try {
            Creneau existant = creneauService.trouverParId(idCreneau);
            if (existant == null) {
                throw new IllegalArgumentException("Créneau introuvable");
            }
            if (!existant.isDisponible()) {
                throw new IllegalArgumentException("Impossible de modifier un créneau déjà réservé");
            }
            if (dureeMinutes <= 0) {
                throw new IllegalArgumentException("Durée invalide");
            }
            existant.setDureeMinutes(dureeMinutes);
            creneauService.modifier(existant);
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau);
        } catch (RuntimeException e) {
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau + "&erreur=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void supprimerCreneau(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        LocalDate dateCreneau = LocalDate.parse(req.getParameter("dateCreneau"));
        int idCreneau = Integer.parseInt(req.getParameter("idCreneau"));
        try {
            Creneau existant = creneauService.trouverParId(idCreneau);
            if (existant == null) {
                throw new IllegalArgumentException("Créneau introuvable");
            }
            if (!existant.isDisponible()) {
                throw new IllegalArgumentException("Impossible de supprimer un créneau déjà réservé");
            }
            creneauService.supprimer(idCreneau);
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau);
        } catch (RuntimeException e) {
            resp.sendRedirect(req.getContextPath() + "/secretaire?action=creneaux&date=" + dateCreneau + "&erreur=" + java.net.URLEncoder.encode(e.getMessage(), "UTF-8"));
        }
    }

    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        List<Visite> visitesRecentes = visiteService.trouverVisitesRecentes();
        req.setAttribute("visitesRecentes", visitesRecentes);

        // Rendez-vous reserves par les patients en attente de confirmation par la secretaire
        List<RendezVous> rendezVousEnAttente =
                rendezVousService.trouverParStatut(StatutRendezVous.EN_ATTENTE);
        req.setAttribute("rendezVousEnAttente", rendezVousEnAttente);

        // Statistiques pour les cartes du tableau de bord
        int nbPatientsArrivesAujourdHui = 0;
        List<Visite> patientsArrives = visiteService.trouverPatientsArrives();
        if (patientsArrives != null) {
            nbPatientsArrivesAujourdHui = patientsArrives.size();
        }

        int nbRendezVousAujourdHui = 0;
        List<RendezVous> tousLesRendezVous = rendezVousService.trouverTous();
        LocalDate aujourdHui = LocalDate.now();
        if (tousLesRendezVous != null) {
            for (RendezVous rdv : tousLesRendezVous) {
                if (rdv != null && rdv.getDateRdv() != null
                        && rdv.getDateRdv().isEqual(aujourdHui)) {
                    nbRendezVousAujourdHui++;
                }
            }
        }

        int nbVisitesAEnregistrer = (rendezVousEnAttente != null) ? rendezVousEnAttente.size() : 0;
        long nbPatientsActifs = patientService.compterTous();

        req.setAttribute("nbPatientsArrivesAujourdHui", nbPatientsArrivesAujourdHui);
        req.setAttribute("nbRendezVousAujourdHui", nbRendezVousAujourdHui);
        req.setAttribute("nbVisitesAEnregistrer", nbVisitesAEnregistrer);
        req.setAttribute("nbPatientsActifs", nbPatientsActifs);

        req.getRequestDispatcher("/jsp/secretaire/dashboard.jsp").forward(req, resp);
    }

    private void afficherPatientsArrives(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("patientsArrives", visiteService.trouverPatientsArrives());
        req.getRequestDispatcher("/jsp/secretaire/patients-arrives.jsp").forward(req, resp);
    }

    private void enregistrerVisite(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int idPatient = Integer.parseInt(req.getParameter("idPatient"));
        String motif = req.getParameter("motif");
        String idRdvStr = req.getParameter("idRendezVous");
        Integer idRdv = !isBlank(idRdvStr) ? Integer.parseInt(idRdvStr) : null;

        visiteService.enregistrerVisite(idPatient, idRdv, motif);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=patientsArrives");
    }

    private void confirmerRdv(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int idRdv = Integer.parseInt(req.getParameter("idRendezVous"));
        rendezVousService.confirmer(idRdv);
        resp.sendRedirect(req.getContextPath() + "/secretaire?action=dashboard");
    }

    private void afficherRecherchePatient(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.getRequestDispatcher("/jsp/secretaire/rechercher.jsp").forward(req, resp);
    }

    private void rechercherPatient(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String nom = req.getParameter("nom");
        String dateNaissanceStr = req.getParameter("dateNaissance");

        LocalDate dateNaissance = !isBlank(dateNaissanceStr)
                ? LocalDate.parse(dateNaissanceStr)
                : null;

        List<Patient> patients = (dateNaissance != null)
                ? patientService.rechercherParNomEtDateNaissance(nom, dateNaissance)
                : java.util.Collections.<Patient>emptyList();

        req.setAttribute("patients", patients);
        afficherRecherchePatient(req, resp);
    }

    /** Java 8-compatible replacement for String::isBlank. */
    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
