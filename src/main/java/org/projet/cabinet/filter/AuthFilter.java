package org.projet.cabinet.filter;

import java.io.IOException;

import javax.servlet.Filter;
import javax.servlet.FilterChain;
import javax.servlet.FilterConfig;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class AuthFilter implements Filter {

    public void init(FilterConfig filterConfig) throws ServletException { }

    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {
        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        String contexte = req.getContextPath();
        String chemin = req.getRequestURI().substring(contexte.length());

        // Pages publiques (pas de session requise)
        if (chemin.startsWith("/login")
                || chemin.startsWith("/inscription")
                || chemin.startsWith("/logout")
                || chemin.startsWith("/css/")
                || chemin.startsWith("/img/")
                || chemin.startsWith("/js/")) {
            chain.doFilter(request, response);
            return;
        }

        HttpSession session = req.getSession(false);
        if (session == null
                || session.getAttribute("idUtilisateur") == null
                || session.getAttribute("roleUtilisateur") == null) {
            resp.sendRedirect(contexte + "/login");
            return;
        }

        chain.doFilter(request, response);
    }

    public void destroy() { }
}

