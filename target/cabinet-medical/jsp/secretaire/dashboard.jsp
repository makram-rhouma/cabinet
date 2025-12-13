<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Visite,org.projet.cabinet.model.RendezVous" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Tableau de bord secrétaire</title>
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
                        <div class="stats-label mb-1">Patients arriv&eacute;s aujourd'hui</div>
                        <div class="stats-value">${nbPatientsArrivesAujourdHui}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-person-walking" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Patients d&eacute;j&agrave; enregistr&eacute;s &agrave; l'accueil aujourd'hui.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Rendez-vous aujourd'hui</div>
                        <div class="stats-value">${nbRendezVousAujourdHui}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-calendar-event" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Rendez-vous pr&eacute;vus &agrave; g&eacute;rer aujourd'hui.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Visites &agrave; enregistrer</div>
                        <div class="stats-value">${nbVisitesAEnregistrer}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-clipboard-plus" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Patients &agrave; enregistrer dans le syst&egrave;me.</p>
            </div>
        </div>

	        <div class="card card-elevated stats-card">
            <div class="card-body">
                <div class="d-flex align-items-center justify-content-between mb-2">
                    <div>
                        <div class="stats-label mb-1">Patients actifs</div>
                        <div class="stats-value">${nbPatientsActifs}</div>
                    </div>
	                    <div class="stats-icon-circle">
	                        <i class="bi bi-person-heart" aria-hidden="true"></i>
	                    </div>
                </div>
                <p class="text-muted small mb-0">Patients suivis r&eacute;guli&egrave;rement par le cabinet.</p>
            </div>
        </div>
	    </div>

	    <div class="mb-3">
	        <a href="${pageContext.request.contextPath}/secretaire?action=patientsArrives" class="btn btn-primary me-2">
	            <i class="bi bi-person-walking me-1" aria-hidden="true"></i>Patients arrivés
	        </a>
	        <a href="${pageContext.request.contextPath}/secretaire?action=rechercherPatient" class="btn btn-secondary">
	            <i class="bi bi-search me-1" aria-hidden="true"></i>Rechercher un patient
	        </a>
	    </div>

		<div class="card card-elevated mb-4">
		    <div class="card-body">
		        <h5 class="card-title mb-3">Rendez-vous &agrave; confirmer</h5>
		        <div class="table-responsive">
		            <table class="table table-sm align-middle table-modern">
		                <thead>
		                <tr>
		                    <th>Date</th>
		                    <th>Heure</th>
		                    <th>Patient</th>
		                    <th class="text-end">Actions</th>
		                </tr>
		                </thead>
		                <tbody>
		                <%
		                    List<RendezVous> rdvEnAttente = (List<RendezVous>) request.getAttribute("rendezVousEnAttente");
		                    if (rdvEnAttente != null && !rdvEnAttente.isEmpty()) {
		                        for (RendezVous r : rdvEnAttente) {
		                %>
		                <tr>
		                    <td><%= r.getDateRdv() %></td>
		                    <td><%= r.getHeureRdv() %></td>
		                    <td><%= r.getPatient().getUtilisateur().getNom() %> <%= r.getPatient().getUtilisateur().getPrenom() %></td>
		                    <td class="text-end">
		                        <form method="post" action="${pageContext.request.contextPath}/secretaire" class="d-inline">
		                            <input type="hidden" name="action" value="confirmerRdv">
		                            <input type="hidden" name="idRendezVous" value="<%= r.getId() %>">
		                            <button type="submit" class="btn btn-sm btn-success">
		                                <i class="bi bi-check-circle me-1" aria-hidden="true"></i>Confirmer
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
		                                <i class="bi bi-calendar-check" aria-hidden="true"></i>
		                            </div>
		                            <p class="mb-0">Aucun rendez-vous en attente de confirmation.</p>
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

	    <div class="card card-elevated filter-card mb-4">
	        <div class="card-body">
	            <h5 class="card-title mb-3">Filtrer les visites récentes</h5>
	            <form class="row g-3" id="secretaire-visites-filter-form">
	                <div class="col-md-4">
	                    <label for="filter-visites-patient" class="form-label">Patient</label>
	                    <input type="text" class="form-control" id="filter-visites-patient" placeholder="Rechercher par nom de patient">
	                </div>
	                <div class="col-md-3">
	                    <label for="filter-visites-date" class="form-label">Date</label>
	                    <input type="date" class="form-control" id="filter-visites-date">
	                </div>
	                <div class="col-md-3">
	                    <label for="filter-visites-motif" class="form-label">Motif</label>
	                    <input type="text" class="form-control" id="filter-visites-motif" placeholder="Rechercher par motif">
	                </div>
	                <div class="col-md-2 d-flex align-items-end">
	                    <div class="d-flex w-100 gap-2">
	                        <button type="submit" class="btn btn-primary flex-grow-1">
	                            <i class="bi bi-funnel me-1" aria-hidden="true"></i>Appliquer
	                        </button>
	                        <button type="button" class="btn btn-outline-secondary" id="secretaire-visites-filter-reset">
	                            <i class="bi bi-arrow-counterclockwise me-1" aria-hidden="true"></i>Réinitialiser
	                        </button>
	                    </div>
	                </div>
	            </form>
	            <div id="secretaire-visites-filter-count" class="text-muted small mt-2 filter-results-count" role="status" aria-live="polite"></div>
	        </div>
	    </div>

		    <div class="card card-elevated">
        <div class="card-body">
            <h5 class="card-title">Visites récentes</h5>
		                <div class="table-responsive">
		                	<table class="table table-striped align-middle table-modern" id="visites-recentes-table">
                    <thead>
                    <tr>
                        <th>Date</th>
                        <th>Patient</th>
                        <th>Motif</th>
                    </tr>
                    </thead>
                    <tbody>
                    <% List<Visite> visitesRecentes = (List<Visite>) request.getAttribute("visitesRecentes");
                       if (visitesRecentes != null && !visitesRecentes.isEmpty()) {
                           for (Visite v : visitesRecentes) { %>
                        <tr>
                            <td><%= v.getDateVisite() %></td>
                            <td><%= v.getPatient().getUtilisateur().getNom() %> <%= v.getPatient().getUtilisateur().getPrenom() %></td>
                            <td><%= v.getMotif() %></td>
                        </tr>
                    <%   }
	                       } else { %>
	                        <tr>
	                            <td colspan="3">
	                                <div class="app-empty-state">
	                                    <div class="app-empty-state-icon">
	                                        <i class="bi bi-clipboard-x" aria-hidden="true"></i>
	                                    </div>
	                                    <p class="mb-0">Aucune visite récente.</p>
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
	    var form = document.getElementById('secretaire-visites-filter-form');
	    if (!form) return;
	    var patientInput = document.getElementById('filter-visites-patient');
	    var dateInput = document.getElementById('filter-visites-date');
	    var motifInput = document.getElementById('filter-visites-motif');
	    var resetBtn = document.getElementById('secretaire-visites-filter-reset');
	    var table = document.getElementById('visites-recentes-table');
	    if (!table) return;
	    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr'));
	    var countEl = document.getElementById('secretaire-visites-filter-count');

	    function extractDate(text) {
	        var trimmed = (text || '').trim();
	        if (trimmed.length >= 10) {
	            return trimmed.substring(0, 10);
	        }
	        return trimmed;
	    }

	    function applyFilter() {
	        if (table) {
	            table.classList.add('table-filtering');
	        }
	        var patientVal = patientInput.value.trim().toLowerCase();
	        var dateVal = dateInput.value;
	        var motifVal = motifInput.value.trim().toLowerCase();
	        var visibleCount = 0;

	        rows.forEach(function(row) {
	            var visible = true;
	            var cells = row.getElementsByTagName('td');
	            if (cells.length < 3) {
	                return;
	            }
	            var dateText = extractDate(cells[0].textContent || '');
	            var patientText = (cells[1].textContent || '').toLowerCase();
	            var motifText = (cells[2].textContent || '').toLowerCase();

	            if (dateVal && dateText !== dateVal) {
	                visible = false;
	            }
	            if (patientVal && patientText.indexOf(patientVal) === -1) {
	                visible = false;
	            }
	            if (motifVal && motifText.indexOf(motifVal) === -1) {
	                visible = false;
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

	    patientInput.addEventListener('input', applyFilter);
	    dateInput.addEventListener('change', applyFilter);
	    motifInput.addEventListener('input', applyFilter);
	    resetBtn.addEventListener('click', function () {
	        patientInput.value = '';
	        dateInput.value = '';
	        motifInput.value = '';
	        applyFilter();
	    });

	    applyFilter();
	})();
	</script>

	</body>
	</html>
