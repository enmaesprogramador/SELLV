using POS_VET_API.DataAccess.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_VET_API.DataAccess.Repository
{
    public interface ICompanyRepository : IGenericInterface<Company>
    {
    }

    public class CompanyRepository(SELLVDBContext _context) :
        GenericRepository<Company>(_context), ICompanyRepository
    {
    }
}
