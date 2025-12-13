<%@ page contentType="text/html; charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html>
<head>
		<meta charset="UTF-8">
		<title>Inscription patient - Cabinet m&eacute;dical</title>
		<link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet">
		<link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.11.3/font/bootstrap-icons.min.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/css/common.css" rel="stylesheet">
		<link href="${pageContext.request.contextPath}/css/login.css" rel="stylesheet">
</head>
<body class="login-page">
<div class="login-shell w-100">
	<section class="login-hero" aria-hidden="true">
		<div class="login-hero-content">
			<div class="app-navbar-brand mb-3">CABINET M&Eacute;DICAL</div>
			<h1 class="login-hero-title mb-3">Cr&eacute;ez votre compte patient en quelques clics</h1>
			<p class="login-hero-subtitle mb-4">
				Prenez rendez-vous avec votre m&eacute;decin au cabinet ou en vid&eacute;o et suivez vos bilans dans un espace s&eacute;curis&eacute;.
			</p>
			<div class="d-flex flex-wrap gap-2">
				<span class="app-chip">Rendez-vous rapides</span>
				<span class="app-chip">Notifications de suivi</span>
				<span class="app-chip">Dossier patient centralis&eacute;</span>
			</div>
		</div>
	</section>

	<section class="login-card-wrapper" aria-label="Formulaire d'inscription patient">
		<div class="card login-card bg-white">
			<div class="login-card-header border-0">
				<h2 class="fw-semibold mb-1">Inscription patient</h2>
				<p class="text-muted-soft mb-0">Cr&eacute;ez votre compte pour g&eacute;rer vos rendez-vous et votre suivi m&eacute;dical.</p>
			</div>
			<div class="login-card-body">
				<% String erreur = (String) request.getAttribute("erreur");
				   if (erreur != null) { %>
					<div class="alert alert-danger"><%= erreur %></div>
				<% } %>

				<form method="post" action="${pageContext.request.contextPath}/inscription" novalidate>
					<div class="row">
						<div class="col-md-6 mb-3">
							<label class="form-label">Nom</label>
							<input type="text" name="nom" class="form-control login-input" required>
						</div>
						<div class="col-md-6 mb-3">
							<label class="form-label">Pr&eacute;nom</label>
							<input type="text" name="prenom" class="form-control login-input" required>
						</div>
					</div>

					<div class="mb-3">
						<label class="form-label">Email</label>
						<input type="email" name="email" class="form-control login-input" required>
					</div>

					<div class="mb-3">
						<label class="form-label">Mot de passe</label>
						<input type="password" name="motDePasse" class="form-control login-input" required>
					</div>

					<div class="row">
						<div class="col-md-6 mb-3">
							<label class="form-label">Date de naissance</label>
							<input type="date" name="dateNaissance" class="form-control login-input" required>
						</div>
						<div class="col-md-6 mb-3">
							<label class="form-label">T&eacute;l&eacute;phone</label>
							<input type="text" name="telephone" class="form-control login-input">
						</div>
					</div>

					<button type="submit" class="btn btn-primary w-100 py-2">
						<i class="bi bi-person-plus me-1" aria-hidden="true"></i>Cr&eacute;er le compte
					</button>
				</form>

				<div class="mt-3 text-center small login-footer-text">
					D&eacute;j&agrave; inscrit ?
					<a href="${pageContext.request.contextPath}/login" class="fw-semibold">Se connecter</a>
				</div>
			</div>
		</div>
	</section>
</div>

</body>
</html>