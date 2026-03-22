using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Newtonsoft.Json.Serialization;
using pruebatecnica.Contexto;
using pruebatecnica.Contrato;
using pruebatecnica.Implementacion;
using pruebatecnica.Middleware;

namespace pruebatecnica
{
    public class Startup
    {
        public Startup(IConfiguration configuration)
        {
            Configuration = configuration;
        }

        public IConfiguration Configuration { get; }

        public void ConfigureServices(IServiceCollection services)
        {
            services.AddControllers()
                .AddNewtonsoftJson(options =>
                    options.SerializerSettings.ReferenceLoopHandling =
                        Newtonsoft.Json.ReferenceLoopHandling.Ignore)
                .AddNewtonsoftJson(options =>
                    options.SerializerSettings.ContractResolver =
                        new DefaultContractResolver());

            services.AddDbContext<AppDbContext>(options =>
                options.UseLazyLoadingProxies()
                       .UseNpgsql(Configuration.GetConnectionString("cadenaconexion"))
            );

            services.AddScoped<IUsersContrato, UsuariosLogic>();
            services.AddScoped<IProductsContrato, ProductosLogic>();

            services.AddCors(options =>
            {
                options.AddPolicy("AllowFlutter", builder =>
                {
                    builder.AllowAnyOrigin()
                           .AllowAnyMethod()
                           .AllowAnyHeader();
                });
            });
        }

        public void Configure(IApplicationBuilder app, IWebHostEnvironment env)
        {
            if (env.IsDevelopment())
            {
                app.UseDeveloperExceptionPage();
            }

            app.UseCors("AllowFlutter");
            app.UseMiddleware<ApiKeyMiddleware>();
            app.UseStaticFiles();
            app.UseRouting();
            app.UseAuthorization();

            app.UseEndpoints(endpoints =>
            {
                endpoints.MapControllers();
            });
        }
    }
}