<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<%@ page import="java.util.*,org.projet.cabinet.model.Visite" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Patients arrivés</title>
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

	<div class="container mt-4 app-main">
		    <h3>Patients arrivés aujourd'hui</h3>

		    <div class="card card-elevated filter-card mb-3">
		    	<div class="card-body">
		    		<h5 class="card-title mb-3">Filtrer les patients arrivés</h5>
		    		<form class="row g-3" id="patients-arrives-filter-form">
		    			<div class="col-md-4">
		    				<label for="filter-patients-date" class="form-label">Date d'arrivée</label>
		    				<input type="date" class="form-control" id="filter-patients-date">
		    			</div>
		    			<div class="col-md-3">
		    				<label for="filter-patients-time" class="form-label">Heure d'arrivée</label>
		    				<input type="time" class="form-control" id="filter-patients-time">
		    			</div>
		    			<div class="col-md-3">
		    				<label for="filter-patients-status" class="form-label">Statut / motif</label>
		    				<input type="text" class="form-control" id="filter-patients-status" placeholder="Rechercher par statut ou motif">
		    			</div>
		    			<div class="col-md-2 d-flex align-items-end">
		    				<div class="d-flex w-100 gap-2">
		    					<button type="submit" class="btn btn-primary flex-grow-1">Appliquer</button>
		    					<button type="button" class="btn btn-outline-secondary" id="patients-arrives-filter-reset">Réinitialiser</button>
		    				</div>
		    			</div>
		    		</form>
		    		<div id="patients-arrives-filter-count" class="text-muted small mt-2 filter-results-count" role="status" aria-live="polite"></div>
		    	</div>
		    </div>

		    <div class="card card-elevated mt-3">
		    	<div class="card-body">
		    		<div class="table-responsive">
		        	<table class="table table-hover align-middle table-modern" id="patients-arrives-table">
            <thead>
            <tr>
                <th>Heure</th>
                <th>Patient</th>
                <th>Motif</th>
            </tr>
            </thead>
            <tbody>
            <% List<Visite> patientsArrives = (List<Visite>) request.getAttribute("patientsArrives");
               if (patientsArrives != null && !patientsArrives.isEmpty()) {
                   for (Visite v : patientsArrives) { %>
                <tr>
                    <td><%= v.getDateVisite() %></td>
                    <td><%= v.getPatient().getUtilisateur().getNom() %> <%= v.getPatient().getUtilisateur().getPrenom() %></td>
                    <td><%= v.getMotif() %></td>
                </tr>
            <%   }
               } else { %>
                <tr>
                    <td colspan="3" class="text-muted">Aucun patient signalé comme arrivé pour le moment.</td>
                </tr>
	            <% } %>
	            </tbody>
	        </table>
		    	</div>
		    </div>
		</div>

		<script>
		(function() {
		    var form = document.getElementById('patients-arrives-filter-form');
		    if (!form) return;
		    var dateInput = document.getElementById('filter-patients-date');
		    var timeInput = document.getElementById('filter-patients-time');
		    var statusInput = document.getElementById('filter-patients-status');
		    var resetBtn = document.getElementById('patients-arrives-filter-reset');
		    var table = document.getElementById('patients-arrives-table');
		    if (!table) return;
		    var rows = Array.prototype.slice.call(table.querySelectorAll('tbody tr'));
		    var countEl = document.getElementById('patients-arrives-filter-count');

		    function extractDate(text) {
		        var trimmed = (text || '').trim();
		        if (trimmed.length >= 10) {
		            return trimmed.substring(0, 10);
		        }
		        return trimmed;
		    }

		    function extractTime(text) {
		        var trimmed = (text || '').trim();
		        // assume time appears after a space or 'T', e.g. '2025-01-01T09:30'
		        var parts = trimmed.split('T');
		        if (parts.length > 1) {
		            return parts[1].substring(0,5);
		        }
		        var spaceParts = trimmed.split(' ');
		        if (spaceParts.length > 1) {
		            return spaceParts[1].substring(0,5);
		        }
		        return trimmed;
		    }

		    function applyFilter() {
		        if (table) {
		            table.classList.add('table-filtering');
		        }
		        var dateVal = dateInput.value;
		        var timeVal = timeInput.value;
		        var statusVal = statusInput.value.trim().toLowerCase();
		        var visibleCount = 0;

		        rows.forEach(function(row) {
		            var visible = true;
		            var cells = row.getElementsByTagName('td');
		            if (cells.length < 3) {
		                return;
		            }
		            var dateTimeText = cells[0].textContent || '';
		            var dateText = extractDate(dateTimeText);
		            var timeText = extractTime(dateTimeText);
		            var patientAndMotifText = ((cells[1].textContent || '') + ' ' + (cells[2].textContent || '')).toLowerCase();

		            if (dateVal && dateText !== dateVal) {
		                visible = false;
		            }
		            if (timeVal && timeText.indexOf(timeVal.substring(0,5)) !== 0) {
		                visible = false;
		            }
		            if (statusVal && patientAndMotifText.indexOf(statusVal) === -1) {
		                visible = false;
		            }

		            row.style.display = visible ? '' : 'none';
		            if (visible) {
		                visibleCount++;
		            }
		        });

		        if (countEl) {
		            var label = visibleCount === 1 ? ' résultat trouvé' : ' résultats trouvés';
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
		    timeInput.addEventListener('change', applyFilter);
		    statusInput.addEventListener('input', applyFilter);
		    resetBtn.addEventListener('click', function () {
		        dateInput.value = '';
		        timeInput.value = '';
		        statusInput.value = '';
		        applyFilter();
		    });

		    applyFilter();
		})();
		</script>
		
		</body>
		</html>
