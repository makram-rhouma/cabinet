<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.RendezVous" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Tableau de bord M&eacute;decin</title>
	<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
	<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
	<link href="${pageContext.request.contextPath}/css/medecin.css" rel="stylesheet">
</head>
<body class="app-body medecin-dashboard">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
	    <div class="container">
	        <a class="navbar-brand" href="${pageContext.request.contextPath}/medecin">Espace M&eacute;decin</a>
	        <div class="d-flex">
	            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
	                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>D&eacute;connexion
	            </a>
	        </div>
	    </div>
</nav>

<div class="container my-4 app-main">
    <div class="stats-grid mb-4">
        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Rendez-vous aujourd'hui</div>
                        <div class="stats-value">${nbRdvAujourdHui}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-calendar-day" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Rendez-vous confirm&eacute;s pr&eacute;vus aujourd'hui.</p>
            </div>
        </div>

        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Total rendez-vous confirm&eacute;s</div>
                        <div class="stats-value">${nbRdvConfirmesTotal}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-calendar-check" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Rendez-vous confirm&eacute;s dans l'ensemble de votre activit&eacute;.</p>
            </div>
        </div>

        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Patients cette semaine</div>
                        <div class="stats-value">${nbPatientsCetteSemaine}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-people" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Patients vus depuis le d&eacute;but de la semaine.</p>
            </div>
        </div>

        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Bilans r&eacute;dig&eacute;s</div>
                        <div class="stats-value">${nbBilansMedecin}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-clipboard-heart" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Bilans m&eacute;dicaux r&eacute;dig&eacute;s pour vos patients.</p>
            </div>
        </div>
    </div>

    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Tableau de bord M&eacute;decin</h3>
	    	<a href="${pageContext.request.contextPath}/medecin?action=rdvConfirmes" class="btn btn-primary btn-sm">
	    	    <i class="bi bi-calendar-check me-1" aria-hidden="true"></i>Voir tous les rendez-vous confirm&eacute;s
	    	</a>
    </div>

    <div class="row g-4">
        <div class="col-lg-12">
            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3">Rendez-vous confirm&eacute;s</h5>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle table-modern">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Patient</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rdvConfirmes");
                                if (rdvs != null && !rdvs.isEmpty()) {
                                    for (RendezVous r : rdvs) {
                            %>
                            <tr>
                                <td><%= r.getDateRdv() %></td>
                                <td><%= r.getHeureRdv() %></td>
                                <td><%= r.getPatient().getUtilisateur().getNom() %> <%= r.getPatient().getUtilisateur().getPrenom() %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
	                            <tr>
	                                <td colspan="3">
	                                    <div class="app-empty-state">
	                                        <div class="app-empty-state-icon">
	                                            <i class="bi bi-calendar-x" aria-hidden="true"></i>
	                                        </div>
	                                        <p class="mb-0">Aucun rendez-vous confirm&eacute; pour le moment.</p>
	                                    </div>
	                                </td>
	                            </tr>
                            <%
                                }
                            %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
