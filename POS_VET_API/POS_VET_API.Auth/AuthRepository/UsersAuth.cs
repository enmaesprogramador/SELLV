using POS_VET_API.Auth;
using POS_VET_API.DataAccess.DTOs;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.Utils.Exceptions;
using POS_VET_API.Utils.ResponseObject;
using Microsoft.AspNetCore.Http;
using Microsoft.Extensions.Configuration;
namespace POS_VET_API.DataAccess.Repository.Implementations
{
    public class UsersAuth : GenericRepository<User>, IUsersAuth
    {
        private readonly SELLVDBContext _DBContext;
        private readonly IHttpContextAccessor _httpContextAccesor;
        private readonly string? _secretKey;
        public UsersAuth(IConfiguration config, SELLVDBContext DBContext,
            IHttpContextAccessor httpContextAccessor)
            : base(DBContext, httpContextAccessor)
        {
            _DBContext = DBContext;
            _httpContextAccesor = httpContextAccessor;
            // _emailSender = emailSender;
            _secretKey = config.GetSection("settings:secretkey").Value; //Obtener llave y valor
        }
        public ResultPattern<User> UserRegistration(UserRegistrationDto entity)
        {
            if (IsUserNameUnique(entity))
                throw new BadRequestException("User with this user name exist. ");

            var passwordHash = PasswordHashing(entity.Password);
            entity.Password = passwordHash;
            var newUser = new User
            {
                Name = entity.FullName,
                Username = entity.Username,
                BirthDate = entity.BirthDate,
                Phone = entity.PhoneNumber,
                Address = entity.FullDirection,
                Password = entity.Password,
                CreatedAt = DateTime.Today,
                UpdatedAt = DateTime.Today,
                CreatedBy = entity.CreatedBy,
                UpdatedBy = entity.UpdatedBy
            };
            _DBContext.Users.Add(newUser);
            _DBContext.SaveChanges();
            //if (entity.Email is not null)
            //    _emailSender.SendEmailAsync(entity.Email,
            //        AppConstants.ACCOUNT_CREATED_MESSAGE,
            //        $"Hola {entity.FullName} tu cuenta en la app a sido creada. {DateTime.Today}");

            return ResultPattern<User>.Success(newUser,
                StatusCodes.Status200OK,
                "Usuario registrado correctamente. ");
        }
        public ResultPattern<object> Login(LoginDto loginDto)
        {
            var authManager = new AuthManager(_DBContext, _secretKey!);
            var result = authManager.AuthToken(loginDto);
            return ResultPattern<object>.Success(result,
                StatusCodes.Status200OK,
                "Sesion iniciada correctamente. ");
        }
        public bool IsUserNameUnique(UserRegistrationDto user)
        {
            return _DBContext.Users.Any(x => x.Username == user.Username);
        }

        static string PasswordHashing(string password)
            => BCrypt.Net.BCrypt.HashPassword(password, 13);
        
        public bool ChangePassword(Func<User, bool> predicate, ChangeUserPasswordDto changeUserPasswordDto)
        {
            var userToChangePassword = _DBContext.Users.FirstOrDefault(predicate) ??
                throw new NotFoundException("No se encontro el usuario. ");

            var newPassword = PasswordHashing(changeUserPasswordDto.Password);

            userToChangePassword!.Password = newPassword;

            _DBContext.Entry(userToChangePassword)
               .CurrentValues
               .SetValues(newPassword);
            _DBContext.Update(userToChangePassword);
            _DBContext.SaveChanges();

            return true;
        }
    }
}