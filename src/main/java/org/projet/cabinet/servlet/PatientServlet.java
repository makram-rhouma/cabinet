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
import javax.servlet.http.HttpSession;

import org.projet.cabinet.model.*;
import org.projet.cabinet.service.*;

public class PatientServlet extends HttpServlet {

    private CreneauService creneauService;
    private RendezVousService rendezVousService;
    private VisiteService visiteService;
    private BilanService bilanService;

    @Override
    public void init() {
        ServletContext c = getServletContext();
        this.creneauService = new CreneauService(c);
        this.rendezVousService = new RendezVousService(c);
        this.visiteService = new VisiteService(c);
        this.bilanService = new BilanService(c);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        String action = req.getParameter("action");
        if (action == null) {
            action = "dashboard";
        }

        switch (action) {
            case "listerCreneaux":
                afficherCreneaux(req, resp);
                break;
            case "filtrerCreneaux":
                filtrerCreneaux(req, resp);
                break;
            case "historique":
                afficherHistorique(req, resp);
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
        if ("reserver".equals(action)) {
            reserver(req, resp);
        } else if ("signalerArrivee".equals(action)) {
            signalerArrivee(req, resp);
        } else {
            doGet(req, resp);
        }
    }

    private int getIdPatient(HttpServletRequest req) {
        HttpSession s = req.getSession(false);
        Object id = (s != null) ? s.getAttribute("idPatient") : null;
        return (id instanceof Integer) ? (Integer) id : -1;
    }

    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int idPatient = getIdPatient(req);

        // Statistiques rendez-vous du patient
        List<RendezVous> rendezVousPatient = rendezVousService.trouverParPatientId(idPatient);
        LocalDate aujourdHui = LocalDate.now();
        int nbRendezVousAVenir = 0;
        if (rendezVousPatient != null) {
            for (RendezVous rdv : rendezVousPatient) {
                if (rdv != null && rdv.getDateRdv() != null
                        && !rdv.getDateRdv().isBefore(aujourdHui)
                        && rdv.getStatut() != StatutRendezVous.ANNULE) {
                    nbRendezVousAVenir++;
                }
            }
        }

        // Statistiques visites du patient
        List<Visite> visitesPatient = visiteService.trouverParPatientId(idPatient);
        int nbVisitesPassees = (visitesPatient != null) ? visitesPatient.size() : 0;

        // Creneaux disponibles sur la semaine courante
        LocalDate debutSemaine = aujourdHui.with(java.time.DayOfWeek.MONDAY);
        LocalDate finSemaine = debutSemaine.plusDays(6);
        List<Creneau> creneauxSemaine = creneauService.trouverAvecFiltres(
                debutSemaine,
                finSemaine,
                null,
                null);
        int nbCreneauxCetteSemaine = (creneauxSemaine != null) ? creneauxSemaine.size() : 0;

        // Bilans du patient
        List<Bilan> bilansPatient = bilanService.trouverParPatientId(idPatient);
        int nbBilansPatient = (bilansPatient != null) ? bilansPatient.size() : 0;

        // Liste des creneaux disponibles pour l'affichage du tableau
        req.setAttribute("creneauxDisponibles", creneauService.trouverDisponibles());

        req.setAttribute("nbRendezVousAVenir", nbRendezVousAVenir);
        req.setAttribute("nbVisitesPassees", nbVisitesPassees);
        req.setAttribute("nbCreneauxCetteSemaine", nbCreneauxCetteSemaine);
        req.setAttribute("nbBilansPatient", nbBilansPatient);

        req.getRequestDispatcher("/jsp/patient/dashboard.jsp").forward(req, resp);
    }

    private void afficherCreneaux(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        req.setAttribute("creneauxDisponibles", creneauService.trouverDisponibles());
        req.getRequestDispatcher("/jsp/patient/creneaux.jsp").forward(req, resp);
    }

    private void filtrerCreneaux(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        LocalDate dateDebut = parseDate(req.getParameter("dateDebut"));
        LocalDate dateFin = parseDate(req.getParameter("dateFin"));
        LocalTime heureDebut = parseTime(req.getParameter("heureDebut"));
        LocalTime heureFin = parseTime(req.getParameter("heureFin"));

        List<Creneau> creneaux = creneauService.trouverAvecFiltres(
                dateDebut,
                dateFin,
                heureDebut,
                heureFin);

        req.setAttribute("creneauxDisponibles", creneaux);
        req.getRequestDispatcher("/jsp/patient/creneaux.jsp").forward(req, resp);
    }

    private void reserver(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int idPatient = getIdPatient(req);
        int idCreneau = Integer.parseInt(req.getParameter("idCreneau"));

        try {
            RendezVous rdv = rendezVousService.reserver(idPatient, idCreneau);
            req.setAttribute("rendezVous", rdv);
            req.getRequestDispatcher("/jsp/patient/reserver.jsp").forward(req, resp);
        } catch (IllegalArgumentException e) {
            req.setAttribute("erreur", e.getMessage());
            afficherCreneaux(req, resp);
        }
    }

    private void afficherHistorique(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int idPatient = getIdPatient(req);
        req.setAttribute("rendezVous", rendezVousService.trouverParPatientId(idPatient));
        req.setAttribute("visites", visiteService.trouverParPatientId(idPatient));
        req.getRequestDispatcher("/jsp/patient/historique.jsp").forward(req, resp);
    }

    private void signalerArrivee(HttpServletRequest req, HttpServletResponse resp)
            throws IOException {
        int idPatient = getIdPatient(req);
        String idRdvStr = req.getParameter("idRendezVous");
        Integer idRdv = !isBlank(idRdvStr) ? Integer.parseInt(idRdvStr) : null;

        visiteService.enregistrerVisite(idPatient, idRdv, "Arrivée du patient");
        resp.sendRedirect(req.getContextPath() + "/patient?action=historique");
    }

    private LocalDate parseDate(String value) {
        return !isBlank(value) ? LocalDate.parse(value) : null;
    }

    private LocalTime parseTime(String value) {
        return !isBlank(value) ? LocalTime.parse(value) : null;
    }

    /** Java 8-compatible replacement for String::isBlank. */
    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
