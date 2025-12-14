<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,java.time.*,org.projet.cabinet.model.*" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Mon historique m&eacute;dical</title>
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
				<a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">
					<i class="bi bi-box-arrow-right me-1" aria-hidden="true"></i>D&eacute;connexion
				</a>
			</div>
		</div>
</nav>

<div class="container my-4 app-main">
		<div class="d-flex justify-content-between align-items-center mb-3">
			<h3 class="mb-0">Mon historique</h3>
			<a href="${pageContext.request.contextPath}/patient" class="btn btn-outline-secondary btn-sm">
				<i class="bi bi-chevron-left me-1" aria-hidden="true"></i>Retour espace patient
			</a>
		</div>

	<div class="card card-elevated filter-card mb-4">
		<div class="card-body">
			<h5 class="card-title mb-3">Filtrer mes visites pass&eacute;es</h5>
			<form class="row g-3" id="visites-filter-form">
				<div class="col-md-3">
					<label for="filter-visites-from" class="form-label">Date de d&eacute;but</label>
					<input type="date" class="form-control" id="filter-visites-from">
				</div>
				<div class="col-md-3">
					<label for="filter-visites-to" class="form-label">Date de fin</label>
					<input type="date" class="form-control" id="filter-visites-to">
				</div>
				<div class="col-md-4">
					<label for="filter-visites-doctor" class="form-label">M&eacute;decin</label>
					<input type="text" class="form-control" id="filter-visites-doctor" placeholder="Rechercher par m&eacute;decin ou motif">
				</div>
					<div class="col-md-2 d-flex align-items-end">
						<div class="d-flex w-100 gap-2">
							<button type="submit" class="btn btn-primary flex-grow-1">
								<i class="bi bi-funnel me-1" aria-hidden="true"></i>Appliquer
							</button>
							<button type="button" class="btn btn-outline-secondary" id="visites-filter-reset">
								<i class="bi bi-arrow-counterclockwise me-1" aria-hidden="true"></i>R&eacute;initialiser
							</button>
						</div>
					</div>
			</form>
			<div id="visites-filter-count" class="text-muted small mt-2 filter-results-count" role="status" aria-live="polite"></div>
		</div>
	</div>

	<%
		List<RendezVous> rdvs = (List<RendezVous>) request.getAttribute("rendezVous");
		List<Visite> visites = (List<Visite>) request.getAttribute("visites");
		Set<Integer> idsRdvArrives = new HashSet<Integer>();
		if (visites != null) {
			for (Visite v : visites) {
				RendezVous vr = (v != null) ? v.getRendezVous() : null;
				if (vr != null && vr.getId() > 0) {
					idsRdvArrives.add(vr.getId());
				}
			}
		}
	%>

	<div class="row g-4 mt-1">
		<div class="col-12">
			<div class="card card-elevated">
				<div class="card-body">
					<h5 class="card-title">Bilans</h5>
					<div class="table-responsive">
						<table class="table table-sm align-middle table-modern">
							<thead>
							<tr>
								<th>Date</th>
								<th>M&eacute;decin</th>
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
								<td><%= (b.getDateBilan() != null) ? b.getDateBilan() : "-" %></td>
								<td><%= (b.getMedecin() != null) ? (b.getMedecin().getNom() + " " + b.getMedecin().getPrenom()) : "-" %></td>
								<td><%= (b.getMotif() != null) ? b.getMotif() : "-" %></td>
								<td><%= (b.getDiagnostic() != null) ? b.getDiagnostic() : "-" %></td>
							</tr>
							<%
									}
								} else {
							%>
							<tr>
								<td colspan="4">
									<div class="app-empty-state">
										<div class="app-empty-state-icon">
											<i class="bi bi-file-earmark-medical" aria-hidden="true"></i>
										</div>
										<p class="mb-0">Aucun bilan pour le moment.</p>
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

	<div class="row g-4 mt-1">
		<div class="col-12">
			<div class="card card-elevated">
				<div class="card-body">
					<h5 class="card-title">Actions</h5>
					<p class="text-muted small mb-3">Signalez votre arriv&eacute;e uniquement lorsque vous &ecirc;tes pr&eacute;sent au cabinet (rendez-vous confirm&eacute;).</p>
					<div class="table-responsive">
						<table class="table table-sm align-middle table-modern">
							<thead>
							<tr>
								<th>Date</th>
								<th>Heure</th>
								<th class="text-end">Action</th>
							</tr>
							</thead>
							<tbody>
							<%
								LocalDate aujourdHui = LocalDate.now();
								boolean auMoinsUneAction = false;
								if (rdvs != null) {
									for (RendezVous r : rdvs) {
										String statutRdv = (r.getStatut() != null) ? r.getStatut().name() : null;
										boolean estConfirme = "CONFIRME".equals(statutRdv);
										boolean estAujourdHui = (r.getDateRdv() != null) && r.getDateRdv().isEqual(aujourdHui);
										boolean dejaArrive = (r.getId() > 0) && idsRdvArrives.contains(r.getId());
										if (estConfirme && estAujourdHui && !dejaArrive) {
											auMoinsUneAction = true;
							%>
							<tr>
								<td><%= r.getDateRdv() %></td>
								<td><%= r.getHeureRdv() %></td>
								<td class="text-end">
									<form method="post" action="${pageContext.request.contextPath}/patient" class="d-inline">
										<input type="hidden" name="action" value="signalerArrivee">
										<input type="hidden" name="idRendezVous" value="<%= r.getId() %>">
										<button type="submit" class="btn btn-sm btn-success">
											<i class="bi bi-person-walking me-1" aria-hidden="true"></i>Je suis arriv&eacute;
										</button>
									</form>
								</td>
							</tr>
							<%
									}
								}
								}
								if (!auMoinsUneAction) {
							%>
							<tr>
								<td colspan="3">
									<div class="app-empty-state">
										<div class="app-empty-state-icon">
											<i class="bi bi-person-check" aria-hidden="true"></i>
										</div>
										<p class="mb-0">Aucune action disponible pour aujourd'hui.</p>
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

	<div class="row g-4">
		<div class="col-lg-6">
			<div class="card card-elevated">
				<div class="card-body">
					<h5 class="card-title">Rendez-vous</h5>
					<div class="table-responsive">
						<table class="table table-sm align-middle table-modern">
							<thead>
							<tr>
								<th>Date</th>
								<th>Heure</th>
								<th>Statut</th>
								<th>Arriv&eacute;e</th>
							</tr>
							</thead>
							<tbody>
							<% 
							   if (rdvs != null && !rdvs.isEmpty()) {
							       for (RendezVous r : rdvs) { %>
					<tr>
						<td><%= r.getDateRdv() %></td>
						<td><%= r.getHeureRdv() %></td>
					<td>
						<%
							String statut = (r.getStatut() != null) ? r.getStatut().name() : null;
							if (statut != null) {
								if ("CONFIRME".equals(statut)) {
							%>
							<span class="badge bg-info text-dark">
								<i class="bi bi-calendar-check me-1" aria-hidden="true"></i>Confirm&eacute;
							</span>
							<%
								} else if ("EN_ATTENTE".equals(statut)) {
							%>
							<span class="badge bg-warning text-dark">
								<i class="bi bi-hourglass-split me-1" aria-hidden="true"></i>En attente
							</span>
							<%
								} else if ("ANNULE".equals(statut)) {
							%>
							<span class="badge bg-danger">
								<i class="bi bi-x-circle me-1" aria-hidden="true"></i>Annul&eacute;
							</span>
							<%
								} else if ("REALISE".equals(statut)) {
							%>
							<span class="badge bg-success">
								<i class="bi bi-check-circle me-1" aria-hidden="true"></i>R&eacute;alis&eacute;
							</span>
							<%
								} else {
							%>
							<span class="badge bg-secondary"><%= r.getStatut() %></span>
							<%
								}
							}
						%>
					</td>
					<td>
						<%
							if (r != null && r.getId() > 0 && idsRdvArrives.contains(r.getId())) {
						%>
						<span class="badge bg-success">
							<i class="bi bi-person-check me-1" aria-hidden="true"></i>Arriv&eacute;e signal&eacute;e
						</span>
						<%
							} else {
						%>
						<span class="text-muted small">-</span>
						<%
							}
						%>
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
								<p class="mb-0">Aucun rendez-vous pour le moment.</p>
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

		<div class="col-lg-6">
			<div class="card card-elevated">
				<div class="card-body">
					<h5 class="card-title">Visites</h5>
					<div class="table-responsive">
						<table class="table table-sm align-middle table-modern" id="visites-table">
							<thead>
							<tr>
								<th>Date de visite</th>
								<th>Motif</th>
							</tr>
							</thead>
							<tbody>
							<% if (visites != null && !visites.isEmpty()) {
							       for (Visite v : visites) { %>
								<tr>
									<td><%= v.getDateVisite() %></td>
									<td><%= v.getMotif() %></td>
								</tr>
							<%   }
				   } else { %>
					<tr>
						<td colspan="2">
							<div class="app-empty-state">
								<div class="app-empty-state-icon">
									<i class="bi bi-clipboard-x" aria-hidden="true"></i>
								</div>
								<p class="mb-0">Aucune visite enregistr&eacute;e pour le moment.</p>
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

	<script>
	(function() {
	    var form = document.getElementById('visites-filter-form');
	    if (!form) return;
	    var fromInput = document.getElementById('filter-visites-from');
	    var toInput = document.getElementById('filter-visites-to');
	    var doctorInput = document.getElementById('filter-visites-doctor');
	    var resetBtn = document.getElementById('visites-filter-reset');
	    var table = document.getElementById('visites-table');
	    if (!table) return;
	    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr'));
	    var countEl = document.getElementById('visites-filter-count');

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
	        var fromVal = fromInput.value;
	        var toVal = toInput.value;
	        var doctorVal = doctorInput.value.trim().toLowerCase();
	        var visibleCount = 0;

	        rows.forEach(function(row) {
	            var visible = true;
	            var cells = row.getElementsByTagName('td');
	            if (cells.length === 0) {
	                return;
	            }
	            var dateText = extractDate(cells[0].textContent || '');
	            if (fromVal && dateText < fromVal) {
	                visible = false;
	            }
	            if (toVal && dateText > toVal) {
	                visible = false;
	            }
	            if (doctorVal) {
	                var rowText = (row.textContent || '').toLowerCase();
	                if (rowText.indexOf(doctorVal) === -1) {
	                    visible = false;
	                }
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

	    fromInput.addEventListener('change', applyFilter);
	    toInput.addEventListener('change', applyFilter);
	    doctorInput.addEventListener('input', applyFilter);
	    resetBtn.addEventListener('click', function () {
	        fromInput.value = '';
	        toInput.value = '';
	        doctorInput.value = '';
	        applyFilter();
	    });

	    applyFilter();
	})();
	</script>

	</body>
	</html>
