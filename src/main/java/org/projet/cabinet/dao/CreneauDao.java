package org.projet.cabinet.dao; 
import java.sql.*; 
import java.time.*; 
import java.util.ArrayList; 
import java.util.List; 
import javax.servlet.ServletContext; 
import org.projet.cabinet.model.Creneau;

public class CreneauDao extends DaoBase {
    public CreneauDao(ServletContext contexte) { 
        super(contexte); 
    }

    private Creneau mapperCreneau(ResultSet rs) throws SQLException { 
        Creneau c = new Creneau(); 
        c.setId(rs.getInt("id")); 
        Date dateSql = rs.getDate("date_creneau"); 
        if (dateSql != null) { 
            c.setDateCreneau(dateSql.toLocalDate()); 
        } 
        Time heureSql = rs.getTime("heure_creneau"); 
        if (heureSql != null) { 
            c.setHeureCreneau(heureSql.toLocalTime()); 
        } 
        c.setDureeMinutes(rs.getInt("duree_minutes")); 
        c.setDisponible(rs.getBoolean("disponible")); 
        return c; 
    }

    public Creneau creer(Creneau creneau) { 
        String sql = "INSERT INTO creneaux (date_creneau, heure_creneau, duree_minutes, disponible) VALUES (?,?,?,?)"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) { 
            ps.setDate(1, creneau.getDateCreneau() != null ? Date.valueOf(creneau.getDateCreneau()) : null); 
            ps.setTime(2, creneau.getHeureCreneau() != null ? Time.valueOf(creneau.getHeureCreneau()) : null); 
            ps.setInt(3, creneau.getDureeMinutes()); 
            ps.setBoolean(4, creneau.isDisponible()); 
            ps.executeUpdate(); 
            try (ResultSet rs = ps.getGeneratedKeys()) { 
                if (rs.next()) { 
                    creneau.setId(rs.getInt(1)); 
                } 
            } 
            return creneau; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la création du créneau", e); 
        } 
    }

    public List<Creneau> trouverParDate(LocalDate dateCreneau) {
        String sql = "SELECT id, date_creneau, heure_creneau, duree_minutes, disponible FROM creneaux WHERE date_creneau = ? ORDER BY heure_creneau";
        List<Creneau> creneaux = new ArrayList<>();
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setDate(1, dateCreneau != null ? Date.valueOf(dateCreneau) : null);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    creneaux.add(mapperCreneau(rs));
                }
            }
            return creneaux;
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors du chargement des créneaux de la journée", e);
        }
    }

    public int supprimerDisponiblesParDate(LocalDate dateCreneau) {
        String sql = "DELETE FROM creneaux WHERE date_creneau = ? AND disponible = 1";
        try (Connection connexion = obtenirConnexion(); PreparedStatement ps = connexion.prepareStatement(sql)) {
            ps.setDate(1, dateCreneau != null ? Date.valueOf(dateCreneau) : null);
            return ps.executeUpdate();
        } catch (SQLException e) {
            throw new RuntimeException("Erreur lors de la suppression des créneaux disponibles de la journée", e);
        }
    }

    public Creneau trouverParId(int id) { 
        String sql = "SELECT id, date_creneau, heure_creneau, duree_minutes, disponible FROM creneaux WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, id); 
            try (ResultSet rs = ps.executeQuery()) { 
                if (rs.next()) { 
                    return mapperCreneau(rs); 
                } 
                return null; 
            } 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la recherche du créneau par id", e); 
        } 
    }

    public List<Creneau> trouverCreneauxDisponibles() { 
        String sql = "SELECT id, date_creneau, heure_creneau, duree_minutes, disponible FROM creneaux WHERE disponible = 1 AND (date_creneau > CURDATE() OR (date_creneau = CURDATE() AND heure_creneau >= CURTIME())) ORDER BY date_creneau, heure_creneau"; 
        List<Creneau> creneaux = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql); 
             ResultSet rs = ps.executeQuery()) { 
            while (rs.next()) { 
                creneaux.add(mapperCreneau(rs)); 
            } 
            return creneaux; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors du chargement des créneaux disponibles", e); 
        } 
    }

    public List<Creneau> trouverCreneauxDisponiblesAvecFiltres(LocalDate dateDebut, LocalDate dateFin, LocalTime heureDebut, LocalTime heureFin) { 
        StringBuilder sql = new StringBuilder("SELECT id, date_creneau, heure_creneau, duree_minutes, disponible FROM creneaux WHERE disponible = 1 AND (date_creneau > CURDATE() OR (date_creneau = CURDATE() AND heure_creneau >= CURTIME()))"); 
        List<Object> parametres = new ArrayList<>(); 
        if (dateDebut != null) { 
            sql.append(" AND date_creneau >= ?"); 
            parametres.add(Date.valueOf(dateDebut)); 
        } 
        if (dateFin != null) { 
            sql.append(" AND date_creneau <= ?"); 
            parametres.add(Date.valueOf(dateFin)); 
        } 
        if (heureDebut != null) { 
            sql.append(" AND heure_creneau >= ?"); 
            parametres.add(Time.valueOf(heureDebut)); 
        } 
        if (heureFin != null) { 
            sql.append(" AND heure_creneau <= ?"); 
            parametres.add(Time.valueOf(heureFin)); 
        } 
        sql.append(" ORDER BY date_creneau, heure_creneau"); 
        List<Creneau> creneaux = new ArrayList<>(); 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql.toString())) { 
            int index = 1; 
            for (Object param : parametres) { 
                if (param instanceof Date) { 
                    ps.setDate(index++, (Date) param); 
                } else if (param instanceof Time) { 
                    ps.setTime(index++, (Time) param); 
                } 
            } 
            try (ResultSet rs = ps.executeQuery()) { 
                while (rs.next()) { 
                    creneaux.add(mapperCreneau(rs)); 
                } 
            } 
            return creneaux; 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors du filtrage des créneaux", e); 
        } 
    }

    public void marquerIndisponible(int id) { 
        String sql = "UPDATE creneaux SET disponible = 0 WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, id); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la mise à jour du créneau", e); 
        } 
    }

    public void modifier(Creneau creneau) { 
        String sql = "UPDATE creneaux SET date_creneau = ?, heure_creneau = ?, duree_minutes = ?, disponible = ? WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setDate(1, creneau.getDateCreneau() != null ? Date.valueOf(creneau.getDateCreneau()) : null); 
            ps.setTime(2, creneau.getHeureCreneau() != null ? Time.valueOf(creneau.getHeureCreneau()) : null); 
            ps.setInt(3, creneau.getDureeMinutes()); 
            ps.setBoolean(4, creneau.isDisponible()); 
            ps.setInt(5, creneau.getId()); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la modification du créneau", e); 
        } 
    }

    public void supprimer(int id) { 
        String sql = "DELETE FROM creneaux WHERE id = ?"; 
        try (Connection connexion = obtenirConnexion(); 
             PreparedStatement ps = connexion.prepareStatement(sql)) { 
            ps.setInt(1, id); 
            ps.executeUpdate(); 
        } catch (SQLException e) { 
            throw new RuntimeException("Erreur lors de la suppression du créneau", e); 
        } 
    }
}