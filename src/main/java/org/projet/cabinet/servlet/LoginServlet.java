package org.projet.cabinet.servlet; import java.io.IOException; import javax.servlet.*; import javax.servlet.http.*; import org.projet.cabinet.model.*; import org.projet.cabinet.service.*;
public class LoginServlet extends HttpServlet {
    private UtilisateurService utilisateurService; private PatientService patientService;
    public void init() { ServletContext contexte = getServletContext(); this.utilisateurService = new UtilisateurService(contexte); this.patientService = new PatientService(contexte); }
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { RequestDispatcher rd = req.getRequestDispatcher("/jsp/login.jsp"); rd.forward(req, resp); }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { String email = req.getParameter("email"); String motDePasse = req.getParameter("motDePasse"); Utilisateur utilisateur = utilisateurService.authentifier(email, motDePasse); if (utilisateur == null) { req.setAttribute("erreur", "Email ou mot de passe invalide"); doGet(req, resp); return; } HttpSession session = req.getSession(true); session.setAttribute("idUtilisateur", utilisateur.getId()); session.setAttribute("emailUtilisateur", utilisateur.getEmail()); session.setAttribute("roleUtilisateur", utilisateur.getRole()); if (utilisateur.getRole() == RoleUtilisateur.PATIENT) { Patient patient = patientService.trouverParUtilisateurId(utilisateur.getId()); if (patient != null) { session.setAttribute("idPatient", patient.getId()); } }
        String cible = "/"; switch (utilisateur.getRole()) { case PATIENT: cible = "/patient"; break; case SECRETAIRE: cible = "/secretaire"; break; case MEDECIN: cible = "/medecin"; break; case ADMIN: cible = "/admin"; break; default: cible = "/"; }
        resp.sendRedirect(req.getContextPath() + cible); }
}

