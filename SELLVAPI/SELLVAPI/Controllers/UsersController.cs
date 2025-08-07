using Gridify;
using Microsoft.AspNetCore.Authorization;
using Microsoft.AspNetCore.Mvc;
using SELLVAPI.DataAccess.Models;
using SELLVAPI.DataAccess.Repository;
using SELLVAPI.Utils.ResponseObjects;

namespace SELLVAPI.Controllers
{
    [ApiController]
    [Route("api/[controller]")]
    public class UsersController : ControllerBase
    {
        private readonly IUserRepository _usersServices;
        public UsersController(IUserRepository usersServices)
        {
            _usersServices = usersServices;
        }
        [HttpGet, Authorize]
        public ActionResult<ResultPattern<Paging<User>>> GetUsers([FromQuery] GridifyQuery query) =>
            Ok(_usersServices.GetAll(query));

        [HttpGet("{id:int}")]
        public ActionResult<ResultPattern<User>> GetUser(int id)
            => Ok(_usersServices.Get(x => x.Id == id));
    }
}