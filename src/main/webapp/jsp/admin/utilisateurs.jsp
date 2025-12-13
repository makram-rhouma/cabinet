<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Utilisateur,org.projet.cabinet.model.RoleUtilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administration - Utilisateurs</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/admin.css" rel="stylesheet">
</head>
<body class="app-body admin-dashboard">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/admin">Cabinet médical – Administration</a>
        <div class="d-flex gap-2">
            <a href="${pageContext.request.contextPath}/admin" class="btn btn-outline-light btn-sm">
                <i class="bi bi-speedometer2 me-1" aria-hidden="true"></i>Tableau de bord
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container my-4 app-main">
    <div class="app-section-header mb-3">
        <div>
            <h4 class="mb-1">Tous les utilisateurs</h4>
            <p class="text-muted small mb-0">Gestion des comptes. Les comptes ADMIN sont en lecture seule.</p>
        </div>
        <a href="${pageContext.request.contextPath}/admin?action=creerUtilisateur" class="btn btn-primary">
            <i class="bi bi-person-plus me-1" aria-hidden="true"></i>Créer un utilisateur
        </a>
    </div>

    <%
        List<Utilisateur> utilisateurs = (List<Utilisateur>) request.getAttribute("utilisateurs");
        String erreur = (String) request.getAttribute("erreur");
        String succes = (String) request.getAttribute("succes");
    %>

    <% if (erreur != null) { %>
        <div class="alert alert-danger"><%= erreur %></div>
    <% } else if (succes != null) { %>
        <div class="alert alert-success"><%= succes %></div>
    <% } %>

    <div class="card card-elevated mb-3 filter-card">
        <div class="card-body">
            <div class="row g-3 align-items-end">
                <div class="col-md-6">
                    <label for="filtreUtilisateurs" class="form-label">Rechercher (nom, email, rôle)</label>
                    <input type="search" id="filtreUtilisateurs" class="form-control" placeholder="Filtrer les utilisateurs...">
                </div>
            </div>
        </div>
    </div>

    <div class="card card-elevated">
        <div class="card-body">
            <div class="table-responsive">
                <table class="table align-middle table-modern" id="tableUtilisateurs">
                    <thead>
                    <tr>
                        <th>Nom</th>
                        <th>Prénom</th>
                        <th>Email</th>
                        <th>Rôle</th>
                        <th class="text-end">Actions</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% if (utilisateurs != null && !utilisateurs.isEmpty()) {
                           for (Utilisateur u : utilisateurs) {
                               String recherche = (u.getNom() + " " + u.getPrenom() + " " + u.getEmail() + " " + u.getRole());
                    %>
                        <tr data-utilisateur-row="true" data-search="<%= recherche %>">
                            <td><%= u.getNom() %></td>
                            <td><%= u.getPrenom() %></td>
                            <td><%= u.getEmail() %></td>
                            <td>
                                <span class="app-role-pill"><%= u.getRole() %></span>
                            </td>
                            <td class="text-end">
                                <% if (u.getRole() != RoleUtilisateur.ADMIN) { %>
                                    <div class="d-inline-flex gap-1">
                                        <form method="post" action="${pageContext.request.contextPath}/admin" class="d-inline">
                                            <input type="hidden" name="action" value="supprimerUtilisateur">
                                            <input type="hidden" name="id" value="<%= u.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-danger"
                                                    onclick="return confirm('Supprimer cet utilisateur ?');">
                                                <i class="bi bi-trash me-1" aria-hidden="true"></i>Supprimer
                                            </button>
                                        </form>
                                        <a class="btn btn-sm btn-outline-secondary"
                                           href="${pageContext.request.contextPath}/admin?action=modifierUtilisateur&id=<%= u.getId() %>">
                                            <i class="bi bi-pencil-square me-1" aria-hidden="true"></i>Modifier
                                        </a>
                                    </div>
                                <% } else { %>
                                    <span class="text-muted small">ADMIN (non modifiable)</span>
                                <% } %>
                            </td>
                        </tr>
                    <%   }
                       } else { %>
                        <tr>
                            <td colspan="5">
                                <div class="app-empty-state">
                                    <div class="app-empty-state-icon">
                                        <i class="bi bi-people" aria-hidden="true"></i>
                                    </div>
                                    <p class="mb-0">Aucun utilisateur trouvé.</p>
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

<script>
(function() {
    var input = document.getElementById('filtreUtilisateurs');
    if (!input) return;
    input.addEventListener('input', function () {
        var filtre = this.value.toLowerCase();
        var lignes = document.querySelectorAll('tr[data-utilisateur-row]');
        Array.prototype.forEach.call(lignes, function (ligne) {
            var texte = (ligne.getAttribute('data-search') || '').toLowerCase();
            ligne.style.display = texte.indexOf(filtre) !== -1 ? '' : 'none';
        });
    });
})();
</script>

</body>
</html>
