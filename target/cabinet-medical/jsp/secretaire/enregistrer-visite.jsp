<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Espace Secr&eacute;taire - Enregistrer une visite</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/secretaire.css" rel="stylesheet">
</head>
<body class="app-body secretaire-dashboard">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/secretaire">Espace Secr&eacute;taire</a>
        <div class="d-flex">
            <a href="${pageContext.request.contextPath}/logout" class="btn btn-outline-danger btn-sm">D&eacute;connexion</a>
        </div>
    </div>
</nav>

<div class="container my-4 app-main">
    <div class="d-flex justify-content-between align-items-center mb-3">
        <h3 class="mb-0">Enregistrer une visite</h3>
        <a href="${pageContext.request.contextPath}/secretaire?action=patientsArrives" class="btn btn-outline-secondary btn-sm">Patients arriv&eacute;s</a>
    </div>

    <div class="card card-elevated">
        <div class="card-body">
            <form method="post" action="${pageContext.request.contextPath}/secretaire" class="row g-3">
                <input type="hidden" name="action" value="enregistrerVisite">

                <div class="col-md-6">
                    <label class="form-label">Identifiant patient</label>
                    <input type="number" name="idPatient" class="form-control" required>
                </div>

                <div class="col-md-6">
                    <label class="form-label">Identifiant rendez-vous (optionnel)</label>
                    <input type="number" name="idRendezVous" class="form-control">
                </div>

                <div class="col-12">
                    <label class="form-label">Motif</label>
                    <textarea name="motif" class="form-control" rows="3"></textarea>
                </div>

                <div class="col-12">
                    <button type="submit" class="btn btn-primary">Enregistrer la visite</button>
                </div>
            </form>
        </div>
    </div>
</div>

</body>
</html>
