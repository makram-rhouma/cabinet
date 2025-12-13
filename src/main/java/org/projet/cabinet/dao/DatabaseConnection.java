package org.projet.cabinet.dao; import java.sql.Connection; import java.sql.DriverManager; import java.sql.SQLException; import javax.servlet.ServletContext;
/** Gestionnaire singleton des connexions JDBC basées sur les paramètres du web.xml. */
public final class DatabaseConnection { private static DatabaseConnection instance; private final String url; private final String utilisateur; private final String motDePasse;
    private DatabaseConnection(ServletContext contexte) { this.url = contexte.getInitParameter("jdbc.url"); this.utilisateur = contexte.getInitParameter("jdbc.utilisateur"); this.motDePasse = contexte.getInitParameter("jdbc.motdepasse"); try { Class.forName("com.mysql.cj.jdbc.Driver"); } catch (ClassNotFoundException e) { throw new RuntimeException("Pilote MySQL non trouvé", e); } }
    public static synchronized DatabaseConnection getInstance(ServletContext contexte) { if (instance == null) { instance = new DatabaseConnection(contexte); } return instance; }
    public Connection getConnection() throws SQLException { return DriverManager.getConnection(url, utilisateur, motDePasse); }
}
