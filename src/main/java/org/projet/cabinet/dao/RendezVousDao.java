package org.projet.cabinet.dao; 
import java.sql.*; 
import java.time.*; 
import java.util.ArrayList; 
import java.util.List; 
import javax.servlet.ServletContext; 
import org.projet.cabinet.model.*;

public class RendezVousDao extends DaoBase {
    public RendezVousDao(ServletContext contexte) { 
        super(contexte); 
    }

    private RendezVous mapperRendezVous(ResultSet rs) throws SQLException { 
        Utilisateur u = new Utilisateur(); 
        u.setId(rs.getInt("utilisateur_id")); 
        u.setNom(rs.getString("nom")); 
        u.setPrenom(rs.getString("prenom")); 
        u.setEmail(rs.getString("email")); 
        u.setMotDePasse(rs.getString("mot_de_passe")); 
        String roleTexte = rs.getString("role"); 
        if (roleTexte != null) { 
            u.setRole(RoleUtilisateur.valueOf(roleTexte)); 
        }
        Patient p = new Patient(); 
        p.setId(rs.getInt("patient_id")); 
        p.setUtilisateur(u); 
        Date dateNaissanceSql = rs.getDate("date_naissance"); 
        if (dateNaissanceSql != null) { 
            p.setDateNaissance(dateNaissanceSql.toLocalDate()); 
        }
        p.setTelephone(rs.getString("telephone")); 
        RendezVous r = new RendezVous(); 
        r.setId(rs.getInt("id")); 
        r.setPatient(p); 
        Date dateRdvSql = rs.getDate("date_rdv"); 
        if (dateRdvSql != null) { 
            r.setDateRdv(dateRdvSql.toLocalDate()); 
        }
        Time heureRdvSql = rs.getTime("heure_rdv"); 
        if (heureRdvSql != null) { 
            r.setHeureRdv(heureRdvSql.toLocalTime()); 
        }
        String statutTexte = rs.getString("statut"); 
        if (statutTexte != null) { 
            r.setStatut(StatutRendezVous.valueOf(statutTexte)); 
        }
        return r; 
    }

    public RendezVous creer(RendezVous rendezVous) { 
        String sql = "INSERT INTO rendezvous (patient_id, date_rdv, heure_rdv, statut) VALUES (?,?,?,?)"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { 
            ps.setInt(1, rendezVous.getPatient().getId()); 
            ps.setDate(2, rendezVous.getDateRdv() != null ? Date.valueOf(rendezVous.getDateRdv()) : null); 
            ps.setTime(3, rendezVous.getHeureRdv() != null ? Time.valueOf(rendezVous.getHeureRdv()) : null); 
            ps.setString(4, rendezVous.getStatut() != null ? rendezVous.getStatut().name() : StatutRendezVous.EN_ATTENTE.name()); 
            ps.executeUpdate(); 
            try (ResultSet rs = ps.getGeneratedKeys()) { 
                if (rs.next()) { 
                    rendezVous.setId(rs.getInt(1)); 
                }
            }
            return rendezVous; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la création du rendez-vous", e); 
        }
    }

    public RendezVous creerAvecReservationCreneau(RendezVous rendezVous, int idCreneau) {
        String sqlRdv = "INSERT INTO rendezvous (patient_id, date_rdv, heure_rdv, statut) VALUES (?,?,?,?)";
        String sqlCreneau = "UPDATE creneaux SET disponible = 0 WHERE id = ? AND disponible = 1";
        Connection connexion = null;
        try {
            connexion = obtenirConnexion();
            connexion.setAutoCommit(false);

            try (PreparedStatement ps = connexion.prepareStatement(sqlRdv, Statement.RETURN_GENERATED_KEYS)) {
                ps.setInt(1, rendezVous.getPatient().getId());
                ps.setDate(2, rendezVous.getDateRdv() != null ? Date.valueOf(rendezVous.getDateRdv()) : null);
                ps.setTime(3, rendezVous.getHeureRdv() != null ? Time.valueOf(rendezVous.getHeureRdv()) : null);
                ps.setString(4, rendezVous.getStatut() != null ? rendezVous.getStatut().name() : StatutRendezVous.EN_ATTENTE.name());
                ps.executeUpdate();
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        rendezVous.setId(rs.getInt(1));
                    }
                }
            }

            try (PreparedStatement ps = connexion.prepareStatement(sqlCreneau)) {
                ps.setInt(1, idCreneau);
                int nbMaj = ps.executeUpdate();
                if (nbMaj <= 0) {
                    throw new IllegalArgumentException("Créneau indisponible");
                }
            }

