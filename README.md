# Billetera Digital - Caso 1 (Java Servlets + JSP + JSTL)

Aplicación web desarrollada bajo el patrón MVC utilizando **Java 17**, **Jakarta EE (Servlets 6.0)**, **JSP**, **JSTL**, **Bootstrap 5.3** (CDN) y gestión de estado mediante **`HttpSession`**.

## Funcionalidades implementadas
- Saldo inicial automático de **S/ 250.00** por sesión.
- Registro de **Recargas (+)** y **Gastos (-)** con actualización inmediata del saldo.
- Validación de montos mayores a cero y bloqueo de gastos cuando el saldo es insuficiente.
- Historial de movimientos dinámicos renderizados con etiquetas **JSTL** (`<c:forEach>`, `<c:if>`, `<c:choose>`) sin uso de scriptlets.
- Opción independiente para reiniciar la billetera al estado inicial.

## Requisitos y ejecución
1. **Java JDK 17** y **Apache Tomcat 10.1+**.
2. Compilar el proyecto ejecutando en la terminal:
   `.\mvnw.cmd clean package`
3. Desplegar el archivo generado `target/billetera-digital.war` en Tomcat (copiarlo a la carpeta `webapps`).
   También se incluye el archivo **`billetera-digital.war`** listo en la raíz del repositorio.
4. Acceder desde el navegador a: `http://localhost:8080/billetera-digital/billetera`

## Evidencias de funcionamiento
Las capturas de pantalla de todas las pruebas (inicio, recarga, gasto, validaciones de error y reinicio) se encuentran en la carpeta EVIDENCIAS.