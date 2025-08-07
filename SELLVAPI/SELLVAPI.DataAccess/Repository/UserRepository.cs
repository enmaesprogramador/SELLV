using SELLVAPI.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SELLVAPI.DataAccess.Repository
{
    public interface IUserRepository : IGenericInterface<User>
    {
    }
    public class UserRepository(SELLVDBContext _context)
        : GenericRepository<User>(_context), IUserRepository
    {
    }
}
