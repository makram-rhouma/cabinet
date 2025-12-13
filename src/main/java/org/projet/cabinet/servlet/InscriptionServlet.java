package org.projet.cabinet.servlet;

import java.io.IOException;
import java.time.LocalDate;

import javax.servlet.RequestDispatcher;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.projet.cabinet.model.RoleUtilisateur;
import org.projet.cabinet.service.PatientService;
import org.projet.cabinet.service.UtilisateurService;

public class InscriptionServlet extends HttpServlet {

    private UtilisateurService utilisateurService;
    private PatientService patientService;

    @Override
    public void init() {
        ServletContext contexte = getServletContext();
        this.utilisateurService = new UtilisateurService(contexte);
        this.patientService = new PatientService(contexte);
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        RequestDispatcher rd = req.getRequestDispatcher("/jsp/inscription.jsp");
        rd.forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String nom = req.getParameter("nom");
        String prenom = req.getParameter("prenom");
        String email = req.getParameter("email");
        String motDePasse = req.getParameter("motDePasse");
        String dateNaissanceStr = req.getParameter("dateNaissance");
        String telephone = req.getParameter("telephone");

        LocalDate dateNaissance = !isBlank(dateNaissanceStr)
                ? LocalDate.parse(dateNaissanceStr)
                : null;

        try {
            utilisateurService.inscrire(
                    nom,
                    prenom,
                    email,
                    motDePasse,
                    RoleUtilisateur.PATIENT,
                    dateNaissance,
                    telephone);
            resp.sendRedirect(req.getContextPath() + "/login?inscription=ok");
        } catch (IllegalArgumentException e) {
            req.setAttribute("erreur", e.getMessage());
            doGet(req, resp);
        }
    }

    /** Java 8-compatible replacement for String::isBlank. */
    private static boolean isBlank(String value) {
        return value == null || value.trim().isEmpty();
    }
}
