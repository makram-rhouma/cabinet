package org.projet.cabinet.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.List;

import javax.servlet.ServletContext;

import org.projet.cabinet.model.RoleUtilisateur;
import org.projet.cabinet.model.Utilisateur;

public class UtilisateurDao extends DaoBase {

    public UtilisateurDao(ServletContext contexte) {
        super(contexte);
    }

    private Utilisateur mapperUtilisateur(ResultSet rs) throws SQLException {
        Utilisateur u = new Utilisateur();
        u.setId(rs.getInt("id"));
        u.setNom(rs.getString("nom"));
        u.setPrenom(rs.getString("prenom"));
        u.setEmail(rs.getString("email"));
        u.setMotDePasse(rs.getString("mot_de_passe"));
        String roleTexte = rs.getString("role");
        if (roleTexte != null) {
            u.setRole(RoleUtilisateur.valueOf(roleTexte));
        }
        return u;
    }

    public Utilisateur creer(Utilisateur utilisateur) {
        String sql = "INSERT INTO utilisateurs (nom, prenom, email, mot_de_passe, role) VALUES (?,?,?,?,?)";
        try (Connection connexion = obtenirConnexion();
                PreparedStatement ps = connexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, utilisateur.getNom());
            ps.setString(2, utilisateur.getPrenom());
            ps.setString(3, utilisateur.getEmail());
            ps.setString(4, utilisateur.getMotDePasse());
            ps.setString(5, utilisateur.getRole() != null ? utilisateur.getRole().name() : null);
            ps.executeUpdate();
            try (ResultSet rs = ps.getGeneratedKeys()) {
                if (rs.next()) {
                    utilisateur.setId(rs.getInt(1));
                }
            }
            return utilisateur;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la création de l'utilisateur", e);
        }
    }

    public Utilisateur trouverParId(int id) {
        String sql = "SELECT id, nom, prenom, email, mot_de_passe, role FROM utilisateurs WHERE id = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapperUtilisateur(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de l'utilisateur par id", e);
        }
    }

    public Utilisateur trouverParEmail(String email) {
        String sql = "SELECT id, nom, prenom, email, mot_de_passe, role FROM utilisateurs WHERE email = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setString(1, email);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapperUtilisateur(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche de l'utilisateur par email", e);
        }
    }

    public List<Utilisateur> trouverTous() {
        String sql = "SELECT id, nom, prenom, email, mot_de_passe, role FROM utilisateurs ORDER BY nom, prenom";
        List<Utilisateur> utilisateurs = new ArrayList<>();
        try (Connection connexion = obtenirConnexion();
                PreparedStatement ps = connexion.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                utilisateurs.add(mapperUtilisateur(rs));
            }
            return utilisateurs;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement de tous les utilisateurs", e);
        }
    }

    public void modifier(Utilisateur utilisateur) {
        String sql = "UPDATE utilisateurs SET nom = ?, prenom = ?, email = ?, mot_de_passe = ?, role = ? WHERE id = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setString(1, utilisateur.getNom());
            ps.setString(2, utilisateur.getPrenom());
            ps.setString(3, utilisateur.getEmail());
            ps.setString(4, utilisateur.getMotDePasse());
            ps.setString(5, utilisateur.getRole() != null ? utilisateur.getRole().name() : null);
            ps.setInt(6, utilisateur.getId());
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la modification de l'utilisateur", e);
        }
    }

    public void supprimer(int id) {
        String sql = "DELETE FROM utilisateurs WHERE id = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setInt(1, id);
            ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression de l'utilisateur", e);
        }
    }

    public List<Utilisateur> trouverParRole(RoleUtilisateur role) {
        String sql = "SELECT id, nom, prenom, email, mot_de_passe, role FROM utilisateurs WHERE role = ? ORDER BY nom, prenom";
        List<Utilisateur> utilisateurs = new ArrayList<>();
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setString(1, role.name());
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    utilisateurs.add(mapperUtilisateur(rs));
                }
            }
            return utilisateurs;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la recherche des utilisateurs par rôle", e);
        }
    }

    public Utilisateur authentifier(String email, String motDePasse) {
        String sql = "SELECT id, nom, prenom, email, mot_de_passe, role FROM utilisateurs WHERE email = ? AND mot_de_passe = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setString(2, motDePasse);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return mapperUtilisateur(rs);
                }
                return null;
            }
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de l'authentification de l'utilisateur", e);
        }
    }

    /** Nombre total d'utilisateurs dans le système. */
    public long compterTous() {
        String sql = "SELECT COUNT(*) FROM utilisateurs";
        try (Connection connexion = obtenirConnexion();
                PreparedStatement ps = connexion.prepareStatement(sql);
                ResultSet rs = ps.executeQuery()) {
            if (rs.next()) {
                return rs.getLong(1);
            }
            return 0L;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des utilisateurs", e);
        }
    }

    /** Nombre d'utilisateurs pour un rôle donné. */
    public long compterParRole(RoleUtilisateur role) {
        String sql = "SELECT COUNT(*) FROM utilisateurs WHERE role = ?";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setString(1, role.name());
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getLong(1);
                }
            }
            return 0L;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du comptage des utilisateurs par rôle", e);
        }
    }
}