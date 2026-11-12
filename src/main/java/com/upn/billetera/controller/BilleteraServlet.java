package com.upn.billetera.controller;

import com.upn.billetera.model.Movimiento;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet(name = "BilleteraServlet", urlPatterns = {"/billetera"})
public class BilleteraServlet extends HttpServlet {

    private static final double SALDO_INICIAL = 250.00;

    private void inicializarSesion(HttpSession session) {
        if (session.getAttribute("saldo") == null) {
            session.setAttribute("saldo", SALDO_INICIAL);
        }
        if (session.getAttribute("movimientos") == null) {
            session.setAttribute("movimientos", new ArrayList<Movimiento>());
        }
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        inicializarSesion(session);
        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }

    @Override
    @SuppressWarnings("unchecked")
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        inicializarSesion(session);

        String accion = request.getParameter("accion");

        if ("reiniciar".equals(accion)) {
            session.setAttribute("saldo", SALDO_INICIAL);
            session.setAttribute("movimientos", new ArrayList<Movimiento>());
            request.setAttribute("mensaje", "Billetera reiniciada correctamente al saldo inicial.");
            request.setAttribute("tipoAlerta", "info");
            request.getRequestDispatcher("/index.jsp").forward(request, response);
            return;
        }

        String tipo = request.getParameter("tipo");
        String montoStr = request.getParameter("monto");

        double saldoActual = (Double) session.getAttribute("saldo");
        List<Movimiento> movimientos = (List<Movimiento>) session.getAttribute("movimientos");

        try {
            if (montoStr == null || montoStr.trim().isEmpty()) {
                throw new NumberFormatException("Monto vacío");
            }

            double monto = Double.parseDouble(montoStr);

            if (monto <= 0) {
                request.setAttribute("mensaje", "Error: El monto debe ser mayor a cero (S/ 0.00).");
                request.setAttribute("tipoAlerta", "danger");
            } else if ("Gasto".equals(tipo) && monto > saldoActual) {
                request.setAttribute("mensaje", "Error: Saldo insuficiente para realizar este gasto.");
                request.setAttribute("tipoAlerta", "danger");
            } else {
                if ("Recarga".equals(tipo)) {
                    saldoActual += monto;
                } else if ("Gasto".equals(tipo)) {
                    saldoActual -= monto;
                }

                movimientos.add(0, new Movimiento(tipo, monto));

                session.setAttribute("saldo", saldoActual);
                session.setAttribute("movimientos", movimientos);

                request.setAttribute("mensaje", "Operación (" + tipo + ") registrada con éxito.");
                request.setAttribute("tipoAlerta", "success");
            }

        } catch (NumberFormatException e) {
            request.setAttribute("mensaje", "Error: Ingrese un monto numérico válido.");
            request.setAttribute("tipoAlerta", "danger");
        }

        request.getRequestDispatcher("/index.jsp").forward(request, response);
    }
}