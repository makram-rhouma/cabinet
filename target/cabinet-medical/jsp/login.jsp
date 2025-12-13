<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Connexion - Cabinet médical</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body class="login-page">
<div class="login-shell w-100">
	<section class="login-hero" aria-hidden="true">
		<div class="login-hero-content">
			<div class="app-navbar-brand mb-3">CABINET MÉDICAL</div>
			<h1 class="login-hero-title mb-3">Prenez rendez-vous avec votre cabinet en toute sérénité</h1>
			<p class="login-hero-subtitle mb-4">
				Accédez à votre espace santé sécurisé pour gérer rendez-vous, dossiers patients
				et suivi médical, inspiré des plateformes modernes de prise de rendez-vous.
			</p>
			<div class="d-flex flex-wrap gap-2">
				<span class="app-chip">Patients</span>
				<span class="app-chip">Médecins</span>
				<span class="app-chip">Secrétaires</span>
				<span class="app-chip">Administrateurs</span>
			</div>
		</div>
	</section>

	<section class="login-card-wrapper" aria-label="Formulaire de connexion">
		<div class="card login-card bg-white">
			<div class="login-card-header border-0">
				<h2 class="fw-semibold mb-1">Bon retour</h2>
				<p class="text-muted-soft mb-0">Connectez-vous à votre espace santé sécurisé.</p>
			</div>
			<div class="login-card-body">
                    <% String erreur = (String) request.getAttribute("erreur");
                       if (erreur != null) { %>
                        <div class="alert alert-danger"><%= erreur %></div>
                    <% }
                       if ("ok".equals(request.getParameter("inscription"))) { %>
                        <div class="alert alert-success">Inscription réussie, vous pouvez vous connecter.</div>
                    <% }
                       if ("logout".equals(request.getParameter("status"))) { %>
                        <div class="alert alert-info">Vous êtes déconnecté. À bientôt.</div>
                    <% } %>

	                    <form method="post" action="${pageContext.request.contextPath}/login" novalidate>
	                        <div class="mb-3">
	                            <label class="form-label">Email</label>
	                            <input type="email" name="email" class="form-control login-input" placeholder="nom@exemple.com" required>
	                        </div>
	                        <div class="mb-3">
	                            <label class="form-label">Mot de passe</label>
	                            <input type="password" name="motDePasse" class="form-control login-input" minlength="6" required>
	                        </div>
		                        <button type="submit" class="btn btn-primary w-100 py-2">
		                            <i class="bi bi-box-arrow-in-right me-1" aria-hidden="true"></i>Se connecter
		                        </button>
	                    </form>

	                    <div class="mt-3 text-center small login-footer-text">
	                        Pas encore de compte ?
	                        <a href="${pageContext.request.contextPath}/inscription" class="fw-semibold">S'inscrire comme patient</a>
	                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

</body>
</html>
