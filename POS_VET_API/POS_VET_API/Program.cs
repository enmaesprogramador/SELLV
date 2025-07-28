using Microsoft.AspNetCore.Authentication.JwtBearer;
using Microsoft.AspNetCore.Mvc;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.DataAccess.Repository;
using POS_VET_API.MiddleWares;
using POS_VET_API.Swagger;
using POS_VET_API.Utils.ResponseObject;
using System.Reflection;
using System.Text;

var builder = WebApplication.CreateBuilder(args);
var cors = "AllowCors";
const string swaggerTitle = "POS_VET_API";
 // Add services to the conainer.

builder.Services.AddControllers();
// Learn more about configuring Swagger/OpenAPI at https://aka.ms/aspnetcore/swashbuckle
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen();
builder.Services.AddDbContext<SELLVDBContext>(options =>
    options.UseSqlServer(builder.Configuration.GetConnectionString("connString"))
);

var secretkey = builder.Configuration.GetSection("settings:secretkey").Value; 
var keyBytes = Encoding.UTF8.GetBytes(secretkey!);

builder.Services.AddAuthentication(config =>
{
    config.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
    config.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
}).AddJwtBearer(config =>
{
    config.Events = new JwtBearerEvents
    {
        OnChallenge = async context =>
        {
            context.Response.StatusCode = StatusCodes.Status401Unauthorized;
            await context.Response.WriteAsJsonAsync(ResultPattern<object>.Failure(StatusCodes.Status401Unauthorized,
                "Usuario no autenticado. "));
        }
    };
    config.RequireHttpsMetadata = false;
    config.SaveToken = true;
    config.TokenValidationParameters = new TokenValidationParameters()
    {
        ValidateIssuerSigningKey = true,
        IssuerSigningKey = new SymmetricSecurityKey(keyBytes),
        ValidateIssuer = false,
        ValidateAudience = false,
    };
});

builder.Services.AddCors((options) =>
{
    options.DefaultPolicyName = cors;
    options.AddPolicy(cors, p =>
    {
        p.AllowAnyOrigin()
         .AllowAnyMethod()
         .AllowAnyHeader();
    });
});

builder.Services.AddExceptionHandler<GlobalExceptionHandlerMiddleware>();
builder.Services.AddScoped<IUserRepository, UserRepository>()
                .AddScoped<ICompanyRepository, CompanyRepository>();
builder.Services.AddHttpContextAccessor();
builder.Services.AddProblemDetails();

builder.Services.Configure<ApiBehaviorOptions>(options => options.SuppressModelStateInvalidFilter = true);
builder.Services.AddEndpointsApiExplorer();
/*builder.Services.AddSwaggerGen(
    info =>
    {
        info.SwaggerDoc("2.0",
            new OpenApiInfo
            {
                Title = swaggerTitle,
                Version = swaggerVer,
                Description = SwaggerSpecs.GetSwaggerSpecs()
            });
        info.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
        {
            Name = "Authorization",
            Type = SecuritySchemeType.ApiKey,
            Scheme = "Bearer",
            BearerFormat = "JWT",
            In = ParameterLocation.Header,
            Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
        });
        info.AddSecurityRequirement(new OpenApiSecurityRequirement {
        {
            new OpenApiSecurityScheme {
                Reference = new OpenApiReference {
                    Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                }
            },
            new string[] {}
        }
    });

        //var xmlFile = $"{Assembly.GetExecutingAssembly().GetName().Name}.xml";
        //var xmlPath = Path.Combine(AppContext.BaseDirectory, xmlFile);
        //info.IncludeXmlComments(xmlPath);
        //info.ExampleFilters();

    });*/

builder.Services.AddSwaggerGen(c =>
{
    c.SwaggerDoc("v1", new OpenApiInfo 
    { 
        Title = swaggerTitle, 
        Version = "v1" ,
        Description = SwaggerSpecs.GetSwaggerSpecs()
    });

    c.AddSecurityDefinition("Bearer", new OpenApiSecurityScheme()
    {
        Name = "Authorization",
        Type = SecuritySchemeType.ApiKey,
        Scheme = "Bearer",
        BearerFormat = "JWT",
        In = ParameterLocation.Header,
        Description = "JWT Authorization header using the Bearer scheme. \r\n\r\n Enter 'Bearer' [space] and then your token in the text input below.\r\n\r\nExample: \"Bearer 1safsfsdfdfd\"",
    });

    c.AddSecurityRequirement(new OpenApiSecurityRequirement {
        {
            new OpenApiSecurityScheme {
                Reference = new OpenApiReference {
                    Type = ReferenceType.SecurityScheme,
                        Id = "Bearer"
                }
            },
            new string[] {}
        }


    });
});

var app = builder.Build();

app.UseExceptionHandler();
// Configure the HTTP request pipeline.
if (app.Environment.IsDevelopment())
{
    app.UseSwagger(c => c.OpenApiVersion = Microsoft.OpenApi.OpenApiSpecVersion.OpenApi2_0);
    app.UseSwaggerUI(c =>
    {
        c.DefaultModelsExpandDepth(-1);
        c.EnableValidator();
        c.OAuthUseBasicAuthenticationWithAccessCodeGrant();
    });
}
app.UseHttpsRedirection();
app.UseAuthentication();
app.UseAuthorization();

app.MapControllers();

app.Run();
