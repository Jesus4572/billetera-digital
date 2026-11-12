<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billetera Digital - Caso 1 (JSP + Servlet)</title>
    <link href="https://cloudflare.com" rel="stylesheet">
    <style>
        body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f4f6f9; color: #212529; margin: 0; padding: 30px 15px; }
        .container { max-width: 720px; margin: 0 auto; }
        h2 { text-align: center; color: #0d6efd; margin-bottom: 24px; }
        .card { background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.08); margin-bottom: 20px; border: 1px solid #dee2e6; overflow: hidden; }
        .card-primary { border: 2px solid #0d6efd; text-align: center; padding: 20px; }
        .card-header { background: #f8f9fa; padding: 12px 20px; font-weight: bold; border-bottom: 1px solid #dee2e6; }
        .card-body { padding: 20px; }
        .saldo { font-size: 2.8rem; font-weight: bold; color: #198754; margin: 5px 0 0; }
        .alert { padding: 12px 16px; border-radius: 6px; margin-bottom: 20px; font-weight: 500; }
        .alert-success { background-color: #d1e7dd; color: #0f5132; border: 1px solid #badbcc; }
        .alert-danger { background-color: #f8d7da; color: #842029; border: 1px solid #f5c2c7; }
        .alert-info { background-color: #cff4fc; color: #055160; border: 1px solid #b6effb; }
        .row { display: flex; flex-wrap: wrap; gap: 15px; align-items: flex-end; }
        .col { flex: 1; min-width: 160px; }
        label { display: block; margin-bottom: 6px; font-weight: 500; font-size: 0.9rem; }
        select, input[type="number"] { width: 100%; padding: 8px 12px; border: 1px solid #ced4da; border-radius: 6px; font-size: 1rem; box-sizing: border-box; }
        .btn-primary { width: 100%; padding: 9px 16px; background-color: #0d6efd; color: white; border: none; border-radius: 6px; font-size: 1rem; font-weight: 600; cursor: pointer; }
        .btn-primary:hover { background-color: #0b5ed7; }
        .btn-secondary { padding: 6px 12px; background-color: transparent; color: #6c757d; border: 1px solid #6c757d; border-radius: 5px; cursor: pointer; font-size: 0.85rem; }
        .btn-secondary:hover { background-color: #6c757d; color: white; }
        table { width: 100%; border-collapse: collapse; }
        th, td { padding: 12px 20px; text-align: left; border-bottom: 1px solid #dee2e6; }
        th { background-color: #f8f9fa; }
        .text-end { text-align: right; }
        .badge { padding: 4px 10px; border-radius: 12px; font-size: 0.8rem; color: white; font-weight: bold; }
        .bg-success { background-color: #198754; }
        .bg-danger { background-color: #dc3545; }
        .text-success { color: #198754; font-weight: bold; }
        .text-danger { color: #dc3545; font-weight: bold; }
    </style>
</head>
<body>

<div class="container">
    <h2>Billetera Digital (Servlet + JSP)</h2>

    <!-- Saldo actual -->
    <div class="card card-primary">
        <div style="color: #6c757d; font-weight: 600;">Saldo Disponible</div>
        <div class="saldo">
            S/ <fmt:formatNumber value="${sessionScope.saldo}" minFractionDigits="2" maxFractionDigits="2"/>
        </div>
    </div>

    <!-- Mensajes de validación o confirmación -->
    <c:if test="${not empty requestScope.mensaje}">
        <div class="alert alert-${requestScope.tipoAlerta}">
            ${requestScope.mensaje}
        </div>
    </c:if>

    <!-- Formulario de registro de movimientos -->
    <div class="card">
        <div class="card-header">Registrar Nuevo Movimiento</div>
        <div class="card-body">
            <form action="billetera" method="post" class="row">
                <div class="col">
                    <label for="tipo">Tipo de Movimiento</label>
                    <select id="tipo" name="tipo" required>
                        <option value="Recarga">Recarga (+)</option>
                        <option value="Gasto">Gasto (-)</option>
                    </select>
                </div>

                <div class="col">
                    <label for="monto">Monto (S/)</label>
                    <input type="number" step="0.01" id="monto" name="monto" placeholder="Ej. 50.00" required>
                </div>

                <div class="col">
                    <button type="submit" class="btn-primary">Registrar</button>
                </div>
            </form>

            <hr style="border: 0; border-top: 1px solid #dee2e6; margin: 18px 0;">

            <form action="billetera" method="post" class="text-end">
                <input type="hidden" name="accion" value="reiniciar">
                <button type="submit" class="btn-secondary">Reiniciar Billetera</button>
            </form>
        </div>
    </div>

    <!-- Historial de movimientos -->
    <div class="card">
        <div class="card-header">Historial de Movimientos</div>
        <div class="card-body" style="padding: 0;">
            <c:choose>
                <c:when test="${empty sessionScope.movimientos}">
                    <p style="text-align: center; color: #6c757d; padding: 20px; margin: 0;">Aún no se han registrado movimientos en esta sesión.</p>
                </c:when>
                <c:otherwise>
                    <table>
                        <thead>
                            <tr>
                                <th>#</th>
                                <th>Tipo</th>
                                <th class="text-end">Monto</th>
                            </tr>
                        </thead>
                        <tbody>
                            <c:forEach var="mov" items="${sessionScope.movimientos}" varStatus="estado">
                                <tr>
                                    <td>${estado.count}</td>
                                    <td>
                                        <span class="badge ${mov.tipo == 'Recarga' ? 'bg-success' : 'bg-danger'}">
                                            ${mov.tipo}
                                        </span>
                                    </td>
                                    <td class="text-end ${mov.tipo == 'Recarga' ? 'text-success' : 'text-danger'}">
                                        ${mov.tipo == 'Recarga' ? '+' : '-'} S/ <fmt:formatNumber value="${mov.monto}" minFractionDigits="2" maxFractionDigits="2"/>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </c:otherwise>
            </c:choose>
        </div>
    </div>
</div>

</body>
</html>