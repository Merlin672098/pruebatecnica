# pruebatecnica

A new Flutter project.

## Getting Started

MarketBo Flutter + .NET
Aplicación de catálogo de productos con backend en .NET y frontend en Flutter. Permite listar, buscar y actualizar precios de productos, con autenticación via Google (Firebase) y gestión de roles.

Estructura
/
├── lib(frpmt)/   
└── pruebatecnica(backend)/ 


Requisitos

.NET 9 SDK
PostgreSQL 17

Configurar la base de datos

esta en el archivo db.sql que es un backup

{
  "ConnectionStrings": {
    "cadenaconexion": "Host=localhost;Database=pruebatecnica;Port=5432;Username=postgres;Password=pass;SSL Mode=Prefer;Trust Server Certificate=true;"
  },
  "ApiKey": "mi-api-key-secreta-2024"
}# pruebatecnica

Correr el backend
dotnet run
El servidor escucha en http://0.0.0.0:5202. por el tema de conexion en http

to2 los endpoints requieren 
X-Api-Key: mi-api-key-secreta-2024

el login funciona solamente con google al moemnto de inciar sesion con una cuenta de google se podra acceder como proveedor o como cliente 

Configurar la IP del backend
en el archivo de lib/constants/constants.dart se encuentra el ApiProvider para el manejo de peticiones

Decisiones tecnicas
Backend
La arquitectura se organizó en capas diferenciadas — Contratos, Implementación y Repositorio — con el objetivo de separar responsabilidades y facilitar tanto el mantenimiento como futuras pruebas unitarias. 
En cuanto a seguridad, se decidió usar un middleware de API key fija en lugar de JWT completo, ya que cubre los requisitos de la prueba. Las respuestas del API utilizan PascalCase.

Frontend
Se mantuvo la arquitectura limpia ya existente en el proyecto, respetando la separación entre entidades, modelos, repositorios y adaptadores de interfaz. Los interactors concentran la lógica de negocio y los presenters gestionan el feedback visual al usuario. Para la autenticación se adoptó un enfoque híbrido: Firebase maneja el login con Google y el firebaseUid resultante se usa para sincronizar el usuario con el backend .NET, manteniendo desacopladas la identidad y los datos de negocio. Los filtros, el ordenamiento y la paginación se resuelven del lado del cliente sobre la lista completa, reduciendo la cantidad de llamadas al servidor.