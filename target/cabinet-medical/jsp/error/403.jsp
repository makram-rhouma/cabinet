<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="fr">
<head>
    <meta charset="UTF-8">
    <title>Accès refusé - Cabinet médical</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
    <link href="${pageContext.request.contextPath}/css/dashboard.css" rel="stylesheet">
</head>
<body class="app-body">
<nav class="navbar navbar-expand-lg app-topbar app-navbar-shadow navbar-dark">
    <div class="container">
        <a class="navbar-brand" href="${pageContext.request.contextPath}/login">Cabinet médical</a>
    </div>
</nav>

<div class="container app-main d-flex align-items-center justify-content-center" style="min-height: 60vh;">
    <div class="text-center">
        <div class="mb-3">
            <span class="display-4 d-block fw-bold">403</span>
            <i class="bi bi-lock-fill fs-1 text-danger" aria-hidden="true"></i>
        </div>
        <h1 class="h4 mb-3">Accès refusé</h1>
        <p class="text-muted mb-3">
            Vous êtes authentifié mais vous n'avez pas les droits nécessaires pour accéder à cette ressource.
        </p>
        <p class="text-muted small mb-4">
            <% String cheminInterdit = (String) request.getAttribute("cheminInterdit");
               if (cheminInterdit != null) { %>
                Ressource demandée : <code><%= cheminInterdit %></code>
            <% } %>
        </p>
        <div class="d-flex flex-column flex-sm-row justify-content-center gap-2">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">
                <i class="bi bi-box-arrow-in-right me-1" aria-hidden="true"></i>Revenir à l'écran de connexion
            </a>
        </div>
    </div>
</div>

</body>
</html>
