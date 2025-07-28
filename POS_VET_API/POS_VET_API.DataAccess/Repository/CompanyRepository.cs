using POS_VET_API.DataAccess.Models;
using POS_VET_API.Utils.Exceptions;
using POS_VET_API.Utils.ResponseObject;
using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace POS_VET_API.DataAccess.Repository
{
    public interface ICompanyRepository : IGenericInterface<Company>
    {
        bool IsCompanyRncUnique(string rnc);
        bool IsCompanyNameUnique(string name);
    }

    public class CompanyRepository(SELLVDBContext context) :
        GenericRepository<Company>(context), ICompanyRepository
    {
        private readonly SELLVDBContext _context = context;

        public override ResultPattern<Company> Post(Company entity)
        {
            if (IsCompanyNameUnique(entity.Name))
                throw new BadRequestException("An Company with this name exists. ");

            if (IsCompanyRncUnique(entity.FiscalId))
                throw new BadRequestException("An Company with this fiscal id exists. ");

            return base.Post(entity);
        }

        public bool IsCompanyNameUnique(string name)
        {
            return _context
                .Companies
                .Any(x=> x.Name == name);
        }

        public bool IsCompanyRncUnique(string rnc)
        {
            return _context
                .Companies
                .Any(x=>x.FiscalId == rnc);
        }
    }
}