            connexion.commit();
            return rendezVous;
        } catch (SQLException e) {
            if (connexion != null) {
                try {
                    connexion.rollback();
                } catch (SQLException ignore) { }
            }
            throw new RuntimeException("Erreur lors de la réservation du rendez-vous", e);
        } finally {
            if (connexion != null) {
                try {
                    connexion.setAutoCommit(true);
                } catch (SQLException ignore) { }
                try {
                    connexion.close();
                } catch (SQLException ignore) { }
            }
        }
    }

    public RendezVous trouverParId(int id) { 
        String sql = "SELECT r.id, r.patient_id, r.date_rdv, r.heure_rdv, r.statut, p.date_naissance, p.telephone, u.id AS utilisateur_id, u.nom, u.prenom, u.email, u.mot_de_passe, u.role FROM rendezvous r JOIN patients p ON r.patient_id = p.id JOIN utilisateurs u ON p.utilisateur_id = u.id WHERE r.id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, id); 
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next()) { 
                    return mapperRendezVous(rs); 
                }
                return null; 
            }
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la recherche du rendez-vous par id", e); 
        }
    }

    public List<RendezVous> trouverParPatientId(int patientId) { 
        String sql = "SELECT r.id, r.patient_id, r.date_rdv, r.heure_rdv, r.statut, p.date_naissance, p.telephone, u.id AS utilisateur_id, u.nom, u.prenom, u.email, u.mot_de_passe, u.role FROM rendezvous r JOIN patients p ON r.patient_id = p.id JOIN utilisateurs u ON p.utilisateur_id = u.id WHERE r.patient_id = ? ORDER BY r.date_rdv DESC, r.heure_rdv DESC"; 
        List<RendezVous> rendezVous = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, patientId); 
            try (ResultSet rs = ps.executeQuery()) { 
                while (rs.next()) { 
                    rendezVous.add(mapperRendezVous(rs)); 
                }
            }
            return rendezVous; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors du chargement des rendez-vous du patient", e); 
        }
    }

    public List<RendezVous> trouverTous() { 
        String sql = "SELECT r.id, r.patient_id, r.date_rdv, r.heure_rdv, r.statut, p.date_naissance, p.telephone, u.id AS utilisateur_id, u.nom, u.prenom, u.email, u.mot_de_passe, u.role FROM rendezvous r JOIN patients p ON r.patient_id = p.id JOIN utilisateurs u ON p.utilisateur_id = u.id ORDER BY r.date_rdv DESC, r.heure_rdv DESC"; 
        List<RendezVous> rendezVous = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) { 
            while (rs.next()) { 
                rendezVous.add(mapperRendezVous(rs)); 
            }
            return rendezVous; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors du chargement de tous les rendez-vous", e); 
        }
    }

    public List<RendezVous> trouverConfirmes() { 
        String sql = "SELECT r.id, r.patient_id, r.date_rdv, r.heure_rdv, r.statut, p.date_naissance, p.telephone, u.id AS utilisateur_id, u.nom, u.prenom, u.email, u.mot_de_passe, u.role FROM rendezvous r JOIN patients p ON r.patient_id = p.id JOIN utilisateurs u ON p.utilisateur_id = u.id WHERE r.statut = 'CONFIRME' ORDER BY r.date_rdv, r.heure_rdv"; 
        List<RendezVous> rendezVous = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) { 
            while (rs.next()) { 
                rendezVous.add(mapperRendezVous(rs)); 
            }
            return rendezVous; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors du chargement des rendez-vous confirmés", e); 
        }
    }

    public List<RendezVous> trouverParStatut(StatutRendezVous statut) { 
        String sql = "SELECT r.id, r.patient_id, r.date_rdv, r.heure_rdv, r.statut, p.date_naissance, p.telephone, u.id AS utilisateur_id, u.nom, u.prenom, u.email, u.mot_de_passe, u.role FROM rendezvous r JOIN patients p ON r.patient_id = p.id JOIN utilisateurs u ON p.utilisateur_id = u.id WHERE r.statut = ? ORDER BY r.date_rdv DESC, r.heure_rdv DESC"; 
        List<RendezVous> rendezVous = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setString(1, statut.name()); 
            try (ResultSet rs = ps.executeQuery()) { 
                while (rs.next()) { 
                    rendezVous.add(mapperRendezVous(rs)); 
                }
            }
            return rendezVous; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la recherche des rendez-vous par statut", e); 
        }
    }

    public void mettreAJourStatut(int id, StatutRendezVous statut) { 
        String sql = "UPDATE rendezvous SET statut = ? WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setString(1, statut.name()); 
            ps.setInt(2, id); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la mise à jour du statut du rendez-vous", e); 
        }
    }

    public void confirmer(int id) { 
        mettreAJourStatut(id, StatutRendezVous.CONFIRME); 
    }

    public void annuler(int id) { 
        mettreAJourStatut(id, StatutRendezVous.ANNULE); 
    }

    public void marquerRealise(int id) { 
        mettreAJourStatut(id, StatutRendezVous.REALISE); 
    }

    public void modifier(RendezVous rendezVous) { 
        String sql = "UPDATE rendezvous SET patient_id = ?, date_rdv = ?, heure_rdv = ?, statut = ? WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, rendezVous.getPatient().getId()); 
            ps.setDate(2, rendezVous.getDateRdv() != null ? Date.valueOf(rendezVous.getDateRdv()) : null); 
            ps.setTime(3, rendezVous.getHeureRdv() != null ? Time.valueOf(rendezVous.getHeureRdv()) : null); 
            ps.setString(4, rendezVous.getStatut() != null ? rendezVous.getStatut().name() : StatutRendezVous.EN_ATTENTE.name()); 
            ps.setInt(5, rendezVous.getId()); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la modification du rendez-vous", e); 
        }
    }

    public void supprimer(int id) { 
        String sql = "DELETE FROM rendezvous WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, id); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la suppression du rendez-vous", e); 
        }
    }
}