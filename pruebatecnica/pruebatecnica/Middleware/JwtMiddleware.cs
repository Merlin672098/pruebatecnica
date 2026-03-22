using Microsoft.AspNetCore.Http;

namespace pruebatecnica.Middleware
{
    public class ApiKeyMiddleware
    {
        private readonly RequestDelegate _next;
        private readonly IConfiguration _configuration;
        private readonly ILogger<ApiKeyMiddleware> _logger;

        public ApiKeyMiddleware(RequestDelegate next, IConfiguration configuration, ILogger<ApiKeyMiddleware> logger)
        {
            _next = next;
            _configuration = configuration;
            _logger = logger;
        }

        public async Task InvokeAsync(HttpContext httpContext)
        {
            var apiKey = httpContext.Request.Headers["X-Api-Key"].FirstOrDefault();


            if (apiKey != null)
            {
                try
                {
                    var validKey = _configuration["ApiKey"];

                    if (apiKey != validKey)
                        throw new Exception("La API key no coincide");

                   
                    httpContext.Items["Autenticado"] = true;
                }
                catch (Exception ex)
                {
                    _logger.LogWarning("API Key invalida: " + ex.Message);
                    httpContext.Response.StatusCode = StatusCodes.Status401Unauthorized;
                    await httpContext.Response.WriteAsync("API Key inválida");
                    return;
                }
            }

            await _next(httpContext);
        }
    }
}