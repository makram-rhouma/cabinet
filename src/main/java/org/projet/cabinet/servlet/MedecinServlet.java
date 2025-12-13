package org.projet.cabinet.servlet; import java.io.IOException; import javax.servlet.*; import javax.servlet.http.*; import org.projet.cabinet.model.*; import org.projet.cabinet.service.*;
public class MedecinServlet extends HttpServlet {
    private RendezVousService rendezVousService; private BilanService bilanService; private PatientService patientService;
    public void init() { ServletContext c = getServletContext(); this.rendezVousService = new RendezVousService(c); this.bilanService = new BilanService(c); this.patientService = new PatientService(c); }
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { String action = req.getParameter("action"); if (action == null) action = "dashboard"; switch (action) { case "rdvConfirmes": afficherRdvConfirmes(req, resp); break; case "voirPatient": voirPatient(req, resp); break; default: afficherDashboard(req, resp); } }
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { String action = req.getParameter("action"); if ("creerBilan".equals(action)) { creerBilan(req, resp); } else { doGet(req, resp); } }
    private int getIdMedecin(HttpServletRequest req) { HttpSession s = req.getSession(false); Object id = (s != null) ? s.getAttribute("idUtilisateur") : null; return (id instanceof Integer) ? (Integer) id : -1; }
    private void afficherDashboard(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        java.time.LocalDate aujourdHui = java.time.LocalDate.now();

        // Rendez-vous confirmés et statistiques associées
        java.util.List<RendezVous> rdvConfirmes = rendezVousService.trouverConfirmes();
        req.setAttribute("rdvConfirmes", rdvConfirmes);

        long nbRdvAujourdHui = 0;
        if (rdvConfirmes != null) {
            for (RendezVous r : rdvConfirmes) {
                if (r != null && r.getDateRdv() != null && r.getDateRdv().isEqual(aujourdHui)) {
                    nbRdvAujourdHui++;
                }
            }
        }

        long nbRdvConfirmesTotal = (rdvConfirmes != null) ? rdvConfirmes.size() : 0;

        // Bilans du medecin courant et patients vus cette semaine
        int idMedecin = getIdMedecin(req);
        java.util.List<Bilan> bilansMedecin = bilanService.trouverParMedecinId(idMedecin);
        java.time.LocalDate debutSemaine = aujourdHui.with(java.time.DayOfWeek.MONDAY);

        java.util.Set<Integer> patientsCetteSemaine = new java.util.HashSet<Integer>();
        if (bilansMedecin != null) {
            for (Bilan b : bilansMedecin) {
                if (b != null && b.getDateBilan() != null) {
                    java.time.LocalDate dateBilan = b.getDateBilan().toLocalDate();
                    if (!dateBilan.isBefore(debutSemaine)) {
                        Patient p = b.getPatient();
                        if (p != null) {
                            patientsCetteSemaine.add(p.getId());
                        }
                    }
                }
            }
        }

        int nbPatientsCetteSemaine = patientsCetteSemaine.size();
        int nbBilansMedecin = (bilansMedecin != null) ? bilansMedecin.size() : 0;

        req.setAttribute("nbRdvAujourdHui", nbRdvAujourdHui);
        req.setAttribute("nbRdvConfirmesTotal", nbRdvConfirmesTotal);
        req.setAttribute("nbPatientsCetteSemaine", nbPatientsCetteSemaine);
        req.setAttribute("nbBilansMedecin", nbBilansMedecin);

        req.getRequestDispatcher("/jsp/medecin/dashboard.jsp").forward(req, resp);
    }
    private void afficherRdvConfirmes(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { req.setAttribute("rdvConfirmes", rendezVousService.trouverConfirmes()); req.getRequestDispatcher("/jsp/medecin/rdv-confirmes.jsp").forward(req, resp); }
    private void voirPatient(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException { int idPatient = Integer.parseInt(req.getParameter("idPatient")); req.setAttribute("patient", patientService.trouverParId(idPatient)); req.setAttribute("bilans", bilanService.trouverParPatientId(idPatient)); req.getRequestDispatcher("/jsp/medecin/creer-bilan.jsp").forward(req, resp); }
    private void creerBilan(HttpServletRequest req, HttpServletResponse resp) throws IOException { int idMedecin = getIdMedecin(req); int idPatient = Integer.parseInt(req.getParameter("idPatient")); String motif = req.getParameter("motif"); String observations = req.getParameter("observations"); String diagnostic = req.getParameter("diagnostic"); String traitement = req.getParameter("traitement"); bilanService.creerBilan(idPatient, idMedecin, motif, observations, diagnostic, traitement); resp.sendRedirect(req.getContextPath() + "/medecin?action=voirPatient&idPatient=" + idPatient); }
}

