using Gridify;
using Microsoft.AspNetCore.Mvc;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.DataAccess.Repository;
using POS_VET_API.Utils.ResponseObject;

namespace POS_VET_API.Controllers
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
        [HttpGet]
        public ActionResult<ResultPattern<Paging<User>>> GetUsers([FromQuery]GridifyQuery query) =>
            Ok(_usersServices.GetAll(query));

        [HttpPost]
        public ActionResult<ResultPattern<User>> PostUser([FromBody] User user) =>
            Created(string.Empty, _usersServices.Post(user));
    }
}
