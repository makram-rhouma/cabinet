<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Creneau" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Cr&eacute;neaux disponibles</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/patient.css" rel="stylesheet">
</head>
<body class="app-body patient-dashboard">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/patient">Mon espace patient</a>
        <div class="d-flex">
            <a href="${pageContext.request.contextPath}/patient" class="btn btn-outline-secondary btn-sm me-2">
                <i class="bi bi-house-door me-1" aria-hidden="true"></i>Tableau de bord
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>D&eacute;connexion
            </a>
        </div>
    </div>
</nav>

<div class="container my-4 app-main">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <div>
            <h3 class="mb-1">Cr&eacute;neaux disponibles</h3>
            <p class="text-muted mb-0">Choisissez un cr&eacute;neau puis cliquez sur <strong>R&eacute;server</strong>.</p>
        </div>
    </div>

    <div class="card card-elevated filter-card mb-4">
        <div class="card-body">
            <h5 class="card-title mb-3">Filtrer les cr&eacute;neaux</h5>
            <form class="row g-3" method="get" action="${pageContext.request.contextPath}/patient">
                <input type="hidden" name="action" value="filtrerCreneaux">
                <div class="col-md-3">
                    <label class="form-label" for="dateDebut">Date d&eacute;but</label>
                    <input type="date" id="dateDebut" name="dateDebut" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="dateFin">Date fin</label>
                    <input type="date" id="dateFin" name="dateFin" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="heureDebut">Heure d&eacute;but</label>
                    <input type="time" id="heureDebut" name="heureDebut" class="form-control">
                </div>
                <div class="col-md-3">
                    <label class="form-label" for="heureFin">Heure fin</label>
                    <input type="time" id="heureFin" name="heureFin" class="form-control">
                </div>
                <div class="col-12 d-flex justify-content-end">
                    <button type="submit" class="btn btn-primary">
                        <i class="bi bi-funnel me-1" aria-hidden="true"></i>Appliquer les filtres
                    </button>
                </div>
            </form>
        </div>
    </div>

    <% String erreur = (String) request.getAttribute("erreur");
       if (erreur != null) { %>
        <div class="alert alert-danger mb-3"><%= erreur %></div>
    <% } %>

    <div class="card card-elevated">
        <div class="card-body">
            <h5 class="card-title mb-3">Cr&eacute;neaux disponibles</h5>
            <div class="table-responsive">
                <table class="table table-sm align-middle table-modern">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Heure</th>
                        <th>Dur&eacute;e</th>
                        <th class="text-end">Action</th>
                    </tr>
                    </thead>
                    <tbody>
                    <%
                        List<Creneau> liste = (List<Creneau>) request.getAttribute("creneauxDisponibles");
                        if (liste != null && !liste.isEmpty()) {
                            for (Creneau c : liste) {
                    %>
                    <tr>
                        <td><%= c.getDateCreneau() %></td>
                        <td><%= c.getHeureCreneau() %></td>
                        <td><%= c.getDureeMinutes() %> min</td>
                        <td class="text-end">
                            <form method="post" action="${pageContext.request.contextPath}/patient" class="d-inline">
                                <input type="hidden" name="action" value="reserver">
                                <input type="hidden" name="idCreneau" value="<%= c.getId() %>">
                                <button type="submit" class="btn btn-sm btn-primary">
                                    <i class="bi bi-calendar-plus me-1" aria-hidden="true"></i>R&eacute;server
                                </button>
                            </form>
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
                                <p class="mb-0">Aucun cr&eacute;neau disponible ne correspond &agrave; vos filtres.</p>
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
