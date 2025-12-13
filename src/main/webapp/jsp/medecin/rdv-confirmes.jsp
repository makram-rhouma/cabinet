<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.RendezVous" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Rendez-vous confirm&eacute;s</title>
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
	    <div class="d-flex justify-content-between align-items-center mb-3">
	        <h3 class="mb-0">Rendez-vous confirm&eacute;s</h3>
	        <a href="${pageContext.request.contextPath}/medecin" class="btn btn-outline-secondary btn-sm">
	            <i class="bi bi-chevron-left me-1" aria-hidden="true"></i>Retour au tableau de bord
	        </a>
	    </div>

    <div class="card card-elevated">
        <div class="card-body">
            <p class="text-muted small mb-3">
                Liste des rendez-vous confirm&eacute;s avec vos patients.
            </p>
            <div class="table-responsive">
                <table class="table align-middle table-modern">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Heure</th>
                        <th>Patient</th>
                        <th></th>
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
	                        <td class="text-end">
	                            <a class="btn btn-sm btn-primary"
	                               href="${pageContext.request.contextPath}/medecin?action=voirPatient&idPatient=<%= r.getPatient().getId() %>">
	                                <i class="bi bi-person-vcard me-1" aria-hidden="true"></i>Voir patient
	                            </a>
	                        </td>
                    </tr>
                    <%
                            }
                        } else {
                    %>
	                    <tr>
	                        <td colspan="4">
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

</body>
</html>
