<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.*" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>Cr&eacute;ation de bilan</title>
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
	        <h3 class="mb-0">Cr&eacute;er un bilan m&eacute;dical</h3>
	        <a href="${pageContext.request.contextPath}/medecin" class="btn btn-outline-secondary btn-sm">
	            <i class="bi bi-chevron-left me-1" aria-hidden="true"></i>Retour au tableau de bord
	        </a>
	    </div>

    <div class="row g-4">
        <div class="col-lg-5 col-xl-4">
            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3">Cr&eacute;er un bilan</h5>
                    <%
                        Patient patient = (Patient) request.getAttribute("patient");
                    %>
                    <% if (patient != null) { %>
                        <p class="mb-3">
                            <span class="text-muted small d-block mb-1">Patient</span>
                            <strong><%= patient.getUtilisateur().getNom() %> <%= patient.getUtilisateur().getPrenom() %></strong>
                        </p>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/medecin">
                        <input type="hidden" name="action" value="creerBilan">
                        <input type="hidden" name="idPatient" value="<%= patient != null ? patient.getId() : 0 %>">

                        <div class="mb-3">
                            <label class="form-label">Motif</label>
                            <input type="text" name="motif" class="form-control" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Observations</label>
                            <textarea name="observations" class="form-control" rows="3"></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Diagnostic</label>
                            <textarea name="diagnostic" class="form-control" rows="3"></textarea>
                        </div>

                        <div class="mb-3">
                            <label class="form-label">Traitement</label>
                            <textarea name="traitement" class="form-control" rows="3"></textarea>
                        </div>

	                        <button type="submit" class="btn btn-primary w-100">
	                            <i class="bi bi-save me-1" aria-hidden="true"></i>Enregistrer le bilan
	                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-7 col-xl-8">
            <div class="card card-elevated h-100">
                <div class="card-body d-flex flex-column">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title mb-0">Bilans existants</h5>
                    </div>

                    <div class="table-responsive">
                        <table class="table align-middle table-modern">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Motif</th>
                                <th>Diagnostic</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Bilan> bilans = (List<Bilan>) request.getAttribute("bilans");
                                if (bilans != null && !bilans.isEmpty()) {
                                    for (Bilan b : bilans) {
                            %>
                            <tr>
                                <td><%= b.getDateBilan() %></td>
                                <td><%= b.getMotif() %></td>
                                <td><%= b.getDiagnostic() %></td>
                            </tr>
                            <%
                                    }
                                } else {
                            %>
	                            <tr>
	                                <td colspan="3">
	                                    <div class="app-empty-state">
	                                        <div class="app-empty-state-icon">
	                                            <i class="bi bi-clipboard-x" aria-hidden="true"></i>
	                                        </div>
	                                        <p class="mb-0">Aucun bilan enregistr&eacute; pour le moment.</p>
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