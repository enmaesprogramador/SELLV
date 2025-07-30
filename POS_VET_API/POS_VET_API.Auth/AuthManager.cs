using POS_VET_API.DataAccess.Models;
using POS_VET_API.DataAccess.DTOs;
using System.Security.Claims;
using System.Text;
using Microsoft.EntityFrameworkCore;
using Microsoft.IdentityModel.Tokens;
using System.IdentityModel.Tokens.Jwt;
using POS_VET_API.Utils.Exceptions;
using Microsoft.AspNetCore.Identity;
using System.ComponentModel.Design;
namespace POS_VET_API.Auth;
public class AuthManager
{
    private readonly SELLVDBContext _dbContext;
    private readonly string _secretKey;
    public AuthManager(SELLVDBContext dbContext, string secretKey)
    {
        _dbContext = dbContext;
        _secretKey = secretKey;
    }
    public object AuthToken(LoginDto usuario)
    {
        var username = usuario.Username;
        var password = usuario.Password;
        var credenciales = _dbContext.Users
            //.Include(x => x.Roles)
            .SingleOrDefault(x => x.Username == username);
        if (credenciales != null && BCrypt.Net.BCrypt.Verify(password, credenciales.Password))
        {
            var companyId = _dbContext.Users
                           .Where(uc => uc.Id == credenciales.Id)
                           .Select(uc => uc.CompanyId)
                           .FirstOrDefault();

            var userFullName = credenciales.Name;
            var keyBytes = Encoding.UTF8.GetBytes(_secretKey);
            var claims = new ClaimsIdentity();
            claims.AddClaim(new Claim(ClaimTypes.NameIdentifier, usuario.Username!));
            if (companyId is not 0)
                claims.AddClaim(new Claim("CompanyId", companyId.ToString()));

            claims.AddClaim(new Claim("UserId", credenciales.Id.ToString()));
            claims.AddClaim(new Claim("FullName", userFullName!));


            foreach (var role in credenciales.Roles!)
                claims.AddClaim(new Claim(ClaimTypes.Role, role.Name!));
            var tokenDescriptor = new SecurityTokenDescriptor
            {
                Subject = claims,
                Expires = DateTime.UtcNow.AddHours(3),
                SigningCredentials = new SigningCredentials(new SymmetricSecurityKey(keyBytes), SecurityAlgorithms.HmacSha256Signature)
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
                    ExpDate = DateTime.Now + TimeSpan.FromHours(3),
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

