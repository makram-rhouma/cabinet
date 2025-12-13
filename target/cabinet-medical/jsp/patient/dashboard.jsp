<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Creneau" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Espace patient</title>
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
            <a href="${pageContext.request.contextPath}/patient?action=historique" class="btn btn-outline-secondary btn-sm me-2">
                <i class="bi bi-clock-history me-1" aria-hidden="true"></i>Historique
            </a>
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
                <i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>Déconnexion
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
                            <div class="stats-label mb-1">Rendez-vous &agrave; venir</div>
                            <div class="stats-value">${nbRendezVousAVenir}</div>
		                    </div>
                    <div class="stats-icon-circle">
                        <i class="bi bi-calendar2-week" aria-hidden="true"></i>
                    </div>
		                </div>
		                <p class="text-muted small mb-0">Vos prochains rendez-vous planifi&eacute;s.</p>
		            </div>
		        </div>
		
		        <div class="card card-elevated stats-card">
		            <div class="card-body">
		                <div class="d-flex align-items-center justify-content-between mb-2">
		                    <div>
                            <div class="stats-label mb-1">Visites pass&eacute;es</div>
                            <div class="stats-value">${nbVisitesPassees}</div>
		                    </div>
                    <div class="stats-icon-circle">
                        <i class="bi bi-clock-history" aria-hidden="true"></i>
                    </div>
		                </div>
		                <p class="text-muted small mb-0">Visites d&eacute;j&agrave; effectu&eacute;es au cabinet.</p>
		            </div>
		        </div>
		
		        <div class="card card-elevated stats-card">
		            <div class="card-body">
		                <div class="d-flex align-items-center justify-content-between mb-2">
		                    <div>
                            <div class="stats-label mb-1">Cr&eacute;neaux disponibles cette semaine</div>
                            <div class="stats-value">${nbCreneauxCetteSemaine}</div>
		                    </div>
                    <div class="stats-icon-circle">
                        <i class="bi bi-calendar-plus" aria-hidden="true"></i>
                    </div>
		                </div>
		                <p class="text-muted small mb-0">Cr&eacute;neaux que vous pouvez encore r&eacute;server.</p>
		            </div>
		        </div>
		
		        <div class="card card-elevated stats-card">
		            <div class="card-body">
		                <div class="d-flex align-items-center justify-content-between mb-2">
		                    <div>
                            <div class="stats-label mb-1">Mes bilans</div>
                            <div class="stats-value">${nbBilansPatient}</div>
		                    </div>
                    <div class="stats-icon-circle">
                        <i class="bi bi-clipboard-heart" aria-hidden="true"></i>
                    </div>
		                </div>
		                <p class="text-muted small mb-0">Bilans m&eacute;dicaux disponibles dans votre dossier.</p>
		            </div>
		        </div>
		    </div>
	
	    <% String message = (String) request.getAttribute("message");
	       if (message != null) { %>
	        <div class="alert alert-info"><%= message %></div>
	    <% } %>
		
		    <div class="card card-elevated filter-card mb-4">
		        <div class="card-body">
		            <h5 class="card-title mb-3">Filtrer les cr&eacute;neaux disponibles</h5>
		            <form class="row g-3" id="creneaux-filter-form">
		                <div class="col-md-4">
		                    <label for="filter-creneaux-date" class="form-label">Date</label>
		                    <input type="date" class="form-control" id="filter-creneaux-date" name="date">
		                </div>
		                <div class="col-md-4">
		                    <label for="filter-creneaux-text" class="form-label">M&eacute;decin</label>
		                    <input type="text" class="form-control" id="filter-creneaux-text" placeholder="Rechercher par m&eacute;decin (ou texte libre)">
		                </div>
		                <div class="col-md-4 d-flex align-items-end justify-content-end">
                            <div class="d-flex w-100 gap-2">
                                <button type="submit" class="btn btn-primary flex-grow-1">
                                    <i class="bi bi-funnel me-1" aria-hidden="true"></i>Appliquer les filtres
                                </button>
                                <button type="button" class="btn btn-outline-secondary" id="creneaux-filter-reset">
                                    <i class="bi bi-arrow-counterclockwise me-1" aria-hidden="true"></i>R&eacute;initialiser
                                </button>
                            </div>
		                </div>
		            </form>
		            <div id="creneaux-filter-count" class="text-muted small mt-2 filter-results-count" role="status" aria-live="polite"></div>
		        </div>
		    </div>
		
		    <div class="row g-4">
	        <div class="col-lg-4">
	            <div class="card card-elevated">
                <div class="card-body">
                    <h5 class="card-title mb-3">Nouveau rendez-vous</h5>
                    <p class="text-muted small">Choisissez un créneau disponible avec l'un de nos médecins.</p>
                    <a href="${pageContext.request.contextPath}/patient?action=listerCreneaux" class="btn btn-primary w-100 mb-2">
                        <i class="bi bi-calendar-plus me-1" aria-hidden="true"></i>Parcourir les créneaux
                    </a>
                    <a href="${pageContext.request.contextPath}/patient?action=historique" class="btn btn-outline-secondary w-100">
                        <i class="bi bi-clock-history me-1" aria-hidden="true"></i>Voir mon historique
                    </a>
                </div>
            </div>
        </div>

	        <div class="col-lg-8">
	            <div class="card card-elevated">
                <div class="card-body">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="card-title mb-0">Créneaux disponibles à venir</h5>
                        <span class="badge bg-primary badge-pill"><% List<Creneau> liste = (List<Creneau>) request.getAttribute("creneauxDisponibles"); int count = (liste != null) ? liste.size() : 0; %><%= count %> créneau(x)</span>
                    </div>
		                    <div class="table-responsive">
			                        <table class="table align-middle table-modern" id="creneaux-table">
                            <thead>
                            <tr>
                                <th>Date</th>
                                <th>Heure</th>
                                <th>Durée</th>
                                <th></th>
                            </tr>
                            </thead>
                            <tbody>
                            <% if (liste != null && !liste.isEmpty()) {
                                   for (Creneau c : liste) { %>
                                <tr>
                                    <td><%= c.getDateCreneau() %></td>
                                    <td><%= c.getHeureCreneau() %></td>
                                    <td><%= c.getDureeMinutes() %> min</td>
                                    <td>
                                        <form method="post" action="${pageContext.request.contextPath}/patient" class="d-inline">
                                            <input type="hidden" name="action" value="reserver">
                                            <input type="hidden" name="idCreneau" value="<%= c.getId() %>">
                                            <button type="submit" class="btn btn-sm btn-primary">
                                                <i class="bi bi-calendar-check me-1" aria-hidden="true"></i>Réserver
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            <%   }
                               } else { %>
                                <tr>
                                    <td colspan="4">
                                        <div class="app-empty-state">
                                            <div class="app-empty-state-icon">
                                                <i class="bi bi-calendar-x" aria-hidden="true"></i>
                                            </div>
                                            <p class="mb-0">Aucun créneau disponible pour le moment. Revenez plus tard ou contactez le cabinet.</p>
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
	
	<script>
	(function() {
	    var form = document.getElementById('creneaux-filter-form');
	    if (!form) return;
	    var dateInput = document.getElementById('filter-creneaux-date');
	    var textInput = document.getElementById('filter-creneaux-text');
	    var resetBtn = document.getElementById('creneaux-filter-reset');
	    var table = document.getElementById('creneaux-table');
	    if (!table) return;
	    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr'));
	    var countEl = document.getElementById('creneaux-filter-count');

	    function applyFilter() {
	        if (table) {
	            table.classList.add('table-filtering');
	        }
	        var dateVal = dateInput.value;
	        var textVal = textInput.value.trim().toLowerCase();
	        var visibleCount = 0;

	        rows.forEach(function(row) {
	            var visible = true;
	            var cells = row.getElementsByTagName('td');
	            if (cells.length === 0) {
	                return;
	            }
	            var rowDate = (cells[0].textContent || '').trim();
	            if (dateVal) {
	                visible = visible && rowDate.indexOf(dateVal) === 0;
	            }
	            if (textVal) {
	                var rowText = (row.textContent || '').toLowerCase();
	                visible = visible && rowText.indexOf(textVal) !== -1;
	            }
	            row.style.display = visible ? '' : 'none';
	            if (visible) {
	                visibleCount++;
	            }
	        });

	        if (countEl) {
	            var label = visibleCount === 1 ? ' r\u00e9sultat trouv\u00e9' : ' r\u00e9sultats trouv\u00e9s';
	            countEl.textContent = visibleCount + label;
	        }

	        if (table) {
	            setTimeout(function() {
	                table.classList.remove('table-filtering');
	            }, 150);
	        }
	    }

	    form.addEventListener('submit', function (e) {
	        e.preventDefault();
	        applyFilter();
	    });

	    dateInput.addEventListener('change', applyFilter);
	    textInput.addEventListener('input', applyFilter);
	    resetBtn.addEventListener('click', function () {
	        dateInput.value = '';
	        textInput.value = '';
	        applyFilter();
	    });

	    applyFilter();
	})();
	</script>
	
	</body>
	</html>
