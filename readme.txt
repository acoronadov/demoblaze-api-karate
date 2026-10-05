==================================================
PRUEBAS API DEMOBLAZE CON KARATE
==================================================

--------------------------------------------------
1. DESCRIPCIÓN DEL PROYECTO
--------------------------------------------------

Este proyecto automatiza los servicios de registro y autenticación de usuarios de DemoBlaze utilizando Karate.

Los servicios evaluados son:

POST /signup
POST /login

Se cubren cuatro escenarios:

- Crear un nuevo usuario.
- Intentar crear un usuario ya existente.
- Realizar login con usuario y contraseña correctos.
- Intentar login con una contraseña incorrecta.

Además del código HTTP, se valida el contenido de las respuestas, ya que DemoBlaze puede responder HTTP 200 tanto en casos exitosos como en algunos errores funcionales.

--------------------------------------------------
2. TECNOLOGÍAS Y REQUISITOS
--------------------------------------------------

El proyecto utiliza:

- Java 17
- Maven
- Karate 1.5.2
- JUnit 5
- Git

Para ejecutarlo se requiere:

- JDK 17 instalado.
- Maven disponible en el PATH.
- Git.
- Conexión a Internet.
- Acceso a Maven Central y a la API de DemoBlaze.

Para validar la instalación:

java -version
mvn -version
git --version

--------------------------------------------------
3. ESTRUCTURA DEL PROYECTO
--------------------------------------------------

pom.xml
Configuración de dependencias y ejecución con Maven.

.gitignore
Archivos y carpetas que no deben ser versionados.

readme.txt
Instrucciones de uso y ejecución.

conclusiones.txt
Hallazgos y conclusiones del ejercicio.

reports/
Evidencias conservadas de las ejecuciones realizadas.

src/test/java/com/demoblaze/api/ApiTest.java
Runner JUnit 5 para ejecutar Karate.

src/test/resources/karate-config.js
Configuración general del proyecto.

src/test/resources/data/users.json
Datos de prueba reutilizables.

src/test/resources/features/auth/signup.feature
Escenarios del servicio Signup.

src/test/resources/features/auth/login.feature
Escenarios del servicio Login.

src/test/resources/features/helpers/create-user.feature
Feature reutilizable para crear usuarios durante la preparación de los escenarios.

src/test/resources/logback-test.xml
Configuración de logs.

validar.ps1
Script para ejecutar las validaciones y conservar evidencias.

--------------------------------------------------
4. CONFIGURACIÓN Y DATOS DE PRUEBA
--------------------------------------------------

La URL base se configura en:

src/test/resources/karate-config.js

URL utilizada:

https://api.demoblaze.com

Los Features utilizan esta configuración para no repetir la URL completa en cada escenario.

Los datos reutilizables se encuentran en:

src/test/resources/data/users.json

Este archivo contiene las contraseñas utilizadas durante las pruebas.

Los usernames se generan dinámicamente.

DemoBlaze conserva los usuarios registrados, por lo que usar siempre el mismo username impediría repetir correctamente el escenario de registro exitoso.

Cada escenario prepara los datos que necesita, evitando dependencias entre pruebas o entre el orden de ejecución.

--------------------------------------------------
5. ESCENARIOS Y VALIDACIONES
--------------------------------------------------

Signup - usuario nuevo

Se genera un username único y se realiza el registro.

Validaciones:

- HTTP 200
- Respuesta vacía


Signup - usuario existente

Se crea un usuario y posteriormente se intenta registrar nuevamente con las mismas credenciales.

Validaciones:

- HTTP 200
- errorMessage igual a:

This user already exist.


Login - credenciales correctas

Se crea previamente un usuario válido y luego se realiza el login con las mismas credenciales.

Validaciones:

- HTTP 200
- La respuesta contiene:

Auth_token:

El token completo no se valida porque es dinámico.


Login - contraseña incorrecta

Se crea previamente un usuario válido y se realiza el login utilizando una contraseña incorrecta.

Validaciones:

- HTTP 200
- errorMessage igual a:

Wrong password.

--------------------------------------------------
6. EJECUCIÓN
--------------------------------------------------

Desde la raíz del proyecto:

mvn clean test

Este comando limpia los resultados anteriores, ejecuta todos los escenarios y genera el reporte de Karate.

--------------------------------------------------
7. EJECUCIÓN POR TAGS
--------------------------------------------------

Todos los escenarios API:

mvn clean test "-Dkarate.options=--tags @api"

Signup:

mvn clean test "-Dkarate.options=--tags @signup"

Login:

mvn clean test "-Dkarate.options=--tags @login"

Escenarios positivos:

mvn clean test "-Dkarate.options=--tags @positive"

Escenarios negativos:

mvn clean test "-Dkarate.options=--tags @negative"

Smoke:

mvn clean test "-Dkarate.options=--tags @smoke"


Tags utilizados:

@api
Agrupa los escenarios de servicios REST.

@signup
Escenarios relacionados con registro.

@login
Escenarios relacionados con autenticación.

@positive
Casos de comportamiento exitoso.

@negative
Casos de error funcional.

@smoke
Casos principales para una validación rápida de los servicios.

--------------------------------------------------
8. REPORTES Y EVIDENCIAS
--------------------------------------------------

Karate genera el reporte principal en:

target/karate-reports/karate-summary.html

La carpeta target/ no se versiona, ya que se genera nuevamente con cada ejecución.

Las evidencias que se desean conservar se encuentran en:

reports/

Allí se almacenan:

- Reporte HTML.
- Logs de ejecución.
- Resultados JSON.
- Índice de evidencias.

También se puede ejecutar:

.\validar.ps1

Este script ejecuta las validaciones configuradas y conserva las evidencias correspondientes dentro de reports/.

--------------------------------------------------
9. CLONAR Y EJECUTAR DESDE OTRO EQUIPO
--------------------------------------------------

Clonar el repositorio:

git clone https://github.com/acoronadov/demoblaze-api-karate.git

Ingresar al proyecto:

cd demoblaze-api-karate

Validar las herramientas:

java -version
mvn -version
git --version

Ejecutar:

mvn clean test

Maven descargará las dependencias necesarias durante la primera ejecución.

No es necesario crear usuarios previamente, ya que los escenarios generan los datos que requieren durante la prueba.