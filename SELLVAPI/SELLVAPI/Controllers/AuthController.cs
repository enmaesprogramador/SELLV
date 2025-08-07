using Microsoft.AspNetCore.Mvc;
using SELLVAPI.Auth.AuthRepository;
using SELLVAPI.DataAccess.Dto;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.Utils.ResponseObjects;

namespace SELLVAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class AuthController : ControllerBase
    {
        //private readonly IValidator<UserRegistrationDto> _userValidator;
        private readonly IUsersAuth _usersAuth;
        public AuthController(/*IValidator<UserRegistrationDto> userValidator*/ IUsersAuth usersAuth)
        {
            _usersAuth = usersAuth;
        }

        [HttpPost("Register")]
        public ActionResult<ResultPattern<UserRegistrationDto>> Register([FromBody] UserRegistrationDto user)
            => Created(string.Empty, _usersAuth.UserRegistration(user));

        [HttpPost("Login")]
        public ActionResult<ResultPattern<LoginDto>> Login([FromBody] LoginDto loginDto)
            => Ok(_usersAuth.Login(loginDto));

        [HttpPut("ChangePassword/{userid}")]
        public ActionResult<bool> ChangePassword(int userid, [FromBody] ChangeUserPasswordDto changeUserPasswordDto)
        {
            bool predicate(User x) => x.Id == userid;
            return Ok(_usersAuth.ChangePassword(predicate, changeUserPasswordDto));
        }

    }
}
