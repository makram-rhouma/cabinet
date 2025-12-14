<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.time.*,org.projet.cabinet.model.Creneau" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Gestion des créneaux</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/secretaire.css" rel="stylesheet">
</head>
<body class="app-body secretaire-dashboard">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/secretaire">Espace secrétaire</a>
        <div class="d-flex">
            <a href="${pageContext.request.contextPath}/secretaire" class="btn btn-outline-secondary btn-sm me-2">
                <i class="bi bi-house-door me-1" aria-hidden="true"></i>Tableau de bord
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container my-4 app-main">
    <div class="d-flex justify-content-between align-items-start mb-3 flex-wrap gap-2">
        <div>
            <h3 class="mb-1">Gestion des créneaux</h3>
            <p class="text-muted mb-0">Ajouter ou supprimer les créneaux disponibles pour une journée.</p>
        </div>
        <form class="d-flex gap-2" method="get" action="${pageContext.request.contextPath}/secretaire">
            <input type="hidden" name="action" value="creneaux">
            <input type="date" class="form-control" name="date" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>">
            <button type="submit" class="btn btn-primary">
                <i class="bi bi-calendar2-week me-1" aria-hidden="true"></i>Afficher
            </button>
        </form>
    </div>

    <%
        String erreur = request.getParameter("erreur");
        if (erreur != null && !erreur.trim().isEmpty()) {
            try {
                erreur = java.net.URLDecoder.decode(erreur, "UTF-8");
            } catch (Exception ignore) {
            }
    %>
    <div class="alert alert-danger" role="alert">
        <i class="bi bi-exclamation-triangle me-1" aria-hidden="true"></i><%= erreur %>
    </div>
    <%
        }
    %>

    <div class="row g-4">
        <div class="col-lg-5">
            <div class="card card-elevated mb-4">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-plus-circle me-1" aria-hidden="true"></i>Ajouter les créneaux d'une journée</h5>
                    <form method="post" action="${pageContext.request.contextPath}/secretaire" class="row g-3">
                        <input type="hidden" name="action" value="ajouterCreneauxJournee">
                        <input type="hidden" name="dateCreneau" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>">

                        <div class="col-12">
                            <label class="form-label">Date</label>
                            <input type="date" class="form-control" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>" disabled>
                            <div class="form-text">Sélectionnez la date via le filtre en haut.</div>
                        </div>

                        <div class="col-md-6">
                            <label class="form-label">Heure début</label>
                            <input type="time" name="heureDebut" class="form-control" required>
                        </div>
                        <div class="col-md-6">
                            <label class="form-label">Heure fin</label>
                            <input type="time" name="heureFin" class="form-control" required>
                        </div>

                        <div class="col-12">
                            <label class="form-label">Durée (minutes)</label>
                            <input type="number" name="dureeMinutes" class="form-control" min="5" step="5" value="30" required>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-calendar-plus me-1" aria-hidden="true"></i>Générer les créneaux
                            </button>
                        </div>
                    </form>
                </div>
            </div>

            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-trash3 me-1" aria-hidden="true"></i>Supprimer les créneaux disponibles</h5>
                    <form method="post" action="${pageContext.request.contextPath}/secretaire" onsubmit="return confirm('Supprimer tous les créneaux disponibles de cette journée ?');">
                        <input type="hidden" name="action" value="supprimerCreneauxJournee">
                        <input type="hidden" name="dateCreneau" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>">
                        <button type="submit" class="btn btn-outline-danger w-100">
                            <i class="bi bi-trash3 me-1" aria-hidden="true"></i>Supprimer les créneaux disponibles
                        </button>
                        <div class="form-text mt-2">Les créneaux déjà réservés (disponible = false) ne seront pas supprimés.</div>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-7">
            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3"><i class="bi bi-list-ul me-1" aria-hidden="true"></i>Créneaux de la journée</h5>
                    <div class="table-responsive">
                        <table class="table table-sm align-middle table-modern">
                            <thead>
                            <tr>
                                <th>Heure</th>
                                <th>Durée</th>
                                <th>Disponibilité</th>
                                <th class="text-end">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <%
                                List<Creneau> creneauxJournee = (List<Creneau>) request.getAttribute("creneauxJournee");
                                String idEditionStr = request.getParameter("idEdition");
                                Integer idEdition = null;
                                try {
                                    idEdition = (idEditionStr != null && !idEditionStr.trim().isEmpty()) ? Integer.parseInt(idEditionStr) : null;
                                } catch (Exception ignore) {
                                    idEdition = null;
                                }
                                if (creneauxJournee != null && !creneauxJournee.isEmpty()) {
                                    for (Creneau c : creneauxJournee) {
                            %>
                            <tr>
                                <%
                                    boolean edition = (idEdition != null && c != null && c.getId() == idEdition.intValue());
                                %>
                                <td><%= c.getHeureCreneau() %></td>
                                <td>
                                    <%= c.getDureeMinutes() %> min
                                </td>
                                <td>
                                    <% if (c.isDisponible()) { %>
                                    <span class="badge bg-success">Disponible</span>
                                    <% } else { %>
                                    <span class="badge bg-secondary">Réservé</span>
                                    <% } %>
                                </td>
                                <td class="text-end">
                                    <div class="d-inline-flex gap-2">
                                        <%
                                            if (edition) {
                                        %>
                                        <form method="post" action="${pageContext.request.contextPath}/secretaire" class="d-inline">
                                            <input type="hidden" name="action" value="modifierCreneau">
                                            <input type="hidden" name="idCreneau" value="<%= c.getId() %>">
                                            <input type="hidden" name="dateCreneau" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>">
                                            <input type="number" name="dureeMinutes" class="form-control form-control-sm d-inline-block" style="width: 120px" min="5" step="5" value="<%= c.getDureeMinutes() %>" required>
                                            <button type="submit" class="btn btn-sm btn-primary" title="Enregistrer">
                                                <i class="bi bi-check2" aria-hidden="true"></i>
                                            </button>
                                        </form>
                                        <a class="btn btn-sm btn-outline-secondary" title="Annuler" href="${pageContext.request.contextPath}/secretaire?action=creneaux&date=<%= request.getAttribute("dateCreneau") %>">
                                            <i class="bi bi-x" aria-hidden="true"></i>
                                        </a>
                                        <%
                                            } else {
                                        %>
                                        <a class="btn btn-sm btn-outline-primary" title="Modifier" href="${pageContext.request.contextPath}/secretaire?action=creneaux&date=<%= request.getAttribute("dateCreneau") %>&idEdition=<%= c.getId() %>">
                                            <i class="bi bi-pencil-square" aria-hidden="true"></i>
                                        </a>
                                        <form method="post" action="${pageContext.request.contextPath}/secretaire" class="d-inline" onsubmit="return confirm('Supprimer ce créneau ?');">
                                            <input type="hidden" name="action" value="supprimerCreneau">
                                            <input type="hidden" name="idCreneau" value="<%= c.getId() %>">
                                            <input type="hidden" name="dateCreneau" value="<%= request.getAttribute("dateCreneau") != null ? request.getAttribute("dateCreneau") : "" %>">
                                            <button type="submit" class="btn btn-sm btn-outline-danger" title="Supprimer">
                                                <i class="bi bi-trash" aria-hidden="true"></i>
                                            </button>
                                        </form>
                                        <%
                                            }
                                        %>
                                    </div>
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
                                        <p class="mb-0">Aucun créneau pour cette journée.</p>
                                    </div>
                                </td>
                            </tr>
                            <% } %>
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
