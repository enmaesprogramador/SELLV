using Gridify;
using Microsoft.AspNetCore.Http;
using POS_VET_API.DataAccess.Models;
using POS_VET_API.Utils.ResponseObject;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_VET_API.DataAccess.Repository
{
    public interface IUserRepository : IGenericInterface<User>
    {
    }
    public class UserRepository(SELLVDBContext _context) 
        : GenericRepository<User>(_context), IUserRepository
    {        
    }
}
