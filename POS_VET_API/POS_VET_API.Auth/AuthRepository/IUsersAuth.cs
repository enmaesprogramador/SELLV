using POS_VET_API.DataAccess.DTOs;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.DataAccess.Repository;
using POS_VET_API.Utils.ResponseObject;

namespace POS_VET_API.Auth
{
    public interface IUsersAuth : IGenericInterface<User>
    {
        ResultPattern<object> Login(LoginDto loginDto);
        ResultPattern<User> UserRegistration(UserRegistrationDto entity);
        bool IsUserNameUnique(UserRegistrationDto user);
        bool ChangePassword(Func<User, bool> predicate, ChangeUserPasswordDto changeUserPasswordDto);
    }
}
