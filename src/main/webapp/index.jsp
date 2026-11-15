<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ taglib prefix="fmt" uri="jakarta.tags.fmt" %>
<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Billetera Digital - Caso 1 (JSP + Servlet)</title>
    <link href="https://jsdelivr.net" rel="stylesheet">
</head>
<body class="bg-light">

<div class="container py-5" style="max-width: 750px;">
    <h2 class="text-center mb-4 fw-bold text-primary">Billetera Digital (Servlet + JSP)</h2>

    <!-- Saldo actual -->
    <div class="card shadow-sm mb-4 border-primary">
        <div class="card-body text-center">
            <h5 class="card-title text-muted">Saldo Disponible</h5>
            <h1 class="display-4 fw-bold text-success">
                S/ <fmt:formatNumber value="${sessionScope.saldo}" minFractionDigits="2" maxFractionDigits="2"/>
            </h1>
        </div>
    </div>

    <!-- Mensajes de validación o confirmación -->
    <c:if test="${not empty requestScope.mensaje}">
        <div class="alert alert-${requestScope.tipoAlerta} alert-dismissible fade show" role="alert">
            ${requestScope.mensaje}
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
    </c:if>

    <!-- Formulario de registro de movimientos -->
    <div class="card shadow-sm mb-4">
        <div class="card-header bg-white fw-bold">Registrar Nuevo Movimiento</div>
        <div class="card-body">
            <form action="billetera" method="post" class="row g-3">
                <div class="col-md-5">
                    <label for="tipo" class="form-label">Tipo de Movimiento</label>
                    <select class="form-select" id="tipo" name="tipo" required>
                        <option value="Recarga">Recarga (+)</option>
                        <option value="Gasto">Gasto (-)</option>
                    </select>
                </div>

                <div class="col-md-4">
                    <label for="monto" class="form-label">Monto (S/)</label>
                    <input type="number" step="0.01" class="form-control" id="monto" name="monto" placeholder="Ej. 50.00" required>
                </div>

                <div class="col-md-3 d-flex align-items-end">
                    <button type="submit" class="btn btn-primary w-100">Registrar</button>
                </div>
            </form>

            <hr>

            <!-- Botón independiente para reiniciar -->
            <form action="billetera" method="post" class="text-end">
                <input type="hidden" name="accion" value="reiniciar">
                <button type="submit" class="btn btn-outline-secondary btn-sm">Reiniciar Billetera</button>
            </form>
        </div>
    </div>

    <!-- Historial de movimientos -->
    <div class="card shadow-sm">
        <div class="card-header bg-white fw-bold">Historial de Movimientos</div>
        <div class="card-body p-0">
            <c:choose>
                <c:when test="${empty sessionScope.movimientos}">
                    <p class="text-center text-muted my-4">Aún no se han registrado movimientos en esta sesión.</p>
                </c:when>
                <c:otherwise>
                    <table class="table table-hover mb-0">
                        <thead class="table-light">
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
                                    <td class="text-end fw-bold ${mov.tipo == 'Recarga' ? 'text-success' : 'text-danger'}">
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

<script src="https://jsdelivr.net"></script>
</body>
</html>