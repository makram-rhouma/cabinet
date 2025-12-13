package org.projet.cabinet.dao; import java.sql.Connection; import java.sql.SQLException; import javax.servlet.ServletContext;
    public abstract class DaoBase { private final DatabaseConnection databaseConnection;
    public DaoBase(ServletContext contexte) { this.databaseConnection = DatabaseConnection.getInstance(contexte); }
    protected Connection obtenirConnexion() throws SQLException { return databaseConnection.getConnection(); }
}