<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Utilisateur" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Administration - Gestion des utilisateurs</title>
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
        <div class="d-flex">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>Déconnexion
            </a>
        </div>
    </div>
</nav>

<div class="container my-4 app-main">
    <div class="stats-grid mb-4">
	        <div class="card card-elevated stats-card stats-card-doctors">
	            <div class="card-body">
	                <div class="d-flex align-items-center justify-content-between mb-2">
	                    <div>
                        <div class="stats-label mb-1">M&eacute;decins</div>
                        <div class="stats-value">${nbMedecins}</div>
	                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-person-badge" aria-hidden="true"></i>
	                    </div>
	                </div>
                <p class="text-muted small mb-0">Nombre total de m&eacute;decins dans le cabinet.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card stats-card-secretaries">
	            <div class="card-body">
	                <div class="d-flex align-items-center justify-content-between mb-2">
	                    <div>
                        <div class="stats-label mb-1">Secr&eacute;taires</div>
                        <div class="stats-value">${nbSecretaires}</div>
	                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-person-gear" aria-hidden="true"></i>
	                    </div>
	                </div>
                <p class="text-muted small mb-0">Nombre total de secr&eacute;taires actives.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card">
	            <div class="card-body">
	                <div class="d-flex align-items-center justify-content-between mb-2">
	                    <div>
                        <div class="stats-label mb-1">Patients</div>
                        <div class="stats-value">${nbPatients}</div>
	                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-people" aria-hidden="true"></i>
	                    </div>
	                </div>
                <p class="text-muted small mb-0">Patients enregistr&eacute;s dans le syst&egrave;me.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card stats-card-users">
	            <div class="card-body">
	                <div class="d-flex align-items-center justify-content-between mb-2">
	                    <div>
                        <div class="stats-label mb-1">Utilisateurs au total</div>
                        <div class="stats-value">${nbUtilisateursTotal}</div>
	                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-people-fill" aria-hidden="true"></i>
	                    </div>
	                </div>
                <p class="text-muted small mb-0">Tous les comptes actifs (patients et personnel).</p>
            </div>
        </div>
    </div>

    <div class="row g-4">
        <div class="col-lg-4">
            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3">Créer un compte</h5>
                    <p class="text-muted small">Les comptes ADMIN ne peuvent pas être créés ici. Seuls les rôles SECRETAIRE et MEDECIN sont autorisés.</p>

                    <% String erreur = (String) request.getAttribute("erreur");
                       String succes = (String) request.getAttribute("succes");
                       if (erreur != null) { %>
                        <div class="alert alert-danger"><%= erreur %></div>
                    <% } else if (succes != null) { %>
                        <div class="alert alert-success"><%= succes %></div>
                    <% } %>

                    <form method="post" action="${pageContext.request.contextPath}/admin">
                        <input type="hidden" name="action" value="creerUtilisateur">
                        <div class="mb-3">
                            <label class="form-label">Nom</label>
                            <input type="text" name="nom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Prénom</label>
                            <input type="text" name="prenom" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Email</label>
                            <input type="email" name="email" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Mot de passe</label>
                            <input type="password" name="motDePasse" minlength="6" class="form-control" required>
                        </div>
                        <div class="mb-3">
                            <label class="form-label">Rôle</label>
                            <select name="role" class="form-select" required>
                                <option value="" selected disabled>Choisir un rôle</option>
                                <option value="SECRETAIRE">SECRETAIRE</option>
                                <option value="MEDECIN">MEDECIN</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-person-plus me-1" aria-hidden="true"></i>Créer l'utilisateur
                        </button>
                    </form>
                </div>
            </div>
        </div>

        <div class="col-lg-8">
            <div class="card card-elevated">
                <div class="card-body">
                    <div class="app-section-header mb-3">
                        <h5 class="mb-0">Utilisateurs existants</h5>
                        <a href="${pageContext.request.contextPath}/admin?action=listerUtilisateurs" class="btn btn-sm btn-outline-primary">
                            <i class="bi bi-list-ul me-1" aria-hidden="true"></i>Voir tous les utilisateurs
                        </a>
                    </div>
                    <div class="table-responsive">
                        <table class="table align-middle table-modern">
                            <thead>
                            <tr>
                                <th>ID</th>
                                <th>Nom</th>
                                <th>Prénom</th>
                                <th>Email</th>
                                <th>Rôle</th>
                                <th class="text-end">Actions</th>
                            </tr>
                            </thead>
                            <tbody>
                            <% List<Utilisateur> secretaires = (List<Utilisateur>) request.getAttribute("secretaires");
                               List<Utilisateur> medecins = (List<Utilisateur>) request.getAttribute("medecins");
                               if (secretaires != null) {
                                   for (Utilisateur u : secretaires) { %>
                                       <tr>
                                           <td><%= u.getId() %></td>
                                           <td><%= u.getNom() %></td>
                                           <td><%= u.getPrenom() %></td>
                                           <td><%= u.getEmail() %></td>
                                           <td>SECRETAIRE</td>
                                           <td class="text-end">
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
                                           </td>
                                       </tr>
                            <%     }
                               }
                               if (medecins != null) {
                                   for (Utilisateur u : medecins) { %>
                                       <tr>
                                           <td><%= u.getId() %></td>
                                           <td><%= u.getNom() %></td>
                                           <td><%= u.getPrenom() %></td>
                                           <td><%= u.getEmail() %></td>
                                           <td>MEDECIN</td>
                                           <td class="text-end">
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
                                           </td>
                                       </tr>
                            <%     }
                               }
                               if ((secretaires == null || secretaires.isEmpty()) && (medecins == null || medecins.isEmpty())) { %>
	                                   <tr>
	                                       <td colspan="5">
	                                           <div class="app-empty-state">
	                                               <div class="app-empty-state-icon">
	                                                   <i class="bi bi-people" aria-hidden="true"></i>
	                                               </div>
	                                               <p class="mb-0">Aucun utilisateur SECRETAIRE ou MEDECIN pour le moment.</p>
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
