using Microsoft.Extensions.Configuration;
using Microsoft.IdentityModel.Tokens;
using SELLVAPI.DataAccess.Dto;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.Utils.Exceptions;
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;

namespace SELLVAPI.Auth
{
    public class AuthManager
    {
        private readonly SELLVDBContext _dbContext;
        private readonly IConfiguration _configuration;
        public AuthManager(SELLVDBContext dbContext, IConfiguration configuration)
        {
            _dbContext = dbContext;
            _configuration = configuration;
        }
        public object AuthToken(LoginDto usuario)
        {
            var username = usuario.Username;
            var password = usuario.Password;
            var credenciales = _dbContext.Users
                //.Include(x => x.Roles)
                .SingleOrDefault(x => x.Username == username);

            var key = _configuration["JwtSettings:Key"];
            var issuer = _configuration["JwtSettings:Issuer"];
            var audience = _configuration["JwtSettings:Audience"];
            var expTime = _configuration["JwtSettings:tokenValidityMins"];
            int expTiming = Convert.ToInt32(expTime);
            var tokenExp = DateTime.UtcNow.AddMinutes(expTiming);
            if (credenciales != null && BCrypt.Net.BCrypt.Verify(password, credenciales.Password))
            {
                var companyId = _dbContext.Users
                               .Where(uc => uc.Id == credenciales.Id)
                               .Select(uc => uc.CompanyId)
                               .FirstOrDefault();

                var userFullName = credenciales.Name;
                var claims = new ClaimsIdentity();
                claims.AddClaim(new Claim(ClaimTypes.NameIdentifier, usuario.Username!));
                if (companyId is not 0)
                    claims.AddClaim(new Claim("CompanyId", companyId.ToString()));

                claims.AddClaim(new Claim("UserId", credenciales.Id.ToString()));
                claims.AddClaim(new Claim("FullName", userFullName!));


                //foreach (var role in credenciales.Roles!)
                //    claims.AddClaim(new Claim(ClaimTypes.Role, role.Name!));
                var tokenDescriptor = new SecurityTokenDescriptor
                {
                    Subject = claims,
                    Expires = tokenExp,
                    Issuer = issuer,
                    Audience = audience,
                    SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(Encoding.ASCII.GetBytes(key!)), SecurityAlgorithms.HmacSha256Signature)
                };
                var tokenHandler = new JwtSecurityTokenHandler();
                var tokenConfig = tokenHandler.CreateToken(tokenDescriptor);
                var tokenCreado = tokenHandler.WriteToken(tokenConfig);
                try
                {

                    _dbContext.UsersTokens.Add(new UsersToken
                    {
                        Token = tokenCreado,
                        UserId = credenciales.Id,
                        CreatedAt = DateTime.Now,
                        ExpDate = tokenDescriptor.Expires
                    });
                    _dbContext.SaveChanges();
                    var tokenObj = new
                    {
                        Token = tokenCreado,
                        Success = true,
                        ExpDate = DateTime.Now.AddMinutes(expTiming),
                    };
                    return tokenObj;
                }
                catch
                {
                    throw;
                }
            }
            else
            {
                throw new UnauthorizedException("El usuario no tiene acceso. ");
            }
        }
    }
}
